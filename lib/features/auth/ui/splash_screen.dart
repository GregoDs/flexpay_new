import 'dart:io';

import 'package:flexpay/exports.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/model/device_token_model.dart';
import 'package:flexpay/utils/services/notifications_manager.dart';
import 'package:flexpay/utils/services/initialization_service.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/services/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  final upgrader = Upgrader();
  
  
  // String _currentStatus = 'Initializing...';
  // double _progress = 0.0;
  // bool _showProgress = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.forward();

    // Start initialization immediately but NO progress UI
    _initializeApp();
    
    // COMMENTED OUT - Show progress indicator if initialization takes longer than 2 seconds
    // Future.delayed(const Duration(seconds: 2), () {
    //   if (mounted) {
    //     setState(() {
    //       _showProgress = true;
    //     });
    //   }
    // });
  }

  /// Professional initialization with progress tracking and error handling
  Future<void> _initializeApp() async {
    try {
      // COMMENTED OUT - _updateProgress('Starting services...', 0.1);
      
      // Start background initialization immediately (non-blocking)
      final initializationFuture = InitializationService.initializeServices();
      
      // COMMENTED OUT - _updateProgress('Loading app data...', 0.3);
      
      // Minimum splash time to show branding
      final minSplashTime = Future.delayed(const Duration(seconds: 3));
      
      // COMMENTED OUT - _updateProgress('Preparing user interface...', 0.6);
      
      // Wait for both minimum time and initialization
      await Future.wait([
        minSplashTime,
        initializationFuture,
      ]);
      
      // COMMENTED OUT - _updateProgress('Almost ready...', 0.9);
      
      // Check for version updates
      await _checkForVersionUpdate();
      
      // COMMENTED OUT - _updateProgress('Complete!', 1.0);
      
    } catch (e, stackTrace) {
      AppLogger.log('❌ App initialization failed: $e');
      AppLogger.log('Stack trace: $stackTrace');
      
      // Continue with app startup even if some services failed
      await _decideNextScreen();
    }
  }
  
  // COMMENTED OUT - Progress update method
  // void _updateProgress(String status, double progress) {
  //   if (mounted) {
  //     setState(() {
  //       _currentStatus = status;
  //       _progress = progress;
  //     });
  //   }
  // }

  Future<void> _checkForVersionUpdate() async {
    try {
      // COMMENTED OUT - _updateProgress('Checking for updates...', 0.95);
      
      // Try to get FCM token from initialization service
      String? fcmToken = InitializationService.fcmToken;
      
      // If not available, try to get it with timeout
      if (fcmToken == null) {
        fcmToken = await InitializationService.getFCMToken().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            AppLogger.log('⚠️ FCM token retrieval timed out during update check');
            return null;
          },
        );
      }

      // Send device info if token is available
      if (fcmToken != null) {
        try {
          final deviceModel = await DeviceTokenModel.getDeviceToken(fcmToken);
          await ApiDeviceService.sendDeviceInfo(
            deviceModel.toJson(),
          ).timeout(const Duration(seconds: 10));
        } catch (e) {
          AppLogger.log('⚠️ Device info sending failed: $e');
          // Continue without blocking the app
        }
      }

      String? playStoreVersion;
      String? installedVersion;

      // Check for updates with timeout
      await upgrader.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          AppLogger.log('⚠️ Update check timed out');
          return false; // Return a value to satisfy the return type
        },
      );

      playStoreVersion = upgrader.versionInfo?.appStoreVersion?.toString();
      installedVersion = upgrader.versionInfo?.installedVersion?.toString();

      AppLogger.log('Available update version: $playStoreVersion');
      AppLogger.log('Installed app version: $installedVersion');

      if (playStoreVersion != null && installedVersion != null) {
        if (_isNewerVersion(playStoreVersion, installedVersion)) {
          final updateUrl = Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=ke.co.flexpay.app'
              : 'https://apps.apple.com/app/app_store_id';
          _showUpdateDialog(updateUrl);
          return;
        }
      }
    } catch (e) {
      AppLogger.log('Version check failed: $e');
    }

    // Proceed to the next screen if no update required
    await _decideNextScreen();
  }

  void _showUpdateDialog(String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.fromLTRB(22, 24, 24, 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icon/flexhomelogo.png',
                      width: 36,
                      height: 36,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Update FlexPromoter?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Download size: 9.2 MB',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'FlexPromoter recommends that you update to the latest version. Kindly update for the necessary changes to be applied.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF388E3C), // Green
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          minimumSize: const Size(88, 36),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (await canLaunchUrl(Uri.parse(updateUrl))) {
                            await launchUrl(
                              Uri.parse(updateUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: const Text('UPDATE'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Center(
                  child: Image.asset(
                    'assets/icon/flexhomelogo.png',
                    width: 72,
                    height: 72,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isNewerVersion(String storeVersion, String installedVersion) {
    try {
      final store = Version.parse(storeVersion);
      final installed = Version.parse(installedVersion);
      return store > installed;
    } catch (_) {
      return storeVersion != installedVersion;
    }
  }

  Future<void> _decideNextScreen() async {
    try {
      final service = StartupService();
      final route = await service.decideNextRoute().timeout(
        const Duration(seconds: 5),
      );

      if (!mounted) return;

      switch (route) {
        case 'onboarding':
          Navigator.pushReplacementNamed(context, Routes.onboarding);
          break;
        case 'login':
          Navigator.pushReplacementNamed(context, Routes.login);
          break;
        case 'home':
          final user = await SharedPreferencesHelper.getUserModel();
          Navigator.pushReplacementNamed(context, Routes.home, arguments: user);
          break;
        default:
          // Fallback to login if route is unexpected
          Navigator.pushReplacementNamed(context, Routes.login);
      }
    } catch (e) {
      AppLogger.log('⚠️ Route decision failed: $e');
      // Fallback navigation
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: animation,
                child: Image.asset(
                  Assets.images.flexpay.path,
                  width: 330,
                  height: 250,
                ),
              ),

              // Show progress indicator if initialization is taking time
              // if (_showProgress) ...[
              //   const SizedBox(height: 60),
              //   Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     child: Column(
              //       children: [
              //         // Progress bar
              //         Container(
              //           width: double.infinity,
              //           height: 6,
              //           decoration: BoxDecoration(
              //             color: Colors.grey[200],
              //             borderRadius: BorderRadius.circular(3),
              //           ),
              //           child: FractionallySizedBox(
              //             alignment: Alignment.centerLeft,
              //             widthFactor: _progress,
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: ColorName.primaryColor,
              //                 borderRadius: BorderRadius.circular(3),
              //               ),
              //             ),
              //           ),
              //         ),
              //         const SizedBox(height: 16),

              //         // Status text
              //         Text(
              //           _currentStatus,
              //           style: GoogleFonts.montserrat(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.grey[600],
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}