import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

void showKapuDebitModalSheet(
  BuildContext context, {
  required String merchantId,
}) {
  final TextEditingController amountController = TextEditingController();
  final kapuCubit = context.read<KapuCubit>();

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
                    if (state is KapuDebitSuccess) {
                      Navigator.pop(context);
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Debit Successful",
                        message: "✅ ${state.response.message}",
                      );
                    } else if (state is KapuDebitFailure) {
                      Navigator.pop(context);
                      CustomSnackBar.showError(
                        context,
                        title: "Debit Failed",
                        message: "⚠️ ${state.message}",
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is KapuDebitLoading;

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
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // --- Title
                          Text(
                            "Debit Wallet",
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // --- Description
                          Text(
                            "Enter the amount you wish to debit from your Kapu merchant wallet.",
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              color: Colors.black87,
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
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: [
                              for (final amt
                                  in ["500", "1000", "5000", "10000", "20000"])
                                _amountChip(amt, () {
                                  amountController.text = amt;
                                }),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // --- Amount Input Field
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.montserrat(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter amount to debit",
                              hintStyle: GoogleFonts.montserrat(
                                color: Colors.grey[600],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.payments_outlined,
                                color: ColorName.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
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
                                elevation: 3,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      final amountText =
                                          amountController.text.trim();

                                      final parsedAmount =
                                          double.tryParse(amountText);
                                      if (parsedAmount == null ||
                                          parsedAmount <= 0) {
                                        CustomSnackBar.showError(
                                          context,
                                          title: "Invalid Amount",
                                          message:
                                              "Please enter a valid debit amount.",
                                        );
                                        return;
                                      }

                                      context.read<KapuCubit>().debitWallet(
                                            merchantId: merchantId,
                                            amount: parsedAmount,
                                          );
                                    },
                              child: isLoading
                                  ? const SpinKitWave(
                                      color: Colors.white,
                                      size: 22.0,
                                    )
                                  : Text(
                                      "Debit Now",
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
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Widget _amountChip(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorName.primaryColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
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