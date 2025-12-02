import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
    final subTextColor =
        isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Padding(
                padding: EdgeInsets.only(top: 18.h, bottom: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.montserrat(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    _circleIcon(
                      context,
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.pop(context),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              /// Center content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/images/notification_imgs/empty.json',
                      width: 320.w,
                      height: 320.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'No notifications',
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Stay tuned! No updates at the moment,\n'
                      'but exciting news could be just around the corner.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: subTextColor,
                        height: 1.4,
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
}

Widget _circleIcon(
  BuildContext context, {
  required IconData icon,
  required VoidCallback onTap,
  required bool isDark,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 54.h,
      width: 54.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.4),
          width: 1.4,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black87,
          size: 22.sp,
        ),
      ),
    ),
  );
}