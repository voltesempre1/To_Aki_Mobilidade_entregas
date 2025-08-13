// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/app/modules/intercity_ride_details/controllers/intercity_ride_details_controller.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/constant_widgets/custom_dialog_box.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class InterCityBidView extends StatelessWidget {
  const InterCityBidView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: InterCityRideDetailsController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: Responsive.width(100, context),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
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
                            controller.interCityModel.value.bookingTime == null
                                ? ""
                                : controller.interCityModel.value.bookingTime!.toDate().dateMonthYear(),
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
                              controller.interCityModel.value.bookingTime == null ? "" : controller.interCityModel.value.bookingTime!.toDate().time(),
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2000),
                                child: CachedNetworkImage(
                                  // imageUrl: (  Constant.userModel!.profilePic =='' || Constant.userModel!.profilePic == null) ? Constant.profileConstant : Constant.userModel!.profilePic.toString(),
                                  imageUrl: (Constant.userModel?.profilePic != null && Constant.userModel!.profilePic!.isNotEmpty)
                                      ? Constant.userModel!.profilePic!
                                      : Constant.profileConstant,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Constant.loader(),
                                  errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                ),
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
                                    'ID: ${controller.interCityModel.value.id!.substring(0, 5)}',
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Visibility(
                                    visible: controller.interCityModel.value.bookingStatus == BookingStatus.bookingAccepted,
                                    child: Text(
                                      'OTP: ${controller.interCityModel.value.otp}',
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
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
                                  Constant.amountToShow(
                                      amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toStringAsFixed(2)),
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
                                    SvgPicture.asset("assets/icon/ic_multi_person.svg"),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${controller.interCityModel.value.persons}',
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
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          PickDropPointView(
                              pickUpAddress: controller.interCityModel.value.pickUpLocationAddress ?? '',
                              dropAddress: controller.interCityModel.value.dropLocationAddress ?? ''),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Views'.tr,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        controller.interCityModel.value.bidList!.isEmpty
                            ? Center(
                                child: Text(
                                  'No Available Bid List'.tr,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: controller.interCityModel.value.bidList!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (contex, index) {
                                  BidModel bidModel = controller.interCityModel.value.bidList![index];
                                  return FutureBuilder<DriverUserModel?>(
                                      future: FireStoreUtils.getDriverUserProfile(bidModel.driverID ?? ''),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        DriverUserModel driverUserModel = snapshot.data ?? DriverUserModel();
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: Responsive.width(100, context),
                                              padding: const EdgeInsets.all(16),
                                              margin: const EdgeInsets.only(bottom: 14),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
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
                                                      SizedBox(
                                                        height: 48,
                                                        width: 48,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(2000),
                                                          child: CachedNetworkImage(
                                                            imageUrl: (driverUserModel.profilePic != null && driverUserModel.profilePic!.isNotEmpty)
                                                                ? driverUserModel.profilePic!
                                                                : Constant.profileConstant,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => Constant.loader(),
                                                            errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                                          ),
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
                                                              '${driverUserModel.fullName}',
                                                              style: GoogleFonts.inter(
                                                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                const Icon(Icons.star_rate_rounded, color: AppThemData.warning500),
                                                                Text(
                                                                  Constant.calculateReview(
                                                                          reviewCount: driverUserModel.reviewsCount,
                                                                          reviewSum: driverUserModel.reviewsSum)
                                                                      .toString(),
                                                                  // driverUserModel.reviewsSum ?? '0.0',
                                                                  style: GoogleFonts.inter(
                                                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      bidModel.bidStatus == 'close'
                                                          ? Container(
                                                              width: 77,
                                                              height: 32,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(2000), color: AppThemData.danger50),
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                'Closed'.tr,
                                                                style: GoogleFonts.inter(
                                                                  color: AppThemData.danger500,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            )
                                                          : Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return CustomDialogBox(
                                                                                  themeChange: themeChange,
                                                                                  title: "Cancel Bid".tr,
                                                                                  negativeButtonColor: themeChange.isDarkTheme()
                                                                                      ? AppThemData.grey950
                                                                                      : AppThemData.grey50,
                                                                                  negativeButtonTextColor: themeChange.isDarkTheme()
                                                                                      ? AppThemData.grey50
                                                                                      : AppThemData.grey950,
                                                                                  positiveButtonColor: AppThemData.danger500,
                                                                                  positiveButtonTextColor: AppThemData.grey25,
                                                                                  descriptions: "Are you sure you want cancel this bid?".tr,
                                                                                  positiveString: "Cancel Bid".tr,
                                                                                  negativeString: "Cancel".tr,
                                                                                  positiveClick: () async {
                                                                                    Navigator.pop(context);
                                                                                    ShowToastDialog.showLoader('Please Wait');
                                                                                    // bidModel.bidStatus = 'close';
                                                                                    controller.interCityModel.value.bidList![index].bidStatus =
                                                                                        'close';
                                                                                    await FireStoreUtils.setInterCityBooking(
                                                                                            controller.interCityModel.value)
                                                                                        .then((value) {
                                                                                      Map<String, dynamic> playLoad = <String, dynamic>{
                                                                                        "bookingId": controller.interCityModel.value.id
                                                                                      };
                                                                                      if (value == true) {
                                                                                        SendNotification.sendOneNotification(
                                                                                            type: "order",
                                                                                            token: driverUserModel.fcmToken.toString(),
                                                                                            title: 'Your Bid is close',
                                                                                            customerId: FireStoreUtils.getCurrentUid(),
                                                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                                                            bookingId: controller.interCityModel.value.id,
                                                                                            driverId: driverUserModel.id,
                                                                                            body:
                                                                                                'Your ride #${controller.interCityModel.value.id.toString().substring(0, 5)} bid has been close.',
                                                                                            payload: playLoad);
                                                                                        ShowToastDialog.closeLoader();
                                                                                      }

                                                                                      ShowToastDialog.closeLoader();
                                                                                      // Get.offAllNamed(Routes.HOME);
                                                                                    });
                                                                                  },
                                                                                  negativeClick: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  img: Image.asset(
                                                                                    "assets/icon/ic_close.png",
                                                                                    height: 58,
                                                                                    width: 58,
                                                                                  ));
                                                                            });
                                                                      },
                                                                      child: Container(
                                                                        height: 32,
                                                                        width: 32,
                                                                        decoration:
                                                                            BoxDecoration(shape: BoxShape.circle, color: AppThemData.danger500),
                                                                        child: Icon(
                                                                          Icons.clear,
                                                                          color: AppThemData.grey25,
                                                                          size: 26,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 8),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return CustomDialogBox(
                                                                                title: "Confirm Ride Request".tr,
                                                                                descriptions:
                                                                                    "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride."
                                                                                        .tr,
                                                                                img: Image.asset(
                                                                                  "assets/icon/ic_green_right.png",
                                                                                  height: 58,
                                                                                  width: 58,
                                                                                ),
                                                                                positiveClick: () async {
                                                                                  Navigator.pop(context);
                                                                                  log('----------------------> 1111 clik on right acwwpt bid');
                                                                                  ShowToastDialog.showLoader('Please Wait'.tr);
                                                                                  // VehicleTypeModel? vehicleModel = await FireStoreUtils.getVehicleTypeById(driverUserModel.driverVehicleDetails!.vehicleTypeId.toString());
                                                                                  controller.interCityModel.value.driverId = driverUserModel.id;
                                                                                  controller.interCityModel.value.bookingStatus =
                                                                                      BookingStatus.bookingAccepted;
                                                                                  controller.interCityModel.value.updateAt = Timestamp.now();
                                                                                  controller.interCityModel.value.driverVehicleDetails =
                                                                                      driverUserModel.driverVehicleDetails;
                                                                                  // controller.interCityModel.value.vehicleType = vehicleModel;
                                                                                  controller.interCityModel.value.subTotal = bidModel.amount;
                                                                                  controller.interCityModel.value.bidList![index].bidStatus =
                                                                                      'Accept';
                                                                                  controller.interCityModel.value.driverBidIdList!.clear();

                                                                                  await FireStoreUtils.setInterCityBooking(
                                                                                          controller.interCityModel.value)
                                                                                      .then((value) async {
                                                                                    if (value == true) {
                                                                                      ShowToastDialog.showToast("Ride accepted successfully!".tr);
                                                                                      Map<String, dynamic> playLoad = <String, dynamic>{
                                                                                        "bookingId": controller.interCityModel.value.id
                                                                                      };
                                                                                      SendNotification.sendOneNotification(
                                                                                          type: "order",
                                                                                          token: driverUserModel.fcmToken.toString(),
                                                                                          title: 'Your Ride is Accepted',
                                                                                          customerId: FireStoreUtils.getCurrentUid(),
                                                                                          senderId: FireStoreUtils.getCurrentUid(),
                                                                                          bookingId: controller.interCityModel.value.id,
                                                                                          driverId: driverUserModel.id,
                                                                                          body:
                                                                                              'Your ride #${controller.interCityModel.value.id.toString().substring(0, 5)} has been confirmed.',
                                                                                          payload: playLoad);

                                                                                      ShowToastDialog.closeLoader();
                                                                                      // controller.update();
                                                                                    } else {
                                                                                      ShowToastDialog.showToast("Something went wrong!".tr);
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  }).catchError((error) {
                                                                                    log('------------------> accept bid tha time get error=> $error');
                                                                                  });
                                                                                },
                                                                                negativeClick: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                positiveString: "Confirm".tr,
                                                                                negativeString: "Cancel".tr,
                                                                                themeChange: themeChange);
                                                                          },
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        height: 32,
                                                                        width: 32,
                                                                        decoration:
                                                                            BoxDecoration(shape: BoxShape.circle, color: AppThemData.success500),
                                                                        child: Icon(
                                                                          Icons.check,
                                                                          color: AppThemData.grey25,
                                                                          size: 26,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Divider(),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icon/ic_ride.svg",
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            '${driverUserModel.driverVehicleDetails!.brandName}'.tr,
                                                            style: GoogleFonts.inter(
                                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          // SvgPicture.asset(
                                                          //   "assets/icon/ic_ride.svg",
                                                          // ),
                                                          // const SizedBox(width: 8),
                                                          Text(
                                                            Constant.amountToShow(amount: bidModel.amount),
                                                            style: GoogleFonts.inter(
                                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icon/ic_number.svg",
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            '${driverUserModel.driverVehicleDetails!.vehicleNumber}'.tr,
                                                            style: GoogleFonts.inter(
                                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
