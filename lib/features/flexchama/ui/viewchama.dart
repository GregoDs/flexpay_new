// import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
// import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
// import 'package:flexpay/features/flexchama/ui/chama_home/shimmer_chama_products.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flexpay/utils/cache/shared_preferences_helper.dart';

// class ViewChamas extends StatefulWidget {
//   const ViewChamas({super.key});

//   @override
//   State<ViewChamas> createState() => _ViewChamasState();
// }

// class _ViewChamasState extends State<ViewChamas> {
//   final primaryColor = const Color(0xFF009AC1);
//   final flexcoinBg = const Color(0xFFEFE5D2);
//   final loanBg = const Color(0xFFF1F3F6);
//   final flexcoinIconColor = const Color(0xFFF5A623);
//   final loanIconColor = const Color(0xFF6FCF97);
//   final Color textColor = const Color(0xFF1D3C4E);
//   bool _isBackPressed = false;

//   final cardShadow = [
//     BoxShadow(
//       color: Colors.black.withOpacity(0.07),
//       blurRadius: 16.r,
//       offset: Offset(0, 4.h),
//     ),
//   ];

//   bool isYearly = true;
//   int selectedChamaType = 1;

//   String myChamaCount = "_";
//   String ourChamasCount = "_";

//   // Preserve the last successful view so transient states (e.g., subscribe/save loading)
//   // do not replace the UI with a shimmer
//   ChamaViewState? _lastView;
//   bool _isBottomSheetOpen = false;

//   void _showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Center(child: SpinKitWave(color: primaryColor, size: 36)),
//     );
//   }

//   Future<void> _hideLoadingAndPopSheet({
//     Duration delay = const Duration(milliseconds: 350),
//   }) async {
//     await Future.delayed(delay);
//     // Close loading dialog (rootNavigator true because dialogs use root navigator by default here)
//     if (Navigator.of(context, rootNavigator: true).canPop()) {
//       Navigator.of(context, rootNavigator: true).pop();
//     }
//     // Pop only the bottom sheet (not the page) if it is open
//     if (_isBottomSheetOpen && Navigator.of(context).canPop()) {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // First entry: force a fresh fetch to seed cache
//     _fetchOurChamas(refreshListOnly: false, forceRefresh: true);
//   }

//   void _fetchOurChamas({
//     bool refreshListOnly = false,
//     bool forceRefresh = false,
//   }) {
//     final type = isYearly ? "yearly" : "half_yearly";
//     context.read<ChamaCubit>().fetchAllChamaDetails(
//       type: type,
//       refreshListOnly: refreshListOnly,
//       forceRefresh: forceRefresh,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: BlocConsumer<ChamaCubit, ChamaState>(
//           listener: (context, state) {
//             if (state is ChamaViewState) {
//               _lastView = state;
//               final response = state.savings;
//               if (response != null && response.errors?.isNotEmpty == true) {
//                 CustomSnackBar.showError(
//                   context,
//                   title: "Error",
//                   message: response.errors!.first.toString(),
//                 );
//               }
//             }
//             if (state is SubscribeChamaLoading ||
//                 state is SaveToChamaLoading ||
//                 state is PayChamaWalletLoading) {
//               _showLoadingDialog();
//             }
//             //Mpesa success state
//             if (state is SaveToChamaSuccess) {
//               final response = state.response;
//               final mpesaMsg =
//                   (response.messages != null && response.messages!.isNotEmpty)
//                   ? response.messages!.first
//                   : null;
//               CustomSnackBar.showSuccess(
//                 context,
//                 title: "Success",
//                 message: mpesaMsg ?? "Your savings have been updated!",
//               );
//               _hideLoadingAndPopSheet();
//               // 🔄 Trigger refetch via cubit
//               context.read<ChamaCubit>().getUserChamas();
//               _fetchOurChamas(
//                 refreshListOnly: false,
//               ); // 🔄 refresh after saving
//             }

//             //wallet success
//             if (state is PayChamaWalletSuccess) {
//               final response = state.response;
//               // Check for errors in the response, even in success state
//               if (response.errors?.isNotEmpty == true) {
//                 CustomSnackBar.showError(
//                   context,
//                   title: "Error",
//                   message: response.errors!.first,
//                 );
//               } else {
//                 CustomSnackBar.showSuccess(
//                   context,
//                   title: "Success",
//                   message:
//                       "Your savings has been updated and amount deducted from Wallet!",
//                 );
//               }
//               _hideLoadingAndPopSheet();
//               // 🔄 Trigger refetch via cubit
//               context.read<ChamaCubit>().getUserChamas();
//               _fetchOurChamas(
//                 refreshListOnly: false,
//               ); // 🔄 refresh after saving
//             }

