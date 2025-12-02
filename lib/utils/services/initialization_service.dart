import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flexpay/firebase_options.dart';
import 'package:flexpay/utils/services/notifications_manager.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/logger.dart';

/// 🚀 Professional initialization service to prevent ANR
/// Handles heavy initialization operations asynchronously with proper error handling
class InitializationService {
  static bool _isInitialized = false;
  static bool _isInitializing = false;
  static String? _fcmToken;

  /// Check if core services are initialized
  static bool get isInitialized => _isInitialized;
  static bool get isInitializing => _isInitializing;
  static String? get fcmToken => _fcmToken;

  /// Initialize all heavy services in background with proper error handling
  static Future<void> initializeServices() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;

    try {
      AppLogger.log('🚀 Starting background services initialization...');

      // Initialize Firebase first (required for notifications)
      await _initializeFirebase();
      
      // Initialize SharedPreferences in parallel with notifications (after Firebase is ready)
      final futures = <Future>[
        _initializeNotifications(),
        _warmupSharedPreferences(),
      ];

      // Wait for remaining services with timeout
      await Future.wait(futures, eagerError: false).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          AppLogger.log('⚠️ Services initialization timed out, continuing with partial setup');
          return <dynamic>[];
        },
      );

      _isInitialized = true;
      AppLogger.log('✅ Background services initialization completed');
    } catch (e, stackTrace) {
      AppLogger.log('❌ Services initialization failed: $e');
      if (!kReleaseMode) {
        AppLogger.log('Stack trace: $stackTrace');
      }
      // Don't block app startup for non-critical services
    } finally {
      _isInitializing = false;
    }
  }

  /// Initialize Firebase with proper error handling
  static Future<void> _initializeFirebase() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ).timeout(const Duration(seconds: 15));
        AppLogger.log('✅ Firebase initialized successfully');
      }
    } catch (e) {
      AppLogger.log('⚠️ Firebase initialization failed: $e');
      // Firebase failure shouldn't crash the app
    }
  }

  /// Initialize notifications with fallback handling
  static Future<void> _initializeNotifications() async {
    try {
      // Wait for Firebase to be initialized first
      if (Firebase.apps.isEmpty) {
        AppLogger.log('⚠️ Waiting for Firebase to initialize before notifications...');
        // Wait a bit for Firebase initialization to complete
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Check again, if still empty, skip notifications
        if (Firebase.apps.isEmpty) {
          AppLogger.log('⚠️ Firebase not ready, skipping notifications initialization');
          return;
        }
      }
      
      _fcmToken = await NotificationsManager.init().timeout(
        const Duration(seconds: 10),
      );
      AppLogger.log('✅ Notifications initialized, token: ${_fcmToken?.substring(0, 20)}...');
    } catch (e) {
      AppLogger.log('⚠️ Notifications initialization failed: $e');
      // App can function without notifications
    }
  }

  /// Warm up SharedPreferences to avoid first-access delays
  static Future<void> _warmupSharedPreferences() async {
    try {
      await SharedPreferencesHelper.init().timeout(
        const Duration(seconds: 5),
      );
      AppLogger.log('✅ SharedPreferences warmed up');
    } catch (e) {
      AppLogger.log('⚠️ SharedPreferences warmup failed: $e');
    }
  }

  /// Get FCM token with retry logic
  static Future<String?> getFCMToken({int retryCount = 3}) async {
    if (_fcmToken != null) return _fcmToken;

    for (int i = 0; i < retryCount; i++) {
      try {
        if (!_isInitialized && !_isInitializing) {
          await initializeServices();
        }

        if (_fcmToken != null) return _fcmToken;

        // Retry getting token
        _fcmToken = await NotificationsManager.getTokenOnly();
        if (_fcmToken != null) return _fcmToken;

        // Wait before retry
        if (i < retryCount - 1) {
          await Future.delayed(Duration(seconds: 1 << i)); // Exponential backoff
        }
      } catch (e) {
        AppLogger.log('⚠️ FCM token retrieval attempt ${i + 1} failed: $e');
      }
    }

    return null;
  }

  /// Force refresh FCM token
  static Future<String?> refreshFCMToken() async {
    try {
      _fcmToken = await NotificationsManager.refreshToken();
      return _fcmToken;
    } catch (e) {
      AppLogger.log('⚠️ FCM token refresh failed: $e');
      return null;
    }
  }

  /// Check if critical services are ready
  static bool get isReady => _isInitialized && Firebase.apps.isNotEmpty;
}
