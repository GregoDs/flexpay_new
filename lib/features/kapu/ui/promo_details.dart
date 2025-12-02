import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/kapu/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/features/kapu/ui/modals/kapu_topup.dart';
import 'package:flexpay/features/kapu/ui/modals/kapu_voucher_modal.dart';
import 'package:flexpay/features/kapu/ui/modals/transfer_modal.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoCardDetailPage extends StatefulWidget {
  final Map<String, dynamic> merchant;
  final double balance;
  final BookingData booking;
  final UserModel? userModel;
  final bool?
  isBalanceHidden; // ✅ Add parameter to receive balance visibility state

  const PromoCardDetailPage({
    super.key,
    required this.merchant,
    required this.balance,
    required this.booking,
    this.userModel,
    this.isBalanceHidden, // ✅ Optional parameter
  });

  @override
  State<PromoCardDetailPage> createState() => _PromoCardDetailPageState();
}

class _PromoCardDetailPageState extends State<PromoCardDetailPage> {
  bool _hideBalance = true;
  double _currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _currentBalance = widget.balance;

    // ✅ Initialize balance visibility from the previous page's state
    _hideBalance =
        widget.isBalanceHidden ??
        false; // Default to false (show balance) if not provided

    // Don't load from SharedPreferences since we want to sync with previous page
    // _loadHidePreference(); // Commented out to use the passed state instead

