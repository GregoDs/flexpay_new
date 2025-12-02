import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Handles both Join (Our Chamas) and Save (My Chamas)
void showPayChamaModalSheet(
  BuildContext context, {
  required String chamaName,
  required int productId,
  required bool isMyChamas,
}) async {
  final parentContext = context;

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;
  final subtitleColor = isDark
      ? Colors.white70
      : (Colors.grey[700] ?? Colors.grey);
  final inputFillColor = isDark
      ? const Color(0xFF2A2A2D)
      : (Colors.grey[200] ?? Colors.grey);
  final iconColor = isDark ? Colors.white70 : (Colors.blue[800] ?? Colors.blue);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    backgroundColor: bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<ChamaCubit>(parentContext),
        child: _PayChamaModalContent(
          chamaName: chamaName,
          productId: productId,
          isMyChamas: isMyChamas,
          parentContext: parentContext,
          isDark: isDark,
          bgColor: bgColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          inputFillColor: inputFillColor,
          iconColor: iconColor,
        ),
      );
    },
  );
}

class _PayChamaModalContent extends StatefulWidget {
  final String chamaName;
  final int productId;
  final bool isMyChamas;
  final BuildContext parentContext;
  final bool isDark;
  final Color bgColor;
  final Color textColor;
  final Color subtitleColor;
  final Color inputFillColor;
  final Color iconColor;

  const _PayChamaModalContent({
    required this.chamaName,
    required this.productId,
    required this.isMyChamas,
    required this.parentContext,
    required this.isDark,
    required this.bgColor,
    required this.textColor,
    required this.subtitleColor,
    required this.inputFillColor,
    required this.iconColor,
  });

  @override
  State<_PayChamaModalContent> createState() => _PayChamaModalContentState();
}

class _PayChamaModalContentState extends State<_PayChamaModalContent> {
  late TextEditingController amountController;
  String selectedSource = "M-Pesa";
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _handlePayment() async {
    if (_isProcessing) return;

    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      CustomSnackBar.showError(
        context,
        title: "Invalid Amount",
        message: "Please enter a valid amount.",
      );
      return;
    }

    setState(() => _isProcessing = true);

    final cubit = context.read<ChamaCubit>();

    try {
      if (widget.isMyChamas) {
        if (selectedSource == "M-Pesa") {
          await cubit.saveToChamaMpesa(
            productId: widget.productId,
            amount: amount,
          );
        } else {
          await cubit.payChamaViaWallet(
            productId: widget.productId,
            amount: amount,
          );
        }
      } else {
        await cubit.subscribeToChama(
          productId: widget.productId,
          depositAmount: amount,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChamaCubit, ChamaState>(
      listener: (context, state) {
        // ✅ CRITICAL FIX: Pop immediately and let parent handle everything
        if (state is SaveToChamaSuccess ||
            state is PayChamaWalletSuccess ||
            state is SubscribeChamaSuccess ||
            state is SaveToChamaFailure ||
            state is PayChamaWalletFailure ||
            state is SubscribeChamaFailure) {
          // Pop the modal immediately
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Handle
              Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.grey[600] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // --- Title
              Text(
                widget.isMyChamas
                    ? "Save to ${widget.chamaName}"
                    : "Join ${widget.chamaName}",
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.isMyChamas
                    ? "Enter amount and payment method to save to your chama."
                    : "Enter your initial deposit to join this chama.",
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  color: widget.subtitleColor,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),

              // --- Payment Method
              Text(
                "Payment Method",
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PaymentOptionCard(
                    imagePath: "assets/images/payment_platform/mpesa_img.png",
                    label: "M-Pesa",
                    isSelected: selectedSource == "M-Pesa",
                    onTap: _isProcessing
                        ? () {}
                        : () {
                            setState(() {
                              selectedSource = "M-Pesa";
                            });
                          },
                    isDark: widget.isDark,
                    isDisabled: _isProcessing,
                  ),
                  PaymentOptionCard(
                    imagePath: "assets/images/payment_platform/wallet_img.webp",
                    label: "Wallet",
                    isSelected: selectedSource == "Wallet",
                    onTap: _isProcessing
                        ? () {}
                        : () {
                            setState(() {
                              selectedSource = "Wallet";
                            });
                          },
                    isDark: widget.isDark,
                    isDisabled: _isProcessing,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // --- Amount field
              Text(
                "Amount",
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                enabled: !_isProcessing,
                style: GoogleFonts.montserrat(color: widget.textColor),
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  hintStyle: GoogleFonts.montserrat(
                    color: widget.subtitleColor,
                  ),
                  filled: true,
                  fillColor: widget.inputFillColor,
                  prefixIcon: Icon(
                    Icons.currency_exchange,
                    color: widget.iconColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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
                  color: widget.textColor,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (final amt in ["500", "1000", "2000", "5000", "10000"])
                    GestureDetector(
                      onTap: _isProcessing
                          ? null
                          : () => amountController.text = amt,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? const Color(0xFF2A2A2D)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.isDark
                                ? Colors.white54
                                : Colors.blue[800]!.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Ksh $amt",
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: widget.isDark
                                ? Colors.white
                                : Colors.blue[800],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 25.h),

              // --- Submit Button
              BlocBuilder<ChamaCubit, ChamaState>(
                builder: (context, state) {
                  final isLoading =
                      state is SaveToChamaLoading ||
                      state is PayChamaWalletLoading ||
                      state is SubscribeChamaLoading ||
                      _isProcessing;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorName.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: isLoading ? null : _handlePayment,
                      child: isLoading
                          ? const SpinKitWave(color: Colors.white, size: 22.0)
                          : Text(
                              widget.isMyChamas ? "Save Now" : "Join Now",
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // --- Secure Note
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 16.sp, color: widget.subtitleColor),
                    SizedBox(width: 6.w),
                    Text(
                      "Transactions are encrypted",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: widget.subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  "Powered by FlexPay",
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    color: widget.subtitleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Payment Option Card (Reusable)
class PaymentOptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final bool isDisabled;

  const PaymentOptionCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: isDisabled ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2D) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? Colors.amber
                    : (isDark ? Colors.white24 : Colors.grey.withOpacity(0.3)),
                width: isSelected ? 2.5 : 1.2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  Image.asset(imagePath, width: 75.w, height: 85.w),
                  SizedBox(height: 6.h),
                  Text(
                    label,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.amber[800]
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
