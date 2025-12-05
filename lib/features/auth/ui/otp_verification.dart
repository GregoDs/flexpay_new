import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/cubit/auth_state.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/main.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final UserModel userModel;
  final TextEditingController _otpController = TextEditingController();
  String? _phoneNumber;
  bool _isLoading = false;
  bool _isSnackBarShowing = false;
  bool _isResendingOtp = false;
  bool _isVerifyingOtp = false;
  int _secondsRemaining = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phone_number');
    });
  }

  void _startTimer() {
    _secondsRemaining = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onVerifyOtp() {
    if (_phoneNumber != null && _otpController.text.length == 4) {
      setState(() {
        _isLoading = true;
        _isVerifyingOtp = true;
      });
      authCubit.verifyOtp(_phoneNumber!, _otpController.text);
    }
  }

  void _resendOtp() {
    if (_phoneNumber != null && !_isResendingOtp) {
      setState(() {
        _isResendingOtp = true;
        _secondsRemaining = 10;
      });
      _startTimer();
      authCubit.requestOtp(_phoneNumber!, isResend: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1A1A1A)
          : ColorName.whiteColor,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthTokenInvalid) {
              CustomSnackBar.showError(
                context,
                title: "Session Ended",
                message: "Sorry, your session has ended. Please log in again.",
              );
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
            }
          },
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUserUpdated) {
                try {
                  context.read<ChamaCubit>().clearUserData();
                  context
                      .read<HomeCubit>()
                      .clearUserData(); // Reset home cubit when new user logs in
                } catch (e) {}

                final userModel = state.userModel;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home,
                  (route) => false,
                  arguments: userModel,
                );
              } else if (state is AuthOtpSent) {
                setState(() {
                  _isResendingOtp = false;
                  _isLoading = false;
                  _otpController.clear();
                  _secondsRemaining = 10;
                  _startTimer();
                });

                CustomSnackBar.showSuccess(
                  context,
                  title: 'OTP Sent',
                  message: state.message,
                );
              } else if (state is AuthResendOtp) {
                // ✅ Handle resend OTP
                setState(() {
                  _isResendingOtp = false;
                  _isLoading = false;
                  _otpController.clear();
                  _secondsRemaining = 10;
                  _startTimer();
                });

                CustomSnackBar.showSuccess(
                  context,
                  title: 'OTP Resent',
                  message: state.message,
                );
              } else if (state is AuthError) {
                setState(() {
                  _isSnackBarShowing = true;
                  _isResendingOtp = false;
                  _isLoading = false;
                  _isVerifyingOtp = false;
                });

                // ✅ Check for specific "User not found Or not Verified." error
                final errorMessage = state.errorMessage;
                if (errorMessage.contains("User not found Or not Verified.") ||
                    errorMessage.contains("User not found")) {
                  CustomSnackBar.showError(
                    context,
                    title: 'Account Not Found',
                    message: 'User not found. Kindly register to sign in.',
                    actionLabel: 'Register Now',
                    onAction: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      setState(() {
                        _isSnackBarShowing = false;
                      });
                      // Navigate to register page
                      Navigator.pushReplacementNamed(context, Routes.register);
                    },
                  );
                } else {
                  CustomSnackBar.showError(
                    context,
                    title: 'Error',
                    message: errorMessage,
                    actionLabel: 'Dismiss',
                    onAction: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      setState(() {
                        _isSnackBarShowing = false;
                      });
                    },
                  );
                }
              }
            },
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: isDarkMode
                                      ? Colors.white
                                      : ColorName.blackColor,
                                ),
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  Routes.login,
                                ),
                              ),
                              const Text(
                                "Verify otp",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Lottie.asset(
                            "assets/images/otpver.json",
                            fit: BoxFit.contain,
                            height: constraints.maxHeight * 0.25,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Title
                        Text(
                          "Enter OTP",
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          "A 4 digit code has been sent to your \nmobile number ${_phoneNumber ?? "+00-0000-000-0000"}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : ColorName.mainGrey,
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        const SizedBox(height: 32),

                        // OTP fields
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 68,
                            fieldWidth: 58,
                            activeFillColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.white,
                            inactiveFillColor: isDarkMode
                                ? Colors.grey[900]
                                : Colors.white,
                            selectedFillColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.white,
                            activeColor: ColorName.primaryColor,
                            inactiveColor: isDarkMode
                                ? Colors.grey[700]
                                : ColorName.lightGrey,
                            selectedColor: ColorName.primaryColor,
                          ),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: isDarkMode
                                ? Colors.white
                                : ColorName.blackColor,
                            fontFamily: 'Montserrat',
                          ),
                          cursorColor: ColorName.primaryColor,
                          enableActiveFill: true,
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          beforeTextPaste: (text) => true,
                        ),

                        const SizedBox(height: 24),

                        // Verify button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                (_otpController.text.length == 4 && !_isLoading)
                                ? _onVerifyOtp
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorName.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? Center(
                                    child: SpinKitWave(
                                      color: ColorName.primaryColor,
                                      size: 28,
                                    ),
                                  )
                                : const Text(
                                    "Verify OTP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Timer
                        Text(
                          "Request code again  00:${_secondsRemaining.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : ColorName.blackColor,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        // Resend OTP
                        TextButton(
                          onPressed:
                              (_secondsRemaining == 0 && !_isResendingOtp)
                              ? _resendOtp
                              : null,
                          child: _isResendingOtp
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorName.blue200,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                    color: ColorName.blue200,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
