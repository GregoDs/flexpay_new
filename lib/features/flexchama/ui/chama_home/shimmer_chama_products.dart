import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FlexChamaShimmer extends StatelessWidget {
  const FlexChamaShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSystemDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color cardColor = isSystemDarkMode ? Colors.grey[900]! : Colors.white;
    final Color baseColor = isSystemDarkMode
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    final Color highlightColor = isSystemDarkMode
        ? Colors.grey[700]!
        : Colors.grey[100]!;
    final Color textColor = isSystemDarkMode ? Colors.white : Colors.black;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Balance & Loan Limit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShimmerCard(baseColor, highlightColor, cardColor),
                _buildShimmerCard(baseColor, highlightColor, cardColor),
              ],
            ),
            SizedBox(height: 20.h),
            // Chamas card placeholder
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              height: 100.h,
              width: double.infinity,
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(color: baseColor),
              ),
            ),
            SizedBox(height: 20.h),
            // Transactions
            Text(
              'Transactions',
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            // 5 Shimmer transaction rows
            for (int i = 0; i < 5; i++)
              _buildShimmerTransactionRow(baseColor, highlightColor, cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard(
    Color baseColor,
    Color highlightColor,
    Color cardColor,
  ) {
    return Container(
      width: 160.w,
      height: 144.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 28.sp, height: 28.sp, color: baseColor),
            SizedBox(height: 10.h),
            Container(width: 80.w, height: 12.h, color: baseColor),
            SizedBox(height: 5.h),
            Container(width: 100.w, height: 18.h, color: baseColor),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTransactionRow(
    Color baseColor,
    Color highlightColor,
    Color cardColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(width: 60.w, height: 14.h, color: baseColor),
          ),
          SizedBox(width: 20.w),
          // Description shimmer
          Expanded(
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: double.infinity,
                height: 14.h,
                color: baseColor,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Amount shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(width: 50.w, height: 14.h, color: baseColor),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// Wallet Shimmer
/// =====================
class WalletShimmer extends StatelessWidget {
  const WalletShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          _rectShimmer(base, highlight, 40.w, 40.w),
          SizedBox(width: 18.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rectShimmer(base, highlight, 100.w, 14.h),
              SizedBox(height: 10.h),
              _rectShimmer(base, highlight, 160.w, 30.h),
              SizedBox(height: 10.h),
              _rectShimmer(base, highlight, 120.w, 12.h),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _circleShimmer(base, highlight, 28.w),
                  SizedBox(width: 10.w),
                  _rectShimmer(base, highlight, 160.w, 8.h),
                  SizedBox(width: 10.w),
                  _rectShimmer(base, highlight, 30.w, 12.h),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =====================
/// Chama Cards Row Shimmer
/// =====================
class ChamaCardsRowShimmer extends StatelessWidget {
  const ChamaCardsRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _rectShimmer(base, highlight, 160.w, 148.h),
        _rectShimmer(base, highlight, 160.w, 148.h),
      ],
    );
  }
}

/// =====================
/// My Chama List Shimmer
/// =====================
class MyChamaListShimmer extends StatelessWidget {
  const MyChamaListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _rectShimmer(base, highlight, 60.w, 16.h),
              SizedBox(width: 24.w),
              _rectShimmer(base, highlight, 80.w, 16.h),
            ],
          ),
          SizedBox(height: 20.h),
          _rectShimmer(base, highlight, 100.w, 14.h),
          SizedBox(height: 18.h),
          for (int i = 0; i < 3; i++) ...[
            _buildChamaListItemShimmer(base, highlight, cardColor),
            SizedBox(height: 18.h),
          ],
        ],
      ),
    );
  }
}

/// =====================
/// Our Chama List Shimmer (fixed to look like MyChamaListShimmer)
/// =====================
class OurChamaListShimmer extends StatelessWidget {
  const OurChamaListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header placeholders
          Row(
            children: [
              _rectShimmer(base, highlight, 80.w, 16.h),
              SizedBox(width: 24.w),
              _rectShimmer(base, highlight, 100.w, 16.h),
            ],
          ),
          SizedBox(height: 20.h),
          _rectShimmer(base, highlight, 120.w, 14.h),
          SizedBox(height: 18.h),

          // Placeholder list items
          for (int i = 0; i < 3; i++) ...[
            _buildChamaListItemShimmer(base, highlight, cardColor),
            SizedBox(height: 18.h),
          ],
        ],
      ),
    );
  }
}

/// =====================
/// Shared helpers
/// =====================
Widget _rectShimmer(Color base, Color highlight, double w, double h) {
  return Shimmer.fromColors(
    baseColor: base,
    highlightColor: highlight,
    child: Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(6.r),
      ),
    ),
  );
}

Widget _circleShimmer(Color base, Color highlight, double size) {
  return Shimmer.fromColors(
    baseColor: base,
    highlightColor: highlight,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.circle,
      ),
    ),
  );
}

Widget _buildChamaListItemShimmer(
    Color base, Color highlight, Color cardColor) {
  return Container(
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(22.r),
    ),
    child: Row(
      children: [
        _rectShimmer(base, highlight, 40.w, 40.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rectShimmer(base, highlight, 120.w, 16.h),
              SizedBox(height: 6.h),
              _rectShimmer(base, highlight, 100.w, 12.h),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _rectShimmer(base, highlight, 60.w, 28.h),
      ],
    ),
  );
}

Widget _buildTransactionRowShimmer(
    Color base, Color highlight, Color cardColor) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
    margin: EdgeInsets.only(bottom: 8.h),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _rectShimmer(base, highlight, 60.w, 14.h),
        SizedBox(width: 20.w),
        Expanded(
          child: _rectShimmer(base, highlight, double.infinity, 14.h),
        ),
        SizedBox(width: 10.w),
        _rectShimmer(base, highlight, 50.w, 14.h),
      ],
    ),
  );
}
