import 'package:flexpay/features/bookings/cubit/bookings_state.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/ui/booking_details.dart';
import 'package:flexpay/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flexpay/utils/widgets/web_view.dart';
import 'package:flexpay/features/home/ui/notifications_page.dart';
import 'package:flexpay/features/profile/ui/system_menu.dart';
import 'package:flexpay/features/auth/models/user_model.dart' hide User;
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flexpay/main.dart' show routeObserver;

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with RouteAware {
  String selectedTab = "active";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Only fetch if not already loaded
    final state = context.read<BookingsCubit>().state;
    if (state is! BookingsFetched || state.bookings.isEmpty) {
      context.read<BookingsCubit>().fetchBookingsByType("active");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<BookingsCubit>().fetchBookingsByType(
    selectedTab.toLowerCase(),
  );
});
  }

  void _onTabSelected(String tab) {
  setState(() => selectedTab = tab);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<BookingsCubit>().fetchBookingsByType(tab.toLowerCase());
  });
}

  Future<void> _refreshBookings() async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BookingsCubit>().fetchBookingsByType(
          selectedTab.toLowerCase(),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF23262B) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF1D3C4E);
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 22.h,
                  bottom: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          final userModel = await SharedPreferencesHelper.getUserModel();
                          if (userModel != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(userModel: userModel),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle error if needed
                          print('Error getting user model: $e');
                        }
                      },
                      child: Icon(Icons.menu, color: iconColor, size: 32.sp),
                    ),
                    Center(
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF337687),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/icon/logos/logo.png',
                          height: 40.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsPage(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.notifications_none,
                        color: iconColor,
                        size: 32.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),

              // Title + Add Bookings
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 14.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Bookings",
                      style: GoogleFonts.montserrat(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D3C4E),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WebViewPage(
                              url: "https://marketplace.flexpay.co.ke/",
                              title: "FlexPay Marketplace",
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Add Bookings",
                              style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),

              // Search + Tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F7F9),
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 18.w),
                                Icon(
                                  Icons.search,
                                  size: 24.sp,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search by booking reference",
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                    ),
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (value) {
                                      if (value.trim().isNotEmpty) {
                                        context
                                            .read<BookingsCubit>()
                                            .fetchBookingByReference(
                                              value.trim(),
                                            );
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    size: 22.sp,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      context.read<BookingsCubit>().fetchBookingsByType(
                                        selectedTab.toLowerCase(),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 18.w),
                        Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF7B53A),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Tabs
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // _BookingTab(
                            //   label: "All",
                            //   selected: selectedTab == "All",
                            //   color: selectedTab == "All"
                            //       ? const Color(0xFFF7B53A)
                            //       : const Color(0xFFF6F7F9),
                            //   textColor: selectedTab == "All"
                            //       ? Colors.white
                            //       : const Color(0xFF1D3C4E),
                            //   onTap: () => _onTabSelected("All"),
                            // ),
                            // SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Active",
                              selected: selectedTab == "active",
                              color: selectedTab == "active"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("active"),
                            ),
                            SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Overdue",
                              selected: selectedTab == "overdue",
                              color: selectedTab == "overdue"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("overdue"),
                            ),
                            SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Unpaid",
                              selected: selectedTab == "unserviced",
                              color: selectedTab == "unserviced"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("unserviced"),
                            ),
                            SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Completed",
                              selected: selectedTab == "complete",
                              color: selectedTab == "complete"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("complete"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),

              // Bookings List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshBookings,
                  color: const Color(0xFF337687),
                  child: BlocBuilder<BookingsCubit, BookingsState>(
                    builder: (context, state) {
                      if (state is BookingsLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/images/LoadingPlane.json',
                                width: 360.w,
                                height: 360.w,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        );
                      } else if (state is BookingsError) {
                        // Show snack bar with real error message
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          CustomSnackBar.showError(
                            context,
                            title: "Error",
                            message: state.message,
                          );
                          // restore current list
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<BookingsCubit>().fetchBookingsByType(
                              selectedTab.toLowerCase(),
                            );
                          });
                        });

                        // Show friendly error UI
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/images/chamatype.json',
                                width: 220.w,
                                height: 220.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "An error occurred",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is BookingsFetched) {
                        final bookings = state.bookings;
                        // Exclude permanent bookings (is_permanent == 1)
                        final filteredBookings = bookings
                            .where((b) => (b.isPermanent ?? 0) == 0)
                            .toList();

                        if (filteredBookings.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Lottie animation
                                Lottie.asset(
                                  'assets/images/notification_imgs/empty.json',
                                  height: 300,
                                  repeat: true,
                                ),
                                const SizedBox(height: 20),
                                // Text message
                                Text(
                                  "Ooops....No ${state.bookingType} bookings yet",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          cacheExtent: 0,
                          padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                          itemCount: filteredBookings.length,
                          itemBuilder: (context, index) {
                            final booking = filteredBookings[index];
                            return _BookingCard(
                              key: ValueKey(booking.id ?? index),
                              booking: booking,
                              cardColor: cardColor,
                              textColor: textColor,
                              selectedTab: selectedTab,
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final Color cardColor;
  final Color textColor;
  final String selectedTab;

  const _BookingCard({
    Key? key,
    required this.booking,
    required this.cardColor,
    required this.textColor,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<BookingsCubit>(),
              child: BookingDetailsPage(
                booking: booking,
                user: User(),
                selectedTab: selectedTab,
              ),
            ),
          ),
        ); // Only refetch if something changed
        if (result == true) {
         WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<BookingsCubit>().fetchBookingsByType(
              selectedTab.toLowerCase(),
            );
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(18.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                booking.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          "assets/images/bookings_imgs/maldivesholiday.jpeg",
                          width: 46.w,
                          height: 46.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 26.sp,
                        ),
                      ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.productName ?? "Unknown Product",
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        booking.deadlineDate != null
                            ? "Due on ${booking.deadlineDate}"
                            : "Created on ${booking.createdAt}",
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Progress bar row
                      Row(
                        children: List.generate(10, (i) {
                          double total = (booking.total ?? 0).toDouble();
                          double price = (booking.bookingPrice ?? 1).toDouble();
                          double progress = total / price;

                          // If there's any payment (total > 0), ensure minimum 1% progress
                          if (total > 0 && progress < 0.01) {
                            progress = 0.01;
                          }

                          double fill = progress * 10;

                          // Ensure at least one bar is filled when there's any payment
                          if (total > 0 && fill < 1.0) {
                            fill = 1.0;
                          }

                          bool filled = i < fill.round();

                          return Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: Container(
                              width: 16.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: filled ? Colors.green : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Right column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if ((booking.progress ?? 0) >= 1.0)
                      Icon(
                        Icons.verified,
                        color: const Color(0xFFF7B53A),
                        size: 28.sp,
                      ),
                    SizedBox(height: 8.h),
                    Text(
                      "${(() {
                        double total = (booking.total ?? 0).toDouble();
                        double price = (booking.bookingPrice ?? 1).toDouble();
                        double percentage = (total / price) * 100;

                        // If there's any payment (total > 0), ensure minimum 1%
                        if (total > 0 && percentage < 1.0) {
                          return 1;
                        }

                        return percentage.round();
                      })()}%",
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "Paid",
                      style: GoogleFonts.montserrat(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingTab extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _BookingTab({
    required this.label,
    required this.selected,
    required this.color,
    required this.textColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
