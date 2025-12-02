import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReferFriendPage extends StatefulWidget {
  const ReferFriendPage({super.key});

  @override
  State<ReferFriendPage> createState() => _ReferFriendPageState();
}

class _ReferFriendPageState extends State<ReferFriendPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// Validate phone number format
  String? _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return "Please enter a phone number";

    // Remove any spaces or special characters
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check for valid formats: 07XXXXXXXX, 01XXXXXXXX, or 2547XXXXXXXX
    if (cleanPhone.length == 10) {
      if (cleanPhone.startsWith('07') || cleanPhone.startsWith('01')) {
        return null; // Valid format
      } else {
        return "Phone number must start with 07 or 01";
      }
    } else if (cleanPhone.length == 12 && cleanPhone.startsWith('254')) {
      final localPart = cleanPhone.substring(3);
      if (localPart.startsWith('7') || localPart.startsWith('1')) {
        return null; // Valid format
      } else {
        return "Invalid format. Use 2547XXXXXXXX or 2541XXXXXXXX";
      }
    } else {
      return "Use format: 07XXXXXXXX, 01XXXXXXXX, or 2547XXXXXXXX";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1113) : const Color(0xFFF5F7FA);

    final headlineStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      fontSize: 22.sp,
      color: isDark ? Colors.white : const Color(0xFF1D3C4E),
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Refer a Friend", style: headlineStyle),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeReferralSuccess) {
            CustomSnackBar.showSuccess(
              context,
              title: "Referral Sent!",
              message: "Your friend has been referred successfully.",
            );
            _phoneController.clear();
          } else if (state is HomeReferralFailure) {
            // Extract clean error message from the exception
            String errorMessage = state.message;

            // Remove "Exception: " prefix if present
            if (errorMessage.startsWith('Exception: ')) {
              errorMessage = errorMessage.substring('Exception: '.length);
            }

            // If the error is still a stringified object, try to parse it
            if (errorMessage.startsWith('{') && errorMessage.endsWith('}')) {
              try {
                // Try to extract just the message part from the object string
                final messageMatch = RegExp(
                  r'message:\s*([^,}]+)',
                ).firstMatch(errorMessage);
                if (messageMatch != null) {
                  errorMessage = messageMatch.group(1)?.trim() ?? errorMessage;
                  // Remove any quotes around the message
                  if (errorMessage.startsWith('"') &&
                      errorMessage.endsWith('"')) {
                    errorMessage = errorMessage.substring(
                      1,
                      errorMessage.length - 1,
                    );
                  }
                }
              } catch (e) {
                // If parsing fails, use a generic message
                errorMessage =
                    "An error occurred while processing your request";
              }
            }

            CustomSnackBar.showError(
              context,
              title: "Referral Failed",
              message: errorMessage,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is HomeReferralLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🌈 Gradient Header — matching the promo cards
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 28.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF337687), Color(0xFF154F63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF337687).withOpacity(0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Spread the Word!",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Invite your friends to FlexPay and earn KES 100 when they top up KES 500.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withOpacity(0.92),
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // 💬 decorative row — matches Kapu “swipe to view more”
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _iconCircle(
                      Icons.emoji_people_rounded,
                      Colors.orangeAccent,
                    ),
                    SizedBox(width: 16.w),
                    _iconCircle(Icons.card_giftcard, Colors.blueAccent),
                    SizedBox(width: 16.w),
                    _iconCircle(Icons.star_rounded, Colors.amber),
                  ],
                ),

                SizedBox(height: 34.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Friend’s Phone Number",
                    style: GoogleFonts.montserrat(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : const Color(0xFF1D3C4E),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // 📱 input field styled like modern rounded promo boxes
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: TextField(
                    controller: _phoneController,
                    style: GoogleFonts.montserrat(
                      fontSize: 15.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.grey[500],
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 26.h),

                // 🎁 refer button — same tone as gradient header
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final phone = _phoneController.text.trim();

                            // Validate phone number format
                            final validationError = _validatePhoneNumber(phone);
                            if (validationError != null) {
                              CustomSnackBar.showWarning(
                                context,
                                title: "Invalid Phone Number",
                                message: validationError,
                              );
                              return;
                            }

                            context.read<HomeCubit>().makeReferral(phone);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF337687),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SpinKitWave(color: Colors.white, size: 28.sp)
                        : Text(
                            "Send Referral",
                            style: GoogleFonts.montserrat(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 36.h),

                // 🌟 bottom mini note
                Text(
                  "Earn more when more friends join!",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28.sp),
    );
  }
}
