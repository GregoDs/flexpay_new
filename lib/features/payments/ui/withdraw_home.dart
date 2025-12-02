import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/features/payments/cubits/payments_cubit.dart';
import 'package:flexpay/features/payments/cubits/payments_state.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? phoneError;
  String? amountError;

  bool _withdrawSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadCachedPhoneNumber();
    // Fetch wallet on page load to get latest refundable balance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeCubit>().fetchUserWallet();
      }
    });
  }

  Future<void> _loadCachedPhoneNumber() async {
    final userModel = await SharedPreferencesHelper.getUserModel();
    final cachedPhone = userModel?.user.phoneNumber ?? '';
    if (mounted) {
      setState(() {
        phoneController.text = cachedPhone;
      });
    }
  }

  void _validateFields() {
    setState(() {
      phoneError = phoneController.text.trim().isEmpty
          ? "Phone number is required"
          : null;

      amountError = amountController.text.trim().isEmpty
          ? "Enter an amount"
          : null;
    });
  }

  void _submit(BuildContext context) {
    _validateFields();
    if (phoneError == null && amountError == null) {
      final amount = double.tryParse(amountController.text.trim()) ?? 0;
      context.read<PaymentsCubit>().requestWalletRefund(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final fieldColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;

    final textTheme = GoogleFonts.montserratTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            // ✅ Only return true if a withdrawal actually happened
            if (_withdrawSuccess) {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, false);
            }
          },
        ),
        centerTitle: true,
        title: Text(
          "Withdraw",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PaymentsCubit, PaymentsState>(
            listener: (context, state) {
              if (state is WalletRefundFetched) {
                _withdrawSuccess = true;
                CustomSnackBar.showSuccess(
                  context,
                  title: "Success",
                  message: "Refund initiated successfully",
                );

                // 🔄 Refresh wallet balance after refund
                context.read<HomeCubit>().fetchUserWallet();

                // 🧹 Clear the amount field immediately
                setState(() {
                  amountController.clear();
                });

                // ✅ Return true to indicate success
                // Future.delayed(const Duration(milliseconds: 500), () {
                //   // if (mounted) {
                //   //   Navigator.pop(context, true);
                //   // }
                // });
              } else if (state is WalletRefundFailure) {
                CustomSnackBar.showError(
                  context,
                  title: "Error",
                  message: state.message,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            // Get refundable balance from HomeCubit state
            double currentRefundableBalance = 0.0;

            if (homeState is HomeWalletFetched) {
              currentRefundableBalance =
                  homeState
                      .walletResponse
                      .data
                      ?.walletAccount
                      ?.walletRefundBalance
                      ?.toDouble() ??
                  0.0;
            }

            final isLoading =
                context.watch<PaymentsCubit>().state is WalletRefundLoading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Info text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ColorName.primaryColor,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Make a withdrawal from your wallet to facilitate easy purchases on the Flexpay ecosystem.",
                              style: GoogleFonts.montserrat(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      /// Mpesa target
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: fieldColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.phone_android,
                              color: ColorName.primaryColor,
                              size: 60,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "M-Pesa",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),

                      /// Show Refundable Balance (updated from HomeCubit)
                      Text(
                        "Withdrawable Balance: KES ${currentRefundableBalance.toStringAsFixed(2)}",
                        style: GoogleFonts.montserrat(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 28.h),

                      /// Phone Number
                      _buildTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        hint: "Enter phone number",
                        icon: Icons.phone_outlined,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: phoneError,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) => _validateFields(),
                      ),
                      SizedBox(height: 16.h),

                      /// Amount
                      _buildTextField(
                        controller: amountController,
                        label: "Enter Amount (KES)",
                        hint: "e.g. 500",
                        icon: Icons.payments_outlined,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: amountError,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _validateFields(),
                      ),
                      SizedBox(height: 28.h),

                      /// Withdraw button
                      SizedBox(
                        width: double.infinity,
                        child: isLoading
                            ? Center(
                                child: SpinKitWave(
                                  color: ColorName.primaryColor,
                                  size: 30,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorName.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () => _submit(context),
                                child: Text(
                                  "Withdraw",
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(color: textColor),
          readOnly: label == "Phone Number",
          enabled: label != "Phone Number" ? true : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(icon, color: ColorName.primaryColor),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText,
                style: GoogleFonts.montserrat(color: Colors.red, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }
}
