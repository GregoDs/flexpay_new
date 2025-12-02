import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoCardsShimmer extends StatefulWidget {
  const PromoCardsShimmer({super.key});

  @override
  State<PromoCardsShimmer> createState() => _PromoCardsShimmerState();
}

class _PromoCardsShimmerState extends State<PromoCardsShimmer> {
  late final PageController _pageController;
  double _currentPage = 0.0;

  final List<Map<String, dynamic>> merchants = [
    {
      'name': 'Jaza',
       'merchant_id': '812',
        'color': const Color(0xFF761B1A)
        },
    {
      'name': 'Quickmart Supermarket',
      'merchant_id': '347',
      'color': const Color(0xFF111111),
    },
    {
      'name': 'Naivas Supermarket',
      'merchant_id': '107',
      'color': const Color(0xFFFFB020),
    },
    {
      'name': 'HotPoint Appliances',
      'merchant_id': '73',
      'color': const Color(0xFFCD0000),
    },
    {
      'name': 'Azone Supermarket',
      'merchant_id': '727',
      'color': const Color(0xFF6C63FF),
    },
    {
      'name': 'Open Wallet',
      'merchant_id': '4',
      'color': const Color(0xFF00A86B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.78, // same as main file
      initialPage: 0,
    );

    _pageController.addListener(() {
      setState(() {
        _currentPage =
            _pageController.page ?? _pageController.initialPage.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: merchants.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index.toDouble();
              });
            },
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              final color = merchant['color'] as Color;
              final bool isCurrent = index == _currentPage.round();

              // build a gradient shimmer background that mirrors the real card look
              final Color darker = _shadeColor(color, 0.85);
              final Color lighter = _shadeColor(color, 1.12);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                margin: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: isCurrent
                      ? 36.h
                      : 48.h, // exact same margins as main file
                ),
                transform: Matrix4.identity()
                  ..scale(isCurrent ? 1.0 : 0.93)
                  ..setEntry(3, 2, 0.001),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        darker.withOpacity(0.98),
                        lighter.withOpacity(0.95),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(isCurrent ? 0.35 : 0.12),
                        blurRadius: isCurrent ? 25 : 10,
                        spreadRadius: isCurrent ? 2 : 0,
                        offset: Offset(0, isCurrent ? 6 : 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      children: [
                        // subtle pattern overlaid (keeps previous look)
                        Positioned.fill(
                          child: Opacity(
                            opacity:
                                Theme.of(context).brightness == Brightness.dark
                                ? 0.04
                                : 0.06,
                            child: Container(color: Colors.white),
                          ),
                        ),
                        // content padding - exact same as main file
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 18.h,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.white.withOpacity(0.3),
                            highlightColor: Colors.white.withOpacity(0.7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // top row: merchant name + "tap to view" - exact same layout
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 18.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
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
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.24),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 12.w,
                                            height: 12.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Container(
                                            height: 12.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // Amount label + number area (bottom-left) - exact same layout
                                Container(
                                  height: 12.h,
                                  width: 60.w,
                                  margin: EdgeInsets.only(bottom: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                                Container(
                                  height: 26.h,
                                  width: 120.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // bottom right small label - exact same layout
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 12.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(6.r),
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
                ),
              );
            },
          ),
        ),

        // 🌈 Dot Indicator with dynamic color matching current card - exact same as main file
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(merchants.length, (index) {
            final bool isActive = index == _currentPage.round();
            final Color color = merchants[index]['color'] as Color;

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

  // helper to create lighter/darker shades
  Color _shadeColor(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
