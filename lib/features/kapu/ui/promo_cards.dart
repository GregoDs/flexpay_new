import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/kapu/repo/kapu_repo.dart';
import 'package:flexpay/features/kapu/ui/promo_cards_shimmer.dart';
import 'package:flexpay/features/kapu/ui/promo_details.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Add enum for view modes
enum ViewMode { swiper, list }

class PromoCardsSwiperPage extends StatefulWidget {
  final UserModel? userModel;
  final String? preselectedMerchantId; // ✅ Add parameter for direct navigation

  const PromoCardsSwiperPage({
    super.key,
    this.userModel,
    this.preselectedMerchantId, // ✅ Add optional preselected merchant
  });

  @override
  State<PromoCardsSwiperPage> createState() => _PromoCardsSwiperPageState();
}

class _PromoCardsSwiperPageState extends State<PromoCardsSwiperPage> {
  late KapuCubit _kapuCubit;
  bool _isBalanceHidden =
      false; // Changed from true to false - show balances by default
  bool _hasFetchedOnce = false;
  bool _isNavigating = false;
  bool _isRefreshing = false; // Add refresh state

  // Add view mode state
  ViewMode _currentViewMode = ViewMode.list;

  Map<String, double> _merchantBalances = {}; //store live balances locally

  // Add null safety and make list immutable to prevent crashes
  static const List<Map<String, dynamic>> _staticMerchants = [
    {
      'name': 'Jaza Supermarket',
      'merchant_id': '812',
      'color': Color(0xFF4DA6FF),
    },
    {
      'name': 'Quickmart Supermarket',
      'merchant_id': '347',
      'color': Color(0xFF111111),
    },
    {
      'name': 'Naivas Supermarket',
      'merchant_id': '107',
      'color': Color(0xFFFFB020),
    },
    {
      'name': 'HotPoint Appliances',
      'merchant_id': '73',
      'color': Color(0xFFCD0000),
    },
    {
      'name': 'Azone Supermarket',
      'merchant_id': '727',
      'color': Color(0xFF6C63FF),
    },
    {'name': 'Open Wallet', 'merchant_id': '4', 'color': Color(0xFF00A86B)},
  ];

  // Create a mutable copy for runtime operations
  late List<Map<String, dynamic>> merchants;
  List<Map<String, dynamic>> _visibleMerchants = [];
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize merchants list safely
    merchants = List<Map<String, dynamic>>.from(_staticMerchants);
    _visibleMerchants = List<Map<String, dynamic>>.from(merchants);
    _kapuCubit = KapuCubit(KapuRepo(ApiService()));

    // ✅ Handle preselected merchant navigation
    int initialPage = 0;
    if (widget.preselectedMerchantId != null) {
      final preselectedIndex = merchants.indexWhere(
        (merchant) => merchant['merchant_id'] == widget.preselectedMerchantId,
      );
      if (preselectedIndex != -1) {
        initialPage = preselectedIndex;
        _currentPage = initialPage.toDouble();
      }
    }

    // Add safety check for empty merchants list
    if (merchants.isNotEmpty) {
      final merchantIds = merchants
          .map((m) => m['merchant_id'] as String)
          .where((id) => id.isNotEmpty) // Filter out empty IDs
          .toList();

      if (merchantIds.isNotEmpty) {
        _kapuCubit.fetchMultipleKapuWalletBalances(merchantIds);
      }
    }

    _pageController = PageController(
      viewportFraction: 0.78,
      initialPage: initialPage, // ✅ Use calculated initial page
    );

    _pageController.addListener(() {
      if (_pageController.hasClients && mounted) {
        setState(() {
          _currentPage =
              _pageController.page ?? _pageController.initialPage.toDouble();
        });
      }
    });

    // ✅ If navigating directly to a merchant, automatically navigate to details after loading
    if (widget.preselectedMerchantId != null && initialPage != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Wait a bit for the page to settle, then navigate
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && initialPage < merchants.length) {
            _onMerchantTap(merchants[initialPage], initialPage);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _kapuCubit.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1113) : const Color(0xFFF5F7FA);

