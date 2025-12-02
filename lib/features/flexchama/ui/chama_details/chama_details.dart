import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/models/products_model/chama_products_model.dart';
import 'package:flexpay/features/flexchama/ui/modals/pay_chama.dart';
import 'package:flexpay/features/flexchama/ui/chama_details/shimmer_details.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChamaPage extends StatefulWidget {
  const ChamaPage({super.key});

  @override
  State<ChamaPage> createState() => _ChamaPageState();
}

class _ChamaPageState extends State<ChamaPage> {
  String _selectedTab = 'my chamas';
  String _selectedChamaType = 'yearly';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final cubit = context.read<ChamaCubit>();
      cubit.fetchAllChamaDetails(type: "yearly", forceRefresh: false);
    });
  }

  Future<void> _onRefresh() async {
    final cubit = context.read<ChamaCubit>();

    // ✅ Same as initState but with forceRefresh=true to reload latest data
    await cubit.fetchAllChamaDetails(type: "yearly", forceRefresh: true);
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value < 0 ? 0.0 : value;
    if (value is int) return value < 0 ? 0.0 : value.toDouble();
    if (value is num) return value < 0 ? 0.0 : value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value) ?? 0.0;
      return parsed < 0 ? 0.0 : parsed;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : const Color(0xFFF5F6F8);
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final highlightColor = isDark ? Colors.blueAccent : const Color(0xFF57A5D8);

    return WillPopScope(
      onWillPop: () async {
        context.read<ChamaCubit>().fetchChamaUserSavings();
        return true;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        // Replace the entire body of your Scaffold in ChamaPage with this:
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: highlightColor,
            displacement: 50,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: BlocListener<ChamaCubit, ChamaState>(
                listener: (context, state) {
                  // Success states
                  if (state is SaveToChamaSuccess) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Success",
                        message: (state.response.messages?.isNotEmpty == true)
                            ? state.response.messages!.first
                            : "✅ Savings updated successfully!",
                      );
                      context.read<ChamaCubit>().fetchAllChamaDetails(
                        type: _selectedChamaType,
                        forceRefresh: true,
                      );
                    });
                  } else if (state is PayChamaWalletSuccess) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      if (state.response.errors?.isNotEmpty == true) {
                        CustomSnackBar.showError(
                          context,
                          title: "Error",
                          message: state.response.errors!.first,
                        );
                      } else {
                        CustomSnackBar.showSuccess(
                          context,
                          title: "Success",
                          message: "✅ Payment successful! Wallet updated.",
                        );
                      }
                      context.read<ChamaCubit>().fetchAllChamaDetails(
                        type: _selectedChamaType,
                        forceRefresh: true,
                      );
                    });
                  } else if (state is SubscribeChamaSuccess) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Success",
                        message: (state.response.messages?.isNotEmpty == true)
                            ? state.response.messages!.first
                            : "✅ Successfully joined the chama!",
                      );
                      context.read<ChamaCubit>().fetchAllChamaDetails(
                        type: _selectedChamaType,
                        forceRefresh: true,
                      );
                    });
                  }
                  // Failure states
                  else if (state is SaveToChamaFailure) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      CustomSnackBar.showError(
                        context,
                        title: "Payment Failed",
                        message: state.message,
                      );
                      context.read<ChamaCubit>().fetchAllChamaDetails(
                        type: _selectedChamaType,
                        forceRefresh: true,
                      );
                    });
                  } else if (state is PayChamaWalletFailure) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      CustomSnackBar.showError(
                        context,
                        title: "Payment Failed",
                        message: state.message,
                      );
                      context.read<ChamaCubit>().fetchAllChamaDetails(
                        type: _selectedChamaType,
                        forceRefresh: true,
                      );
                    });
                  } else if (state is SubscribeChamaFailure) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      CustomSnackBar.showError(
                        context,
                        title: "Subscription Failed",
                        message: state.message,
                      );
                      context.read<ChamaCubit>().fetchAllChamaDetails(
                        type: _selectedChamaType,
                        forceRefresh: true,
                      );
                    });
                  }
                },

                child: BlocBuilder<ChamaCubit, ChamaState>(
                  builder: (context, state) {
                    // Show ChamaShimmer only for payment flows triggered via modal
                    if (state is SaveToChamaLoading ||
                        state is PayChamaWalletLoading ||
                        state is SubscribeChamaLoading) {
                      return ChamaShimmer(isDark: isDark);
                    }

                    if (state is ChamaSavingsLoading) {
                      return _buildLoadingState(highlightColor, subtitleColor);
                    } else if (state is ChamaError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        CustomSnackBar.showError(
                          context,
                          title: "Error",
                          message: state.message,
                        );
                      });
                      return _buildErrorState(isDark, textColor);
                    } else if (state is ChamaSavingsFetched ||
                        state is ChamaViewState) {
                      final chamaViewState = state is ChamaViewState
                          ? state
                          : null;

                      final userChamas = chamaViewState?.userChamas?.data ?? [];
                      final ourChamas = chamaViewState?.allProducts?.data ?? [];

                      final userChamasCount = userChamas.length;
                      final ourChamasCount = ourChamas.length;

                      final chama = state is ChamaSavingsFetched
                          ? state.savingsResponse.data?.chamaDetails
                          : chamaViewState?.savings?.data?.chamaDetails;

                      if (chama == null ||
                          (chamaViewState?.isListLoading ?? false) ||
                          (chamaViewState?.isWalletLoading ?? false)) {
                        return _buildLoadingState(
                          highlightColor,
                          subtitleColor,
                        );
                      }

                      final totalSavings = _toDouble(chama.totalSavings);
                      final targetAmount = _toDouble(chama.targetAmount);
                      final maturityDate = chama.maturityDate.toString();

                      final progress = targetAmount > 0
                          ? (totalSavings / targetAmount).clamp(0.0, 1.0)
                          : 0.0;
                      final progressText =
                          "${(progress * 100).toStringAsFixed(1)}%";

                      final isMyChamas = _selectedTab == 'my chamas';
                      final chamaList = isMyChamas ? userChamas : ourChamas;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔙 Back + Title Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleIcon(
                                context,
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: () {
                                  Navigator.pop(context);
                                  context
                                      .read<ChamaCubit>()
                                      .fetchChamaUserSavings();
                                },
                                isDark: isDark,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Chamas',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Chama details',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14.sp,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : Colors.grey[300],
                                child: Icon(
                                  Icons.groups,
                                  color: highlightColor,
                                  size: 22.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // 💳 Balance Card
                          _buildBalanceCard(
                            totalSavings,
                            progress,
                            progressText,
                            maturityDate,
                            cardColor,
                            textColor,
                            subtitleColor,
                            highlightColor,
                          ),
                          SizedBox(height: 20.h),

                          // 🔹 Chama Selection Cards
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedTab = 'my chamas'),
                                child: _buildChamaSelectionCard(
                                  FontAwesomeIcons.creditCard,
                                  'My Chamas',
                                  '$userChamasCount',
                                  Colors.green,
                                  textColor,
                                  cardColor,
                                  isSelected: _selectedTab == 'my chamas',
                                  highlightColor: highlightColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedTab = 'our chamas'),
                                child: _buildChamaSelectionCard(
                                  FontAwesomeIcons.handHoldingDollar,
                                  'Our Chamas',
                                  '$ourChamasCount',
                                  Colors.orange,
                                  textColor,
                                  cardColor,
                                  isSelected: _selectedTab == 'our chamas',
                                  highlightColor: highlightColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Section Title
                          Text(
                            isMyChamas ? "My Chamas" : "Our Chamas",
                            style: GoogleFonts.montserrat(
                              fontSize: 24.sp,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isMyChamas
                                ? "These are the chamas you belong to"
                                : "Explore available chama products",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: subtitleColor,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          if (!isMyChamas)
                            Row(
                              children: [
                                _buildTypeTag(
                                  label: 'Yearly',
                                  isSelected: _selectedChamaType == 'yearly',
                                  highlightColor: highlightColor,
                                  onTap: () {
                                    setState(
                                      () => _selectedChamaType = 'yearly',
                                    );
                                    context
                                        .read<ChamaCubit>()
                                        .fetchAllChamaDetails(
                                          type: 'yearly',
                                          forceRefresh: true,
                                        );
                                  },
                                ),
                                SizedBox(width: 10.w),
                                _buildTypeTag(
                                  label: 'Half Yearly',
                                  isSelected:
                                      _selectedChamaType == 'half_yearly',
                                  highlightColor: highlightColor,
                                  onTap: () {
                                    setState(
                                      () => _selectedChamaType = 'half_yearly',
                                    );
                                    context
                                        .read<ChamaCubit>()
                                        .fetchAllChamaDetails(
                                          type: 'half_yearly',
                                          forceRefresh: true,
                                        );
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: 20.h),

                          // 🔹 Dynamic chama list
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: chamaList.length,
                            itemBuilder: (context, index) {
                              if (index >= chamaList.length)
                                return SizedBox.shrink(); // safety check
                              final item = chamaList[index];
                              final isMyChamas = _selectedTab == 'my chamas';

                              // ✅ Always cast from the snapshot item
                              final productId = isMyChamas
                                  ? (item as UserChama).id
                                  : (item as ChamaProduct).id;

                              String name = isMyChamas
                                  ? (item as UserChama).name
                                  : (item as ChamaProduct).name;

                              double total = 0.0;
                              double target = 0.0;
                              double progress = 0.0;

                              if (isMyChamas) {
                                final chamaItem = chamaList[index] as UserChama;
                                name = chamaItem.name;
                                total =
                                    double.tryParse(
                                      (item as UserChama).totalSavings,
                                    ) ??
                                    0.0;

                                target = total * 1.5;
                                progress = target > 0
                                    ? (total / target).clamp(0.0, 1.0)
                                    : 0.0;
                              } else {
                                target = (item as ChamaProduct).targetAmount
                                    .toDouble();
                              }

                              return StatefulBuilder(
                                key: ValueKey(productId),
                                builder: (context, setLocalState) {
                                  bool isPressed = false;

                                  return GestureDetector(
                                    onTapDown: (_) =>
                                        setLocalState(() => isPressed = true),
                                    onTapUp: (_) =>
                                        setLocalState(() => isPressed = false),
                                    onTapCancel: () =>
                                        setLocalState(() => isPressed = false),
                                    onTap: () {
                                      final isMyChamas =
                                          _selectedTab == 'my chamas';

                                      // Use the 'id' field for both UserChama and ChamaProduct
                                      final productId = isMyChamas
                                          ? (chamaList[index] as UserChama).id
                                          : (chamaList[index] as ChamaProduct)
                                                .id;

                                      showPayChamaModalSheet(
                                        context,
                                        chamaName: name,
                                        productId: productId,
                                        isMyChamas: isMyChamas,
                                      );
                                    },
                                    child: AnimatedScale(
                                      // ignore: dead_code
                                      scale: isPressed ? 0.97 : 1.0,
                                      duration: const Duration(
                                        milliseconds: 120,
                                      ),
                                      curve: Curves.easeOut,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        margin: EdgeInsets.only(bottom: 16.h),
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.white10
                                                : Colors.grey.withOpacity(0.4),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.08,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 100.h,
                                              width: 100.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
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
                                                    name,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: textColor,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    isMyChamas
                                                        ? "Total Savings: Ksh ${total.toStringAsFixed(0)}"
                                                        : "Target Amount: Ksh ${target.toStringAsFixed(0)}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 13.sp,
                                                          color: subtitleColor,
                                                        ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  if (isMyChamas)
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          height: 4.h,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4.r,
                                                                ),
                                                          ),
                                                        ),
                                                        FractionallySizedBox(
                                                          widthFactor: progress,
                                                          child: Container(
                                                            height: 4.h,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  highlightColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4.r,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  SizedBox(height: 10.h),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        final isMyChamas =
                                                            _selectedTab ==
                                                            'my chamas';
                                                        final productId =
                                                            isMyChamas
                                                            ? (chamaList[index]
                                                                      as UserChama)
                                                                  .id
                                                            : (chamaList[index]
                                                                      as ChamaProduct)
                                                                  .id;

                                                        showPayChamaModalSheet(
                                                          context,
                                                          chamaName: name,
                                                          productId: productId,
                                                          isMyChamas:
                                                              isMyChamas,
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 18.w,
                                                              vertical: 8.h,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: highlightColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30.r,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: highlightColor
                                                                  .withOpacity(
                                                                    0.4,
                                                                  ),
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    2,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          isMyChamas
                                                              ? "Save"
                                                              : "Join Chama",
                                                          style:
                                                              GoogleFonts.montserrat(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(Color highlightColor, Color subtitleColor) {
    return SizedBox(
      height: 0.8.sh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(color: highlightColor, size: 40.sp),
            SizedBox(height: 16.h),
            Text(
              "Your chama details are loading,\nplease wait...",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // (referral campaign card and modal removed as unused)

  Widget _buildErrorState(bool isDark, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: isDark ? Colors.white70 : Colors.redAccent,
            size: 48.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            "Unable to load chama data.",
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  Widget _buildBalanceCard(
    double totalSavings,
    double progress,
    String progressText,
    String maturityDate,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color highlightColor,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Savings",
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: subtitleColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Ksh ${totalSavings.toStringAsFixed(2)}",
            style: GoogleFonts.montserrat(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: highlightColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Matures on $maturityDate",
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              color: subtitleColor,
            ),
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(highlightColor),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            progressText,
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 External Helper Widgets
Widget _buildChamaSelectionCard(
  IconData icon,
  String title,
  String amount,
  Color iconColor,
  Color textColor,
  Color cardColor, {
  bool isSelected = false,
  required Color highlightColor,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 160.w,
    height: 144.h,
    padding: EdgeInsets.all(16.0.w),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: isSelected ? highlightColor : Colors.transparent,
        width: isSelected ? 2.5 : 1.2,
      ),
      boxShadow: [
        if (isSelected)
          BoxShadow(
            color: highlightColor.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
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

Widget _buildTypeTag({
  required String label,
  required bool isSelected,
  required Color highlightColor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? highlightColor.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? highlightColor : Colors.grey.withOpacity(0.4),
          width: isSelected ? 1.8 : 1.2,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isSelected ? highlightColor : Colors.grey,
        ),
      ),
    ),
  );
}
