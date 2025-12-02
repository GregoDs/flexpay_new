import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

class PersonalInformationPage extends StatelessWidget {
  final UserModel userModel;

  const PersonalInformationPage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

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

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Personal Information',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:  const Color.fromARGB(255, 31, 68, 89),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(userModel.user.firstName, userModel.user.lastName),
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: MediaQuery.of(context).size.width / 2 - 80.w,
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

            // 🔶 Scrollable Info Container
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
                      'Account Details',
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // 🧾 Info Fields (Styled Cards)
                    _buildInfoCard(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: '${userModel.user.firstName} ${userModel.user.lastName}',
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    SizedBox(height: 12.h),

                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: userModel.user.phoneNumber,
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    SizedBox(height: 12.h),

                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: userModel.user.email,
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    SizedBox(height: 12.h),

                    _buildInfoCard(
                      icon: Icons.cake_outlined,
                      label: 'Date of Birth',
                      value: userModel.user.dob ?? 'Not provided',
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    SizedBox(height: 12.h),

                    if (userModel.user.idNumber != null && userModel.user.idNumber!.isNotEmpty)
                      _buildInfoCard(
                        icon: Icons.badge_outlined,
                        label: 'ID Number',
                        value: userModel.user.idNumber!,
                        cardColor: cardColor,
                        textColor: textColor,
                      ),

                    SizedBox(height: 24.h),

                    // 🟢 Account Status Card
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
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: (userModel.user.isVerifiedBool
                                      ? Colors.green
                                      : Colors.orange)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              userModel.user.isVerifiedBool
                                  ? Icons.verified_user
                                  : Icons.pending,
                              size: 24.sp,
                              color: userModel.user.isVerifiedBool
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Status',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                userModel.user.isVerifiedBool
                                    ? 'Verified'
                                    : 'Pending Verification',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // // 🔘 Edit Profile Button (consistent with FlexPay blue)
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton.icon(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF0D4C92),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.r),
                    //       ),
                    //       padding: EdgeInsets.symmetric(vertical: 14.h),
                    //     ),
                    //     onPressed: () {
                    //       // TODO: Navigate to Edit Profile
                    //     },
                    //     icon: Icon(
                    //       Icons.edit,
                    //       color: Colors.white,
                    //       size: 20.sp,
                    //     ),
                    //     label: Text(
                    //       'Edit Profile',
                    //       style: GoogleFonts.montserrat(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16.sp,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Reusable card builder (same rounded style as ProfilePage tiles)
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
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
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
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