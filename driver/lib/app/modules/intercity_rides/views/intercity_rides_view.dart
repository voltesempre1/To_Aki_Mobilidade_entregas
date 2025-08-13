// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/modules/intercity_booking_details/views/intercity_booking_details_view.dart';
import 'package:driver/app/modules/intercity_rides/controllers/intercity_rides_controller.dart';
import 'package:driver/app/modules/reason_for_cancel_intercity_cab/views/reason_for_cancel_intercity_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/custom_loader.dart';
import 'package:driver/constant_widgets/no_rides_view.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/extension/date_time_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class InterCityRidesView extends StatelessWidget {
  const InterCityRidesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: InterCityRidesController(),
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
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
                          SizedBox(
                            width: 8,
                          ),
                          RoundShapeButton(
                            title: "OnGoing".tr,
                            buttonColor: controller.selectedType.value == 1
                                ? AppThemData.primary500
                                : themeChange.isDarkTheme()
                                    ? AppThemData.black
                                    : AppThemData.white,
                            buttonTextColor: controller.selectedType.value == 1
                                ? AppThemData.black
                                : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                            onTap: () async {
                              controller.selectedType.value = 1;
                              await controller.getData(
                                  isActiveDataFetch: false, isOngoingDataFetch: true, isCompletedDataFetch: false, isRejectedDataFetch: false);
                            },
                            size: Size((Responsive.width(90, context) / 3), 38),
                            textSize: 12,
                          ),
                          SizedBox(
                            width: 8,
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
                          SizedBox(
                            width: 8,
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
                      await controller.getData(
                          isActiveDataFetch: true, isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 1) {
                      await controller.getData(
                          isActiveDataFetch: false, isOngoingDataFetch: true, isCompletedDataFetch: false, isRejectedDataFetch: false);
                    } else if (controller.selectedType.value == 2) {
                      await controller.getData(
                          isActiveDataFetch: false, isOngoingDataFetch: false, isCompletedDataFetch: true, isRejectedDataFetch: false);
                    } else {
                      await controller.getData(
                          isActiveDataFetch: false, isOngoingDataFetch: false, isCompletedDataFetch: false, isRejectedDataFetch: true);
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
                                IntercityModel bookingModel = controller.selectedType.value == 0
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
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                    margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
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
                                              bookingModel.bookingTime == null ? "" : bookingModel.bookingTime!.toDate().dateMonthYear(),
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
                                                bookingModel.bookingTime == null ? "" : bookingModel.bookingTime!.toDate().time(),
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
                                                Get.to(
                                                  InterCityBookingDetailsView(),
                                                  arguments: {
                                                    "bookingId": bookingModel.id ?? '',
                                                  },
                                                );
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
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // SizedBox(
                                              //   height: 60,
                                              //   width: 60,
                                              //   child: CachedNetworkImage(
                                              //     imageUrl: bookingModel.vehicleType == null ? Constant.profileConstant : bookingModel.vehicleType!.image,
                                              //     fit: BoxFit.cover,
                                              //     placeholder: (context, url) => Constant.loader(),
                                              //     errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                              //   ),
                                              // ),
                                              // Container(
                                              //   width: 60,
                                              //   height: 60,
                                              //   margin: const EdgeInsets.only(right: 10),
                                              //   clipBehavior: Clip.antiAlias,
                                              //   decoration: ShapeDecoration(
                                              //     color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius: BorderRadius.circular(200),
                                              //     ),
                                              //     image: DecorationImage(
                                              //       image: NetworkImage(customerModel.profilePic != null
                                              //           ? customerModel.profilePic!.isNotEmpty
                                              //           ? customerModel.profilePic ?? Constant.profileConstant
                                              //           : Constant.profileConstant
                                              //           : Constant.profileConstant),
                                              //       fit: BoxFit.fill,
                                              //     ),
                                              //   ),
                                              // ),
                                              FutureBuilder<UserModel?>(
                                                future: FireStoreUtils.getUserProfile(bookingModel.customerId ?? ''),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(
                                                      child: CustomLoader(),
                                                    );
                                                  }

                                                  if (!snapshot.hasData || snapshot.data == null) {
                                                    return Container();
                                                  }
                                                  UserModel customerModel = snapshot.data ?? UserModel();
                                                  return Container(
                                                    width: 60,
                                                    height: 60,
                                                    margin: const EdgeInsets.only(right: 10),
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: ShapeDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(200),
                                                      ),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: (customerModel.profilePic != null && customerModel.profilePic!.isNotEmpty)
                                                          ? customerModel.profilePic!
                                                          : Constant.profileConstant,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(
                                                        child: CustomLoader(),
                                                      ),
                                                      errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                                    ),
                                                  );
                                                },
                                              ),

                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'ID: ${bookingModel.id!.substring(0, 5)}',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Ride Start Date: ${Constant.formatDate(Constant.parseDate(bookingModel.startDate))}',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
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
                                                    Constant.amountToShow(amount: Constant.calculateInterCityFinalAmount(bookingModel).toString()),
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
                                                      SvgPicture.asset("assets/icon/ic_multi_person.svg"),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        '${bookingModel.persons}',
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
                                                PickDropPointView(
                                                    pickUpAddress: bookingModel.pickUpLocationAddress ?? '',
                                                    dropAddress: bookingModel.dropLocationAddress ?? ''),
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Constant.isInterCityBid == false
                                                    bookingModel.bookingStatus == BookingStatus.bookingPlaced
                                                        ? bookingModel.isPersonalRide == true
                                                            ? Constant.isInterCityBid == true
                                                                ? Expanded(
                                                                    child: RoundShapeButton(
                                                                      title: (bookingModel.driverBidIdList == null ||
                                                                              bookingModel.driverBidIdList!.isEmpty)
                                                                          ? "Add Bid".tr
                                                                          : (bookingModel.driverBidIdList!.contains(FireStoreUtils.getCurrentUid())
                                                                              ? "View Bid".tr
                                                                              : "Add Bid".tr),
                                                                      buttonColor: AppThemData.primary500,
                                                                      buttonTextColor: AppThemData.black,
                                                                      onTap: () {
                                                                        Get.to(
                                                                          InterCityBookingDetailsView(),
                                                                          arguments: {
                                                                            "bookingId": bookingModel.id ?? '',
                                                                          },
                                                                        );
                                                                      },
                                                                      size: const Size(double.infinity, 48),
                                                                    ),
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      RoundShapeButton(
                                                                        title: "Cancel Ride".tr,
                                                                        buttonColor: AppThemData.danger500,
                                                                        buttonTextColor: AppThemData.white,
                                                                        onTap: () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return CustomDialogBox(
                                                                                    themeChange: themeChange,
                                                                                    title: "Cancel Ride".tr,
                                                                                    negativeButtonColor: themeChange.isDarkTheme()
                                                                                        ? AppThemData.grey950
                                                                                        : AppThemData.grey50,
                                                                                    negativeButtonTextColor: themeChange.isDarkTheme()
                                                                                        ? AppThemData.grey50
                                                                                        : AppThemData.grey950,
                                                                                    positiveButtonColor: AppThemData.danger500,
                                                                                    positiveButtonTextColor: AppThemData.grey25,
                                                                                    descriptions: "Are you sure you want cancel this ride?".tr,
                                                                                    positiveString: "Cancel Ride".tr,
                                                                                    negativeString: "Cancel".tr,
                                                                                    positiveClick: () async {
                                                                                      Navigator.pop(context);
                                                                                      List rejectedId = bookingModel.rejectedDriverId ?? [];
                                                                                      rejectedId.add(FireStoreUtils.getCurrentUid());
                                                                                      bookingModel.bookingStatus = BookingStatus.bookingRejected;
                                                                                      bookingModel.rejectedDriverId = rejectedId;
                                                                                      bookingModel.updateAt = Timestamp.now();
                                                                                      FireStoreUtils.setInterCityBooking(bookingModel)
                                                                                          .then((value) async {
                                                                                        if (value == true) {
                                                                                          ShowToastDialog.showToast(
                                                                                              "Ride cancelled successfully!".tr);
                                                                                          // DriverUserModel? driverModel =
                                                                                          //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                                                          UserModel? receiverUserModel =
                                                                                              await FireStoreUtils.getUserProfile(
                                                                                                  bookingModel.customerId.toString());
                                                                                          Map<String, dynamic> playLoad = <String, dynamic>{
                                                                                            "bookingId": bookingModel.id
                                                                                          };

                                                                                          await SendNotification.sendOneNotification(
                                                                                              type: "order",
                                                                                              token: receiverUserModel!.fcmToken.toString(),
                                                                                              title: 'Your Ride is Rejected',
                                                                                              customerId: receiverUserModel.id,
                                                                                              senderId: FireStoreUtils.getCurrentUid(),
                                                                                              bookingId: bookingModel.id.toString(),
                                                                                              driverId: bookingModel.driverId.toString(),
                                                                                              body:
                                                                                                  'Your ride #${bookingModel.id.toString().substring(0, 5)} has been Rejected by Driver.',
                                                                                              // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                                                              payload: playLoad);

                                                                                          Navigator.pop(context);
                                                                                        } else {
                                                                                          ShowToastDialog.showToast("Something went wrong!");
                                                                                          Navigator.pop(context);
                                                                                        }
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
                                                                        size: Size(Responsive.width(40, context), 42),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 4,
                                                                      ),
                                                                      RoundShapeButton(
                                                                        title: "Accept".tr,
                                                                        buttonColor: AppThemData.primary500,
                                                                        buttonTextColor: AppThemData.black,
                                                                        onTap: () {
                                                                          if (double.parse(Constant.userModel!.walletAmount.toString()) >=
                                                                              double.parse(Constant.minimumAmountToAcceptRide.toString())) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return CustomDialogBox(
                                                                                    title: "Confirm Ride Request",
                                                                                    descriptions:
                                                                                        "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.",
                                                                                    img: Image.asset(
                                                                                      "assets/icon/ic_green_right.png",
                                                                                      height: 58,
                                                                                      width: 58,
                                                                                    ),
                                                                                    positiveClick: () async {
                                                                                      if (Constant.isSubscriptionEnable == true) {
                                                                                        if (Constant.userModel!.subscriptionPlanId != null &&
                                                                                            Constant.userModel!.subscriptionPlanId!.isNotEmpty) {
                                                                                          if (Constant.userModel!.subscriptionTotalBookings == '0') {
                                                                                            Navigator.pop(context);
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (context) {
                                                                                                  return SubscriptionAlertDialog(
                                                                                                    title:
                                                                                                        "You can't accept more Rides.Upgrade your Plan.",
                                                                                                    cancelText: "Cancel",
                                                                                                    confirmText: "Upgrade",
                                                                                                    themeChange: themeChange,
                                                                                                  );
                                                                                                });
                                                                                            // ShowToastDialog.showToast(
                                                                                            //     "You can't accept more Bookings.Upgrade your Plan.");
                                                                                            return;
                                                                                          }
                                                                                        }

                                                                                        if (Constant.userModel!.subscriptionExpiryDate != null &&
                                                                                            Constant.userModel!.subscriptionExpiryDate!
                                                                                                .toDate()
                                                                                                .isBefore(DateTime.now())) {
                                                                                          Navigator.pop(context);
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return SubscriptionAlertDialog(
                                                                                                  title:
                                                                                                      "Your subscription has expired. Please renew your plan.",
                                                                                                  cancelText: "Cancel",
                                                                                                  confirmText: "Upgrade",
                                                                                                  themeChange: themeChange,
                                                                                                );
                                                                                              });
                                                                                          // ShowToastDialog.showToast(
                                                                                          //     "Your subscription has expired. Please renew your plan.");
                                                                                          return;
                                                                                        }
                                                                                      }

                                                                                      VehicleTypeModel? vehicleModel =
                                                                                          await FireStoreUtils.getVehicleTypeById(Constant
                                                                                              .userModel!.driverVehicleDetails!.vehicleTypeId
                                                                                              .toString());
                                                                                      bookingModel.driverVehicleDetails =
                                                                                          Constant.userModel!.driverVehicleDetails;
                                                                                      bookingModel.vehicleType = vehicleModel;
                                                                                      bookingModel.driverId = FireStoreUtils.getCurrentUid();
                                                                                      bookingModel.bookingStatus = BookingStatus.bookingAccepted;
                                                                                      bookingModel.updateAt = Timestamp.now();
                                                                                      FireStoreUtils.setInterCityBooking(bookingModel)
                                                                                          .then((value) async {
                                                                                        if (value == true) {
                                                                                          ShowToastDialog.showToast("Ride accepted successfully!");

                                                                                          UserModel? receiverUserModel =
                                                                                              await FireStoreUtils.getUserProfile(
                                                                                                  bookingModel.customerId.toString());
                                                                                          Map<String, dynamic> playLoad = <String, dynamic>{
                                                                                            "bookingId": bookingModel.id
                                                                                          };

                                                                                          await SendNotification.sendOneNotification(
                                                                                              type: "order",
                                                                                              token: receiverUserModel!.fcmToken.toString(),
                                                                                              title: 'Your Ride is Accepted',
                                                                                              customerId: receiverUserModel.id,
                                                                                              senderId: FireStoreUtils.getCurrentUid(),
                                                                                              bookingId: bookingModel.id.toString(),
                                                                                              driverId: bookingModel.driverId.toString(),
                                                                                              body:
                                                                                                  'Your ride #${bookingModel.id.toString().substring(0, 5)} has been confirmed.',
                                                                                              payload: playLoad);

                                                                                          if (Constant.isSubscriptionEnable == true &&
                                                                                              Constant.userModel!.subscriptionPlanId != null &&
                                                                                              Constant.userModel!.subscriptionPlanId!.isNotEmpty &&
                                                                                              Constant.userModel!.subscriptionTotalBookings != '0' &&
                                                                                              Constant.userModel!.subscriptionTotalBookings != '-1' &&
                                                                                              Constant.userModel!.subscriptionTotalBookings != null) {
                                                                                            int remainingBookings = int.parse(
                                                                                                    Constant.userModel!.subscriptionTotalBookings!) -
                                                                                                1;
                                                                                            Constant.userModel!.subscriptionTotalBookings =
                                                                                                remainingBookings.toString();
                                                                                            await FireStoreUtils.updateDriverUser(
                                                                                                Constant.userModel!);
                                                                                          }

                                                                                          Navigator.pop(context);
                                                                                        } else {
                                                                                          ShowToastDialog.showToast("Something went wrong!");
                                                                                          Navigator.pop(context);
                                                                                        }
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    negativeClick: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    positiveString: "Confirm",
                                                                                    negativeString: "Cancel",
                                                                                    themeChange: themeChange);
                                                                              },
                                                                            );
                                                                          } else {
                                                                            ShowToastDialog.showToast(
                                                                                "You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
                                                                          }
                                                                        },
                                                                        size: Size(Responsive.width(40, context), 42),
                                                                      )
                                                                    ],
                                                                  )
                                                            : Constant.isInterCitySharingBid == true
                                                                ? Expanded(
                                                                    child: RoundShapeButton(
                                                                      title: (bookingModel.driverBidIdList == null ||
                                                                              bookingModel.driverBidIdList!.isEmpty)
                                                                          ? "Add Bid".tr
                                                                          : (bookingModel.driverBidIdList!.contains(FireStoreUtils.getCurrentUid())
                                                                              ? "View Bid".tr
                                                                              : "Add Bid".tr),
                                                                      buttonColor: AppThemData.primary500,
                                                                      buttonTextColor: AppThemData.black,
                                                                      onTap: () {
                                                                        Get.to(
                                                                          InterCityBookingDetailsView(),
                                                                          arguments: {
                                                                            "bookingId": bookingModel.id ?? '',
                                                                          },
                                                                        );
                                                                      },
                                                                      size: const Size(double.infinity, 48),
                                                                    ),
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      RoundShapeButton(
                                                                        title: "Cancel Ride".tr,
                                                                        buttonColor: AppThemData.danger500,
                                                                        buttonTextColor: AppThemData.white,
                                                                        onTap: () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return CustomDialogBox(
                                                                                    themeChange: themeChange,
                                                                                    title: "Cancel Ride".tr,
                                                                                    negativeButtonColor: themeChange.isDarkTheme()
                                                                                        ? AppThemData.grey950
                                                                                        : AppThemData.grey50,
                                                                                    negativeButtonTextColor: themeChange.isDarkTheme()
                                                                                        ? AppThemData.grey50
                                                                                        : AppThemData.grey950,
                                                                                    positiveButtonColor: AppThemData.danger500,
                                                                                    positiveButtonTextColor: AppThemData.grey25,
                                                                                    descriptions: "Are you sure you want cancel this ride?".tr,
                                                                                    positiveString: "Cancel Ride".tr,
                                                                                    negativeString: "Cancel".tr,
                                                                                    positiveClick: () async {
                                                                                      Navigator.pop(context);
                                                                                      List rejectedId = bookingModel.rejectedDriverId ?? [];
                                                                                      rejectedId.add(FireStoreUtils.getCurrentUid());
                                                                                      bookingModel.bookingStatus = BookingStatus.bookingRejected;
                                                                                      bookingModel.rejectedDriverId = rejectedId;
                                                                                      bookingModel.updateAt = Timestamp.now();
                                                                                      FireStoreUtils.setInterCityBooking(bookingModel)
                                                                                          .then((value) async {
                                                                                        if (value == true) {
                                                                                          ShowToastDialog.showToast("Ride cancelled successfully!");
                                                                                          // DriverUserModel? driverModel =
                                                                                          //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                                                          UserModel? receiverUserModel =
                                                                                              await FireStoreUtils.getUserProfile(
                                                                                                  bookingModel.customerId.toString());
                                                                                          Map<String, dynamic> playLoad = <String, dynamic>{
                                                                                            "bookingId": bookingModel.id
                                                                                          };

                                                                                          await SendNotification.sendOneNotification(
                                                                                              type: "order",
                                                                                              token: receiverUserModel!.fcmToken.toString(),
                                                                                              title: 'Your Ride is Rejected',
                                                                                              customerId: receiverUserModel.id,
                                                                                              senderId: FireStoreUtils.getCurrentUid(),
                                                                                              bookingId: bookingModel.id.toString(),
                                                                                              driverId: bookingModel.driverId.toString(),
                                                                                              body:
                                                                                                  'Your ride #${bookingModel.id.toString().substring(0, 5)} has been Rejected by Driver.',
                                                                                              // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                                                              payload: playLoad);

                                                                                          Navigator.pop(context);
                                                                                        } else {
                                                                                          ShowToastDialog.showToast("Something went wrong!");
                                                                                          Navigator.pop(context);
                                                                                        }
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
                                                                        size: Size(Responsive.width(40, context), 42),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 4,
                                                                      ),
                                                                      RoundShapeButton(
                                                                        title: "Accept".tr,
                                                                        buttonColor: AppThemData.primary500,
                                                                        buttonTextColor: AppThemData.black,
                                                                        onTap: () {
                                                                          if (double.parse(Constant.userModel!.walletAmount.toString()) >=
                                                                              double.parse(Constant.minimumAmountToAcceptRide.toString())) {
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
                                                                                      if (Constant.isSubscriptionEnable == true) {
                                                                                        if (Constant.userModel!.subscriptionPlanId != null &&
                                                                                            Constant.userModel!.subscriptionPlanId!.isNotEmpty) {
                                                                                          if (Constant.userModel!.subscriptionTotalBookings == '0') {
                                                                                            Navigator.pop(context);
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (context) {
                                                                                                  return SubscriptionAlertDialog(
                                                                                                    title:
                                                                                                        "You can't accept more Rides.Upgrade your Plan.",
                                                                                                    cancelText: "Cancel",
                                                                                                    confirmText: "Upgrade",
                                                                                                    themeChange: themeChange,
                                                                                                  );
                                                                                                });
                                                                                            // ShowToastDialog.showToast("You can't accept more Bookings.Upgrade your Plan.");
                                                                                            return;
                                                                                          }
                                                                                        }

                                                                                        if (Constant.userModel!.subscriptionExpiryDate != null &&
                                                                                            Constant.userModel!.subscriptionExpiryDate!
                                                                                                .toDate()
                                                                                                .isBefore(DateTime.now())) {
                                                                                          Navigator.pop(context);
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return SubscriptionAlertDialog(
                                                                                                  title:
                                                                                                      "Your subscription has expired. Please renew your plan.",
                                                                                                  cancelText: "Cancel",
                                                                                                  confirmText: "Upgrade",
                                                                                                  themeChange: themeChange,
                                                                                                );
                                                                                              });
                                                                                          // ShowToastDialog.showToast("Your subscription has expired. Please renew your plan.");
                                                                                          return;
                                                                                        }
                                                                                      }
                                                                                      VehicleTypeModel? vehicleModel =
                                                                                          await FireStoreUtils.getVehicleTypeById(Constant
                                                                                              .userModel!.driverVehicleDetails!.vehicleTypeId
                                                                                              .toString());
                                                                                      bookingModel.driverVehicleDetails =
                                                                                          Constant.userModel!.driverVehicleDetails;
                                                                                      bookingModel.vehicleType = vehicleModel;
                                                                                      bookingModel.driverId = FireStoreUtils.getCurrentUid();
                                                                                      bookingModel.bookingStatus = BookingStatus.bookingAccepted;
                                                                                      bookingModel.updateAt = Timestamp.now();
                                                                                      FireStoreUtils.setInterCityBooking(bookingModel)
                                                                                          .then((value) async {
                                                                                        if (value == true) {
                                                                                          ShowToastDialog.showToast("Ride accepted successfully!".tr);

                                                                                          UserModel? receiverUserModel =
                                                                                              await FireStoreUtils.getUserProfile(
                                                                                                  bookingModel.customerId.toString());
                                                                                          Map<String, dynamic> playLoad = <String, dynamic>{
                                                                                            "bookingId": bookingModel.id
                                                                                          };

                                                                                          await SendNotification.sendOneNotification(
                                                                                              type: "order",
                                                                                              token: receiverUserModel!.fcmToken.toString(),
                                                                                              title: 'Your Ride is Accepted',
                                                                                              customerId: receiverUserModel.id,
                                                                                              senderId: FireStoreUtils.getCurrentUid(),
                                                                                              bookingId: bookingModel.id.toString(),
                                                                                              driverId: bookingModel.driverId.toString(),
                                                                                              body:
                                                                                                  'Your ride #${bookingModel.id.toString().substring(0, 5)} has been confirmed.',
                                                                                              payload: playLoad);

                                                                                          if (Constant.isSubscriptionEnable == true &&
                                                                                              Constant.userModel!.subscriptionPlanId != null &&
                                                                                              Constant.userModel!.subscriptionPlanId!.isNotEmpty &&
                                                                                              Constant.userModel!.subscriptionTotalBookings != '0' &&
                                                                                              Constant.userModel!.subscriptionTotalBookings != '-1' &&
                                                                                              Constant.userModel!.subscriptionTotalBookings != null) {
                                                                                            int remainingBookings = int.parse(
                                                                                                    Constant.userModel!.subscriptionTotalBookings!) -
                                                                                                1;
                                                                                            Constant.userModel!.subscriptionTotalBookings =
                                                                                                remainingBookings.toString();
                                                                                            await FireStoreUtils.updateDriverUser(
                                                                                                Constant.userModel!);
                                                                                          }
                                                                                          Navigator.pop(context);
                                                                                        } else {
                                                                                          ShowToastDialog.showToast("Something went wrong!");
                                                                                          Navigator.pop(context);
                                                                                        }
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    negativeClick: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    positiveString: "Confirm",
                                                                                    negativeString: "Cancel",
                                                                                    themeChange: themeChange);
                                                                              },
                                                                            );
                                                                          } else {
                                                                            ShowToastDialog.showToast(
                                                                                "You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
                                                                          }
                                                                        },
                                                                        size: Size(Responsive.width(40, context), 42),
                                                                      )
                                                                    ],
                                                                  )
                                                        : bookingModel.bookingStatus == BookingStatus.bookingAccepted
                                                            ? Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  RoundShapeButton(
                                                                    title: "Cancel Ride".tr,
                                                                    buttonColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                                                    buttonTextColor:
                                                                        themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                                    onTap: () {
                                                                      Get.to(() => ReasonForCancelInterCityView(
                                                                            bookingInterCityModel: bookingModel,
                                                                          ));
                                                                    },
                                                                    size: Size(Responsive.width(40, context), 42),
                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  RoundShapeButton(
                                                                    title: "Pickup".tr,
                                                                    buttonColor: AppThemData.primary500,
                                                                    buttonTextColor: AppThemData.black,
                                                                    onTap: () {
                                                                      Get.toNamed(Routes.ASK_FOR_OTP_INTERCITY, arguments: {
                                                                        "bookingModel": bookingModel,
                                                                      });
                                                                    },
                                                                    size: Size(Responsive.width(40, context), 42),
                                                                  )
                                                                ],
                                                              )
                                                            // : SizedBox()
                                                            : bookingModel.bookingStatus == BookingStatus.bookingPlaced
                                                                ? Expanded(
                                                                    child: RoundShapeButton(
                                                                      title: (bookingModel.driverBidIdList == null ||
                                                                              bookingModel.driverBidIdList!.isEmpty)
                                                                          ? "Add Bid".tr
                                                                          : (bookingModel.driverBidIdList!.contains(FireStoreUtils.getCurrentUid())
                                                                              ? "View Bid".tr
                                                                              : "Add Bid".tr),
                                                                      buttonColor: AppThemData.primary500,
                                                                      buttonTextColor: AppThemData.black,
                                                                      onTap: () {
                                                                        Get.to(
                                                                          InterCityBookingDetailsView(),
                                                                          arguments: {
                                                                            "bookingId": bookingModel.id ?? '',
                                                                          },
                                                                        );
                                                                      },
                                                                      size: const Size(double.infinity, 48),
                                                                    ),
                                                                  )
                                                                : bookingModel.bookingStatus == BookingStatus.bookingAccepted
                                                                    ? Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          RoundShapeButton(
                                                                            title: "Cancel Ride".tr,
                                                                            buttonColor:
                                                                                themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                                                            buttonTextColor:
                                                                                themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                                            onTap: () {
                                                                              Get.to(() => ReasonForCancelInterCityView(
                                                                                    bookingInterCityModel: bookingModel,
                                                                                  ));
                                                                            },
                                                                            size: Size(Responsive.width(40, context), 42),
                                                                          ),
                                                                          const SizedBox(width: 4),
                                                                          RoundShapeButton(
                                                                            title: "Pickup".tr,
                                                                            buttonColor: AppThemData.primary500,
                                                                            buttonTextColor: AppThemData.black,
                                                                            onTap: () {
                                                                              Get.toNamed(Routes.ASK_FOR_OTP_INTERCITY, arguments: {
                                                                                "bookingModel": bookingModel,
                                                                              });
                                                                            },
                                                                            size: Size(Responsive.width(40, context), 42),
                                                                          )
                                                                        ],
                                                                      )
                                                                    // bookingModel.bookingStatus == BookingStatus.bookingOngoing
                                                                    //                 ? Row(
                                                                    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //                     crossAxisAlignment: CrossAxisAlignment.center,
                                                                    //                     children: [
                                                                    //                       RoundShapeButton(
                                                                    //                         title: "Cancel Ride",
                                                                    //                         buttonColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                                                    //                         buttonTextColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                                    //                         onTap: () {
                                                                    //                           Get.to(() => ReasonForCancelInterCityView(
                                                                    //                                 bookingInterCityModel: bookingModel ?? IntercityModel(),
                                                                    //                               ));
                                                                    //                         },
                                                                    //                         size: Size(Responsive.width(40, context), 42),
                                                                    //                       ),
                                                                    //                       RoundShapeButton(
                                                                    //                         title: "Pickup",
                                                                    //                         buttonColor: AppThemData.primary500,
                                                                    //                         buttonTextColor: AppThemData.black,
                                                                    //                         onTap: () {
                                                                    //                           Get.toNamed(Routes.ASK_FOR_OTP_INTERCITY, arguments: {
                                                                    //                             "bookingModel": bookingModel,
                                                                    //                           });
                                                                    //                         },
                                                                    //                         size: Size(Responsive.width(40, context), 42),
                                                                    //                       )
                                                                    //                     ],
                                                                    //                   )
                                                                    : SizedBox(),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
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
                          : ListView(children: [NoRidesView(themeChange: themeChange)]),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
