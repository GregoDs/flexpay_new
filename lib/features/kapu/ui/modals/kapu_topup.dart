import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

void showKapuTopUpModalSheet(
  BuildContext context, {
  required UserModel? userModel,
  required BookingData booking,
}) {
  // Add null safety checks for userModel and booking
  if (userModel == null ||
      booking.merchantId == null ||
      booking.merchantId!.isEmpty) {
    Future.delayed(Duration.zero, () {
      CustomSnackBar.showError(
        context,
        title: "Invalid Data",
        message: "Unable to process top-up. Missing required information.",
      );
    });
    return;
  }

  String initialPhone = '';
  if (userModel.user.phoneNumber.isNotEmpty) {
    final userPhone = userModel.user.phoneNumber;
    try {
      if (userPhone.startsWith('07')) {
        initialPhone = '254${userPhone.substring(1)}';
      } else if (userPhone.startsWith('+254')) {
        initialPhone = userPhone.substring(1);
      } else if (userPhone.startsWith('254')) {
        initialPhone = userPhone;
      } else {
        initialPhone = userPhone;
      }
    } catch (e) {
      // Handle any string manipulation errors gracefully
      initialPhone = userPhone;
    }
  }

  final TextEditingController phoneController = TextEditingController(
    text: initialPhone,
  );
  final TextEditingController amountController = TextEditingController();
  final kapuCubit = context.read<KapuCubit>();

  String selectedSource = "M-Pesa"; // default source
  bool localLoading = false; // Local loading feedback

  // Add safety check for booking data
  final merchantId = booking.merchantId ?? "";
  if (merchantId.isEmpty) {
    Future.delayed(Duration.zero, () {
      CustomSnackBar.showError(
        context,
        title: "Invalid Merchant",
        message: "Merchant information is missing. Cannot proceed with top-up.",
      );
    });
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: ColorName.primaryColor,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        child: BlocProvider.value(
          value: kapuCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return BlocConsumer<KapuCubit, KapuState>(
                  listener: (context, state) {
                    if (state is KapuTopUpSuccess ||
                        state is KapuWalletTopUpSuccess) {
                      // Add safety check before wallet refresh
                      if (merchantId.isNotEmpty) {
                        try {
                          // Fire wallet balance re-fetch so balance in PromoDetails updates
                          context.read<KapuCubit>().fetchKapuWalletBalance(
                            merchantId,
                          );
                        } catch (e) {
                          // Handle any errors in wallet refresh gracefully
                        }
                      }
                      Navigator.pop(context);
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Top-up Success",
                        message: selectedSource == "M-Pesa"
                            ? "Mpesa STK prompt sent."
                            : "Wallet top-up successful.",
                      );
                    } else if (state is KapuTopUpFailure ||
                        state is KapuWalletTopUpFailure) {
                      setState(() => localLoading = false);
                      final errorMessage = state is KapuTopUpFailure
                          ? state.message
                          : (state as KapuWalletTopUpFailure).message;
                      CustomSnackBar.showError(
                        context,
                        title: "Top-Up Failed",
                        message: "⚠️ $errorMessage",
                        useOverlay: true,
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading =
                        localLoading ||
                        state is KapuTopUpLoading ||
                        state is KapuWalletTopUpLoading;

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header indicator
                          Center(
                            child: Container(
                              width: 50.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Payment method selector with safety checks
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _PaymentOptionCard(
                                imagePath:
                                    "assets/images/payment_platform/mpesa_img.png",
                                label: "M-Pesa",
                                isSelected: selectedSource == "M-Pesa",
                                onTap: () {
                                  setState(() => selectedSource = "M-Pesa");
                                },
                                borderHighlight: ColorName.primaryColor,
                                cardColor: Colors.white,
                              ),
                              _PaymentOptionCard(
                                imagePath:
                                    "assets/images/payment_platform/wallet_img.webp",
                                label: "Wallet",
                                isSelected: selectedSource == "Wallet",
                                onTap: () {
                                  setState(() => selectedSource = "Wallet");
                                },
                                borderHighlight: ColorName.primaryColor,
                                cardColor: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Top-Up Kapu Wallet",
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            selectedSource == "M-Pesa"
                                ? "Enter your phone number and amount to top-up via M-Pesa."
                                : "Enter amount to top-up your Kapu wallet from your balance.",
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Phone (enabled only for Mpesa)
                          if (selectedSource == "M-Pesa")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  enabled: true,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter phone number",
                                    prefixIcon: const Icon(
                                      Icons.phone_outlined,
                                      color: ColorName.primaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          // Amount field
                          Text(
                            "Amount",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.montserrat(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter amount to top-up",
                              prefixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: ColorName.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      final amountText = amountController.text
                                          .trim();
                                      final rawPhone = phoneController.text
                                          .trim();

                                      // Add comprehensive validation
                                      final parsedAmount = double.tryParse(
                                        amountText,
                                      );
                                      if (parsedAmount == null ||
                                          parsedAmount <= 0) {
                                        CustomSnackBar.showError(
                                          context,
                                          title: "Invalid Amount",
                                          message:
                                              "Please enter a valid top-up amount.",
                                        );
                                        return;
                                      }

                                      // Add maximum amount validation
                                      if (parsedAmount > 100000) {
                                        CustomSnackBar.showError(
                                          context,
                                          title: "Amount Too Large",
                                          message:
                                              "Maximum top-up amount is KES 100,000.",
                                        );
                                        return;
                                      }

                                      if (selectedSource == "M-Pesa") {
                                        // Enhanced phone validation
                                        if (rawPhone.isEmpty) {
                                          CustomSnackBar.showError(
                                            context,
                                            title: "Invalid Phone Number",
                                            message:
                                                "Please enter your phone number.",
                                          );
                                          return;
                                        }

                                        String formattedPhone = rawPhone;
                                        try {
                                          if (rawPhone.startsWith("07")) {
                                            formattedPhone =
                                                "254${rawPhone.substring(1)}";
                                          } else if (rawPhone.startsWith(
                                            "+254",
                                          )) {
                                            formattedPhone = rawPhone.substring(
                                              1,
                                            );
                                          } else if (!rawPhone.startsWith(
                                            "254",
                                          )) {
                                            CustomSnackBar.showError(
                                              context,
                                              title: "Invalid Phone Number",
                                              message:
                                                  "Phone must start with 07 or 254.",
                                            );
                                            return;
                                          }

                                          if (formattedPhone.length != 12) {
                                            CustomSnackBar.showError(
                                              context,
                                              title: "Invalid Phone Number",
                                              message:
                                                  "Phone number should be 12 digits (e.g., 2547XXXXXXXX).",
                                            );
                                            return;
                                          }
                                        } catch (e) {
                                          CustomSnackBar.showError(
                                            context,
                                            title: "Phone Format Error",
                                            message:
                                                "Unable to format phone number. Please check and try again.",
                                          );
                                          return;
                                        }

                                        setState(() => localLoading = true);

                                        try {
                                          // Add safety check for booking data before API call
                                          if (booking.merchantId == null ||
                                              booking.merchantId!.isEmpty) {
                                            throw Exception(
                                              "Invalid merchant information",
                                            );
                                          }

                                          // Proceed with M-Pesa
                                          context
                                              .read<KapuCubit>()
                                              .topUpKapuWallet(
                                                amount: parsedAmount,
                                                phoneNumber: formattedPhone,
                                                booking: booking,
                                              );
                                        } catch (e) {
                                          setState(() => localLoading = false);
                                          CustomSnackBar.showError(
                                            context,
                                            title: "Top-Up Error",
                                            message:
                                                "Failed to initiate M-Pesa payment. Please try again.",
                                          );
                                        }
                                      } else {
                                        // Enhanced wallet flow validation
                                        if (merchantId.isEmpty) {
                                          CustomSnackBar.showError(
                                            context,
                                            title: "Invalid Merchant",
                                            message:
                                                "Merchant information is missing.",
                                          );
                                          return;
                                        }

                                        setState(() => localLoading = true);

                                        try {
                                          context
                                              .read<KapuCubit>()
                                              .payKapuFromWallet(
                                                merchantId: merchantId,
                                                amount: parsedAmount.toString(),
                                              );
                                        } catch (e) {
                                          setState(() => localLoading = false);
                                          CustomSnackBar.showError(
                                            context,
                                            title: "Wallet Payment Error",
                                            message:
                                                "Failed to process wallet payment. Please try again.",
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorName.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 3,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: isLoading
                                  ? const SpinKitWave(
                                      color: Colors.white,
                                      size: 22.0,
                                    )
                                  : Text(
                                      selectedSource == "M-Pesa"
                                          ? "Top-Up via MPESA"
                                          : "Top-Up from Wallet",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 40.h),
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
    },
  );
}

class _PaymentOptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color borderHighlight;
  final Color cardColor;

  const _PaymentOptionCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.borderHighlight,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black87;
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
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: borderHighlight, width: 2.5)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: borderHighlight.withOpacity(0.13),
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
                Image.asset(imagePath, width: 62.w, height: 67.w),
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
