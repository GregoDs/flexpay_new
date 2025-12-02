import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/auth/ui/login.dart';
import 'package:flexpay/features/auth/ui/otp_verification.dart';
import 'package:flexpay/features/auth/ui/register.dart';
import 'package:flexpay/features/auth/ui/onboarding_screen.dart';
import 'package:flexpay/features/auth/ui/splash_screen.dart';
import 'package:flexpay/features/bookings/ui/bookings.dart';
import 'package:flexpay/features/flexchama/ui/chama_details/chama_details.dart';
import 'package:flexpay/features/flexchama/ui/registration_chama/chama_reg.dart';
import 'package:flexpay/features/flexchama/ui/viewchama.dart';
import 'package:flexpay/features/goals/ui/goals.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';

/// ✅ Centralized route configuration
class AppRoutes {
  static final routes = {
    Routes.splash: (context) => const SplashScreen(),
    Routes.onboarding: (context) => const OnBoardingScreen(),

    Routes.register: (context) => const CreateAccountPage(),
    Routes.login: (context) => const LoginScreen(),
    Routes.otp: (context) => const OtpScreen(),

    Routes.chamaPage: (context) => const ChamaPage(),

    Routes.home: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;

      if (args is! UserModel) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomSnackBar.showError(
            context,
            title: "Error",
            message: "User data missing. Please log in again.",
          );
          Navigator.pushReplacementNamed(context, Routes.login);
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // ✅ NavigationWrapper will automatically access Cubits from global providers in main.dart
      return NavigationWrapper(initialIndex: 0, userModel: args);
    },

    Routes.goals: (context) => const GoalsPage(),
    Routes.registerChama: (context) => const ChamaRegistrationPage(),
    // Routes.viewChamas: (context) => const ViewChamas(),
    Routes.bookings: (context) => const BookingsPage(),
    Routes.merchants: (context) => MerchantsScreen(),
  };
}

/// ✅ Route name constants
class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const login = '/login';
  static const otp = '/otp';
  static const home = '/home';
  static const goals = '/goals';
  static const registerChama = '/registerChama';
  static const viewChamas = '/viewChamas';
  static const bookings = '/bookings';
  static const merchants = '/merchants';
  static const bookingDetails = '/booking-details';
  static const chamaPage = '/chamaPage';
}
