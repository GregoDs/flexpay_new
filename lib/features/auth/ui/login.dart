import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/cubit/auth_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  String? _validationError;

  // Phone number validation method
  String? _validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove any spaces or special characters
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check valid formats: 254706622071, 0706622071, or 706622071
    if (cleanPhone.length == 12 && cleanPhone.startsWith('254')) {
      // Format: 254706622071
      String numberPart = cleanPhone.substring(3);
      if (numberPart.startsWith('7') || numberPart.startsWith('1')) {
        return null; // Valid
      }
    } else if (cleanPhone.length == 10 && cleanPhone.startsWith('0')) {
      // Format: 0706622071
      String numberPart = cleanPhone.substring(1);
      if (numberPart.startsWith('7') || numberPart.startsWith('1')) {
        return null; // Valid
      }
    } else if (cleanPhone.length == 9) {
      // Format: 706622071
      if (cleanPhone.startsWith('7') || cleanPhone.startsWith('1')) {
        return null; // Valid
      }
    }

    return 'Wrong phone number format, please try again';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.montserratTextTheme(
      Theme.of(context).textTheme,
    );
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        centerTitle: true,
        title: Text(
          "Sign In",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              setState(() => _isLoading = true);
            } else if (state is AuthOtpSent) {
              setState(() => _isLoading = false);
              CustomSnackBar.showSuccess(
                context,
                title: 'Success',
                message: state.message,
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushReplacementNamed(context, Routes.otp);
              });
            } else if (state is AuthError) {
              setState(() => _isLoading = false);
              CustomSnackBar.showError(
                context,
                title: 'Error',
                message: state.errorMessage,
                actionLabel: 'Dismiss',
                onAction: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.32,
                      child: Lottie.asset(
                        'assets/images/auth_images/Welcome.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.026),

                    // Intro text
                    Text(
                      "Hello There",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Text(
                      "Sign in to continue to Flexpay lipiapolepole",
                      style: textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Phone field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: phoneController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.montserrat(color: textColor),
                      onChanged: (value) {
                        // Clear validation error when user starts typing again
                        if (_validationError != null) {
                          setState(() {
                            _validationError = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldColor,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/flags/kenya.png',
                                width: 24,
                                height: 18,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "+254",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        hintText: "phone number",
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.grey[500],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _validationError != null ? Colors.red : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _validationError != null ? Colors.red : ColorName.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (_validationError != null) ...[
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _validationError!,
                          style: GoogleFonts.montserrat(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: GestureDetector(
                    //     onTap: _isLoading ? null : () {},
                    //     child: Text(
                    //       "Forgot Password?",
                    //       style: textTheme.bodySmall?.copyWith(
                    //         color: ColorName.primaryColor,
                    //         fontWeight: FontWeight.w600,
                    //         decoration: TextDecoration.underline,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: screenHeight * 0.02),

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.018,
                          ),
                        ),
                        onPressed: _isLoading 
                            ? null
                            : () {
                                final phoneNumber = phoneController.text.trim();
                                final validationError = _validatePhoneNumber(phoneNumber);
                                
                                if (validationError != null) {
                                  setState(() {
                                    _validationError = validationError;
                                  });
                                  return;
                                }

                                // Clear any existing validation errors if phone is valid
                                setState(() {
                                  _validationError = null;
                                });

                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setString('phone_number', phoneNumber);
                                });
                                context.read<AuthCubit>().requestOtp(phoneNumber);
                              },
                        child: _isLoading
                            ? Center(
                                child: SpinKitWave(
                                  color: ColorName.primaryColor,
                                  size: 28,
                                ),
                              )
                            : Text(
                                "Sign In",
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: textTheme.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () => Navigator.pushReplacementNamed(
                                  context,
                                  Routes.register,
                                ),
                          child: Text(
                            "Register now",
                            style: textTheme.bodyMedium?.copyWith(
                              color: ColorName.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