//             if (state is SubscribeChamaSuccess) {
//               CustomSnackBar.showSuccess(
//                 context,
//                 title: "Success",
//                 message: "You joined the Chama successfully!",
//               );
//               _hideLoadingAndPopSheet();
//               _fetchOurChamas(
//                 refreshListOnly: false,
//               ); // 🔄 refresh after joining
//             }

//             // Show failures via our custom snackbar
//             if (state is SubscribeChamaFailure) {
//               CustomSnackBar.showError(
//                 context,
//                 title: "Error",
//                 message: state.message,
//               );
//               _hideLoadingAndPopSheet();
//             }

//             if (state is SaveToChamaFailure) {
//               CustomSnackBar.showError(
//                 context,
//                 title: "Error",
//                 message: state.message,
//               );
//               _hideLoadingAndPopSheet();
//             }
//             if (state is PayChamaWalletFailure) {
//               CustomSnackBar.showError(
//                 context,
//                 title: "Error",
//                 message: state.message,
//               );
//               _hideLoadingAndPopSheet();
//             }
//           },

//           builder: (context, state) {
//             // Keep rendering the last known good view while subscribe/save emits
//             final ChamaViewState? view = state is ChamaViewState
//                 ? state
//                 : _lastView;
//             if (view == null) {
//               return const FlexChamaShimmer();
//             }

//             myChamaCount = (view.userChamas?.data.length != null)
//                 ? view.userChamas!.data.length.toString()
//                 : "_";

//             ourChamasCount = (view.allProducts?.data.length != null)
//                 ? view.allProducts!.data.length.toString()
//                 : "_";

//             String totalSavings = "0";
//             String maturityDate = "_";
//             double progress = 0.0;
//             String progressText = "0%";

//             // final chamaDetails = view.savings?.data?.chamaDetails;
//             // if (chamaDetails != null) {
//             //   totalSavings = chamaDetails.totalSavings.toString();
//             //   maturityDate = chamaDetails.maturityDate;
//             //   if (chamaDetails.targetAmount > 0) {
//             //     progress =
//             //         chamaDetails.totalSavings / chamaDetails.targetAmount;
//             //     progressText = "${(progress * 100).toStringAsFixed(1)}%";
//             //   }
//             // }

//             final chamaDetails = view.savings?.data?.chamaDetails;
//             if (chamaDetails != null) {
//               // ✅ Check if totalSavings is negative (e.g., -1), treat as 0
//               final rawSavings = chamaDetails.totalSavings;
//               totalSavings = rawSavings > 0 ? rawSavings.toString() : "0";

//               maturityDate = chamaDetails.maturityDate;

//               if (chamaDetails.targetAmount > 0 && rawSavings > 0) {
//                 progress = rawSavings / chamaDetails.targetAmount;
//                 progressText = "${(progress * 100).toStringAsFixed(1)}%";
//               }
//             }

//             return RefreshIndicator(
//               onRefresh: () async {
//                 _fetchOurChamas(refreshListOnly: false, forceRefresh: true);
//               },

