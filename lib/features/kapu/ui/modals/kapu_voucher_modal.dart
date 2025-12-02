import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/models/kapu_shops/kapu_shops_model.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Future<bool?> showKapuCreateVoucherModalSheet(
  BuildContext context, {
  required String merchantId,
}) async {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String? selectedOutletId;

  final kapuCubit = context.read<KapuCubit>();

  // ✅ Move listener outside the builder to prevent multiple rebuild triggers
  searchController.addListener(() {
    // You can add debug prints if needed
  });

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: ColorName.primaryColor,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        child: BlocProvider.value(
          value: kapuCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            child: BlocConsumer<KapuCubit, KapuState>(
              listener: (context, state) {
                if (state is KapuVoucherSuccess) {
                  Future.delayed(const Duration(milliseconds: 600), () async {
                    await kapuCubit.fetchKapuWalletBalance(merchantId);
                  });
                  Navigator.pop(context);
                  CustomSnackBar.showSuccess(
                    context,
                    title: "Voucher Created",
                    message: "🎟️ Voucher created successfully",
                  );
                } else if (state is KapuVoucherFailure) {
                  CustomSnackBar.showError(
                    context,
                    title: "Voucher Creation Failed",
                    message: "⚠️ ${state.message}",
                    useOverlay: true,
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is KapuVoucherLoading;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Create Voucher",
                        style: GoogleFonts.montserrat(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Search for merchant, create a voucher with us now and enjoy all the Kapu benefits.",
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Search Merchants",
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // ✅ Wrapping TypeAhead in a Stateless widget to avoid rebuild issues
                      _KapuTypeAheadField(
                        searchController: searchController,
                        onSelected: (Outlet suggestion) {
                          final outletId = suggestion.id?.toString();
                          final outletName = suggestion.outletName ?? '';
                          if (outletId == null || outletId.isEmpty) {
                            CustomSnackBar.showError(
                              context,
                              title: "Invalid Outlet",
                              message: "Selected outlet is not valid.",
                            );
                            return;
                          }
                          selectedOutletId = outletId;
                          searchController.text = outletName;
                          FocusScope.of(context).unfocus();
                          CustomSnackBar.showSuccess(
                            context,
                            title: "Outlet Selected",
                            message: "🛍️ $outletName",
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Enter the amount you wish to allocate to a new Kapu voucher.",
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Quick Amounts",
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          for (final amt in [
                            "500",
                            "1000",
                            "5000",
                            "10000",
                            "20000",
                          ])
                            _amountChip(amt, () => amountController.text = amt),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.montserrat(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter voucher amount",
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.card_giftcard_outlined,
                            color: ColorName.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: ColorName.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorName.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 3,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  final parsedAmount = double.tryParse(
                                    amountController.text.trim(),
                                  );
                                  if (parsedAmount == null ||
                                      parsedAmount <= 0) {
                                    CustomSnackBar.showError(
                                      context,
                                      title: "Invalid Amount",
                                      message:
                                          "Please enter a valid voucher amount.",
                                    );
                                    return;
                                  }
                                  if (selectedOutletId == null) {
                                    CustomSnackBar.showError(
                                      context,
                                      title: "No Outlet Selected",
                                      message:
                                          "Please select an outlet before creating a voucher.",
                                    );
                                    return;
                                  }
                                  context.read<KapuCubit>().createKapuVoucher(
                                    merchantId: merchantId,
                                    outletId: selectedOutletId!,
                                    amount: parsedAmount,
                                  );
                                },
                          child: isLoading
                              ? const SpinKitWave(
                                  color: Colors.white,
                                  size: 22.0,
                                )
                              : Text(
                                  "Create Voucher",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class _KapuTypeAheadField extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(Outlet) onSelected;

  const _KapuTypeAheadField({
    required this.searchController,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final outlets = List<Outlet>.from(context.read<KapuCubit>().outletResponse?.outlets ?? []);
    return TypeAheadField<Outlet>(
      suggestionsCallback: (pattern) {
        try {
          if (outlets.isEmpty) return [];
          if (pattern.isEmpty) return outlets.take(5).toList();
          return outlets
              .where(
                (o) => (o.outletName ?? '').toLowerCase().contains(
                  pattern.toLowerCase(),
                ),
              )
              .take(5)
              .toList();
        } catch (_) {
          return [];
        }
      },
      builder: (context, controller, focusNode) {
        controller.text = searchController.text;
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: GoogleFonts.montserrat(color: Colors.black, fontSize: 14.sp),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: ColorName.primaryColor,
            ),
            hintText: "Search for an outlet",
            hintStyle: GoogleFonts.montserrat(
              color: Colors.grey[600],
              fontSize: 13.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        );
      },
      decorationBuilder: (context, child) {
        return Material(
          elevation: 6,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
        );
      },
      itemBuilder: (context, suggestion) {
        final outletName = suggestion.outletName ?? "Unknown Outlet";
        return ListTile(
          leading: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: ColorName.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.store_rounded,
              color: ColorName.primaryColor,
              size: 18,
            ),
          ),
          title: Text(
            outletName,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "double click",
            style: GoogleFonts.montserrat(
              fontSize: 11.sp,
              color: Colors.grey[600],
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
        );
      },
      onSelected: onSelected,
    );
  }
}

Widget _amountChip(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorName.primaryColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        "Ksh $label",
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ColorName.primaryColor,
        ),
      ),
    ),
  );
}
