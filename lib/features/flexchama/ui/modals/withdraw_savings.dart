import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showWithdrawModalSheet(BuildContext context) {
  // Guard: ensure user has withdrawable amount > 0 before opening modal
  final chamastate = context.read<ChamaCubit>().state;
  int? withdrawable;
  if (chamastate is ChamaSavingsFetched) {
    withdrawable =
        chamastate.savingsResponse.data?.chamaDetails.withdrawableAmount;
  } else if (chamastate is ChamaViewState) {
    withdrawable = chamastate.savings?.data?.chamaDetails.withdrawableAmount;
  } else if (chamastate is ChamaSavingsLoading) {
    withdrawable =
        chamastate.previousSavings?.data?.chamaDetails.withdrawableAmount;
  }
  if ((withdrawable ?? 0) <= 0) {
    CustomSnackBar.showError(
      context,
      title: "Unavailable",
      message: "Sorry, you do not have sufficient withdrawable savings.",
    );
    return;
  }

  final TextEditingController amountController = TextEditingController();
  final chamaCubit = context.read<ChamaCubit>();

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;
  final subtitleColor = isDark ? Colors.white70 : Colors.grey[700];
  final chipBgColor = isDark ? const Color(0xFF2A2A2D) : Colors.grey[200];
  final chipBorderColor = isDark ? Colors.white54 : Colors.blue[800];
  final inputFillColor = isDark ? const Color(0xFF2A2A2D) : Colors.grey[200];
  final iconColor = isDark ? Colors.white70 : Colors.blue[800];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: chamaCubit,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: BlocConsumer<ChamaCubit, ChamaState>(
            listener: (context, state) {
              if (state is WithdrawChamaSavingsSuccess) {
                Navigator.pop(context);
                CustomSnackBar.showSuccess(
                  context,
                  title: "Withdrawal Sent",
                  message:
                      "✅ ${state.response.message ?? 'Request successful!'}",
                );

                // ✅ Refresh savings after successful withdrawal
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    context.read<ChamaCubit>().fetchChamaUserSavings();
                  }
                });
              } else if (state is WithdrawChamaSavingsFailure) {
                Navigator.pop(context);
                CustomSnackBar.showError(
                  context,
                  title: "Withdrawal Failed",
                  message: "⚠️ ${state.message}",
                );

                // ✅ CRITICAL: Refresh savings even after failure to reset loading state
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    context.read<ChamaCubit>().fetchChamaUserSavings();
                  }
                });
              }
            },
            builder: (context, state) {
              final isLoading = state is WithdrawChamaSavingsLoading;

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header indicator
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Title
                    Text(
                      "Withdraw from Chama Savings",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // --- Description
                    Text(
                      "Enter the amount you'd like to withdraw. The funds will be processed and sent to your registered M-PESA number.",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Quick Amounts
                    Text(
                      "Quick Amounts",
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: [
                        for (final amt in [
                          "500",
                          "1000",
                          "5000",
                          "10000",
                          "20000",
                        ])
                          GestureDetector(
                            onTap: () {
                              amountController.text = amt;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: chipBgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: chipBorderColor!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Ksh $amt",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // --- Input Field
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Enter amount to withdraw",
                        hintStyle: GoogleFonts.montserrat(color: subtitleColor),
                        filled: true,
                        fillColor: inputFillColor,
                        prefixIcon: Icon(
                          Icons.money_outlined,
                          color: iconColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // --- Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                final amount = amountController.text.trim();
                                if (amount.isEmpty) {
                                  CustomSnackBar.showError(
                                    context,
                                    title: "Missing Amount",
                                    message: "Please enter withdrawal amount",
                                  );
                                  return;
                                }

                                final parsedAmount = double.tryParse(amount);
                                if (parsedAmount == null || parsedAmount <= 0) {
                                  CustomSnackBar.showError(
                                    context,
                                    title: "Invalid Amount",
                                    message: "Please enter a valid amount",
                                  );
                                  return;
                                }

                                context.read<ChamaCubit>().withdrawChamaSavings(
                                  parsedAmount,
                                );
                              },
                        child: isLoading
                            ? const SpinKitWave(color: Colors.white, size: 22.0)
                            : Text(
                                "Send Withdrawal Request",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
