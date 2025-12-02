import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

void showPayLoanModalSheet(BuildContext context) {
  // Guard: ensure user has an outstanding loan (loan_taken > 0) before opening modal
  final chamastate = context.read<ChamaCubit>().state;
  int? loanTaken;
  if (chamastate is ChamaSavingsFetched) {
    loanTaken = chamastate.savingsResponse.data?.chamaDetails.loanTaken;
  } else if (chamastate is ChamaViewState) {
    loanTaken = chamastate.savings?.data?.chamaDetails.loanTaken;
  } else if (chamastate is ChamaSavingsLoading) {
    loanTaken = chamastate.previousSavings?.data?.chamaDetails.loanTaken;
  }
  if ((loanTaken ?? 0) <= 0) {
    CustomSnackBar.showError(
      context,
      title: "Unavailable",
      message: "You have no outstanding loan to repay.",
    );
    return;
  }

  final TextEditingController amountController = TextEditingController();
  final chamaCubit = context.read<ChamaCubit>();

  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;
  final subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
  final fieldColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[200];
  final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

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
            listener: (context, state) async {
              if (state is RepayChamaLoanSuccess) {
                await Future.delayed(const Duration(milliseconds: 600));
                Navigator.pop(context);
                CustomSnackBar.showSuccess(
                  context,
                  title: "Loan Payment Initialized",
                  message: "✅ ${state.response.message}",
                );
              } else if (state is RepayChamaLoanFailure) {
                await Future.delayed(const Duration(milliseconds: 600));
                Navigator.pop(context);
                CustomSnackBar.showError(
                  context,
                  title: "Loan Payment Failed",
                  message: "⚠️ ${state.message}",
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is RepayChamaLoanLoading;

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
                          color: isDark ? Colors.grey[700] : Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Title
                    Text(
                      "Pay Off Your Loan",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // --- Description
                    Text(
                      "Enter the amount you wish to repay. The payment will be processed via your registered M-PESA number.",
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
                          _amountChip(amt, () {
                            amountController.text = amt;
                          }, isDark: isDark),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // --- Input Field
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Enter amount to repay",
                        hintStyle: TextStyle(color: subtitleColor),
                        filled: true,
                        fillColor: fieldColor,
                        prefixIcon: Icon(
                          Icons.payments_outlined,
                          color: ColorName.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 0.8,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 0.8,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ColorName.primaryColor,
                            width: 1.5,
                          ),
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
                                    message:
                                        "Please enter the repayment amount.",
                                  );
                                  return;
                                }

                                final parsedAmount = double.tryParse(amount);
                                if (parsedAmount == null || parsedAmount <= 0) {
                                  CustomSnackBar.showError(
                                    context,
                                    title: "Invalid Amount",
                                    message:
                                        "Please enter a valid repayment amount.",
                                  );
                                  return;
                                }

                                context.read<ChamaCubit>().repayChamaLoan(
                                  parsedAmount,
                                );
                              },
                        child: isLoading
                            ? const SpinKitWave(color: Colors.white, size: 22.0)
                            : Text(
                                "Repay Loan",
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

Widget _amountChip(String label, VoidCallback onTap, {required bool isDark}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorName.primaryColor, width: 1),
      ),
      child: Text(
        "Ksh $label",
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ColorName.primaryColor,
        ),
      ),
    ),
  );
}
