import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChamaShimmer extends StatelessWidget {
  final bool isDark;
  const ChamaShimmer({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Balance Card
          Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(height: 20.h),

          // 🔹 Selection Cards Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRectCard(baseColor),
              _buildRectCard(baseColor),
            ],
          ),
          SizedBox(height: 20.h),

          // 🔹 Section Title
          Container(
            width: 150.w,
            height: 20.h,
            color: baseColor,
          ),
          SizedBox(height: 10.h),
          Container(
            width: 220.w,
            height: 14.h,
            color: baseColor,
          ),
          SizedBox(height: 20.h),

          // 🔹 List of Chamas (3 shimmer items)
          for (int i = 0; i < 3; i++) ...[
            _buildChamaListItem(baseColor),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }

  Widget _buildRectCard(Color color) {
    return Container(
      width: 150.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  Widget _buildChamaListItem(Color color) {
    return Container(
      height: 110.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 100.h,
            height: 100.h,
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          // Text placeholders
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 160.w, height: 16.h, color: color),
                  SizedBox(height: 6.h),
                  Container(width: 100.w, height: 14.h, color: color),
                  SizedBox(height: 10.h),
                  Container(width: double.infinity, height: 6.h, color: color),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 80.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
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
}