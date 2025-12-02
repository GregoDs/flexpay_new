import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

class CustomerServicePage extends StatelessWidget {
  final UserModel userModel;

  const CustomerServicePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _callNumber() async {
    // const phoneNumber = '+254759687055';
    const phoneNumber = '+254719725060';
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final backgroundColor = isDark ? Colors.black : Colors.grey[50]!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 68, 89),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Customer Service',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 40), // placeholder for alignment
                ],
              ),
            ),

            // Profile Header (reuse style)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                children: [
                  SizedBox(width: 32.w),
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 31, 68, 89),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Icon(Icons.headset_mic, color: Colors.white, size: 40),
                  ),
                  SizedBox(width: 24.w),
                  Text(
                    'We’re here to help!',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    Text(
                      'Contact Options',
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildContactTile(
                      context,
                      icon: Icons.phone,
                      title: 'Call Customer Care',
                      subtitle: 'Call us through mobile',
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: _callNumber,
                    ),
                    SizedBox(height: 12.h),

                    _buildContactTile(
                      context,
                      icon: Icons.message,
                      title: 'Chat on WhatsApp',
                      subtitle: 'Open WhatsApp Support',
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () => _launchURL('https://wa.me/254759687055'),
                    ),
                    SizedBox(height: 12.h),

                    // _buildContactTile(
                    //   context,
                    //   icon: Icons.camera_alt_outlined,
                    //   title: 'Instagram',
                    //   subtitle: '@flexpay_placeholder',
                    //   cardColor: cardColor,
                    //   textColor: textColor,
                    //   onTap: () => _launchURL('https://instagram.com/flexpay_placeholder'),
                    // ),
                    // SizedBox(height: 12.h),

                    // _buildContactTile(
                    //   context,
                    //   icon: Icons.alternate_email_outlined,
                    //   title: 'Twitter (X)',
                    //   subtitle: '@flexpay_placeholder',
                    //   cardColor: cardColor,
                    //   textColor: textColor,
                    //   onTap: () => _launchURL('https://twitter.com/flexpay_placeholder'),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0D4C92).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: const Color(0xFF0D4C92), size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey, size: 24.sp),
          ],
        ),
      ),
    );
  }
}