//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// HEADER
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                        IconButton(
//                           onPressed: () async {
//                             if (_isBackPressed) return;
//                             _isBackPressed = true;

//                             try {
//                               // Refresh parent data BEFORE pop
//                               // await context.read<ChamaCubit>().fetchChamaUserSavings();
//                             } catch (e) {
//                               debugPrint("Back refresh error: $e");
//                             } finally {
//                               if (context.mounted) {
//                                 Navigator.pop(context);
//                               }
//                               // Unlock after delay
//                               await Future.delayed(const Duration(milliseconds: 500));
//                               if (mounted) _isBackPressed = false;
//                             }
//                           },
//                           icon: Icon(Icons.arrow_back, color: textColor, size: 22.sp),
//                         ),
//                         Center(
//                           child: ColorFiltered(
//                             colorFilter: ColorFilter.mode(
//                               textColor,
//                               BlendMode.srcIn,
//                             ),
//                             child: Image.asset(
//                               'assets/icon/logos/logo.png',
//                               height: 40.h,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           Icons.notifications_none,
//                           color: textColor,
//                           size: 22.sp,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8.h),

//                     /// Wallet
//                     Text(
//                       "Wallet",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     ),
//                     SizedBox(height: 16.h),

//                     view.isWalletLoading
//                         ? const WalletShimmer()
//                         : _buildWalletCard(
//                             totalSavings,
//                             maturityDate,
//                             progress,
//                             progressText,
//                           ),

//                     SizedBox(height: 20.h),
//                     _buildCampaignCard(context),
//                     SizedBox(height: 20.h),

//                     _buildChamaCardsRow(),

//                     SizedBox(height: 24.h),

//                     /// Chamas Section
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(16.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (selectedChamaType == 2)
//                             Row(
//                               children: [
//                                 _ChamaTab(
//                                   label: "Yearly",
//                                   selected: isYearly,
//                                   onTap: () {
//                                     setState(() => isYearly = true);
//                                     // Use cache when switching tabs; no refresh
//                                     _fetchOurChamas(refreshListOnly: true);
//                                   },
//                                 ),
//                                 SizedBox(width: 20.w),
//                                 _ChamaTab(
//                                   label: "Half Yearly",
//                                   selected: !isYearly,
//                                   onTap: () {
//                                     setState(() => isYearly = false);
//                                     // Use cache when switching tabs; no refresh
//                                     _fetchOurChamas(refreshListOnly: true);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           if (selectedChamaType == 2) SizedBox(height: 12.h),

//                           Text(
//                             selectedChamaType == 1 ? "My Chama" : "Our Chamas",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 14.sp,
//                               color: const Color(0xFF3399CC),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(height: 16.h),

//                           if (selectedChamaType == 1 &&
//                               view.userChamas == null &&
//                               view.isListLoading)
//                             const MyChamaListShimmer(),
//                           if (selectedChamaType == 1 &&
//                               view.userChamas != null) ...[
//                             if (view.userChamas!.data.isEmpty)
//                               Center(
//                                 child: Text(
//                                   "You don’t have any chamas yet.",
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 14.sp,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               )
//                             else
//                               ...List.generate(view.userChamas!.data.length, (
//                                 index,
//                               ) {
//                                 final chama = view.userChamas!.data[index];
//                                 return Padding(
//                                   padding: EdgeInsets.only(bottom: 14.h),
//                                   child: _ChamaListItem(
//                                     icon: Icons.group,
//                                     title: chama.name,
//                                     savings: "KES ${chama.totalSavings}",
//                                     productId: chama.id,
//                                     onSave: () {
//                                       _showSaveToMyChamaModal(
//                                         context,
//                                         chama.id,
//                                         chama.name,
//                                         onSheetVisibility: (v) {
//                                           setState(
//                                             () => _isBottomSheetOpen = v,
//                                           );
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 );
//                               }),
//                           ],

