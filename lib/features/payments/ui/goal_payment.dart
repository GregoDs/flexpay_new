import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/goals/cubits/goals_cubit.dart';
import 'package:flexpay/features/goals/cubits/goals_state.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';

class GoalPaymentModal {
  static Future<bool?> show(
    BuildContext context, {
    required String goalName,
    required String initialPhone,
    required String goalReference,
    required String prefilledAmount,
  }) async {
    final amountController = TextEditingController(text: prefilledAmount);
    final userModel = await SharedPreferencesHelper.getUserModel();
    final prefilledPhone = userModel?.user.phoneNumber ?? initialPhone;
    final phoneController = TextEditingController(text: prefilledPhone);

    String selectedSource = "M-Pesa"; // Default
    bool localLoading = false; // Local loading control

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final fieldColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF3F4F6);
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.grey[600];
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final accentColor = const Color(0xFF009AC1);
    final borderHighlight = isDark ? Colors.tealAccent : Colors.amber;

    final goalsCubit = context.read<GoalsCubit>();

    return await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: goalsCubit,
          child: StatefulBuilder(
            builder: (context, setState) {
              return BlocListener<GoalsCubit, GoalsState>(
                listener: (context, state) async {
                  // When wallet payment succeeds
                  if (state is GoalWalletPaymentSuccess) {
                    // Check if the response actually contains errors
                    final response = state.response;
                    if (response.data?.success == false &&
                        response.data?.errors?.isNotEmpty == true) {
                      // This is actually an error disguised as success
                      setState(() => localLoading = false);
                      CustomSnackBar.showError(
                        context,
                        title: "Payment Failed",
                        message:
                            "⚠️ ${response.data?.errors?.first ?? 'Payment failed'}",
                        useOverlay: true, // Show above modal
                      );
                      return;
                    }

                    // Actual success
                    Navigator.pop(context, true);
                    CustomSnackBar.showSuccess(
                      context,
                      title: "Payment Success",
                      message: "Goal payment done successfully ✅",
                    );
                  }
                  // When M-Pesa payment succeeds
                  else if (state is GoalMpesaPaymentSuccess) {
                    Navigator.pop(context, true);
                    CustomSnackBar.showSuccess(
                      context,
                      title: "M-Pesa Payment Initiated",
                      message: "Check your phone to complete the payment.",
                    );
                  }
                  // Errors - keep modal open and show overlay
                  else if (state is GoalWalletPaymentError ||
                      state is GoalMpesaPaymentError) {
                    setState(() => localLoading = false);
                    CustomSnackBar.showError(
                      context,
                      title: "Payment Failed",
                      message: state is GoalWalletPaymentError
                          ? "⚠️ ${state.message}"
                          : "⚠️ ${(state as GoalMpesaPaymentError).message}",
                      useOverlay: true, // Show above modal
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 22.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      const Color(0xFF006D80),
                                      const Color(0xFF002E3B),
                                    ]
                                  : [
                                      const Color(0xFF009AC1),
                                      const Color(0xFF1D3C4E),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.savings_rounded,
                                size: 40.sp,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Pay towards $goalName",
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Choose payment method and enter details",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Body
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Payment Options
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _PaymentOptionCard(
                                    imagePath:
                                        "assets/images/payment_platform/mpesa_img.png",
                                    label: "M-Pesa",
                                    isSelected: selectedSource == "M-Pesa",
                                    onTap: () => setState(() {
                                      selectedSource = "M-Pesa";
                                    }),
                                    isDark: isDark,
                                    borderHighlight: borderHighlight,
                                    cardColor: cardColor,
                                  ),
                                  _PaymentOptionCard(
                                    imagePath:
                                        "assets/images/payment_platform/wallet_img.webp",
                                    label: "Wallet",
                                    isSelected: selectedSource == "Wallet",
                                    onTap: () => setState(() {
                                      selectedSource = "Wallet";
                                    }),
                                    isDark: isDark,
                                    borderHighlight: borderHighlight,
                                    cardColor: cardColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              // Phone input
                              Text(
                                "Phone Number",
                                style: GoogleFonts.montserrat(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.montserrat(color: textColor),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fieldColor,
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: accentColor,
                                  ),
                                  hintText: "Enter phone number",
                                  hintStyle: GoogleFonts.montserrat(
                                    color: hintColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Amount input
                              Text(
                                "Amount",
                                style: GoogleFonts.montserrat(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.montserrat(color: textColor),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fieldColor,
                                  prefixIcon: Icon(
                                    Icons.currency_exchange,
                                    color: accentColor,
                                  ),
                                  hintText: "Enter amount",
                                  hintStyle: GoogleFonts.montserrat(
                                    color: hintColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // Pay Button
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: localLoading
                                      ? null
                                      : () async {
                                          final amount = double.tryParse(
                                            amountController.text.trim(),
                                          );
                                          final phone = phoneController.text
                                              .trim();

                                          if (amount == null || amount <= 0) {
                                            CustomSnackBar.showError(
                                              context,
                                              title: "Invalid Amount",
                                              message:
                                                  "Please enter a valid amount.",
                                            );
                                            return;
                                          }

                                          if (selectedSource == "M-Pesa" &&
                                              phone.isEmpty) {
                                            CustomSnackBar.showError(
                                              context,
                                              title: "Missing Phone",
                                              message:
                                                  "Please enter a phone number.",
                                            );
                                            return;
                                          }

                                          setState(() => localLoading = true);

                                          if (selectedSource == "Wallet") {
                                            await context
                                                .read<GoalsCubit>()
                                                .payGoalFromWallet(
                                                  goalReference,
                                                  amount,
                                                );
                                          } else {
                                            await context
                                                .read<GoalsCubit>()
                                                .payGoalViaMpesa(
                                                  goalReference,
                                                  amount,
                                                  phone,
                                                );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                  ),
                                  child: localLoading
                                      ? SpinKitWave(
                                          color: Colors.white,
                                          size: 24.sp,
                                        )
                                      : Text(
                                          "Make Payment",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final Color borderHighlight;
  final Color cardColor;

  const _PaymentOptionCard({
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    required this.borderHighlight,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? borderHighlight
                  : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: borderHighlight.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(8.w),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.payment,
                      size: 24.sp,
                      color: const Color(0xFF009AC1),
                    );
                  },
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
