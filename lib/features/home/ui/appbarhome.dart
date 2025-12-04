import 'dart:async';

import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/features/home/ui/notifications_page.dart';
import 'package:flexpay/features/home/ui/shimmers_home.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/payments/ui/voucher_sheet.dart';
import 'package:flexpay/features/profile/ui/system_menu.dart';
import 'package:flexpay/features/payments/ui/topup_home_page.dart';
import 'package:flexpay/features/payments/ui/withdraw_home.dart';
import 'package:flexpay/features/kapu/ui/promo_cards.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/getters/getters.dart' as AppUtils;
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/kapu/ui/kapu_opt_in.dart';

import '../../../utils/services/logger.dart';

class AppBarHome extends StatefulWidget {
  final String userName;
  final UserModel userModel;
  final bool isDataReady;
  final VoidCallback? onWalletBalanceMissing;

  const AppBarHome(
    BuildContext context, {
    super.key,
    required this.userName,
    required this.userModel,
    required this.isDataReady,
    this.onWalletBalanceMissing,
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  bool isBalanceVisible = true;
  bool isKapuButtonPressed = false;
  bool isDataReady = false;
  double? cachedBalance;
  bool showRefreshIcon = true;
  Timer? _refreshIconTimer;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _refreshIconTimer?.cancel();
    super.dispose();
  }

  void _fetchInitialData() async {
    await context.read<HomeCubit>().fetchUserWallet();
    await _ensureMinimumShimmerDuration();
    setState(() {
      isDataReady = true;

      final state = context.read<HomeCubit>().state;
      if (state is HomeWalletFetched) {
        final wallet = state.walletResponse.data?.walletAccount?.walletBalance;
        cachedBalance = wallet?.balance.toDouble();
      }
    });
  }

  Future<void> _ensureMinimumShimmerDuration() async {
    await Future.delayed(const Duration(seconds: 0));
  }

  void _manualRefresh() {
    setState(() {
      isDataReady = false;
      showRefreshIcon = false; // Hide the icon immediately
    });
    
    // Cancel any existing timer
    _refreshIconTimer?.cancel();
    
    // Start new timer to show icon again after 1 minute
    _refreshIconTimer = Timer(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          showRefreshIcon = true;
        });
      }
    });
    
    _fetchInitialData();
  }

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  String _getGreetingOnly() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good morning, ";
    } else if (hour < 17) {
      return "Good afternoon, ";
    } else {
      return "Good evening, ";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        _manualRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Top section with profile, greeting, and notifications
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 44.h),
              color: isDark ? theme.scaffoldBackgroundColor : Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  /// Profile + Greeting + Notifications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(userModel: widget.userModel),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 22.r,
                              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                              child: Icon(
                                Icons.person_2,
                                size: 28.sp,
                                color: isDark ? Colors.blue[300] : Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreetingOnly().replaceAll(', ', ''),
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.sp,
                                  color: isDark ? Colors.grey[400] : Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                widget.userName.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // QR Code Icon
                          GestureDetector(
                            onTap: () {
                              // Add QR code functionality here
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? Colors.grey[800]?.withOpacity(0.5) 
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.qr_code_scanner,
                                color: isDark ? Colors.grey[300] : Colors.black54,
                                size: 24.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Notifications
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationsPage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? Colors.grey[800]?.withOpacity(0.5) 
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    color: isDark ? Colors.grey[300] : Colors.black54,
                                    size: 24.sp,
                                  ),
                                  // Red dot for notifications
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            

            // Balance card section
            Transform.translate(
              offset: Offset(0, -20.h), // Overlap with the top section
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/appbarbackground.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Balance header with masked account number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Amount',
                              style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 4.w), // Add spacing between text and icon
                            if (showRefreshIcon)
                              GestureDetector(
                                onTap: () {
                                  _manualRefresh();
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.yellow,
                                  size: 12.sp,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Balance amount with visibility toggle
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (!widget.isDataReady) {
                          return const AppBarBalanceShimmer();
                        }

                        double? balance = cachedBalance;
                        if (state is HomeWalletFetched) {
                          final wallet = state.walletResponse.data?.walletAccount?.walletBalance;
                          balance = wallet?.balance.toDouble();
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              balance != null
                                  ? (isBalanceVisible
                                        ? 'KES ${balance.toStringAsFixed(2)}'
                                        : 'KES ******')
                                  : 'KES ******',
                              style: GoogleFonts.montserrat(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            GestureDetector(
                              onTap: toggleBalanceVisibility,
                              child: Icon(
                                isBalanceVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                                size: 20.sp,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Action buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(
                          Icons.discount_rounded,
                          "Generate\nVouchers",
                           onTap: () async {
                            showMerchantVoucherModal(
                              context,
                              "FlexPay",
                              0, // Default merchant ID for the Vouchers button
                            );
                          },
                        ),
                         _buildActionButton(
                          Icons.arrow_downward,
                          "Top up",
                          onTap: () async {
                            final result = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(builder: (_) => TopUpHomePage()),
                            );
                            if (result == true) {
                              context.read<HomeCubit>().fetchUserWallet();
                            }
                          },
                        ),
                        _buildActionButton(
                          Icons.account_balance_wallet,
                            "Withdraw",
                            onTap: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(builder: (_) => WithdrawPage()),
                              );
                              if (result == true) {
                                context.read<HomeCubit>().fetchUserWallet();
                              }
                            },
                        ),
                            _buildActionButton(
                    Icons.card_giftcard,
                    "Shopping\nWallet",
                    onTap: () async {
                      if (isKapuButtonPressed)
                        return; // Prevent multiple presses
                      setState(() {
                        isKapuButtonPressed = true;
                      });

                      final userId = widget.userModel.user.id.toString();

                      final hasVisited =
                          await SharedPreferencesHelper.hasVisitedKapu(userId);
                      final hasUsed = await SharedPreferencesHelper.hasUsedKapu(
                        userId,
                      );
                      final hasInteracted =
                          await SharedPreferencesHelper.hasInteractedWithKapu(
                            userId,
                          );

                      AppLogger.log(
                        '🔍 [KAPU NAV CHECK] userId=$userId | visited=$hasVisited | used=$hasUsed | interacted=$hasInteracted',
                      );

                      try {
                        await context
                            .read<KapuCubit>()
                            .fetchAllKapuWalletsInstantly();
                        final state = context.read<KapuCubit>().state;

                        if (state is KapuAllWalletsInstantlyFetched &&
                            state.walletsResponse.success &&
                            state.walletsResponse.data.isNotEmpty) {
                          AppLogger.log(
                            '🟢 [KAPU NAV] Wallet data exists → navigating directly to PromoCardsSwiperPage',
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PromoCardsSwiperPage(
                                userModel: widget.userModel,
                              ),
                            ),
                            (route) => route.isFirst,
                          );
                        } else {
                          AppLogger.log(
                            '🟡 [KAPU NAV] Navigating to OnBoardKapu (user has not interacted yet)',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnBoardKapu(
                                userModel: widget.userModel,
                                onOptIn: () async {
                                  await SharedPreferencesHelper.markKapuVisited(
                                    userId,
                                  );
                                  AppLogger.log(
                                    '✅ [KAPU NAV] User opted in → marking visited and navigating to PromoCardsSwiperPage',
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PromoCardsSwiperPage(
                                            userModel: widget.userModel,
                                          ),
                                    ),
                                    (route) => route.isFirst,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        AppLogger.log(
                          '❌ [KAPU NAV] Error during navigation: $e',
                        );
                      } finally {
                        setState(() {
                          isKapuButtonPressed = false; // Reset the flag
                        });
                      }
                    },
                  ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Action Button Builder - Updated for the new design
  Widget _buildActionButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFF9ACD32), // Green color from design
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