//                           if (selectedChamaType == 2 &&
//                               view.allProducts == null &&
//                               view.isListLoading)
//                             const OurChamaListShimmer(),
//                           if (selectedChamaType == 2 &&
//                               view.allProducts != null)
//                             ...List.generate(view.allProducts!.data.length, (
//                               index,
//                             ) {
//                               final product = view.allProducts!.data[index];
//                               return Padding(
//                                 padding: EdgeInsets.only(bottom: 14.h),
//                                 child: _ChamaListItem(
//                                   icon: Icons.savings,
//                                   title: product.name,
//                                   savings: "KES ${product.targetAmount}",
//                                   productId: product.id,
//                                   onJoin: () {
//                                     _showJoinOurChamaPaymentModal(
//                                       context,
//                                       product.id,
//                                       product.name,
//                                       onSheetVisibility: (v) {
//                                         setState(() => _isBottomSheetOpen = v);
//                                       },
//                                     );
//                                   },
//                                 ),
//                               );
//                             }),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   /// ✅ Wallet card helper
//   Widget _buildWalletCard(
//     String savings,
//     String maturity,
//     double progress,
//     String progressText,
//   ) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: cardShadow,
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10.w),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE6F7FB),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Icon(
//               Icons.account_balance_wallet,
//               color: primaryColor,
//               size: 26.sp,
//             ),
//           ),
//           SizedBox(width: 14.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Savings Balance",
//                   style: GoogleFonts.montserrat(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.w600,
//                     color: primaryColor,
//                   ),
//                 ),
//                 FittedBox(
//                   child: Text(
//                     savings,
//                     style: GoogleFonts.montserrat(
//                       fontSize: 32.sp,
//                       fontWeight: FontWeight.w600,
//                       color: textColor,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "Maturity date: $maturity",
//                   style: GoogleFonts.montserrat(
//                     fontSize: 11.sp,
//                     color: textColor,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Row(
//                   children: [
//                     Container(
//                       width: 26.w,
//                       height: 26.w,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.15),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.calendar_month,
//                         color: Colors.blue,
//                         size: 16.sp,
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(4.r),
//                         child: LinearProgressIndicator(
//                           value: progress,
//                           minHeight: 6.h,
//                           backgroundColor: Colors.blue.withOpacity(0.15),
//                           valueColor: const AlwaysStoppedAnimation(Colors.blue),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Text(
//                       progressText,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ✅ Chama Cards row helper
//   Widget _buildChamaCardsRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() {
//               selectedChamaType = 1;
//               // Use cached data when toggling between My/Our chamas
//               _fetchOurChamas(refreshListOnly: true);
//             }),
//             child: _buildSelectedChamaCard(
//               FontAwesomeIcons.creditCard,
//               'My Chama',
//               myChamaCount.toString(),
//               loanIconColor,
//               textColor,
//               loanBg,
//               isSelected: selectedChamaType == 1,
//             ),
//           ),
//         ),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() {
//               selectedChamaType = 2;
//               // Use cached data when toggling between My/Our chamas
//               _fetchOurChamas(refreshListOnly: true);
//             }),
//             child: _buildSelectedChamaCard(
//               FontAwesomeIcons.handHoldingDollar,
//               'Our Chamas',
//               ourChamasCount.toString(),
//               flexcoinIconColor,
//               textColor,
//               flexcoinBg,
//               isSelected: selectedChamaType == 2,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Widget _buildCampaignCard(BuildContext context) {
//   return GestureDetector(
//     onTap: () {
//       _showCampaignModal(context);
//     },
//     child: Container(
//       padding: EdgeInsets.all(18.w),
//       decoration: BoxDecoration(
//         image: const DecorationImage(
//           image: AssetImage('assets/images/appbarbackground.png'),
//           fit: BoxFit.cover,
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.r),
//           bottomLeft: Radius.circular(20.r),
//           bottomRight: Radius.circular(20.r),
//         ),
//       ),
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(Icons.campaign, color: Colors.white, size: 28.sp),
//             SizedBox(width: 8.w),
//             Flexible(
//               child: Text(
//                 'Spread the word!\nClick to refer a friend and earn',
//                 style: GoogleFonts.montserrat(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 16.sp,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// void _showCampaignModal(BuildContext context) {
//   final chamaCubit = context.read<ChamaCubit>();
//   final TextEditingController _phoneController = TextEditingController();

//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.white,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//     ),
//     builder: (_) {
//       return BlocProvider.value(
//         value: chamaCubit,
//         child: BlocConsumer<ChamaCubit, ChamaState>(
//           listener: (context, state) {
//             if (state is ChamaReferralSuccess) {
//               CustomSnackBar.showSuccess(
//                 context,
//                 title: "Referral Sent!",
//                 message: "Your friend has been referred successfully.",
//               );
//               Navigator.pop(context);
//             } else if (state is ChamaReferralFailure) {
//               CustomSnackBar.showError(
//                 context,
//                 title: "Referral Failed",
//                 message: state.message,
//               );
//               Navigator.pop(context);
//             }
//           },

