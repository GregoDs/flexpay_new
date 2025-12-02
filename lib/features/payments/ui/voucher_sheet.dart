import 'package:flexpay/features/payments/cubits/payments_cubit.dart';
import 'package:flexpay/features/payments/cubits/payments_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showMerchantVoucherModal(
  BuildContext context,
  String merchantName,
  int merchantId,
) {
  final TextEditingController amountController = TextEditingController();
  final paymentsCubit = context.read<PaymentsCubit>();

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;
  final subtitleColor = isDark ? Colors.white70 : Colors.grey[700];
  final chipBgColor = isDark ? const Color(0xFF2A2A2D) : Colors.grey[200];
  final chipBorderColor = isDark ? Colors.white54 : Colors.blue[800];
  final inputFillColor = isDark ? const Color(0xFF2A2A2D) : Colors.grey[200];
  final iconColor = isDark ? Colors.white70 : Colors.blue[800];

  final List<Map<String, dynamic>> merchants = [
    {
      'name': 'Naivas Supermarket',
      'merchant_id': '107',
      'color': const Color(0xFFFFB020),
    },
    {
      'name': 'HotPoint Appliances',
      'merchant_id': '73',
      'color': const Color(0xFFCD0000),
    },
    {
      'name': 'Appliance Zone',
      'merchant_id': '347',
      'color': const Color(0xFF111111),
    },
    {
      'name': 'CityWalk Limited',
      'merchant_id': '689',
      'color': const Color(0xFF761B1A),
    },
  ];

  String? selectedMerchantName;
  String? selectedMerchantId;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return BlocProvider.value(
            value: paymentsCubit,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: BlocConsumer<PaymentsCubit, PaymentsState>(
                listener: (context, state) {
                  if (state is VoucherSuccess) {
                    Navigator.pop(context);
                    CustomSnackBar.showSuccess(
                      context,
                      title: "Success!",
                      message: "✅ Voucher created successfully!",
                    );
                  } else if (state is VoucherFailure) {
                    
                    CustomSnackBar.showError(
                      context,
                      title: "Voucher Creation Failed",
                      message: "⚠️ ${state.message}",
                      useOverlay: true,
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is VoucherLoading;

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
                              color: isDark
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        Text(
                          "Create Voucher Goal",
                          style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        Text(
                          "Select a merchant and set an amount to create a shopping voucher that can be redeemed at any of their outlets nationwide.",
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            color: subtitleColor,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // --- Merchant Dropdown
                        Text(
                          "Select Merchant",
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        Container(
                          decoration: BoxDecoration(
                            color: inputFillColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: bgColor,
                              value: selectedMerchantName,
                              isExpanded: true,
                              hint: Text(
                                "Select merchant",
                                style: GoogleFonts.montserrat(
                                  color: subtitleColor,
                                ),
                              ),
                              style: GoogleFonts.montserrat(
                                color: textColor,
                                fontSize: 14.sp,
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: iconColor,
                              ),
                              items: merchants.map((merchant) {
                                return DropdownMenuItem<String>(
                                  value: merchant['name'],
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                          color: merchant['color'],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        merchant['name'],
                                        style: GoogleFonts.montserrat(
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                final selected = merchants.firstWhere(
                                  (m) => m['name'] == value,
                                );
                                setState(() {
                                  selectedMerchantName = selected['name'];
                                  selectedMerchantId = selected['merchant_id'];
                                });
                              },
                            ),
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
                              "5000",
                              "10000",
                              "20000",
                              "50000",
                              "100000",
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
                            hintText: "Enter custom amount",
                            hintStyle: GoogleFonts.montserrat(
                              color: subtitleColor,
                            ),
                            filled: true,
                            fillColor: inputFillColor,
                            prefixIcon: Icon(
                              Icons.card_giftcard_rounded,
                              color: iconColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),

                        // --- Note/Description
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            selectedMerchantName == null
                                ? "Please select a merchant to generate a voucher."
                                : "Once generated, this voucher can only be redeemed for $selectedMerchantName products.",
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              color: isDark ? Colors.red[300] : Colors.red[700],
                              height: 1.4,
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

                                    if (selectedMerchantId == null) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Missing Merchant",
                                        message:
                                            "Please select a merchant first.",
                                      );
                                      return;
                                    }

                                    if (amount.isEmpty) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Missing Amount",
                                        message: "Please enter voucher amount",
                                      );
                                      return;
                                    }

                                    final parsedAmount = double.tryParse(
                                      amount,
                                    );
                                    if (parsedAmount == null ||
                                        parsedAmount <= 0) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Invalid Amount",
                                        message: "Please enter a valid number",
                                      );
                                      return;
                                    }

                                    context
                                        .read<PaymentsCubit>()
                                        .generateVoucher(
                                          merchantId: int.parse(
                                            selectedMerchantId!,
                                          ),
                                          voucherAmount: amount,
                                        );
                                  },
                            child: isLoading
                                ? const SpinKitWave(
                                    color: Colors.white,
                                    size: 22.0,
                                  )
                                : Text(
                                    "Generate Voucher",
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
    },
  );
}
