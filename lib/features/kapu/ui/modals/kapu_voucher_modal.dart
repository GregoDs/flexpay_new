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
  
  // ✅ Ensure outlets are fetched when modal opens
  if (kapuCubit.outletResponse?.outlets == null || 
      kapuCubit.outletResponse!.outlets!.isEmpty) {
    await kapuCubit.fetchKapuShops(merchantId);
  }

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
            child: StatefulBuilder(
              builder: (context, setState) {
                return BlocConsumer<KapuCubit, KapuState>(
                  listener: (context, state) {
                    if (state is KapuVoucherSuccess) {
                      Future.delayed(
                        const Duration(milliseconds: 600),
                        () async {
                          await kapuCubit.fetchKapuWalletBalance(merchantId);
                        },
                      );

                      Navigator.pop(context, true);
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Voucher Created",
                        message: "🎟️ Voucher created successfully",
                      );
                    } else if (state is KapuVoucherFailure) {
                      Navigator.pop(context, false);
                      CustomSnackBar.showError(
                        context,
                        title: "Voucher Creation Failed",
                        message: "⚠️ ${state.message}",
                      );
                    }
                    // ✅ Update local state when shops are fetched
                    else if (state is KapuShopsFetched) {
                      setState(() {
                        // Trigger rebuild to show outlets in TypeAheadField
                      });
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is KapuVoucherLoading;
                    final isLoadingShops = state is KapuShopsLoading;

                    // ✅ Get outlets from cubit
                    final outlets = context.read<KapuCubit>().outletResponse?.outlets ?? [];

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

                          // ✅ Show loading indicator when fetching shops
                          if (isLoadingShops)
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SpinKitWave(
                                      color: ColorName.primaryColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      "Loading outlets...",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // ✅ Updated TypeAheadField with proper outlets access
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.12),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TypeAheadField<Outlet>(
                              controller: searchController, // ✅ Add missing controller
                              suggestionsCallback: (pattern) {
                                // ✅ Use the outlets from the current context
                                debugPrint('🔍 Available outlets: ${outlets.length}');
                                debugPrint('🔍 Search pattern: "$pattern"');
                                
                                if (outlets.isEmpty) {
                                  debugPrint('⚠️ No outlets available');
                                  return <Outlet>[];
                                }
                                
                                if (pattern.isEmpty) {
                                  final result = outlets.take(10).toList();
                                  debugPrint('✅ Returning ${result.length} outlets for empty pattern');
                                  return result;
                                }
                                
                                final filtered = outlets
                                    .where(
                                      (outlet) => (outlet.outletName ?? '')
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()),
                                    )
                                    .take(10)
                                    .toList();
                                
                                debugPrint('✅ Returning ${filtered.length} filtered outlets');
                                return filtered;
                              },
                              
                              // ✅ Use builder parameter for text field decoration
                              builder: (context, controller, focusNode) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: GoogleFonts.montserrat(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Search for outlet...",
                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.grey[600],
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      Icons.search,
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
                                );
                              },

                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  leading: Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: ColorName.primaryColor.withOpacity(
                                        0.08,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.store_rounded,
                                      color: ColorName.primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    suggestion.outletName ?? "",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    "Tap to select",
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

                              onSelected: (Outlet suggestion) {
                                setState(() {
                                  searchController.text =
                                      suggestion.outletName ?? '';
                                  selectedOutletId = suggestion.id?.toString();
                                });

                                FocusScope.of(context).unfocus();

                                CustomSnackBar.showSuccess(
                                  context,
                                  title: "Outlet Selected",
                                  message: "🛍️ ${suggestion.outletName}",
                                );

                                debugPrint(
                                  '✅ Selected outlet: ${suggestion.outletName}, ID: ${suggestion.id}',
                                );
                              },
                              
                              // ✅ Add empty list widget when no suggestions found
                              emptyBuilder: (context) => Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Text(
                                  outlets.isEmpty 
                                    ? "Loading outlets..." 
                                    : "No outlets found",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
                                _amountChip(amt, () {
                                  amountController.text = amt;
                                }),
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
                                      final amountText = amountController.text
                                          .trim();
                                      final parsedAmount = double.tryParse(
                                        amountText,
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
                );
              },
            ),
          ),
        ),
      );
    },
  );
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