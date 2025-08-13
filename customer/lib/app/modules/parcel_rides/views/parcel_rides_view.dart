import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/parcel_model.dart';
import 'package:customer/app/modules/book_parcel/views/book_parcel_view.dart';
import 'package:customer/app/modules/parcel_ride_details/controllers/parcel_ride_details_controller.dart';
import 'package:customer/app/modules/parcel_ride_details/views/parcel_ride_details_view.dart';
import 'package:customer/app/modules/reason_for_parcel_cancel/views/parcel_reason_for_cancel_view.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/no_rides_view.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/parcel_rides_controller.dart';

class ParcelRidesView extends StatelessWidget {
  const ParcelRidesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: ParcelRidesController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(
            //   title: "My Rides".tr,
            //   bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            //   isUnderlineShow: false,
            // ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RoundShapeButton(
                            title: "Active".tr,
                            buttonColor: controller.selectedType.value == 0
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 0
                                ? AppThemData.black
                                : themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                            onTap: () {
                              controller.selectedType.value = 0;
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                          RoundShapeButton(
                            title: "OnGoing".tr,
                            buttonColor: controller.selectedType.value == 1
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 1 ? AppThemData.black : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                            onTap: () {
                              controller.selectedType.value = 1;
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                          RoundShapeButton(
                            title: "Completed".tr,
                            buttonColor: controller.selectedType.value == 2
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 2
                                ? AppThemData.black
                                : themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                            onTap: () {
                              controller.selectedType.value = 2;
                            },
                            size: Size((Responsive.width(100, context) / 3), 38),
                            textSize: 12,
                          ),
                          RoundShapeButton(
                            title: "Cancelled".tr,
                            buttonColor: controller.selectedType.value == 3
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 3
                                ? AppThemData.black
                                : themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                            onTap: () {
                              controller.selectedType.value = 3;
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                RefreshIndicator(
                  onRefresh: () async {
                    if (controller.selectedType.value == 0) {
                      await controller.getData(isActiveDataFetch: true, isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 1) {
                      await controller.getData(isActiveDataFetch: false, isOngoingDataFetch: true, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 2) {
                      await controller.getData(isActiveDataFetch: false, isOngoingDataFetch: false, isCompletedDataFetch: true, isRejectedDataFetch: false);
                    } else {
                      await controller.getData(isActiveDataFetch: false, isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: true);
                    }
                  },
                  child: SizedBox(
                    height: Responsive.height(75, context),
                    child: Obx(
                      () => (controller.selectedType.value == 0
                              ? controller.activeRides.isNotEmpty
                              : controller.selectedType.value == 1
                                  ? controller.ongoingRides.isNotEmpty
                                  : controller.selectedType.value == 2
                                      ? controller.completedRides.isNotEmpty
                                      : controller.rejectedRides.isNotEmpty)
                          ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 8),
                              itemCount: controller.selectedType.value == 0
                                  ? controller.activeRides.length
                                  : controller.selectedType.value == 1
                                      ? controller.ongoingRides.length
                                      : controller.selectedType.value == 2
                                          ? controller.completedRides.length
                                          : controller.rejectedRides.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                RxBool isOpen = false.obs;
                                ParcelModel parcelModel = controller.selectedType.value == 0
                                    ? controller.activeRides[index]
                                    : controller.selectedType.value == 1
                                        ? controller.ongoingRides[index]
                                        : controller.selectedType.value == 2
                                            ? controller.completedRides[index]
                                            : controller.rejectedRides[index];
                                return GestureDetector(
                                  onTap: () {
                                    isOpen.value = !isOpen.value;
                                  },
                                  child: Container(
                                    width: Responsive.width(100, context),
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              parcelModel.bookingTime == null ? "" : parcelModel.bookingTime!.toDate().dateMonthYear(),
                                              style: GoogleFonts.inter(
                                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              height: 15,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 1,
                                                    strokeAlign: BorderSide.strokeAlignCenter,
                                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                parcelModel.bookingTime == null ? "" : parcelModel.bookingTime!.toDate().time(),
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                // InterCityRideDetailsController detailsController = Get.put(InterCityRideDetailsController());
                                                // detailsController.bookingId.value = interCityModel.id ?? '';
                                                // detailsController.interCityModel.value = interCityModel;
                                                // Get.to(const InterCityRideDetailsView());
                                                ParcelRideDetailsController detailsController = Get.put(ParcelRideDetailsController());
                                                detailsController.bookingId.value = parcelModel.id ?? '';
                                                detailsController.parcelModel.value = parcelModel;
                                                Get.to(const ParcelRideDetailsView());
                                              },
                                              child: Icon(
                                                Icons.keyboard_arrow_right_sharp,
                                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(2000),
                                                child: CachedNetworkImage(
                                                  height: 60,
                                                  width: 60,
                                                  imageUrl: (Constant.userModel?.profilePic != null && Constant.userModel!.profilePic!.isNotEmpty) ? Constant.userModel!.profilePic! : Constant.profileConstant,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Constant.loader(),
                                                  errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'ID: #${parcelModel.id!.substring(0, 5)}',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Visibility(
                                                      // visible: parcelModel.bookingStatus == BookingStatus.bookingAccepted,
                                                      // visible: true,
                                                      child: Text(
                                                        'OTP: ${parcelModel.otp}',
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   (bookingModel.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
                                                    //   style: GoogleFonts.inter(
                                                    //     color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                    //     fontSize: 14,
                                                    //     fontWeight: FontWeight.w400,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    Constant.amountToShow(amount: Constant.calculateParcelFinalAmount(parcelModel).toString()),
                                                    // amount: Constant.calculateInterCityFinalAmount(bookingModel).toStringAsFixed(2)),
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset("assets/icon/ic_weight.svg"),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        '${parcelModel.weight}',
                                                        style: GoogleFonts.inter(
                                                          color: AppThemData.primary500,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(
                                          () => Visibility(
                                            visible: isOpen.value,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                PickDropPointView(pickUpAddress: parcelModel.pickUpLocationAddress ?? '', dropAddress: parcelModel.dropLocationAddress ?? ''),
                                                const SizedBox(height: 16),
                                                parcelModel.bookingStatus == BookingStatus.bookingPlaced
                                                    ?   Constant.isParcelBid == false   ?
                                                RoundShapeButton(
                                                  title: "Cancel Ride".tr,
                                                  buttonColor: AppThemData.danger_500p,
                                                  buttonTextColor: AppThemData.white,
                                                  onTap: () {
                                                    Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": parcelModel});
                                                  },
                                                  size: Size(Responsive.width(100, context), 52),
                                                )  : Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: RoundShapeButton(
                                                              title: "Cancel Ride".tr,
                                                              buttonColor: AppThemData.danger_500p,
                                                              buttonTextColor: AppThemData.white,
                                                              onTap: () {
                                                                Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": parcelModel});
                                                              },
                                                              size: const Size(double.infinity, 48),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: RoundShapeButton(
                                                              title: "View Bid".tr,
                                                              buttonColor: AppThemData.primary500,
                                                              buttonTextColor: AppThemData.black,
                                                              onTap: () {
                                                                ParcelRideDetailsController detailsController = Get.put(ParcelRideDetailsController());
                                                                detailsController.bookingId.value = parcelModel.id ?? '';
                                                                detailsController.parcelModel.value = parcelModel;
                                                                Get.to(const ParcelRideDetailsView());
                                                              },
                                                              size: const Size(double.infinity, 48),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : parcelModel.bookingStatus == BookingStatus.bookingAccepted
                                                        ? RoundShapeButton(
                                                            title: "Cancel Ride".tr,
                                                            buttonColor: AppThemData.danger_500p,
                                                            buttonTextColor: AppThemData.white,
                                                            onTap: () {
                                                              Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": parcelModel});
                                                            },
                                                            size: Size(Responsive.width(100, context), 52),
                                                          )
                                                        : SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView(children: [
                              NoRidesView(
                                themeChange: themeChange,
                                onTap: () {
                                  Get.to(const BookParcelView());
                                },
                              )
                            ]),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
