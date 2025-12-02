import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SideMenuWrapper extends StatefulWidget {
  final Widget child;
  const SideMenuWrapper({super.key, required this.child});

  static _SideMenuWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<_SideMenuWrapperState>();
  }

  @override
  _SideMenuWrapperState createState() => _SideMenuWrapperState();
}

class _SideMenuWrapperState extends State<SideMenuWrapper>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  bool get isMenuOpen => _isMenuOpen;

  final double menuWidth = 240.w; // slightly narrower

  String userName = "Miroslava Savitskaya";
  String userPhone = "+254 712 345 678";

  void toggleMenu() => setState(() => _isMenuOpen = !_isMenuOpen);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalMargin = screenHeight * 0.125; // top + bottom margin = 1/4 screen

    return Stack(
      children: [
        widget.child,

        // --- Overlay ---
        if (_isMenuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: toggleMenu,
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

        // --- Side Menu ---
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: _isMenuOpen ? 0 : -menuWidth,
          right: _isMenuOpen ? MediaQuery.of(context).size.width - menuWidth : null,
          top: verticalMargin,
          bottom: verticalMargin,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: menuWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appbarbackground.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Profile Card (Apple-inspired compact)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 0.7,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22.r,
                              backgroundColor: Colors.white.withOpacity(0.85),
                              child: const Icon(
                                CupertinoIcons.person_fill,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    userPhone,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // --- Expandable Menu Items ---
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildExpandableItem(
                          icon: CupertinoIcons.person_crop_circle,
                          title: "Profile",
                          subItems: ["Logout", "Delete Account"],
                        ),
                        _buildExpandableItem(
                          icon: CupertinoIcons.phone_circle,
                          title: "Contact Us",
                          subItems: ["Call", "+254 700 123 456"], // replace later
                        ),
                        _buildExpandableItem(
                          icon: CupertinoIcons.cart_fill,
                          title: "Open Kapu",
                          subItems: ["My Kapu"],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // --- FlexPay Logo ---
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icon/flexhomelogo.png',
                          height: 43.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Lipia Polepole",
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11.sp,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableItem({
    required IconData icon,
    required String title,
    required List<String> subItems,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: Key(title),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white54,
        tilePadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2.h),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(icon, color: Colors.white, size: 20.sp),
        children: subItems
            .map(
              (sub) => InkWell(
                onTap: () => toggleMenu(),
                child: Padding(
                  padding: EdgeInsets.only(left: 44.w, top: 4.h, bottom: 4.h),
                  child: Text(
                    sub,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}