import 'dart:async';

import 'package:flexpay/utils/widgets/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flexpay/features/merchants/cubits/merchant_state.dart';
import 'package:flexpay/features/merchants/cubits/merchant_cubit.dart';

class MerchantsScreen extends StatefulWidget {
  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  final Set<int> favoriteIndices = {};
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredMerchants = [];
  Timer? _debounce;

  final Map<String, String> localMerchantImages = {
    "Smart Devices": "assets/merchantspageimg/Smartdevices.png",
    "Moko": "assets/merchantspageimg/Moko.png",
    "Leviticus": "assets/merchantspageimg/Leviticus.png",
    "Patabay": "assets/merchantspageimg/Patabay.png",
    "Compland company": "assets/merchantspageimg/Compland.png",
    "Hotpoint Appliances Ltd": "assets/merchantspageimg/Hotpoint.png",
    "Electromart Kenya": "assets/merchantspageimg/Electromart.png",
    "Naivas Supermarket": "assets/merchantspageimg/Naivas.png",
    "ZuriMall Limited": "assets/merchantspageimg/Zurimall.png",
    "Quickmart Supermarket": "assets/merchantspageimg/Quickmart.png",
    "Citywalk Limited": "assets/merchantspageimg/Citywalk.png",
  };

  @override
  void initState() {
    super.initState();
    context.read<MerchantsCubit>().fetchMerchants("all");
  }

  @override
  void dispose() {
    _debounce?.cancel(); // cancel debounce when widget disposes
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, List merchants) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // wait 300ms after user stops typing
      _filterMerchants(query, merchants);
    });
  }

  void _filterMerchants(String query, List merchants) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredMerchants = merchants
          .where(
            (merchant) =>
                merchant.merchantName != null &&
                merchant.merchantName!.toLowerCase().contains(lowerQuery),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color inputBg = isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF6F7F9);
    final Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.black54;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black)
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                Center(
                  child: Image.asset(
                    'assets/icon/logos/logo.png',
                    height: 60.h,
                    color: isDarkMode ? Colors.white : const Color(0xFF337687),
                    fit: BoxFit.contain,
                  ),
                ),

                _buildWelcomeSection(isDarkMode),

                // 🔍 Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 18.w),
                              Icon(
                                Icons.search,
                                size: 26.sp,
                                color: subTextColor,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (query) {
                                    final state = context
                                        .read<MerchantsCubit>()
                                        .state;
                                    if (state is MerchantsFetched) {
                                      _filterMerchants(
                                        query,
                                        state.merchants ?? [],
                                      );
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: "Search for a merchant...",
                                    hintStyle: GoogleFonts.montserrat(
                                      fontSize: 16.sp,
                                      color: subTextColor,
                                    ),
                                  ),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.sp,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 18.w),
                      Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7B53A),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🛍 Merchants grid
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: BlocBuilder<MerchantsCubit, MerchantsState>(
                    builder: (context, state) {
                      if (state is MerchantsLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/images/LoadingPlane.json',
                                width: 360.w,
                                height: 360.w,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        );
                      } else if (state is MerchantsError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else if (state is MerchantsFetched) {
                        final merchants =
                            (_searchController.text.isEmpty
                                ? state.merchants
                                : _filteredMerchants) ??
                            [];

                        if (merchants.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/images/notification_imgs/empty.json',
                                  width: 360.w,
                                  height: 360.w,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "No merchants found",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.sp,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          key: ValueKey(merchants.length),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 25,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: merchants.length,
                          itemBuilder: (context, index) {
                            if (index >= merchants.length)
                              return const SizedBox();
                            final merchant = merchants[index];
                            final imagePath =
                                localMerchantImages[merchant.merchantName ??
                                    ""] ??
                                "assets/merchantspageimg/default.png";

                            return MerchantCard(
                              name: merchant.merchantName ?? "Unknown",
                              link: merchant.websiteUrl ?? "",
                              imageUrl: imagePath,
                              isDarkMode: isDarkMode,
                              isFavorite: favoriteIndices.contains(index),
                              onFavoriteToggle: () {
                                setState(() {
                                  favoriteIndices.contains(index)
                                      ? favoriteIndices.remove(index)
                                      : favoriteIndices.add(index);
                                });
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🟡 WELCOME SECTION
Widget _buildWelcomeSection(bool isDarkMode) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Text(
              "Save polepole",
              style: GoogleFonts.montserrat(
                fontSize: 26.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 64.w,
                height: 4.h,
                color: const Color(0xFFF7B53A),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          'You can save with us through these merchants:',
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

// 🟢 MERCHANT CARD
class MerchantCard extends StatelessWidget {
  final String name;
  final String link;
  final String imageUrl;
  final bool isDarkMode;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final String location;
  final String rating;

  const MerchantCard({
    required this.name,
    required this.link,
    required this.imageUrl,
    required this.isDarkMode,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.location = "Kenya",
    this.rating = "4k",
    Key? key,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;

    return GestureDetector(
      onTap: () {
        if (link.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewPage(url: link, title: name),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: cardColor,
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Image.asset(
                imageUrl,
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Heart button
            Positioned(
              top: 10.h,
              right: 10.w,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: cardColor,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18.sp,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFFF7B53A) : subTextColor,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ),
            ),

            // Arrow button
            Positioned(
              bottom: 52.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA0C6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.arrow_outward,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),

            // Bottom info
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(18.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 13.sp,
                                color: subTextColor,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                location,
                                style: GoogleFonts.montserrat(
                                  fontSize: 11.sp,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFF7B53A),
                          size: 15.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          rating,
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
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
}
