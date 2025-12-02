import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:google_fonts/google_fonts.dart';

void showBorrowLoanModalSheet(BuildContext context) {
  // Guard: ensure user has a positive loan limit before opening modal
  final chamastate = context.read<ChamaCubit>().state;
  int? loanLimit;
  if (chamastate is ChamaSavingsFetched) {
    loanLimit = chamastate.savingsResponse.data?.chamaDetails.loanLimit;
  } else if (chamastate is ChamaViewState) {
    loanLimit = chamastate.savings?.data?.chamaDetails.loanLimit;
  } else if (chamastate is ChamaSavingsLoading) {
    loanLimit = chamastate.previousSavings?.data?.chamaDetails.loanLimit;
  }
  if ((loanLimit ?? 0) <= 0) {
    CustomSnackBar.showError(
      context,
      title: "Unavailable",
      message: "Your loan limit is 0. You cannot borrow at the moment.",
    );
    return;
  }

  final TextEditingController amountController = TextEditingController();
  final chamaCubit = context.read<ChamaCubit>();

  bool loanSuccess = false;
  String? loanSuccessMessage;

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  // Dynamic color palette
  final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;
  final subtitleColor = isDark ? Colors.white70 : Colors.grey[700];
  final chipColor = isDark ? const Color(0xFF2C2C2C) : Colors.grey[200];
  final chipBorderColor = isDark ? Colors.blue[300]! : Colors.blue[800]!;
  final iconColor = isDark ? Colors.blue[300]! : Colors.blue[800]!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: backgroundColor,
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
              if (loanSuccess && state is ChamaSavingsFetched) {
                Navigator.pop(context);
                Future.microtask(() {
                  final parentContext = Navigator.of(
                    context,
                    rootNavigator: true,
                  ).context;
                  try {
                    parentContext.read<ChamaCubit>().fetchChamaUserSavings();
                  } catch (_) {
                    try {
                      context.read<ChamaCubit>().fetchChamaUserSavings();
                    } catch (_) {}
                  }
                });
                CustomSnackBar.showSuccess(
                  context,
                  title: "Loan Request Sent",
                  message:
                      "✅ ${loanSuccessMessage ?? 'Your loan request was submitted successfully!'}",
                );
                loanSuccess = false;
                loanSuccessMessage = null;
              } else if (state is RequestChamaLoanSuccess) {
                loanSuccess = true;
                loanSuccessMessage = state.response.message;
              } else if (state is RequestChamaLoanFailure) {
                Navigator.pop(context);
                Future.microtask(() {
                  final parentContext = Navigator.of(
                    context,
                    rootNavigator: true,
                  ).context;
                  try {
                    parentContext.read<ChamaCubit>().fetchChamaUserSavings();
                  } catch (_) {
                    try {
                      context.read<ChamaCubit>().fetchChamaUserSavings();
                    } catch (_) {}
                  }
                });
                CustomSnackBar.showError(
                  context,
                  title: "Loan Request Failed",
                  message: "⚠️ ${state.message}",
                );
                loanSuccess = false;
                loanSuccessMessage = null;
              }
            },
            builder: (context, state) {
              final isLoading = state.runtimeType.toString().endsWith(
                'Loading',
              );

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    Text(
                      "Request a Loan",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Text(
                      "Enter the amount you’d like to borrow. Your request will be reviewed and processed based on your Chama loan limit.",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),

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
                          _amountChip(
                            amt,
                            () => amountController.text = amt,
                            chipColor!,
                            chipBorderColor,
                            textColor,
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Enter amount to borrow",
                        hintStyle: GoogleFonts.montserrat(color: subtitleColor),
                        filled: true,
                        fillColor: chipColor,
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
                                    message: "Please enter a loan amount",
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

                                context.read<ChamaCubit>().requestChamaLoan(
                                  amount: parsedAmount,
                                );
                              },
                        child: isLoading
                            ? const SpinKitWave(color: Colors.white, size: 22.0)
                            : Text(
                                "Submit Loan Request",
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

Widget _amountChip(
  String label,
  VoidCallback onTap,
  Color chipColor,
  Color chipBorderColor,
  Color textColor,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipBorderColor, width: 1),
      ),
      child: Text(
        "Ksh $label",
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: chipBorderColor,
        ),
      ),
    ),
  );
}