//           builder: (context, state) {
//             return Padding(
//               padding: EdgeInsets.fromLTRB(32.w, 24.h, 18.w, 24.h),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Top underline indicator
//                     Center(
//                       child: Container(
//                         width: 50.w,
//                         height: 5.h,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(3.r),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     // Animated or lively icons row
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.emoji_people,
//                             color: Colors.orange,
//                             size: 30.sp,
//                           ),
//                           SizedBox(width: 12.w),
//                           Icon(
//                             Icons.card_giftcard,
//                             color: Colors.blue,
//                             size: 30.sp,
//                           ),
//                           SizedBox(width: 12.w),
//                           Icon(Icons.star, color: Colors.amber, size: 30.sp),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 18.h),
//                     // Title
//                     Center(
//                       child: Text(
//                         'Refer & Earn',
//                         style: GoogleFonts.montserrat(
//                           fontSize: 22.sp,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF1D3C4E),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 6.h),
//                     // Subtitle
//                     Text(
//                       'Share the love—get KES 100 when your friend tops up KES 500!',
//                       style: GoogleFonts.montserrat(
//                         fontSize: 14.sp,
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     SizedBox(height: 26.h),
//                     // Phone Number Label
//                     Text(
//                       "Phone Number",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     // Phone Number Input
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF3F4F6),
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 18.w),
//                       child: TextField(
//                         controller: _phoneController,
//                         style: GoogleFonts.montserrat(
//                           fontSize: 15.sp,
//                           color: Colors.black,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: "Enter Phone number",
//                           border: InputBorder.none,
//                           hintStyle: GoogleFonts.montserrat(
//                             color: Colors.grey[500],
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                         keyboardType: TextInputType.phone,
//                       ),
//                     ),
//                     SizedBox(height: 22.h),
//                     // Refer Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52.h,
//                       child: ElevatedButton(
//                         onPressed: state is ChamaReferralLoading
//                             ? null
//                             : () {
//                                 final phone = _phoneController.text.trim();
//                                 if (phone.isNotEmpty) {
//                                   context.read<ChamaCubit>().makeReferral(
//                                     phone,
//                                   );
//                                 }
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF337687),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: state is ChamaReferralLoading
//                             ? SizedBox(
//                                 height: 22.sp,
//                                 width: 22.sp,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : Text(
//                                 "Refer",
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     SizedBox(height: 24.h),
//                     Divider(thickness: 1, color: Colors.grey[300]),
//                     SizedBox(height: 10.h),
//                     // Referral Rewards Section
//                     Text(
//                       "My Referral Rewards",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1D3C4E),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     _referralRow("Friends Joined", "50"),
//                     _referralRow("Total Earned", "Kes 5,000"),
//                     _referralRow("Amount Used", "Kes 250"),
//                     _referralRow("Current Balance", "Kes 4,750"),
//                     SizedBox(height: 10.h),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }

// Widget _referralRow(String label, String value) {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 4.h),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.montserrat(
//             fontSize: 15.sp,
//             color: Colors.grey[800],
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         Text(
//           value,
//           style: GoogleFonts.montserrat(
//             fontSize: 15.sp,
//             color: Colors.grey[800],
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void _showJoinOurChamaPaymentModal(
//   BuildContext parentContext,
//   int productId,
//   String chamaName, {
//   ValueChanged<bool>? onSheetVisibility,
// }) {
//   onSheetVisibility?.call(true);
//   showModalBottomSheet(
//     context: parentContext,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (modalContext) {
//       final depositController = TextEditingController();

//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(modalContext).viewInsets.bottom,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // === Top header with gradient ===
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF337687), Color(0xFF1D3C4E)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.account_balance_wallet,
//                       size: 40.sp,
//                       color: Colors.white,
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       "Join $chamaName",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       "Enter your initial deposit to subscribe",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 14.sp,
//                         color: Colors.white70,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),

//               // === Content section ===
//               Padding(
//                 padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Deposit Amount",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     SizedBox(height: 10.h),

//                     // Deposit field
//                     TextField(
//                       controller: depositController,
//                       keyboardType: TextInputType.number,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 15.sp,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: const Color(0xFFF3F4F6),
//                         prefixIcon: Icon(
//                           Icons.currency_exchange,
//                           color: Colors.blue[800],
//                         ),
//                         hintText: "Enter amount",
//                         hintStyle: GoogleFonts.montserrat(
//                           color: Colors.grey[500],
//                           fontSize: 15.sp,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 24.h),

//                     // Action button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52.h,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           final deposit = double.tryParse(
//                             depositController.text.trim(),
//                           );
//                           if (deposit == null || deposit <= 0) {
//                             ScaffoldMessenger.of(modalContext).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Please enter a valid deposit"),
//                               ),
//                             );
//                             return;
//                           }

//                           parentContext.read<ChamaCubit>().subscribeToChama(
//                             productId: productId,
//                             depositAmount: deposit,
//                           );
//                           Navigator.pop(modalContext);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF337687),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: Text(
//                           "Join Chama",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),

//                     // Secure note
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.lock, size: 16.sp, color: Colors.grey[600]),
//                         SizedBox(width: 6.w),
//                         Text(
//                           "Your deposit is secure",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 13.sp,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // === Footer ===
//               Padding(
//                 padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
//                 child: Text(
//                   "Powered by FlexPay",
//                   style: GoogleFonts.montserrat(
//                     fontSize: 12.sp,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   ).whenComplete(() {
//     onSheetVisibility?.call(false);
//   });
// }

