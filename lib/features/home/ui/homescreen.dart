import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/ui/appbarhome.dart';
import 'package:flexpay/features/home/ui/notifications_page.dart';
import 'package:flexpay/features/home/ui/transactions_home.dart';
import 'package:flexpay/features/goals/ui/create_goal.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/ui/kapu_opt_in.dart';
import 'package:flexpay/features/kapu/ui/promo_cards.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/features/payments/ui/topup_home_page.dart';
import 'package:flexpay/features/payments/ui/voucher_sheet.dart';
import 'package:flexpay/features/payments/ui/withdraw_home.dart';
import 'package:flexpay/features/profile/ui/system_menu.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final bool isDarkModeOn;
  final UserModel userModel;

  const HomeScreen({
    super.key,
    required this.isDarkModeOn,
    required this.userModel,
    UserModel? user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  List<dynamic> outlets = [];
  bool isLoading = true;
  List<TransactionData> _transactions = <TransactionData>[];
  bool _txLoading = false;
  String? _txError;
  bool _isNavigatingToKapu = false;
  bool _walletLoading = false;
  bool _isLoading = true;

  bool _walletFetched = false;
  bool _transactionsFetched = false;

  // ✅ Add balance visibility state
  bool _isBalanceVisible = true;

  late AnimationController _bannerAnimationController;
  late Animation<double> _fadeAnimation;
  Timer? _imageTimer;
  int _currentImageIndex = 0;

  // ✅ Add shopping wallets data - same as promo cards
  Map<String, double> _shoppingWalletBalances = {};
  bool _shoppingWalletsLoading = false;
  bool _isNavigatingToShoppingWallet = false;

  // ✅ Merchants data - same as in promo_cards.dart
  static const List<Map<String, dynamic>> _shoppingWalletMerchants = [
    {
      'name': 'Jaza Supermarket',
      'merchant_id': '812',
      'color': Color(0xFF4DA6FF),
      'icon': Icons.shopping_bag,
    },
    {
      'name': 'Quickmart Supermarket',
      'merchant_id': '347',
      'color': Color(0xFF111111),
      'icon': Icons.store,
    },
    {
      'name': 'Naivas Supermarket',
      'merchant_id': '107',
      'color': Color(0xFFFFB020),
      'icon': Icons.local_mall,
    },
    {
      'name': 'HotPoint Appliances',
      'merchant_id': '73',
      'color': Color(0xFFCD0000),
      'icon': Icons.devices,
    },
    {
      'name': 'Azone Supermarket',
      'merchant_id': '727',
      'color': Color(0xFF6C63FF),
      'icon': Icons.checkroom,
    },
    {
      'name': 'Open Wallet',
      'merchant_id': '4',
      'color': Color(0xFF00A86B),
      'icon': Icons.account_balance_wallet,
    },
  ];

  static const List<String> _bannerImages = [
    'assets/images/home_images/gift_box_1.png',
    'assets/images/home_images/gift_box_2.png',
    'assets/images/home_images/shopping_trolley.png',
  ];

  PageController _pageController = PageController();
  int _currentCardIndex = 0;

  @override
  void initState() {
    super.initState();

    _bannerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bannerAnimationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Start the initial animation
    _bannerAnimationController.forward();

    // Start the image rotation timer
    _startImageRotation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cubit = context.read<HomeCubit>();
      final kapuCubit = context.read<KapuCubit>();

      if (!_walletLoading && cubit.state is! HomeWalletFetched) {
        _walletLoading = true;
        cubit.fetchUserWallet().then((_) => _walletLoading = false);
      }

      if (!_txLoading && cubit.state is! HomeTransactionsFetched) {
        setState(() {
          _txLoading = true;
          _txError = null;
        });
        cubit.fetchLatestTransactions().then(
          (_) => setState(() => _txLoading = false),
        );
      }

      // ✅ Fetch shopping wallet balances
      _fetchShoppingWalletBalances(kapuCubit);
    });
  }

  // ✅ Add method to fetch shopping wallet balances
  Future<void> _fetchShoppingWalletBalances(KapuCubit kapuCubit) async {
    if (_shoppingWalletsLoading) return;

    setState(() {
      _shoppingWalletsLoading = true;
    });

    try {
      final merchantIds = _shoppingWalletMerchants
          .map((merchant) => merchant['merchant_id'] as String)
          .toList();

      await kapuCubit.fetchMultipleKapuWalletBalances(merchantIds);
    } catch (e) {
      AppLogger.log('❌ Error fetching shopping wallet balances: $e');
    } finally {
      if (mounted) {
        setState(() {
          _shoppingWalletsLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _startImageRotation() {
    if (_bannerImages.isEmpty) return;

    _imageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _bannerImages.isNotEmpty) {
        _bannerAnimationController.reverse().then((_) {
          if (mounted && _bannerImages.isNotEmpty) {
            setState(() {
              _currentImageIndex =
                  (_currentImageIndex + 1) % _bannerImages.length;
            });
            _bannerAnimationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerAnimationController.dispose();
    _imageTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    // Robust reset of load/completion flags at refresh start
    setState(() {
      _walletFetched = false;
      _transactionsFetched = false;
      _isLoading = true;
      _txLoading = true;
      _txError = null;
    });

    final cubit = context.read<HomeCubit>();
    // Parallel fetch, let listeners flip flags when done
    await Future.wait([
      cubit.fetchUserWallet(),
      cubit.fetchLatestTransactions(),
    ]);
  }

  // Added a delay to ensure shimmer lasts for at least 2 seconds
  Future<void> _ensureMinimumShimmerDuration() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // ✅ Add KapuCubit listener for shopping wallet balances
          BlocListener<KapuCubit, KapuState>(
            listener: (context, state) {
              if (state is KapuWalletListFetched) {
                // Update shopping wallet balances
                final balances = <String, double>{};
                final walletsList = state.wallets;

                for (
                  int i = 0;
                  i < walletsList.length && i < _shoppingWalletMerchants.length;
                  i++
                ) {
                  final merchantId =
                      _shoppingWalletMerchants[i]['merchant_id'] as String;
                  final balance = walletsList[i].data?.balance ?? 0.0;
                  balances[merchantId] = balance;
                }

                setState(() {
                  _shoppingWalletBalances = balances;
                });
              } else if (state is KapuWalletFetched) {
                // Update individual wallet balance
                final merchantId = state.merchantId;
                final newBalance =
                    state.kapuWalletResponse.data?.balance ?? 0.0;
                setState(() {
                  _shoppingWalletBalances[merchantId] = newBalance;
                });
              }
            },
          ),
          // Original HomeCubit listener
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) async {
              AppLogger.log('BlocListener: Current state = $state');

              if (state is HomeWalletFetched) {
                final walletBalance =
                    state.walletResponse.data!.walletAccount?.walletBalance;
                AppLogger.log(
                  'Wallet balance fetched: Total Credit = ${walletBalance?.totalCredit}, Total Debit = ${walletBalance?.totalDebit}',
                );
                await _ensureMinimumShimmerDuration();
                setState(() {
                  _walletFetched = true;
                  _isLoading = !_walletFetched || !_transactionsFetched;
                  AppLogger.log('Updated _isLoading = $_isLoading');
                });
              }

              if (state is HomeTransactionsFetched) {
                await _ensureMinimumShimmerDuration();
                setState(() {
                  _transactionsFetched = true;
                  _txLoading = false;

                  final newTransactions = state.transactionsResponse.data;
                  _transactions = newTransactions.isNotEmpty
                      ? List<TransactionData>.from(newTransactions)
                      : <TransactionData>[];
                  AppLogger.log(
                    'Transactions fetched: _transactionsFetched = $_transactionsFetched, count: ${_transactions.length}',
                  );
                  _isLoading = !_walletFetched || !_transactionsFetched;
                  AppLogger.log('Updated _isLoading = $_isLoading');
                });
              }

              if (state is HomeWalletLoading ||
                  state is HomeTransactionsLoading) {
                setState(() {
                  _isLoading = true;
                  AppLogger.log(
                    'Combined loading started: _isLoading = $_isLoading',
                  );
                });
              }

              if (state is HomeWalletFailure ||
                  state is HomeTransactionsFailure) {
                await _ensureMinimumShimmerDuration();
                setState(() {
                  _isLoading = false;
                  _txLoading = false;
                  AppLogger.log(
                    'Combined loading failed: _isLoading = $_isLoading',
                  );
                });
              }
            },
          ),
        ],
        child: Column(
          children: [
            // Fixed header section (Profile + Greeting + Notifications)
            _buildFixedHeader(context, isDark),

            // Scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: const Color(0xFF337687),
                child: CustomScrollView(
                  slivers: [
                    // Balance card section
                    SliverToBoxAdapter(child: _buildBalanceCard(context)),

                    // Main content section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          children: [
                            // Christmas banner
                            _buildChristmasBanner(context),
                            SizedBox(height: 22.h),

                            // Campaign cards
                            // _buildCampaignCard(context),
                            // SizedBox(height: 20.h),

                            // Shopping Wallets Section
                            _buildShoppingWalletsSection(context),
                            SizedBox(height: 12.h),

                            // Transactions section
                            _buildTransactionsSection(context),
                          ],
                        ),
                      ),
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

  Widget _buildFixedHeader(BuildContext context, bool isDark) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 44.h,
        bottom: 10.h,
      ),
      color: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.02),

          // Profile + Greeting + Notifications Row
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
                      Row(
                        children: [
                          Text(
                            widget.userModel.user.firstName.toUpperCase(),
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 6.w), // small space
                          Text(
                            "👋",
                            style: TextStyle(
                              fontSize: 20.sp, // match size with the name
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  // QR Code Icon
                  // GestureDetector(
                  //   onTap: () {
                  //     // Add QR code functionality here
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(8.w),
                  //     decoration: BoxDecoration(
                  //       color: isDark
                  //           ? Colors.grey[800]?.withOpacity(0.5)
                  //           : Colors.grey.withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(8.r),
                  //     ),
                  //     child: Icon(
                  //       Icons.qr_code_scanner,
                  //       color: isDark ? Colors.grey[300] : Colors.black54,
                  //       size: 24.sp,
                  //     ),
                  //   ),
                  // ),
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
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 4.h, bottom: 10.h),
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
      child: _buildBalanceCardContent(),
    );
  }

  Widget _buildBalanceCardContent() {
    // Remove local variable declarations that override class-level state
    bool showRefreshIcon = true;
    bool isKapuButtonPressed = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Balance header with refresh icon
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
                SizedBox(width: 4.w),
                if (showRefreshIcon)
                  GestureDetector(
                    onTap: () => _refreshData(),
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
            if (state is HomeWalletInitial || state is HomeWalletLoading) {
              // Show shimmer
              return Container(
                height: 40.h,
                width: 200.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              );
            }
            if (state is HomeWalletFetched) {
              final wallet =
                  state.walletResponse.data?.walletAccount?.walletBalance;
              final balance = wallet?.balance.toDouble();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    balance != null
                        ? (_isBalanceVisible
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
                    onTap: () {
                      setState(() {
                        _isBalanceVisible = !_isBalanceVisible;
                      });
                    },
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                      size: 20.sp,
                    ),
                  ),
                ],
              );
            }
            // On error or other state
            return Text(
              'KES ******',
              style: GoogleFonts.montserrat(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
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
              Icons.arrow_upward,
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
                if (isKapuButtonPressed) return; // Prevent multiple presses
                setState(() {
                  isKapuButtonPressed = true;
                });

                final userId = widget.userModel.user.id.toString();

                final hasVisited = await SharedPreferencesHelper.hasVisitedKapu(
                  userId,
                );
                final hasUsed = await SharedPreferencesHelper.hasUsedKapu(
                  userId,
                );
                final hasInteracted =
                    await SharedPreferencesHelper.hasInteractedWithKapu(userId);

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
                        builder: (context) =>
                            PromoCardsSwiperPage(userModel: widget.userModel),
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
                                builder: (context) => PromoCardsSwiperPage(
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
                  AppLogger.log('❌ [KAPU NAV] Error during navigation: $e');
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
    );
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

  Widget _buildCampaignCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // First row: Savings and Loans
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(
                  context: context,
                  title: 'Refer',
                  subtitle: 'Share and earn rewards',
                  icon: Icons.credit_card_outlined,
                  backgroundColor: const Color(
                    0xFF9BC53D,
                  ), // Green color for cards
                  onTap: () => _showCampaignModal(
                    context,
                  ), // Keep the referral modal for now
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildServiceCard(
                  context: context,
                  title: 'Loans',
                  subtitle: 'Click to borrow',
                  icon: Icons.account_balance_wallet_outlined,
                  backgroundColor: const Color(0xFF2E5984),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                    final NavigationWrapperState? navState = context
                        .findAncestorStateOfType<NavigationWrapperState>();
                    if (navState != null) {
                      navState.setTabIndex(3);
                    }
                  },
                ),
              ),
            ],
          ),
          // SizedBox(height: 12.h),
          // Second row: Insurance and Cards
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildServiceCard(
          //         context: context,
          //         title: 'Contact us',
          //         subtitle: 'Call us now for inquiries',
          //         icon: Icons.message,
          //         backgroundColor: const Color(
          //           0xFF4A6B7C,
          //         ), // Teal color for insurance
          //         onTap: () => _launchURL('https://wa.me/254759687055'),
          //       ),
          //     ),
          //     SizedBox(width: 12.w),
          //     Expanded(
          //       child: _buildServiceCard(
          //         context: context,
          //         title: 'Youtube',
          //         subtitle: 'How to use the app',
          //         icon: Icons.video_collection,
          //         backgroundColor: Colors.red,
          //         onTap: () => _launchURL(
          //           'https://www.youtube.com/@flexpaylipiapolepole',
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8.r,
              spreadRadius: 2.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          subtitle,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 8.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white.withOpacity(0.9),
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.white, size: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: const Color(0xFF337687),
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Coming Soon!',
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF337687),
              ),
            ),
          ],
        ),
        content: Text(
          '$serviceName service will be available soon. Stay tuned for updates!',
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF337687),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'OK',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCampaignModal(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 18.w, 24.h),
          child: SingleChildScrollView(
            child: BlocProvider.value(
              value: homeCubit,
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is HomeReferralSuccess) {
                    Navigator.pop(context); // close modal
                    CustomSnackBar.showSuccess(
                      context,
                      title: "Referral Sent!",
                      message: "Your friend has been referred successfully.",
                    );
                  } else if (state is HomeReferralFailure) {
                    // Extract clean error message from the exception
                    String errorMessage = state.message;
                    if (errorMessage.startsWith('Exception: ')) {
                      errorMessage = errorMessage.substring(
                        'Exception: '.length,
                      );
                    }

                    CustomSnackBar.showError(
                      context,
                      title: "Referral Failed",
                      message: errorMessage,
                      useOverlay: true,
                    );
                  }
                },

                builder: (context, state) {
                  final isLoading = state is HomeReferralLoading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // underline indicator
                      Center(
                        child: Container(
                          width: 50.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // icons row
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_people,
                              color: Colors.orange,
                              size: 30.sp,
                            ),
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.card_giftcard,
                              color: Colors.blue,
                              size: 30.sp,
                            ),
                            SizedBox(width: 12.w),
                            Icon(Icons.star, color: Colors.amber, size: 30.sp),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // title
                      Center(
                        child: Text(
                          'Refer & Earn',
                          style: GoogleFonts.montserrat(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D3C4E),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      Text(
                        'Share the love—get KES 100 when your friend tops up KES 500!',
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 26.h),

                      Text(
                        "Phone Number",
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // phone input
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: TextField(
                          controller: phoneController,
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter phone Number",
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.montserrat(
                              color: Colors.grey[500],
                              fontSize: 15.sp,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(height: 22.h),

                      // REFER button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  final phone = phoneController.text.trim();

                                  // Validate phone number format
                                  if (phone.isEmpty) {
                                    CustomSnackBar.showWarning(
                                      context,
                                      title: "Missing Number",
                                      message:
                                          "Please enter a phone number to refer.",
                                    );
                                    return;
                                  }

                                  // Client-side validation for immediate feedback
                                  final cleanPhone = phone.replaceAll(
                                    RegExp(r'[^\d]'),
                                    '',
                                  );
                                  bool isValidFormat = false;

                                  if (cleanPhone.length == 10) {
                                    isValidFormat =
                                        cleanPhone.startsWith('07') ||
                                        cleanPhone.startsWith('01');
                                  } else if (cleanPhone.length == 12 &&
                                      cleanPhone.startsWith('254')) {
                                    final localPart = cleanPhone.substring(3);
                                    isValidFormat =
                                        localPart.startsWith('7') ||
                                        localPart.startsWith('1');
                                  }

                                  if (!isValidFormat) {
                                    CustomSnackBar.showWarning(
                                      context,
                                      title: "Invalid Format",
                                      message:
                                          "Use format: 07XXXXXXXX, 01XXXXXXXX, or 2547XXXXXXXX",
                                    );
                                    return;
                                  }

                                  context.read<HomeCubit>().makeReferral(phone);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF337687),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SpinKitWave(color: Colors.white, size: 28.sp)
                              : Text(
                                  "Refer",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChristmasBanner(BuildContext context) {
    // Add safety check for banner images
    if (_bannerImages.isEmpty) {
      return SizedBox(height: 114.h); // Return empty container if no images
    }

    return Padding(
      padding: EdgeInsets.zero, // Already handled by parent ListView
      child: GestureDetector(
        onTap: () async {
          if (_isNavigatingToKapu) return;
          setState(() => _isNavigatingToKapu = true);

          try {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateGoalPage(
                  prefilledGoal: {'product_name': 'Christmas Shopping Goal'},
                ),
              ),
            );
          } catch (e) {
            AppLogger.log('❌ [GOAL NAV ERROR] $e');
          } finally {
            if (mounted) setState(() => _isNavigatingToKapu = false);
          }
        },
        child: Container(
          height: 114.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: const DecorationImage(
              image: AssetImage('assets/images/home_images/app_banner1.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8.r,
                spreadRadius: 4.r,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            // Standardized padding
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.18), // much lighter overlay
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 1,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _currentImageIndex < _bannerImages.length
                        ? Image.asset(
                            _bannerImages[_currentImageIndex],
                            fit: BoxFit.contain,
                            height: 100.h,
                            width: 100.w,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100.h,
                                width: 100.w,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              );
                            },
                          )
                        : Container(
                            height: 100.h,
                            width: 100.w,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported),
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

  Widget _buildTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_transactions.isNotEmpty) {
                  Navigator.of(context).push(
                    _createSlideUpRoute(
                      List<TransactionData>.from(_transactions),
                    ),
                  );
                }
              },
              child: Text(
                'View All',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF7CAA23),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        if (_isLoading || _txLoading) ...[
          Center(child: SpinKitWave(color: ColorName.primaryColor, size: 24)),
        ] else if (_transactions.isEmpty)
          Text(
            _txError ?? 'Transactions are not available at the moment.',
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          )
        else
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.isNotEmpty
                  ? _transactions.length.clamp(0, 5)
                  : 0,
              itemBuilder: (context, index) {
                if (index >= _transactions.length) {
                  return const SizedBox.shrink();
                }

                final tx = _transactions[index];
                final isIncome = tx.paymentAmount >= 0;
                final amountText = _formatAmount(
                  tx.paymentAmount,
                  prefix: 'KES ',
                );
                final status = 'Successful';

                return _buildTransactionTile(
                  tx,
                  amountText,
                  isIncome,
                  status,
                  context,
                );
              },
            ),
          ),

        // Add spacing before shopping wallets section
        // SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildShoppingWalletsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shopping Wallets',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to all shopping wallets page
                // TODO: Implement navigation to full shopping wallets page
              },
              child: Text(
                'View All',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF7CAA23),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Horizontal scrollable shopping wallet cards
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _shoppingWalletMerchants.length,
            itemBuilder: (context, index) {
              final merchant = _shoppingWalletMerchants[index];
              final balance =
                  _shoppingWalletBalances[merchant['merchant_id']] ?? 0.0;
              return _buildShoppingWalletCard(
                context,
                merchant['name'],
                'KES ${balance.toStringAsFixed(2)}',
                merchant['icon'],
                merchant['color'],
                index,
              );
            },
          ),
        ),

        // Add bottom spacing
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildShoppingWalletCard(
    BuildContext context,
    String title,
    String balance,
    IconData icon,
    Color accentColor,
    int index,
  ) {
    return GestureDetector(
      onTap: () async {
        if (_isNavigatingToShoppingWallet) return;
        setState(() => _isNavigatingToShoppingWallet = true);

        try {
          final merchant = _shoppingWalletMerchants[index];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromoCardsSwiperPage(
                userModel: widget.userModel,
                preselectedMerchantId: merchant['merchant_id'],
              ),
            ),
          );
        } catch (e) {
          AppLogger.log('❌ [SHOPPING WALLET NAV ERROR] $e');
        } finally {
          if (mounted) setState(() => _isNavigatingToShoppingWallet = false);
        }
      },
      child: Container(
        width: 240.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: const DecorationImage(
            image: AssetImage('assets/images/appbarbackground.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12.r,
              spreadRadius: 2.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black.withOpacity(0.2), Colors.transparent],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top section with icon, title, and visibility toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20.sp),
                  ),
                  Row(
                    children: [
                      // Hide/Show balance toggle
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            _isBalanceVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Active',
                          style: GoogleFonts.montserrat(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Title
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Balance with visibility toggle
              Text(
                _isBalanceVisible ? balance : 'KES ******',
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 24.r,
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
    TransactionData tx,
    String amount,
    bool isIncome,
    String status,
    BuildContext context,
  ) {
    Color circleColor = isIncome
        ? const Color(0xFF7CAA23)
        : const Color(0xFF7CAA23);
    Color statusColor = status == 'Successful'
        ? const Color(0xFF7CAA23)
        : Colors.redAccent;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: GestureDetector(
        onTap: () {
          if (_transactions.isNotEmpty) {
            Navigator.of(context).push(
              _createSlideUpRoute(List<TransactionData>.from(_transactions)),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.18),
              width: 1.4,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_outward,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 12.w),

              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tx.productName,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      tx.date,
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (isIncome ? '' : '-') + amount,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    status,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatAmount(double value, {String prefix = ''}) {
  final isNegative = value < 0;
  final abs = value.abs();
  final hasCents = abs.truncateToDouble() != abs;
  final text = hasCents ? abs.toStringAsFixed(2) : abs.toStringAsFixed(0);
  final signed = isNegative ? '-$prefix$text' : '+$prefix$text';
  return signed;
}

Route _createSlideUpRoute(List<TransactionData> transactions) {
  if (transactions.isEmpty) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text('No Transactions')),
        body: Center(child: Text('No transactions available')),
      ),
    );
  }

  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) =>
        TransactionDetailsPage(transactions: transactions),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.easeInOutCubicEmphasized;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