    // Mark the user as having interacted with Kapu
    SharedPreferencesHelper.markKapuInteracted(
      widget.booking.userId.toString(),
    );
  }

  Future<void> _loadHidePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hideBalance = prefs.getBool('hide_balance') ?? true;
    });
  }

  Future<void> _saveHidePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hide_balance', value);
  }

  // Add refresh method to fetch latest balance
  Future<void> _onRefresh() async {
    try {
      final kapuCubit = context.read<KapuCubit>();
      await kapuCubit.fetchKapuWalletBalance(
        widget.merchant['merchant_id'].toString(),
      );
    } catch (e) {
      // Handle error silently or show a snackbar if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh balance'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchant = widget.merchant;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1113) : Colors.white;

    return BlocListener<KapuCubit, KapuState>(
      listener: (context, state) {
        if (state is KapuWalletFetched) {
          final currentMerchantId = widget.merchant['merchant_id'].toString();
          if (state.merchantId == currentMerchantId) {
            setState(() {
              _currentBalance =
                  state.kapuWalletResponse.data?.balance ?? _currentBalance;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: merchant['color'],
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 18.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _circleIcon(
                            context,
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          Text(
                            "CARD DETAILS",
                            style: GoogleFonts.montserrat(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1D2935),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1D2935),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      // 🔹 Main content row
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left actions
                            Column(
                              children: [
                                _buildActionButton(
                                  icon: Icons.account_balance_wallet_outlined,
                                  label: "Top-Up",
                                  isDark: isDark,
                                  onTap: () {
                                    showKapuTopUpModalSheet(
                                      context,
                                      userModel:
                                          widget.userModel, // ✅ Pass user model
                                      booking: widget.booking,
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),

                                _buildActionButton(
                                  icon: Icons.transfer_within_a_station,
                                  label: "Transfer",
                                  isDark: isDark,
                                  onTap: () async {
                                    // ✅ Make async
                                    final didTransfer =
                                        await showKapuTransferModalSheet(
                                          context,
                                          fromMerchantId: widget
                                              .merchant['merchant_id']
                                              .toString(),
                                        );

                                    // ✅ If a transfer actually occurred (modal returns true)
                                    if (didTransfer == true && mounted) {
                                      Navigator.pop(
                                        context,
                                        true,
                                      ); // notify previous page to refresh
                                    }
                                  },
                                ),

                                SizedBox(height: 20.h),
                                // _buildActionButton(
                                //   icon: Icons.edit_outlined,
                                //   label: "Deposit",
                                //   isDark: isDark,
                                //   onTap: () {
                                //     showKapuDebitModalSheet(
                                //       context,
                                //       merchantId:
                                //           widget.merchant['merchant_id'].toString(),
                                //     );
                                //   },
                                // ),
                                _buildActionButton(
                                  icon: Icons.confirmation_num_outlined,
                                  label: "Create Voucher",
                                  isDark: isDark,
                                  onTap: () async {
                                    // ✅ No need to check return value anymore
                                    await showKapuCreateVoucherModalSheet(
                                      context,
                                      merchantId: widget.merchant['merchant_id']
                                          .toString(),
                                    );
                                    // Modal handles its own success notification
                                    // and balance refresh happens automatically via BlocListener
                                  },
                                ),

                                SizedBox(height: 20.h),
                                _buildActionButton(
                                  icon: _hideBalance
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  label: _hideBalance
                                      ? "Show Info"
                                      : "Hide Info",
                                  isDark: isDark,
                                  onTap: () {
                                    setState(() {
                                      _hideBalance = !_hideBalance;
                                    });
                                    _saveHidePreference(_hideBalance);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(width: 20.w),

                            // Right Hero Card
                            Expanded(
                              child: Hero(
                                tag: 'kapu_card_${merchant['merchant_id']}',
                                flightShuttleBuilder:
                                    (
                                      flightContext,
                                      animation,
                                      direction,
                                      fromHeroContext,
                                      toHeroContext,
                                    ) {
                                      // ✅ Fade-only transition = no yellow flicker
                                      return FadeTransition(
                                        opacity: animation.drive(
                                          Tween<double>(
                                            begin: 0.0,
                                            end: 1.0,
                                          ).chain(
                                            CurveTween(curve: Curves.easeInOut),
                                          ),
                                        ),
                                        child: toHeroContext.widget,
                                      );
                                    },
                                transitionOnUserGestures: true,
                                child: Material(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.hardEdge,
                                  child: Container(
                                    height: 210.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _shadeColor(
                                            merchant['color'],
                                            0.85,
                                          ).withOpacity(0.98),
                                          _shadeColor(
                                            merchant['color'],
                                            1.12,
                                          ).withOpacity(0.95),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: merchant['color'].withOpacity(
                                            0.4,
                                          ),
                                          blurRadius: 25,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(20.w),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Opacity(
                                            opacity: isDark ? 0.04 : 0.06,
                                            child: Image.asset(
                                              'assets/images/home_images/promo_card_pattern.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Chip + contactless icons
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 24.w,
                                                      height: 18.h,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4.r,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Icon(
                                                      Icons.wifi,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      size: 16.sp,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 26.h),

                                            // Balance
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 350,
                                              ),
                                              child: _hideBalance
                                                  ? Text(
                                                      "•••••••",
                                                      key: const ValueKey(
                                                        "hidden_balance",
                                                      ),
                                                      style:
                                                          GoogleFonts.montserrat(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 2,
                                                          ),
                                                    )
                                                  : Text(
                                                      "Ksh ${_currentBalance.toStringAsFixed(2)}",
                                                      key: const ValueKey(
                                                        "visible_balance",
                                                      ),
                                                      style:
                                                          GoogleFonts.montserrat(
                                                            color: Colors.white,
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                            ),
                                            SizedBox(height: 8.h),

                                            // Merchant name
                                            Text(
                                              merchant['name'],
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔹 Card Info Section
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "CARD INFORMATION",
                            style: GoogleFonts.montserrat(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _hideBalance = !_hideBalance);
                              _saveHidePreference(_hideBalance);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _hideBalance
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    _hideBalance ? "Show Info" : "Hide Info",
                                    style: GoogleFonts.montserrat(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildInfoRow("Merchant", merchant['name'], isDark),
                      _buildInfoRow(
                        "Balance",
                        _hideBalance
                            ? "•••••••"
                            : "Ksh ${_currentBalance.toStringAsFixed(2)}",
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  // 🔹 Utility widgets same as Version A
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white : Colors.black54,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 13.sp,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Color _shadeColor(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
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