import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpay/features/bookings/cubit/bookings_state.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';

class BookingPaymentModal {
  static Future<bool?> show(
    BuildContext context, {
    required String bookingName,
    required String initialPhone,
    required String bookingReference,
  }) async {
    final amountController = TextEditingController();

    /// ✅ Prefilled phone
    final userModel = await SharedPreferencesHelper.getUserModel();
    final prefilledPhone = userModel?.user.phoneNumber ?? initialPhone;
    final phoneController = TextEditingController(text: prefilledPhone);

    String selectedSource = "M-Pesa"; // default
    bool localLoading = false; // Local loading control

    /// ✅ Theme Handling
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final fieldColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF3F4F6);
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white60 : Colors.grey[600];
    final accentColor = const Color(0xFF009AC1);
    final borderHighlight = isDark ? Colors.tealAccent : Colors.amber;

    final bookingsCubit = context.read<BookingsCubit>();

    return await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: bookingsCubit,
          child: StatefulBuilder(
            builder: (context, setState) {
              return BlocListener<BookingsCubit, BookingsState>(
                listener: (context, state) async {
                  // When wallet payment succeeds
                  if (state is BookingWalletPaymentSuccess) {
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
                      message: "Booking payment completed successfully ✅",
                    );
                  }
                  // When M-Pesa payment succeeds
                  else if (state is BookingMpesaPaymentSuccess) {
                    Navigator.pop(context, true);
                    CustomSnackBar.showSuccess(
                      context,
                      title: "M-Pesa Payment Initiated",
                      message: "Check your phone to complete the payment.",
                    );
                  }
                  // Errors - keep modal open and show overlay
                  else if (state is BookingWalletPaymentError ||
                      state is BookingMpesaPaymentError) {
                    setState(() => localLoading = false);
                    CustomSnackBar.showError(
                      context,
                      title: "Payment Failed",
                      message: state is BookingWalletPaymentError
                          ? "⚠️ ${state.message}"
                          : "⚠️ ${(state as BookingMpesaPaymentError).message}",
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
                        // ✅ Header
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
                                Icons.payment,
                                size: 40.sp,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Pay for $bookingName",
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

                        // ✅ Body
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Payment method selector
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _PaymentOptionCard(
                                    imagePath:
                                        "assets/images/payment_platform/mpesa_img.png",
                                    label: "M-Pesa",
                                    isSelected: selectedSource == "M-Pesa",
                                    onTap: () => setState(
                                      () => selectedSource = "M-Pesa",
                                    ),
                                    isDark: isDark,
                                    borderHighlight: borderHighlight,
                                    cardColor: cardColor,
                                  ),
                                  _PaymentOptionCard(
                                    imagePath:
                                        "assets/images/payment_platform/wallet_img.webp",
                                    label: "Wallet",
                                    isSelected: selectedSource == "Wallet",
                                    onTap: () => setState(
                                      () => selectedSource = "Wallet",
                                    ),
                                    isDark: isDark,
                                    borderHighlight: borderHighlight,
                                    cardColor: cardColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              // Phone field
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

                              // Amount field
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

                              // ✅ Payment Button
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
                                                .read<BookingsCubit>()
                                                .payBookingFromWallet(
                                                  bookingReference,
                                                  amount,
                                                );
                                          } else {
                                            await context
                                                .read<BookingsCubit>()
                                                .payBookingViaMpesa(
                                                  bookingReference,
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
  final bool isDark;
  final VoidCallback onTap;
  final Color borderHighlight;
  final Color cardColor;

  const _PaymentOptionCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    required this.borderHighlight,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black87;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(color: borderHighlight, width: 2.5)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: borderHighlight.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: AnimatedScale(
            scale: isSelected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                Image.asset(imagePath, width: 75.w, height: 85.w),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? borderHighlight : textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
