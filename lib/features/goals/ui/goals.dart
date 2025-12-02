import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/goals/cubits/goals_cubit.dart';
import 'package:flexpay/features/goals/cubits/goals_state.dart';
import 'package:flexpay/features/goals/models/goals_model/show_goals_model.dart';
import 'package:flexpay/features/goals/ui/create_goal.dart';
import 'package:flexpay/features/goals/ui/goal_details_page.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> with RouteAware {
  final List<Map<String, dynamic>> flexGoals = [
    {
      "product_category_name": "Private home",
      "targetAmount": "from Kshs 48k",
      "image": "assets/images/goals_imgs/rent_goals.png",
      "color": Colors.amber,
      "isSelected": true,
    },
    {
      "product_category_name": "College",
      "targetAmount": "from Kshs 21k",
      "image": "assets/images/goals_imgs/school_fees.png",
      "color": const Color(0xFF2F3E46),
      "isSelected": false,
    },
    {
      "product_category_name": "Christmas",
      "targetAmount": "from Kshs 10k",
      "image": "assets/images/goals_imgs/christmass_goals.png",
      "color": const Color(0xFFB71C1C),
      "isSelected": false,
    },
    {
      "product_category_name": "Vacation",
      "targetAmount": "from Kshs 18k",
      "image": "assets/images/goals_imgs/vacation.png",
      "color": const Color(0xFF0096C7),
      "isSelected": false,
    },
    {
      "product_category_name": "Shopping",
      "targetAmount": "from Kshs 5k",
      "image": "assets/images/goals_imgs/shopping.jpg",
      "color": Colors.green,
      "isSelected": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GoalsCubit>().fetchGoals();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<GoalsCubit>().fetchGoals();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final bgColor = isDarkMode ? Colors.black : const Color(0xFFF5F6F8);
    final cardColor = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final iconBorderColor = isDarkMode
        ? Colors.white.withOpacity(0.6)
        : Colors.black54;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: ColorName.primaryColor,
          displacement: 50,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: isDarkMode
                              ? Colors.white10
                              : Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 24.sp,
                            color: ColorName.primaryColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello there,",
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            Text(
                              "Click the add button to create a goal",
                              style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Add Button
                    GestureDetector(
                      onTap: () async {
                        final created = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateGoalPage(),
                          ),
                        );

                        if (created == true && mounted) {
                          context.read<GoalsCubit>().fetchGoals();
                        }
                      },
                      child: Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: iconBorderColor,
                            width: 1.6,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.add, color: iconColor, size: 32.sp),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // FlexGoals Section (UPDATED)
                Text(
                  "Select FlexGoals",
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Swipe through our FlexGoals or make your own",
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: 20.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: CardSwiper
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 206.h,
                        child: CardSwiper(
                          cardsCount: flexGoals.length,
                          numberOfCardsDisplayed: 2,
                          backCardOffset: const Offset(0, 25),
                          padding: EdgeInsets.zero,
                          cardBuilder: (context, index, percentX, percentY) {
                            if (index >= flexGoals.length)
                              return const SizedBox.shrink();
                            final goal = flexGoals[index];
                            final isSelected = goal["isSelected"];

                            return GestureDetector(
                              onTap: () {
                                String targetText = goal["targetAmount"]
                                    .toString()
                                    .toLowerCase();
                                double numericValue = 0;

                                if (targetText.contains('k')) {
                                  final number = double.tryParse(
                                    targetText.replaceAll(
                                      RegExp(r'[^0-9.]'),
                                      '',
                                    ),
                                  );
                                  if (number != null)
                                    numericValue = number * 1000;
                                } else {
                                  final number = double.tryParse(
                                    targetText.replaceAll(
                                      RegExp(r'[^0-9.]'),
                                      '',
                                    ),
                                  );
                                  if (number != null) numericValue = number;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateGoalPage(
                                      prefilledGoal: {
                                        'product_name':
                                            goal["product_category_name"],
                                        'amount': numericValue.toStringAsFixed(
                                          0,
                                        ),
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120.w,
                                margin: EdgeInsets.only(right: 18.w),
                                decoration: BoxDecoration(
                                  color: goal["color"],
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        child: Image.asset(
                                          goal["image"],
                                          height: 100.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Text(
                                        goal["product_category_name"],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        goal["targetAmount"],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12.sp,
                                          color: isSelected
                                              ? Colors.black.withOpacity(0.7)
                                              : Colors.white70,
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
                    ),

                    // Right side: Lottie animation filling the remaining gap
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: Lottie.asset(
                          'assets/images/goals_imgs/Swipe Right.json',
                          height: 150.h,
                          repeat: true,
                          animate: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // My Goals Section (unchanged)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My goals",
                      style: GoogleFonts.montserrat(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "View All",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        color: ColorName.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                BlocBuilder<GoalsCubit, GoalsState>(
                  builder: (context, state) {
                    final isDarkMode =
                        Theme.of(context).brightness == Brightness.dark;

                    if (state is FetchGoalsLoading) {
                      return Center(
                        child: SpinKitWave(
                          color: isDarkMode
                              ? Colors.white
                              : ColorName.primaryColor,
                          size: 28.sp,
                        ),
                      );
                    } else if (state is FetchGoalsError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        CustomSnackBar.showError(
                          context,
                          title: "Failed to Fetch Goals",
                          message: state.message,
                        );
                      });
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Lottie.asset(
                              'assets/images/goals_imgs/Saving.json',
                              width: 0.8.sw,
                              height: 0.22.sh,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Click the Create a Goal button to start making a goal with us today",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorName.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CreateGoalPage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Create Goal",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is FetchGoalsSuccess) {
                      if (state.goals.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Lottie.asset(
                                'assets/images/goals_imgs/Saving.json',
                                width: 0.8.sw,
                                height: 0.22.sh,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Click the Create a Goal button to start making a goal with us today",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorName.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CreateGoalPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Create Goal",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final goals = List<GoalData>.from(state.goals);

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.goals.length,
                        itemBuilder: (context, index) {
                          if (index >= goals.length)
                            return const SizedBox.shrink();

                          final GoalData goal = goals[index];

                          final total = (goal.total is num)
                              ? goal.total.toDouble()
                              : double.tryParse(
                                      goal.total?.toString() ?? '0',
                                    ) ??
                                    0.0;

                          final bookingPrice = (goal.bookingPrice is num)
                              ? goal.bookingPrice.toDouble()
                              : double.tryParse(
                                      goal.bookingPrice?.toString() ?? '0',
                                    ) ??
                                    0.0;

                          final deposit = (goal.initialDeposit is num)
                              ? goal.initialDeposit.toDouble()
                              : double.tryParse(
                                      goal.initialDeposit?.toString() ?? '0',
                                    ) ??
                                    0.0;

                          final progress = bookingPrice > 0
                              ? (total / bookingPrice)
                              : 0.0;
                          final cappedProgress = progress > 1.0
                              ? 1.0
                              : progress; // Cap progress at 100%

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<GoalsCubit>(),
                                    child: GoalDetailsPage(goal: goal.toJson()),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white10
                                      : Colors.grey.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120.h,
                                    width: 120.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/goals_imgs/create_goals.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.productName ?? "Unnamed Goal",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          goal.productTypeName ?? "No Type",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13.sp,
                                            color: subtitleColor,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "${(cappedProgress * 100).toStringAsFixed(0)}%", // Display capped progress percentage
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorName.primaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor:
                                                  cappedProgress, // Use capped progress for the progress bar
                                              child: Container(
                                                height: 4.h,
                                                decoration: BoxDecoration(
                                                  color: ColorName.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        4.r,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "Ksh ${total.toStringAsFixed(0)} / Ksh ${bookingPrice.toStringAsFixed(0)}",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14.sp,
                                            color: subtitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
