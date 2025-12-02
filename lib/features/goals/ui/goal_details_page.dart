import 'package:flexpay/features/goals/cubits/goals_cubit.dart';
import 'package:flexpay/features/goals/cubits/goals_state.dart';
import 'package:flexpay/features/payments/ui/goal_payment.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalDetailsPage extends StatefulWidget {
  final Map<String, dynamic> goal;
  const GoalDetailsPage({Key? key, required this.goal}) : super(key: key);

  @override
  State<GoalDetailsPage> createState() => _GoalDetailsPageState();
}

class _GoalDetailsPageState extends State<GoalDetailsPage> {
  int selectedIndex = 0;
  final List<int> topUpAmounts = [500, 1000, 5000, 10000];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        Map<String, dynamic> updatedGoal = widget.goal;

        if (state is FetchGoalsSuccess) {
          updatedGoal = state.goals
              .map((g) => g.toJson())
              .firstWhere(
                (goal) =>
                    goal['booking_reference'] ==
                    widget.goal['booking_reference'],
                orElse: () => widget.goal,
              );
        }

        return _buildGoalUI(context, updatedGoal);
      },
    );
  }

  Widget _buildGoalUI(BuildContext context, Map<String, dynamic> goal) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : const Color(0xFFF5F6F8);
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final accentColor = ColorName.primaryColor;

    final productName = goal['product_name'] ?? 'N/A';
    final productType = goal['product_type_name'] ?? 'N/A';
    final imagePath =
        goal['image'] ?? 'assets/images/goals_imgs/create_goals.png';

    final bookingPriceRaw = goal['booking_price'] ?? 0;
    final initialDepositRaw = goal['initial_deposit'] ?? 0;
    final totalRaw = goal['total'] ?? 0;

    final double bookingPrice = _toDouble(bookingPriceRaw);
    final double deposit = _toDouble(initialDepositRaw);
    final double total = _toDouble(totalRaw);
    final double progress = bookingPrice > 0 ? (total / bookingPrice) : 0.0;
    final bool goalCompleted = total >= bookingPrice;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<GoalsCubit>().fetchGoals();
          },
          color: accentColor,
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          displacement: 40,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleIcon(
                      context,
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                      isDark: isDark,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          productName.length > 20
                              ? "${productName.substring(0, 22)}..."
                              : productName,
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          productType,
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                    _circleIcon(
                      context,
                      icon: Icons.more_vert,
                      onTap: () {},
                      isDark: isDark,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Top-up options
                SizedBox(
                  height: 45.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemCount: topUpAmounts.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF2A2A2D) : Colors.white,
                            borderRadius: BorderRadius.circular(40.r),
                            border: Border.all(
                              color:
                                  isSelected ? accentColor : Colors.transparent,
                              width: isSelected ? 2 : 0,
                            ),
                          ),
                          child: Text(
                            "Ksh ${topUpAmounts[index]}",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? accentColor : textColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 25.h),

                // Goal Info Card
                Container(
                  width: double.infinity,
                  height: 340.h,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40.h,
                        left: 60.w,
                        right: 60.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            height: 180.h,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        right: 16.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName.length > 20
                                      ? "${productName.substring(0, 22)}..."
                                      : productName,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  productType,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    color: subtitleColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Ksh ${total.toStringAsFixed(0)} / Ksh ${bookingPrice.toStringAsFixed(0)}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 52.w,
                                  width: 52.w,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 3.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        accentColor),
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.25),
                                  ),
                                ),
                                Text(
                                  "${(progress * 100).toInt()}%",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // Transaction History
                // Text(
                //   "Transaction History",
                //   style: GoogleFonts.montserrat(
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.w600,
                //     color: textColor,
                //   ),
                // ),
                // SizedBox(height: 12.h),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     _buildTransactionRow(
                //         "10 July 2025", "+Ksh 500", textColor, subtitleColor),
                //     _buildTransactionRow(
                //         "08 July 2025", "+Ksh 1000", textColor, subtitleColor),
                //     _buildTransactionRow(
                //         "02 July 2025", "+Ksh 200", textColor, subtitleColor),
                //   ],
                // ),
                SizedBox(height: 30.h),
                // Top Up Button (with goal completion logic)
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goalCompleted
                          ? Colors.grey.shade400.withOpacity(0.8) // Frozen state
                          : accentColor, // Active state
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: goalCompleted ? 0 : 4,
                    ),
                    onPressed: goalCompleted
                        ? null // Disable the button entirely
                        : () async {
                            final bookingReference = goal['booking_reference'] ?? '';
                            final goalName = goal['product_name'] ?? 'Unnamed Goal';

                            final userModel = await SharedPreferencesHelper.getUserModel();
                            final userPhone = userModel?.user.phoneNumber ?? '';

                            final selectedAmount = topUpAmounts[selectedIndex];

                            final result = await GoalPaymentModal.show(
                              context,
                              goalName: goalName,
                              initialPhone: userPhone,
                              goalReference: bookingReference,
                              prefilledAmount: selectedAmount.toString(),
                            );

                            if (result == true) {
                              // Refetch updated goal state
                              context.read<GoalsCubit>().fetchGoals();
                            }
                          },
                    child: Text(
                      goalCompleted ? "Goal Accomplished 🎉" : "Top Up Goal Balance",
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.4),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isDark ? Colors.white : Colors.black,
            size: 22.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionRow(
    String date,
    String amount,
    Color textColor,
    Color subtitleColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: subtitleColor,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}