import 'package:flexpay/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flexpay/main.dart'; // For navigatorKey

/// Initialize the FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('⏰ Background message received: ${message.messageId}');
  debugPrint('📩 Message data: ${message.data}');
}

class NotificationsManager {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _isInitialized = false;
  static String? _cachedToken;

  /// Initialize notification channels, FCM listeners, and permissions
  /// Now with proper error handling and non-blocking operations
  static Future<String?> init() async {
    if (_isInitialized) return _cachedToken;

    try {
      // Create Android notification channel (API 26+)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      // Initialize local notifications with custom icon
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@drawable/ic_stat_ic_notification');

      final InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Create the notification channel on the device
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permissions with timeout
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('⚠️ Permission request timed out');
          return NotificationSettings(
            authorizationStatus: AuthorizationStatus.notDetermined,
            alert: AppleNotificationSetting.notSupported,
            announcement: AppleNotificationSetting.notSupported,
            badge: AppleNotificationSetting.notSupported,
            carPlay: AppleNotificationSetting.notSupported,
            lockScreen: AppleNotificationSetting.notSupported,
            notificationCenter: AppleNotificationSetting.notSupported,
            showPreviews: AppleShowPreviewSetting.notSupported,
            timeSensitive: AppleNotificationSetting.notSupported,
            criticalAlert: AppleNotificationSetting.notSupported,
            sound: AppleNotificationSetting.notSupported,
            providesAppNotificationSettings: AppleNotificationSetting.notSupported,
          );
        },
      );
      debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

      // Get device token with retry logic
      _cachedToken = await _getTokenWithRetry();
      debugPrint('📱 FCM Token: $_cachedToken');

      // Setup message listeners
      _setupMessageListeners(channel);

      _isInitialized = true;
      return _cachedToken;
    } catch (e, stackTrace) {
      debugPrint('❌ NotificationsManager init failed: $e');
      debugPrint('Stack trace: $stackTrace');
      // Don't crash the app, just return null
      return null;
    }
  }

  /// Get FCM token only without full initialization
  static Future<String?> getTokenOnly() async {
    if (_cachedToken != null) return _cachedToken;

    try {
      _cachedToken = await _messaging.getToken().timeout(
        const Duration(seconds: 10),
      );
      return _cachedToken;
    } catch (e) {
      debugPrint('⚠️ Failed to get FCM token: $e');
      return null;
    }
  }

  /// Refresh FCM token
  static Future<String?> refreshToken() async {
    try {
      await _messaging.deleteToken();
      _cachedToken = await _messaging.getToken().timeout(
        const Duration(seconds: 10),
      );
      debugPrint('📱 FCM Token refreshed: $_cachedToken');
      return _cachedToken;
    } catch (e) {
      debugPrint('⚠️ Failed to refresh FCM token: $e');
      return null;
    }
  }

  /// Setup message listeners in a separate method
  static void _setupMessageListeners(AndroidNotificationChannel channel) {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground message: ${message.notification?.title}');
      debugPrint('📩 Message data: ${message.data}');

      if (message.notification != null &&
          message.notification?.android != null) {
        final BigPictureStyleInformation bigPictureStyle =
            BigPictureStyleInformation(
          DrawableResourceAndroidBitmap(
            'your_colored_logo',
          ), // your full-color image
          contentTitle: message.notification?.title,
          summaryText: message.notification?.body,
        );

        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon:
                  '@drawable/ic_stat_ic_notification', // small status bar icon (white/mono)
              styleInformation: bigPictureStyle, // big picture with color
            ),
          ),
          payload: message.data['route'],
        );
      }
    });

    // When app opened from notification (terminated -> opened)
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpened);
  }

  /// Get token with retry logic and exponential backoff
  static Future<String?> _getTokenWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final token = await _messaging.getToken().timeout(
          Duration(seconds: 5 + (i * 2)), // Increasing timeout
        );
        if (token != null && token.isNotEmpty) {
          return token;
        }
      } catch (e) {
        debugPrint('⚠️ Token retrieval attempt ${i + 1} failed: $e');
        if (i < maxRetries - 1) {
          await Future.delayed(Duration(seconds: 1 << i)); // Exponential backoff
        }
      }
    }
    return null;
  }

  /// Handle tapping on a notification (foreground)
  static void _onNotificationTap(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      await _handleNavigation(payload);
    }
  }

  /// Handle tapping on a notification (background / terminated)
  static void _onNotificationOpened(RemoteMessage message) async {
    final route = message.data['route'];
    if (route != null && route.isNotEmpty) {
      await _handleNavigation(route);
    }
  }

  /// Navigate safely depending on login state with improved error handling
  static Future<void> _handleNavigation(String route) async {
    try {
      final UserModel? user = await SharedPreferencesHelper.getUserModel().timeout(
        const Duration(seconds: 5),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentState == null) {
          debugPrint('⚠️ Navigator not ready yet. Cannot navigate.');
          return;
        }

        if (user == null || user.token.isEmpty) {
          // User not logged in → go to login
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Routes.login,
            (route) => false,
          );
        } else {
          // User logged in → always navigate to home first
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Routes.home,
            (route) => false,
            arguments: user,
          );

          // Optionally navigate to the specific screen after Home
          if (route.isNotEmpty && route != Routes.home) {
            navigatorKey.currentState!.pushNamed(route);
          }
        }
      });
    } catch (e) {
      debugPrint('⚠️ Navigation handling failed: $e');
      // Fallback: just navigate to splash/login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.login,
          (route) => false,
        );
      });
    }
  }

  /// Check if notifications are initialized
  static bool get isInitialized => _isInitialized;

  /// Get cached token
  static String? get cachedToken => _cachedToken;
}
