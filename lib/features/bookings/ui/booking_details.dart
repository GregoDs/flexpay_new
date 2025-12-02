import 'package:flexpay/features/bookings/ui/booking_payments.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpay/features/bookings/cubit/bookings_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flexpay/main.dart' show routeObserver;

class BookingDetailsPage extends StatefulWidget {
  final Booking booking;
  final User user;
  final String selectedTab;

  const BookingDetailsPage({
    Key? key,
    required this.booking,
    required this.user,
    required this.selectedTab,
  }) : super(key: key);

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage>
    with RouteAware {
  late Booking _booking;
  bool _isRefreshing = false;
  bool _shouldRefreshOnReturn = false;
  bool _shouldRefreshHome = false;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route observer
    final ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // // Called when coming back to this page (e.g., after popping payment modal)
    if (_shouldRefreshOnReturn) {
      _shouldRefreshOnReturn = false; // reset the flag
      _showUpdatingSnackbar();
      _fetchLatestBooking();
    }
  }

  void _showUpdatingSnackbar() {
    CustomSnackBar.showInfo(
      context,
      title: "Please Wait",
      message: "Updating booking details...",
    );
  }

  Future<void> _fetchLatestBooking() async {
    setState(() => _isRefreshing = true);
    try {
      await context.read<BookingsCubit>().fetchBookingByReference(
        _booking.bookingReference ?? "",
      );
      CustomSnackBar.showSuccess(
        context,
        title: "Updated",
        message: "Booking details refreshed successfully.",
      );

      _shouldRefreshHome = true;
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  Future<void> _onRefresh() async {
    await _fetchLatestBooking();
  }

  Future<void> _handlePayment() async {
    final result = await BookingPaymentModal.show(
      context,
      bookingName: _booking.productName ?? "",
      initialPhone: widget.user.phoneNumber1 ?? "",
      bookingReference: _booking.bookingReference ?? "",
    );

    if (result == true) {
      // ✅ Immediately show feedback & refresh
      _showUpdatingSnackbar();
      await _fetchLatestBooking();

      _shouldRefreshHome = true;
    }
  }

  String formatPaymentDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final parsedDate = DateTime.parse(dateStr);
      return DateFormat("dd-MM-yyyy").format(parsedDate); // e.g. 20-08-2025
    } catch (e) {
      return dateStr;
    }
  }

  String formatMaturityDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "No maturity set";
    try {
      final parsedDate = DateTime.parse(dateStr);
      return DateFormat("d MMM yyyy").format(parsedDate); // e.g. 23 Nov 2025
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context, _shouldRefreshHome),
          ),
          centerTitle: true,
          title: Text(
            "Booking Details",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        body: BlocConsumer<BookingsCubit, BookingsState>(
          listener: (context, state) {
            if (state is BookingsFetched && state.bookings.isNotEmpty) {
              setState(() {
                _booking = state.bookings.first;
              });
            }
          },
          builder: (context, state) {
            final isLoading = state is BookingsLoading || _isRefreshing;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: ColorName.primaryColor,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (isLoading) {
                    return Center(
                      child: SpinKitWave(
                        color: ColorName.primaryColor,
                        size: 32.sp,
                      ),
                    );
                  }
                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 86.h,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Card with booking image overlapping
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Card background
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  70.h,
                                  20.w,
                                  20.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  image: DecorationImage(
                                    image: const AssetImage(
                                      "assets/images/appbarbackground.png",
                                    ),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.6),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      _booking.productName ?? "No Booking Name",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 28.h),

                                    // Product Cost & Balance
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildRowItem(
                                          "Product Cost",
                                          "Kshs ${_booking.bookingPrice ?? 0}",
                                        ),
                                        _buildRowItem(
                                          "Balance",
                                          "Kshs ${(_booking.bookingPrice ?? 0) - (_booking.total ?? 0)}",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 14.h),

                                    // Paid & Maturity
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildRowItem(
                                          "Paid",
                                          "Kshs ${_booking.total ?? 0}",
                                        ),
                                        _buildRowItem(
                                          "Maturity",
                                          formatMaturityDate(
                                            _booking.deadlineDate,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    const Divider(
                                      thickness: 1,
                                      color: Colors.white30,
                                    ),
                                    SizedBox(height: 20.h),

                                    // Complete Booking Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorName.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14.h,
                                          ),
                                        ),
                                        onPressed: () async {
                                          await _handlePayment();
                                        },
                                        child: Text(
                                          "Make Payment",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),


                                    // Cancel Booking Button with BlocConsumer - COMMENTED OUT
                                    /*
                                    BlocConsumer<BookingsCubit, BookingsState>(
                                      listener: (context, state) {
                                        if (state is BookingCancelSuccess) {
                                          CustomSnackBar.showSuccess(
                                            context,
                                            title: "Success",
                                            message:
                                                "Booking cancelled successfully",
                                          );
                                          if (context.mounted) {
                                            Navigator.pop(
                                              context,
                                              true,
                                            ); // return true to parent
                                          }
                                        } else if (state
                                            is BookingCancelError) {
                                          CustomSnackBar.showError(
                                            context,
                                            title: "Error",
                                            message: state.message,
                                          );
                                          if (context.mounted) {
                                            Navigator.pop(context, true); // This will trigger refresh
                                          }
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state is BookingCancelLoading;

                                        return SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Colors.redAccent,
                                                width: 2,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14.h,
                                              ),
                                            ),
                                            onPressed: isLoading
                                                ? null
                                                : () {
                                                    context
                                                        .read<BookingsCubit>()
                                                        .cancelBooking(
                                                          _booking.bookingReference ??
                                                              "",
                                                        );
                                                  },
                                            child: isLoading
                                                ? SpinKitWave(
                                                    color: Colors.redAccent,
                                                    size: 24.sp,
                                                  )
                                                : Text(
                                                    "Cancel Booking",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16.sp,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    */
                                  ],
                                ),
                              ),

                              // Booking Image (overlapping top)
                              Positioned(
                                top: -60.h,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 120.w,
                                    height: 120.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      color: Colors.grey[300],
                                    ),
                                    child: ClipOval(
                                      child:
                                          _booking.image != null &&
                                              _booking.image!.isNotEmpty
                                          ? Image.network(
                                              _booking.image!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/images/bookings_imgs/maldivesholiday.jpeg",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 32.h),

                          // Payments Section
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Payments",
                              style: GoogleFonts.montserrat(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorName.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),

                          if (_booking.payments != null &&
                              _booking.payments!.isNotEmpty)
                            ..._booking.payments!.map(
                              (p) => Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(14.w),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[850]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatPaymentDate(p.createdAt),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Mobile Money Transfer",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Kshs ${p.paymentAmount}",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Text(
                              "No payments yet",
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                color: textColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