// Future<void> _showSaveToMyChamaModal(
//   BuildContext parentContext,
//   int productId,
//   String chamaName, {
//   ValueChanged<bool>? onSheetVisibility,
// }) async {
//   final amountController = TextEditingController();
//   String selectedSource = "M-Pesa";

//   // Fetch phone number from backend (SharedPreferences)
//   final userModel = await SharedPreferencesHelper.getUserModel();
//   final backendPhone = userModel?.user.phoneNumber ?? "";
//   final phoneController = TextEditingController(text: backendPhone);

//   onSheetVisibility?.call(true);
//   showModalBottomSheet(
//     context: parentContext,
//     backgroundColor: Colors.white,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // === Header with gradient ===
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       vertical: 22.h,
//                       horizontal: 16.w,
//                     ),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF009AC1), Color(0xFF1D3C4E)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(Icons.savings, size: 40.sp, color: Colors.white),
//                         SizedBox(height: 8.h),
//                         Text(
//                           "Save to $chamaName",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           "Choose source and enter details to save",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 14.sp,
//                             color: Colors.white70,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),

//                   // === Body ===
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Payment Method section
//                         Text(
//                           "Payment Method",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                         SizedBox(height: 2.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             PaymentOptionCard(
//                               imagePath:
//                                   "assets/images/payment_platform/mpesa_img.png",
//                               label: "M-Pesa",
//                               isSelected: selectedSource == "M-Pesa",
//                               onTap: () =>
//                                   setState(() => selectedSource = "M-Pesa"),
//                             ),
//                             PaymentOptionCard(
//                               imagePath:
//                                   "assets/images/payment_platform/wallet_img.webp",
//                               label: "Wallet",
//                               isSelected: selectedSource == "Wallet",
//                               onTap: () =>
//                                   setState(() => selectedSource = "Wallet"),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16.h),

//                         // Phone number field (read-only)
//                         Text(
//                           "Phone Number",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         TextField(
//                           controller: phoneController,
//                           style: GoogleFonts.montserrat(
//                             fontSize: 15.sp,
//                             color: Colors.black,
//                           ),
//                           keyboardType: TextInputType.phone,
//                           enabled: false, // Make field non-editable
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: const Color(0xFFF3F4F6),
//                             prefixIcon: Icon(
//                               Icons.phone,
//                               color: Colors.blue[800],
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16.h),

//                         // Amount field
//                         Text(
//                           "Amount",
//                           style: GoogleFonts.montserrat(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         TextField(
//                           controller: amountController,
//                           style: GoogleFonts.montserrat(
//                             fontSize: 15.sp,
//                             color: Colors.black,
//                           ),
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: const Color(0xFFF3F4F6),
//                             prefixIcon: Icon(
//                               Icons.currency_exchange,
//                               color: Colors.blue[800],
//                             ),
//                             hintText: "Enter amount",
//                             hintStyle: GoogleFonts.montserrat(
//                               color: Colors.grey[500],
//                               fontSize: 15.sp,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 24.h),

//                         // Save button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 52.h,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               final amount = double.tryParse(
//                                 amountController.text.trim(),
//                               );
//                               // Always use backendPhone for the request
//                               final phoneNumber = backendPhone;

//                               if (amount == null || amount <= 0) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Enter valid amount"),
//                                   ),
//                                 );
//                                 return;
//                               }
//                               if (phoneNumber.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Phone number not found"),
//                                   ),
//                                 );
//                                 return;
//                               }

