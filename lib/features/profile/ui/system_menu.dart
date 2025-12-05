import 'package:flexpay/features/profile/ui/customer_care.dart';
import 'package:flexpay/features/profile/ui/personal_information.dart';
import 'package:flexpay/features/home/ui/notifications_page.dart';
import 'package:flexpay/features/profile/ui/refer_friend.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/widgets/theme_toggle_widget.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _appVersion = 'Unknown';
      });
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
                    'Profile',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              'https://flagcdn.com/w40/ke.png',
                              width: 24.w,
                              height: 16.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 24.w,
                                  height: 16.h,
                                  color: Colors.red,
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'EN',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Profile Avatar and Name
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                children: [
                  SizedBox(width: 32.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInformationPage(
                            userModel: widget.userModel,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 31, 68, 89),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(
                                widget.userModel.user.firstName,
                                widget.userModel.user.lastName,
                              ),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50.r),
                                bottomRight: Radius.circular(50.r),
                              ),
                            ),
                            child: Text(
                              '100%',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16.sp,
                              color: const Color(0xFF0D4C92),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Text(
                    '${widget.userModel.user.firstName} ${widget.userModel.user.lastName}',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Scrollable Content
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
                      'Account Settings',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ✅ PERSONAL INFORMATION TILE
                    _buildListTile(
                      context,
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInformationPage(
                              userModel: widget.userModel,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12.h),

                    // ✅ Support Section
                    Text(
                      'Support',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Add Refer a Friend Button
                    _buildListTile(
                      context,
                      icon: Icons.share,
                      title: 'Refer a Friend',
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReferFriendPage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 12.h),

                    _buildListTile(
                      context,
                      icon: Icons.headset_mic_outlined,
                      title: 'Customer Service',
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerServicePage(
                              userModel: widget.userModel,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24.h),

                    Text(
                      'Preferences',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Theme Toggle
                    Container(
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
                      child: const ThemeToggleWidget(padding: EdgeInsets.zero),
                    ),

                    SizedBox(height: 12.h),

                    _buildListTile(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      cardColor: cardColor,
                      textColor: textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsPage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 12.h),

                    _buildListTile(
                      context,
                      icon: Icons.logout,
                      title: 'Log Out',
                      cardColor: cardColor,
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Version Information
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Version: $_appVersion',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'FlexPay Technologies',
                            style: GoogleFonts.montserrat(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: textColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color cardColor,
    required Color textColor,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    VoidCallback? onTap,
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
                color: (iconColor ?? const Color(0xFF0D4C92)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: iconColor ?? const Color(0xFF0D4C92),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: iconColor ?? textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, size: 24.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Log Out',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                context.read<ChamaCubit>().clearUserData();
                context
                    .read<HomeCubit>()
                    .clearUserData(); // Added: reset home cubit
              } catch (e) {}

              await SharedPreferencesHelper.clearUserModel();
              await SharedPreferencesHelper.clearBookings();

              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.montserrat(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    return initials.isEmpty ? 'U' : initials;
  }
}
