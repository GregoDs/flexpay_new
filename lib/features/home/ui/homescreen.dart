import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/ui/appbarhome.dart';
import 'package:flexpay/features/home/ui/transactions_home.dart';
import 'package:flexpay/features/goals/ui/create_goal.dart';
import 'package:flexpay/gen/colors.gen.dart';
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
  List<TransactionData> _transactions =  <TransactionData>[]; 
  bool _txLoading = false;
  String? _txError;
  bool _isNavigatingToKapu = false;
  bool _walletLoading = false;
  bool _isLoading = true;

  bool _walletFetched = false;
  bool _transactionsFetched = false;

  late AnimationController _bannerAnimationController;
  late Animation<double> _fadeAnimation;
  Timer? _imageTimer;
  int _currentImageIndex = 0;

 
  static const List<String> _bannerImages = [
    'assets/images/home_images/gift_box_1.png',
    'assets/images/home_images/gift_box_2.png',
    'assets/images/home_images/shopping_trolley.png',
  ];

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
    });
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
    final cubit = context.read<HomeCubit>();

    // Prevent overlapping API calls
    if (_walletLoading || _txLoading) return;

    setState(() {
      _txLoading = true;
      _txError = null;
    });

    await Future.wait([
      cubit.fetchUserWallet().then((_) => _walletLoading = false),
      cubit.fetchLatestTransactions().then(
        (_) => setState(() => _txLoading = false),
      ),
    ]);
  }

  // Added a delay to ensure shimmer lasts for at least 2 seconds
  Future<void> _ensureMinimumShimmerDuration() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.60,
            ),
            child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) async {
                AppLogger.log(
                  'BlocListener: Current state = $state',
                ); // Debug log

                if (state is HomeWalletFetched) {
                  final walletBalance =
                      state.walletResponse.data!.walletAccount?.walletBalance;
                  AppLogger.log(
                    'Wallet balance fetched: Total Credit = ${walletBalance?.totalCredit}, Total Debit = ${walletBalance?.totalDebit}',
                  );
                  await _ensureMinimumShimmerDuration(); // Ensure shimmer lasts for 2 seconds
                  setState(() {
                    _walletFetched = true; // Mark wallet as fetched
                    _isLoading =
                        !_walletFetched ||
                        !_transactionsFetched; 
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
                    _isLoading =
                        !_walletFetched ||
                        !_transactionsFetched; 
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
                  await _ensureMinimumShimmerDuration(); // Ensure shimmer lasts for 2 seconds
                  setState(() {
                    _isLoading = false; 
                    _txLoading = false; 
                    AppLogger.log(
                      'Combined loading failed: _isLoading = $_isLoading',
                    );
                  });
                }
              },
              child: AppBarHome(
                context,
                userName: "${widget.userModel.user.firstName}",
                userModel: widget.userModel,
                isDataReady:
                    !_isLoading, // Use combined loading flag to control shimmer
                onWalletBalanceMissing: () {
                  // Add a fallback UI or refetch option
                  AppLogger.log(
                    'Wallet balance missing in UI. Prompting user to refetch.',
                  );
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Wallet Balance Missing'),
                      content: Text(
                        'Your wallet balance is not visible. Would you like to refetch it?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<HomeCubit>().fetchUserWallet();
                          },
                          child: Text('Refetch'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: const Color(0xFF337687),
            child: ListView(
              // STANDARDIZED HORIZONTAL PADDING FOR SETTINGS AND ALIGNMENT
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              children: [
                SizedBox(height: 8.h),
                // Refer & Earn Section - positioned above Kapu banner
                _buildCampaignCard(context),
                SizedBox(height: 12.h),

                // 🎅 Xmas Kapu Promo Banner
                _buildChristmasBanner(context),

                SizedBox(height: 20.h),
                // VoucherModalSheet(context: context),
                // SizedBox(height: 8.h),
                // _buildMerchantImages(context),
                // SizedBox(height: 8.h),
                _buildTransactionsSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCampaignCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCampaignModal(context);
      },
      // Wrap in Row and Expanded to break right padding
      child: Row(
        children: [
          Expanded(
            child: Container(
              // No right margin or padding, only left
              margin: EdgeInsets.only(left: 0),
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 0, 16.h),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/appbarbackground.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 12.r,
                    spreadRadius: 2.r,
                    offset: Offset(4, 0), // shadow toward the inside of page
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.campaign,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Refer & Earn',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Spread the word!\nRefer a friend and earn rewards',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  color: Color(0xFF7CAA23),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.isNotEmpty
                ? _transactions.length.clamp(0, 5)
                : 0, // Additional safety check
            itemBuilder: (context, index) {
              // Add bounds checking
              if (index >= _transactions.length) {
                return const SizedBox.shrink();
              }

              final tx = _transactions[index];

              final isIncome = tx.paymentAmount >= 0;
              final amountText = _formatAmount(
                tx.paymentAmount,
                prefix: 'KES ',
              );
              // Dummy status for now:
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
      ],
    );
  }

  Widget _buildTransactionTile(
    TransactionData tx,
    String amount,
    bool isIncome,
    String status,
    BuildContext context,
  ) {
    // Visual style to match screenshot card
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
          // Open all transactions with the same smooth animation
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
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
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
              SizedBox(width: 15.w),
              // Details
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
                    SizedBox(height: 3.h),
                    Text(
                      tx.date,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount and status
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
                  SizedBox(height: 3.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 2.5.h,
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
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

  String _formatAmount(double value, {String prefix = ''}) {
    final isNegative = value < 0;
    final abs = value.abs();
    final hasCents = abs.truncateToDouble() != abs;
    final text = hasCents ? abs.toStringAsFixed(2) : abs.toStringAsFixed(0);
    final signed = isNegative ? '-$prefix$text' : '+$prefix$text';
    return signed;
  }

  Route _createSlideUpRoute(List<TransactionData> transactions) {
    // Add null safety check
    if (transactions.isEmpty) {
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('No Transactions')),
          body: Center(child: Text('No transactions available')),
        ),
      );
    }

    return PageRouteBuilder(
      transitionDuration: const Duration(
        milliseconds: 700,
      ), // smoother & slower
      pageBuilder: (context, animation, secondaryAnimation) =>
          TransactionDetailsPage(transactions: transactions),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutCubicEmphasized; // ultra smooth, modern

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