//                               if (selectedSource == "M-Pesa") {
//                                 // 👉 Call Mpesa-specific Cubit
//                                 parentContext
//                                     .read<ChamaCubit>()
//                                     .saveToChamaMpesa(
//                                       productId: productId,
//                                       amount: amount,
//                                     );
//                               } else if (selectedSource == "Wallet") {
//                                 parentContext
//                                     .read<ChamaCubit>()
//                                     .payChamaViaWallet(
//                                       productId: productId,
//                                       amount: amount,
//                                     );
//                               }

//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF009AC1),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(24),
//                               ),
//                               elevation: 2,
//                             ),
//                             child: Text(
//                               "Save",
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16.h),

//                         // Secure note
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.lock,
//                               size: 16.sp,
//                               color: Colors.grey[600],
//                             ),
//                             SizedBox(width: 6.w),
//                             Text(
//                               "Transactions are encrypted",
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 13.sp,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Footer
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
//                     child: Text(
//                       "Powered by FlexPay",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 12.sp,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   ).whenComplete(() {
//     onSheetVisibility?.call(false);
//   });
// }

// class PaymentOptionCard extends StatelessWidget {
//   final String imagePath;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const PaymentOptionCard({
//     Key? key,
//     required this.imagePath,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           margin: EdgeInsets.symmetric(horizontal: 8.w),
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),

//             // ✅ Only add border if selected
//             border: isSelected
//                 ? Border.all(color: Colors.amber, width: 2.5)
//                 : null,

//             // ✅ Only add shadow if selected
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: Colors.amber.withOpacity(0.4),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                 : [],
//           ),
//           child: AnimatedScale(
//             scale: isSelected ? 1.05 : 1.0,
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.easeInOut,
//             child: Column(
//               children: [
//                 Image.asset(imagePath, width: 75.w, height: 85.w),
//                 SizedBox(height: 6.h),
//                 Text(
//                   label,
//                   style: GoogleFonts.montserrat(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: isSelected ? Colors.amber[800] : Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildSelectedChamaCard(
//   IconData icon,
//   String title,
//   String amount,
//   Color iconColor,
//   Color textColor,
//   Color cardColor, {
//   bool isSelected = false,
// }) {
//   return Container(
//     width: 160.w,
//     height: 158.h,
//     padding: EdgeInsets.all(16.0.w),
//     decoration: BoxDecoration(
//       color: cardColor,
//       borderRadius: BorderRadius.circular(20.r),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           spreadRadius: 2,
//           blurRadius: 8,
//         ),
//       ],
//       border: isSelected ? Border.all(color: Colors.amber, width: 3) : null,
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: iconColor, size: 24.sp),
//         SizedBox(height: 10.h),
//         Text(
//           title,
//           style: GoogleFonts.montserrat(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.bold,
//             color: textColor,
//           ),
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           amount,
//           style: GoogleFonts.montserrat(
//             fontSize: 22.sp,
//             fontWeight: FontWeight.w600,
//             color: textColor,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class _ChamaTab extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _ChamaTab({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.montserrat(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//               color: selected ? const Color(0xFF3399CC) : Colors.grey[500],
//             ),
//           ),
//           SizedBox(height: 4.h),
//           if (selected)
//             Container(
//               width: 48.w,
//               height: 6.h,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF3399CC),
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _ChamaListItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String savings;
//   final int productId;
//   final VoidCallback? onSave; // NEW
//   final VoidCallback? onJoin; // NEW

//   const _ChamaListItem({
//     required this.icon,
//     required this.title,
//     required this.savings,
//     required this.productId,
//     this.onSave,
//     this.onJoin,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               margin: EdgeInsets.only(right: 12.w),
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE6F7FB),
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               child: Icon(icon, color: const Color(0xFF3399CC), size: 28.sp),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.montserrat(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Total Savings: $savings",
//                     style: GoogleFonts.montserrat(
//                       fontSize: 12.sp,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 90.w,
//               height: 44.h,
//               child: ElevatedButton(
//                 onPressed:
//                     onSave ??
//                     onJoin ??
//                     () {
//                       _showJoinOurChamaPaymentModal(context, productId, title);
//                     },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4CA0C6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(22.r),
//                   ),
//                   elevation: 0,
//                   padding: EdgeInsets.zero,
//                 ),
//                 child: Text(
//                   onSave != null ? "Save" : "Join",
//                   style: GoogleFonts.montserrat(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: 18.h),
//           child: Divider(color: Colors.grey[300], thickness: 1, height: 1),
//         ),
//       ],
//     );
//   }
// }
