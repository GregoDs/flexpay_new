import 'dart:math';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';
import 'package:flexpay/features/flexchama/ui/chama_home/appbar_chama_home.dart';
import 'package:flexpay/features/flexchama/ui/chama_home/shimmer_chama_products.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/services/logger.dart';

class FlexChama extends StatefulWidget {
  final dynamic profile;
  const FlexChama({super.key, required this.profile});

  @override
  State<FlexChama> createState() => _FlexChamaState();
}

class _FlexChamaState extends State<FlexChama> {
  @override
  void initState() {
    super.initState();
    // Seed the cache on first build
    context.read<ChamaCubit>().fetchChamaUserSavings();
  }

  Future<void> _refresh() async {
    await context.read<ChamaCubit>().fetchChamaUserSavings();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final highlightColor = isDark ? Colors.blueAccent : const Color(0xFF57A5D8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.48),
        child: AppBarChama(context),
      ),
      body: BlocListener<ChamaCubit, ChamaState>(
        listener: (context, state) {
          // ---- 1. ALWAYS store the last successful response ----
          if (state is ChamaSavingsFetched) {
            // no-op: shimmer will handle loading transitions
          }

          // ---- 2. Existing error-snackbar handling (unchanged) ----
          if (state is ChamaSavingsFetched &&
              state.savingsResponse.statusCode != 400 &&
              state.savingsResponse.errors?.isNotEmpty == true) {
            final response = state.savingsResponse;
            if ((response.errors?.isNotEmpty ?? false) &&
                response.statusCode != 400) {
              final errorMsg = response.errors!.first.toString();
              CustomSnackBar.showError(
                context,
                title: "Error",
                message: errorMsg,
              );
            } else if (response.statusCode == 400) {
              AppLogger.log(
                "400 error ignored for UI: ${response.errors?.first}",
              );
            }
          }
        },
        child: BlocBuilder<ChamaCubit, ChamaState>(
          buildWhen: (previous, current) {
            return current is ChamaSavingsLoading ||
                current is ChamaSavingsFetched ||
                current is ChamaViewState ||
                current is ChamaError;
          },
          builder: (context, state) {
            // Always show shimmer when any loading is in progress after modal actions
            if (state is WithdrawChamaSavingsLoading ||
                state is RepayChamaLoanLoading ||
                state is RequestChamaLoanLoading ||
                state is ChamaSavingsLoading) {
              return const FlexChamaShimmer();
            }

            ChamaSavingsResponse? savingsData;

            // 1. Fresh data
            if (state is ChamaSavingsFetched) {
              savingsData = state.savingsResponse;
            } else if (state is ChamaViewState) {
              savingsData = state.savings; // ✅ handle multi-fetch state too
            }
            // If still no data (edge), show shimmer
            if (savingsData == null) {
              return const FlexChamaShimmer();
            }

            // 4. Error → show error
            if (state is ChamaError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            // ---- UI with real data (unchanged) ----
            final ChamaSavingsResponse nonNullSavings = savingsData;
            final data = nonNullSavings.data;
            if (data == null) {
              return const FlexChamaShimmer();
            }
            final chamaDetails = data.chamaDetails;
            final loanBalance = chamaDetails.loanTaken;
            final loanLimit = chamaDetails.loanLimit;

            return RefreshIndicator(
              onRefresh: _refresh,
              color: highlightColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Loan Balance & Limit Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBalanceCard(
                          FontAwesomeIcons.creditCard,
                          'Loan Balance',
                          '${AppUtils.formatAmount(loanBalance)}',
                          Colors.green,
                          textColor,
                          cardColor,
                        ),
                        _buildBalanceCard(
                          FontAwesomeIcons.handHoldingDollar,
                          'Loan Limit',
                          '${AppUtils.formatAmount(loanLimit)}',
                          Colors.orange,
                          textColor,
                          cardColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Chamas card
                    GestureDetector(
                      onTap: () async {
                        // Just navigate – let FlexChama own the data
                        await Navigator.pushNamed(context, Routes.chamaPage);
                      },
                      child: _buildCard(
                        icon: Icons.groups,
                        title: 'Chamas',
                        description: 'Tap to view your chama',
                        highlightColor: highlightColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Transactions
                    Text(
                      'Transactions',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Builder(
                        builder: (_) {
                          final payments = data.payments.data;

                          if (payments.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Text(
                                "No Payments yet",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.italic,
                                  color: textColor,
                                ),
                              ),
                            );
                          }

                          // Safe: show up to 5 transactions
                          final displayedPayments = payments.take(5).toList();

                          return Column(
                            children: displayedPayments.map((payment) {
                              return _buildTransactionRow(
                                payment.createdAt,
                                payment.paymentSource,
                                'Kshs ${AppUtils.formatAmount(payment.paymentAmount)}',
                                textColor,
                                cardColor,
                              );
                            }).toList(),
                          );
                        },
                      ),               
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // The rest of the file (widgets) is **exactly** as you had it.
  // -----------------------------------------------------------------

  Widget _buildBalanceCard(
    IconData icon,
    String title,
    String amount,
    Color iconColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      width: 160.w,
      height: 144.h,
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28.sp),
          SizedBox(height: 10.h),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
    required Color highlightColor,
    required Color textColor,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: highlightColor, size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: highlightColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: highlightColor, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    String date,
    String description,
    String amount,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
