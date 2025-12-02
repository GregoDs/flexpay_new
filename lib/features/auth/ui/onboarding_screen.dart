import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/widgets/app_text.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ✅ Make status bar match theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // extend body behind status bar
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDarkMode ? Colors.black : Colors.white, // bottom nav bar color
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true, // ✅ allows full background behind status bar
      backgroundColor: isDarkMode ? Colors.black : ColorName.whiteColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: isDarkMode ? Colors.black : ColorName.whiteColor,
              ),
              PageView(
                physics: const ClampingScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    currentIndex = page;
                  });
                },
                controller: _pageController,
                children: <Widget>[
                  makePage(
                    image: Lottie.asset(
                      "assets/images/chamatype.json",
                      height: MediaQuery.of(context).size.height * 0.85,
                      fit: BoxFit.contain,
                    ),
                    title: 'Welcome to Lipia polepole',
                    content:
                        'Empowering customers to own products through flexible installment payments. Promote, earn, and grow!',
                  ),
                  makePage(
                    image: Lottie.asset(
                      "assets/images/onboarding2.json",
                      height: MediaQuery.of(context).size.height * 2.0,
                      fit: BoxFit.contain,
                    ),
                    title: 'Earn as you Save',
                    content:
                        'Easily start a saving plan for \nwhat you want to buy while \nearning cash rewards from us',
                  ),
                  makePage(
                    image: Lottie.asset(
                      "assets/images/chamatype.json",
                      height: MediaQuery.of(context).size.height * 0.90,
                      fit: BoxFit.contain,
                    ),
                    title: 'Save with Others',
                    content:
                        'Chama is for you, your friends & \nfamily to save in a fun and \nmotivating way \nwhile being accountable',
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 24.h,
                  left: 12.w,
                  right: 12.w,
                ),
                child: currentIndex == 2
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 360,
                            height: 57.6,
                            child: ElevatedButton(
                              onPressed: () async {
                                await SharedPreferencesHelper
                                    .setFirstLaunchDone();
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.login);
                                }
                              },
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(
                                      color: isDarkMode
                                          ? Colors.white
                                          : ColorName.primaryColor,
                                    ),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                elevation: WidgetStateProperty.all(0.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.medium(
                                    'Get Started',
                                    color: isDarkMode
                                        ? Colors.white
                                        : ColorName.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          currentIndex == 0
                              ? GestureDetector(
                                  onTap: () {
                                    _pageController.animateToPage(
                                      currentIndex + 2,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 2.4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.grey[800]
                                          : ColorName.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: AppText.medium(
                                      'Skip',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? Colors.white
                                          : ColorName.blackColor,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                currentIndex + 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 19.2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 31.2,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : ColorName.lightGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AppText.medium(
                                'Next',
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.white
                                    : ColorName.blackColor,
                              ),
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

  Widget makePage(
      {required Widget image, required String title, required String content}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: 180.h,
            child: image,
          ),
          SizedBox(
            height: 30.h,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 900),
            child: AppText.large(
              title,
              textAlign: TextAlign.center,
              color: isDarkMode ? Colors.white : ColorName.primaryColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: AppText.medium(
              content,
              textAlign: TextAlign.center,
              color: isDarkMode ? Colors.grey[300] : ColorName.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          currentIndex == 2
              ? const SizedBox()
              : Container(
                  margin: EdgeInsets.only(top: 36.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator(),
                  ),
                ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: ColorName.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}