    final headlineStyle = GoogleFonts.montserrat(
      fontSize: 36.sp,
      fontWeight: FontWeight.w500,
      height: 1.24,
      color: isDark ? Colors.white : const Color(0xFF1D2935),
    );

    final subtitleStyle = GoogleFonts.montserrat(
      fontSize: 13.sp,
      color: isDark ? Colors.grey[400] : Colors.black54,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    );

    return BlocProvider(
      create: (_) => _kapuCubit,
      child: BlocListener<KapuCubit, KapuState>(
        listener: (context, state) {
          if (state is KapuWalletFetched) {
            final merchantId = state.merchantId;
            final newBalance = state.kapuWalletResponse.data?.balance ?? 0.0;

            // ✅ Only update the affected merchant balance
            setState(() {
              _merchantBalances[merchantId] = newBalance;
            });
          }

          if (state is KapuWalletListFetched) {
            // ✅ Initialize the map with balances when loaded with bounds checking
            final balances = <String, double>{};
            final walletsList = state.wallets;

            for (
              int i = 0;
              i < walletsList.length && i < merchants.length;
              i++
            ) {
              final merchantId = merchants[i]['merchant_id']?.toString();
              if (merchantId != null && merchantId.isNotEmpty) {
                final balance = walletsList[i].data?.balance ?? 0.0;
                balances[merchantId] = balance;
              }
            }
            setState(() {
              _merchantBalances = balances;
              _hasFetchedOnce = true;
            });
          }
        },
        child: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshBalances, // Add refresh logic
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _circleIcon(
                          context,
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        Text(
                          'Christmas Kapu'.toUpperCase(),
                          style: subtitleStyle.copyWith(letterSpacing: 1.6),
                        ),
                        Text(
                          '${(_currentPage.round() + 1)}/${merchants.length}',
                          style: subtitleStyle,
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),

                    Text.rich(
                      TextSpan(
                        text: 'Start saving for\n',
                        children: [
                          TextSpan(
                            text: 'your next shopping ',
                            style: headlineStyle,
                          ),
                          TextSpan(
                            text: 'and earn cash back rewards 🎅',
                            style: headlineStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        style: headlineStyle,
                      ),
                    ),

                    SizedBox(height: 26.h),

                    // Add view mode toggle button with better styling
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currentViewMode == ViewMode.swiper
                              ? 'Swipe View'
                              : 'List View',
                          style: subtitleStyle.copyWith(fontSize: 12.sp),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFFF6F7F9),
                            borderRadius: BorderRadius.circular(20.r),
                            border: isDark
                                ? Border.all(
                                    color: Colors.grey[700]!,
                                    width: 0.5,
                                  )
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentViewMode = ViewMode.swiper;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _currentViewMode == ViewMode.swiper
                                        ? (isDark ? Colors.white : Colors.black)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.view_carousel,
                                        size: 16.sp,
                                        color:
                                            _currentViewMode == ViewMode.swiper
                                            ? (isDark
                                                  ? Colors.black
                                                  : Colors.white)
                                            : (isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Cards',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              _currentViewMode ==
                                                  ViewMode.swiper
                                              ? (isDark
                                                    ? Colors.black
                                                    : Colors.white)
                                              : (isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentViewMode = ViewMode.list;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _currentViewMode == ViewMode.list
                                        ? (isDark ? Colors.white : Colors.black)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.view_list,
                                        size: 16.sp,
                                        color: _currentViewMode == ViewMode.list
                                            ? (isDark
                                                  ? Colors.black
                                                  : Colors.white)
                                            : (isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'List',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              _currentViewMode == ViewMode.list
                                              ? (isDark
                                                    ? Colors.black
                                                    : Colors.white)
                                              : (isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: BlocBuilder<KapuCubit, KapuState>(
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: _buildStateChild(state),
                          );
                        },
                      ),
                    ),

                    Center(
                      child: Text(
                        _currentViewMode == ViewMode.swiper
                            ? 'Swipe to view more'
                            : 'Scroll to see all merchants',
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateChild(KapuState state) {
    if (_hasFetchedOnce && _merchantBalances.isNotEmpty) {
      return _currentViewMode == ViewMode.swiper
          ? _buildSwiper([])
          : _buildListView();
    }
    if (state is KapuWalletLoading) {
      return const PromoCardsShimmer(key: ValueKey('shimmer'));
    } else if (state is KapuWalletListFetched) {
      return _currentViewMode == ViewMode.swiper
          ? _buildSwiper(state.wallets)
          : _buildListView();
    } else if (state is KapuWalletFailure) {
      return Center(
        key: const ValueKey('error'),
        child: Text(
          "⚠️ ${state.message}",
          style: GoogleFonts.montserrat(
            color: Colors.redAccent,
            fontSize: 14.sp,
          ),
        ),
      );
    }
    return const PromoCardsShimmer(key: ValueKey('shimmer_fallback'));
  }

  Widget _buildSwiper(List<KapuWalletBalances> wallets) {
    // Safety: prevent empty merchants crash
    if (_visibleMerchants.isEmpty) {
      return Center(
        child: Text(
          'No merchants available',
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    // Clamp current page so PageView doesn't try invalid index
    _currentPage = _currentPage.clamp(
      0,
      (_visibleMerchants.length - 1).toDouble(),
    );

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            key: ValueKey(
              _visibleMerchants.length,
            ), // rebuild if list length changes
            controller: _pageController,
            itemCount: _visibleMerchants.length,
            itemBuilder: (context, index) {
              if (index < 0 || index >= _visibleMerchants.length) {
                return const SizedBox.shrink();
              }

              final merchant = _visibleMerchants[index];
              final merchantId = merchant['merchant_id']?.toString() ?? '';
              final balance = _merchantBalances[merchantId] ?? 0.0;
              final bool isCurrent = index == _currentPage.round();

              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                margin: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: isCurrent ? 36.h : 48.h,
                ),
                transform: Matrix4.identity()
                  ..scale(isCurrent ? 1.0 : 0.93)
                  ..setEntry(3, 2, 0.001),
                child: GestureDetector(
                  onTap: () => _onMerchantTap(merchant, index),
                  child: _buildCard(merchant, balance, index),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        // Indicators
        if (_visibleMerchants.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_visibleMerchants.length, (index) {
              if (index < 0 || index >= _visibleMerchants.length)
                return const SizedBox.shrink();
              final bool isActive = index == _currentPage.round();
              final Color color =
                  (_visibleMerchants[index]['color'] as Color?) ?? Colors.blue;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: isActive ? 22.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withOpacity(0.9)
                      : color.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildListView() {
    if (_visibleMerchants.isEmpty) {
      return Center(
        child: Text(
          'No merchants available',
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    // Clamp current page to avoid invalid index
    _currentPage = _currentPage.clamp(
      0,
      (_visibleMerchants.length - 1).toDouble(),
    );

    return ListView.builder(
      key: ValueKey(_visibleMerchants.length), // rebuild if list changes
      itemCount: _visibleMerchants.length,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        if (index < 0 || index >= _visibleMerchants.length)
          return const SizedBox.shrink();

        final merchant = _visibleMerchants[index];
        final merchantId = merchant['merchant_id']?.toString() ?? '';
        final balance = _merchantBalances[merchantId] ?? 0.0;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () => _onMerchantTap(merchant, index),
            child: _buildListCard(merchant, balance, index),
          ),
        );
      },
    );
  }

  // Move tap logic to a single function to avoid repetition
  Future<void> _onMerchantTap(Map<String, dynamic> merchant, int index) async {
    if (_isNavigating) return;

    _isNavigating = true;
    _currentPage = index.toDouble();

    final merchantId = merchant['merchant_id']?.toString() ?? '';
    if (merchantId.isEmpty) {
      _isNavigating = false;
      return;
    }

    try {
      await SharedPreferencesHelper.markKapuUsed(
        widget.userModel!.user.id.toString(),
      );

      final booking = await _kapuCubit.createKapuBooking(
        merchantId: merchantId,
      );
      _kapuCubit.fetchKapuShops(merchantId);

      if (booking != null) {
        await Future.delayed(const Duration(milliseconds: 120));
        final shouldRefresh = await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, animation, __) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: BlocProvider.value(
                  value: context.read<KapuCubit>(),
                  child: PromoCardDetailPage(
                    merchant: merchant,
                    balance: _merchantBalances[merchantId] ?? 0.0,
                    booking: booking,
                    userModel: widget.userModel,
                    isBalanceHidden: _isBalanceHidden,
                  ),
                ),
              ),
            ),
          ),
        );

        if (shouldRefresh == true && mounted) {
          final merchantIds = merchants
              .map((m) => m['merchant_id']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList();
          if (merchantIds.isNotEmpty) {
            _kapuCubit.fetchMultipleKapuWalletBalances(merchantIds);
          }
        }
      }
    } finally {
      _isNavigating = false;
    }
  }

  // Complete the list card builder with proper null safety
  Widget _buildListCard(
    Map<String, dynamic> merchant,
    double balance,
    int index,
  ) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color base = merchant['color'] as Color? ?? Colors.blue;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: base.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: base.withOpacity(0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Merchant icon/avatar
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: base.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: base.withOpacity(0.3), width: 1),
              ),
              child: Icon(Icons.store, color: base, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            // Merchant info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    merchant['name']?.toString() ?? 'Unknown Merchant',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF1D2935),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'FlexPay Merchant',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Balance info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isBalanceHidden
                      ? "Ksh •••••"
                      : "Ksh ${balance.toStringAsFixed(2)}",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: base,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 12.sp,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Tap to view',
                      style: GoogleFonts.montserrat(
                        fontSize: 11.sp,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> merchant, double balance, int index) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color base = merchant['color'] as Color;
    final Color darker = _shadeColor(base, 0.85);
    final Color lighter = _shadeColor(base, 1.12);

    return Hero(
      tag: 'kapu_card_${merchant['merchant_id']}',
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            direction,
            fromHeroContext,
            toHeroContext,
          ) {
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: toHeroContext.widget,
            );
          },
      transitionOnUserGestures: true,
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darker.withOpacity(0.98), lighter.withOpacity(0.95)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: isDarkMode ? 0.04 : 0.06,
                  child: Image.asset(
                    'assets/images/home_images/promo_card_pattern.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            merchant['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.24),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 12.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Tap to view",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount",
                          style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // 👁️ Hide/Show button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isBalanceHidden = !_isBalanceHidden;
                            });
                          },
                          child: Icon(
                            _isBalanceHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _isBalanceHidden
                          ? "Ksh •••••"
                          : "Ksh ${balance.toStringAsFixed(2)}",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "FlexPay Merchant",
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 12.sp,
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
  }

  Color _shadeColor(Color color, double factor) {
    final HSLColor hsl = HSLColor.fromColor(color);
    final double lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Widget _circleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF6F7F9),
          shape: BoxShape.circle,
          border: isDark
              ? Border.all(color: Colors.grey[700]!, width: 0.5)
              : null,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black,
          size: 20.sp,
        ),
      ),
    );
  }

  Future<void> _refreshBalances() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    final merchantIds = merchants
        .map((m) => m['merchant_id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (merchantIds.isNotEmpty) {
      await _kapuCubit.fetchMultipleKapuWalletBalances(merchantIds);
    }

    setState(() {
      _isRefreshing = false;
    });
  }
}
