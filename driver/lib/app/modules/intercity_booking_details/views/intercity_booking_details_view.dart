// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/reason_for_cancel_intercity_cab/views/reason_for_cancel_intercity_view.dart';
import 'package:driver/app/modules/search_intercity_ride/controllers/search_ride_controller.dart';
import 'package:driver/app/modules/track_intercity_ride_screen/views/track_intercity_ride_screen_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/intercity_booking_details_controller.dart';
import 'widget/intercity_bid_view.dart';
import 'widget/intercity_detail_view.dart';

class InterCityBookingDetailsView extends StatelessWidget {
  const InterCityBookingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: InterCityBookingDetailsController(),
        builder: (controller) {
          bool shouldShowButton = controller.interCityModel.value.bidList?.any((bid) => bid.driverID == FireStoreUtils.getCurrentUid()) == false;
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(title: "Intercity Ride Detail".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            // floatingActionButton:   controller.interCityModel.value.bookingStatus ==  BookingStatus.bookingPlaced ?
            //
            // (Constant.isInterCityBid == false ?          Padding(
            //   padding: const EdgeInsets.only(left: 22,right: 22),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       RoundShapeButton(
            //         title: "Cancel Ride",
            //         buttonColor: AppThemData.danger500,
            //         buttonTextColor: AppThemData.white,
            //         onTap: () {
            //           showDialog(
            //               context: context,
            //               builder: (BuildContext context) {
            //                 return CustomDialogBox(
            //                     themeChange: themeChange,
            //                     title: "Cancel Ride".tr,
            //                     negativeButtonColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
            //                     negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
            //                     positiveButtonColor: AppThemData.danger500,
            //                     positiveButtonTextColor: AppThemData.grey25,
            //                     descriptions: "Are you sure you want cancel this ride?".tr,
            //                     positiveString: "Cancel Ride".tr,
            //                     negativeString: "Cancel".tr,
            //                     positiveClick: () async {
            //                       Navigator.pop(context);
            //                       List rejectedId = controller.interCityModel.value.rejectedDriverId ?? [];
            //                       rejectedId.add(FireStoreUtils.getCurrentUid());
            //                      controller.interCityModel.value.bookingStatus = BookingStatus.bookingRejected;
            //                      controller.interCityModel.value.rejectedDriverId = rejectedId;
            //                      controller.interCityModel.value.updateAt = Timestamp.now();
            //                       FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
            //                         if (value == true) {
            //                           ShowToastDialog.showToast("InterCity ride cancelled successfully!");
            //                           // DriverUserModel? driverModel =
            //                           //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
            //                           UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId.toString());
            //                           Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.interCityModel.value.id};
            //
            //                           await SendNotification.sendOneNotification(
            //                               type: "order",
            //                               token: receiverUserModel!.fcmToken.toString(),
            //                               title: 'Your InterCity Ride is Rejected',
            //                               customerId: receiverUserModel.id,
            //                               senderId: FireStoreUtils.getCurrentUid(),
            //                               bookingId: controller.interCityModel.value.id.toString(),
            //                               driverId: controller.interCityModel.value.driverId.toString(),
            //                               body: 'Your ride #${controller.interCityModel.value.id.toString().substring(0, 4)} has been Rejected by Driver.',
            //                               // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
            //                               payload: playLoad);
            //
            //                           Navigator.pop(context);
            //                         } else {
            //                           ShowToastDialog.showToast("Something went wrong!");
            //                           Navigator.pop(context);
            //                         }
            //                       });
            //                     },
            //                     negativeClick: () {
            //                       Navigator.pop(context);
            //                     },
            //                     img: Image.asset(
            //                       "assets/icon/ic_close.png",
            //                       height: 58,
            //                       width: 58,
            //                     ));
            //               });
            //         },
            //         size: Size(Responsive.width(40, context), 42),
            //       ),
            //       SizedBox(width: 4,),
            //       RoundShapeButton(
            //         title: "Accept".tr,
            //         buttonColor: AppThemData.primary500,
            //         buttonTextColor: AppThemData.black,
            //         onTap: () {
            //           if (double.parse(Constant.userModel!.walletAmount.toString()) > double.parse(Constant.minimumAmountToAcceptRide.toString())) {
            //             showDialog(
            //               context: context,
            //               builder: (context) {
            //                 return CustomDialogBox(
            //                     title: "Confirm InterCity Ride Request",
            //                     descriptions: "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.",
            //                     img: Image.asset(
            //                       "assets/icon/ic_green_right.png",
            //                       height: 58,
            //                       width: 58,
            //                     ),
            //                     positiveClick: () {
            //                       controller.interCityModel.value.driverId = FireStoreUtils.getCurrentUid();
            //                       controller.interCityModel.value.bookingStatus = BookingStatus.bookingAccepted;
            //                       controller.interCityModel.value.updateAt = Timestamp.now();
            //                       FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
            //                         if (value == true) {
            //                           ShowToastDialog.showToast("InterCity Ride accepted successfully!");
            //                           UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId.toString());
            //                           Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.interCityModel.value.id};
            //
            //                           await SendNotification.sendOneNotification(
            //                               type: "order",
            //                               token: receiverUserModel!.fcmToken.toString(),
            //                               title: 'Your InterCity Ride is Accepted',
            //                               customerId: receiverUserModel.id,
            //                               senderId: FireStoreUtils.getCurrentUid(),
            //                               bookingId: controller.interCityModel.value!.id.toString(),
            //                               driverId: controller.interCityModel.value.driverId.toString(),
            //                               body: 'Your ride #${controller.interCityModel.value.id.toString().substring(0, 4)} has been confirmed.',
            //                               payload: playLoad);
            //                           Navigator.pop(context);
            //                         } else {
            //                           ShowToastDialog.showToast("Something went wrong!");
            //                           Navigator.pop(context);
            //                         }
            //                       });
            //                       Navigator.pop(context);
            //                     },
            //                     negativeClick: () {
            //                       Navigator.pop(context);
            //                     },
            //                     positiveString: "Confirm",
            //                     negativeString: "Cancel",
            //                     themeChange: themeChange);
            //               },
            //             );
            //           } else {
            //             ShowToastDialog.showToast("You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
            //           }
            //         },
            //         size: Size(Responsive.width(40, context), 42),
            //       )
            //     ],
            //   ),
            // ) :  shouldShowButton != true ?  SizedBox() : RoundShapeButton(
            //   title: "Add Bid".tr,
            //   buttonColor: AppThemData.primary500,
            //   buttonTextColor: AppThemData.black,
            //   onTap: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return BidDialogBox(
            //           onPressConfirm: () async {
            //             controller.saveBidDetail();
            //             Navigator.pop(context);
            //           },
            //           themeChange: themeChange,
            //
            //           onPressCancel: () {
            //             Get.back();
            //           },
            //         );
            //       },
            //     );
            //   },
            //   size: Size(Responsive.width(90, context), 52),
            // ) )
            //  :  SizedBox(),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (controller.interCityModel.value.bookingStatus == BookingStatus.bookingPlaced) ...{
                    controller.interCityModel.value.isPersonalRide == true
                        ? Constant.isInterCityBid == true
                            ? shouldShowButton != true
                                ? SizedBox()
                                : RoundShapeButton(
                                    title: "Add Bid".tr,
                                    buttonColor: AppThemData.primary500,
                                    buttonTextColor: AppThemData.black,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BidDialogBox(
                                            onPressConfirm: () async {
                                              if (Constant.isSubscriptionEnable == true) {
                                                if (Constant.userModel!.subscriptionPlanId != null && Constant.userModel!.subscriptionPlanId!.isNotEmpty) {
                                                  if (Constant.userModel!.subscriptionTotalBookings == '0') {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return SubscriptionAlertDialog(
                                                            title: "You can't Add the Bid. Upgrade your Plan.",
                                                            cancelText: "Cancel",
                                                            confirmText: "Upgrade",
                                                            themeChange: themeChange,
                                                          );
                                                        });
                                                    return;
                                                  }
                                                }

                                                if (Constant.userModel!.subscriptionExpiryDate != null && Constant.userModel!.subscriptionExpiryDate!.toDate().isBefore(DateTime.now())) {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SubscriptionAlertDialog(
                                                          title: "Your subscription has expired. Please renew your plan.",
                                                          cancelText: "Cancel",
                                                          confirmText: "Upgrade",
                                                          themeChange: themeChange,
                                                        );
                                                      });
                                                  return;
                                                }
                                              }
                                              controller.saveBidDetail();
                                              Navigator.pop(context);
                                            },
                                            themeChange: themeChange,
                                            onPressCancel: () {
                                              Get.back();
                                            },
                                          );
                                        },
                                      );
                                    },
                                    size: Size(Responsive.width(90, context), 52),
                                  )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RoundShapeButton(
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
                                                  negativeButtonColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                                                  negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                                  positiveButtonColor: AppThemData.danger500,
                                                  positiveButtonTextColor: AppThemData.grey25,
                                                  descriptions: "Are you sure you want cancel this ride?".tr,
                                                  positiveString: "Cancel Ride".tr,
                                                  negativeString: "Cancel".tr,
                                                  positiveClick: () async {
                                                    Navigator.pop(context);
                                                    List rejectedId = controller.interCityModel.value.rejectedDriverId ?? [];
                                                    rejectedId.add(FireStoreUtils.getCurrentUid());
                                                    controller.interCityModel.value.bookingStatus = BookingStatus.bookingRejected;
                                                    controller.interCityModel.value.rejectedDriverId = rejectedId;
                                                    controller.interCityModel.value.updateAt = Timestamp.now();
                                                    FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
                                                      if (value == true) {
                                                        ShowToastDialog.showToast("Intercity ride cancelled successfully!");
                                                        // DriverUserModel? driverModel =
                                                        //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                        UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId.toString());
                                                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.interCityModel.value.id};

                                                        await SendNotification.sendOneNotification(
                                                            type: "order",
                                                            token: receiverUserModel!.fcmToken.toString(),
                                                            title: 'Your Intercity Ride is Rejected',
                                                            customerId: receiverUserModel.id,
                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                            bookingId: controller.interCityModel.value.id.toString(),
                                                            driverId: controller.interCityModel.value.driverId.toString(),
                                                            body: 'Your ride #${controller.interCityModel.value.id.toString().substring(0, 5)} has been Rejected by Driver.',
                                                            // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                            payload: playLoad);

                                                        Navigator.pop(context);
                                                      } else {
                                                        ShowToastDialog.showToast("Something went wrong!".tr);
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
                                      size: Size(0, 52),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: RoundShapeButton(
                                      title: "Accept".tr,
                                      buttonColor: AppThemData.primary500,
                                      buttonTextColor: AppThemData.black,
                                      onTap: () {
                                        if (double.parse(Constant.userModel!.walletAmount.toString()) >= double.parse(Constant.minimumAmountToAcceptRide.toString())) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialogBox(
                                                  title: "Confirm Intercity Ride Request".tr,
                                                  descriptions: "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.".tr,
                                                  img: Image.asset(
                                                    "assets/icon/ic_green_right.png",
                                                    height: 58,
                                                    width: 58,
                                                  ),
                                                  positiveClick: () async {
                                                    if (Constant.isSubscriptionEnable == true) {
                                                      if (Constant.userModel!.subscriptionPlanId != null && Constant.userModel!.subscriptionPlanId!.isNotEmpty) {
                                                        if (Constant.userModel!.subscriptionTotalBookings == '0') {
                                                          Navigator.pop(context);
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return SubscriptionAlertDialog(
                                                                  title: "You can't accept more Rides.Upgrade your Plan.",
                                                                  cancelText: "Cancel",
                                                                  confirmText: "Upgrade",
                                                                  themeChange: themeChange,
                                                                );
                                                              });
                                                          // ShowToastDialog.showToast("You can't accept more Bookings.Upgrade your Plan.");
                                                          return;
                                                        }
                                                      }

                                                      if (Constant.userModel!.subscriptionExpiryDate != null && Constant.userModel!.subscriptionExpiryDate!.toDate().isBefore(DateTime.now())) {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SubscriptionAlertDialog(
                                                                title: "Your subscription has expired. Please renew your plan.",
                                                                cancelText: "Cancel",
                                                                confirmText: "Upgrade",
                                                                themeChange: themeChange,
                                                              );
                                                            });
                                                        // ShowToastDialog.showToast("Your subscription has expired. Please renew your plan.");
                                                        return;
                                                      }
                                                    }
                                                    VehicleTypeModel? vehicleModel = await FireStoreUtils.getVehicleTypeById(Constant.userModel!.driverVehicleDetails!.vehicleTypeId.toString());
                                                    controller.interCityModel.value.driverVehicleDetails = Constant.userModel!.driverVehicleDetails;
                                                    controller.interCityModel.value.vehicleType = vehicleModel;
                                                    controller.interCityModel.value.driverId = FireStoreUtils.getCurrentUid();
                                                    controller.interCityModel.value.bookingStatus = BookingStatus.bookingAccepted;
                                                    controller.interCityModel.value.updateAt = Timestamp.now();
                                                    FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
                                                      if (value == true) {
                                                        ShowToastDialog.showToast("Intercity Ride accepted successfully!".tr);
                                                        UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId.toString());
                                                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.interCityModel.value.id};

                                                        if (controller.isSearch.value == true) {
                                                          SearchRideController searchController = Get.put(SearchRideController());
                                                          searchController.searchIntercityList.removeWhere((parcel) => parcel.id == controller.interCityModel.value.id);
                                                          searchController.intercityBookingList.removeWhere((parcel) => parcel.id == controller.interCityModel.value.id);
                                                          ShowToastDialog.closeLoader();
                                                        }

                                                        await SendNotification.sendOneNotification(
                                                            type: "order",
                                                            token: receiverUserModel!.fcmToken.toString(),
                                                            title: 'Your Intercity Ride is Accepted',
                                                            customerId: receiverUserModel.id,
                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                            bookingId: controller.interCityModel.value.id.toString(),
                                                            driverId: controller.interCityModel.value.driverId.toString(),
                                                            body: 'Your ride #${controller.interCityModel.value.id.toString().substring(0, 5)} has been confirmed.',
                                                            payload: playLoad);
                                                        if (Constant.isSubscriptionEnable == true &&
                                                            Constant.userModel!.subscriptionPlanId != null &&
                                                            Constant.userModel!.subscriptionPlanId!.isNotEmpty &&
                                                            Constant.userModel!.subscriptionTotalBookings != '0' &&
                                                            Constant.userModel!.subscriptionTotalBookings != '-1' &&
                                                            Constant.userModel!.subscriptionTotalBookings != null) {
                                                          int remainingBookings = int.parse(Constant.userModel!.subscriptionTotalBookings!) - 1;
                                                          Constant.userModel!.subscriptionTotalBookings = remainingBookings.toString();
                                                          await FireStoreUtils.updateDriverUser(Constant.userModel!);
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
                                      size: Size(0, 52),
                                    ),
                                  )
                                ],
                              )
                        : Constant.isInterCitySharingBid == true
                            ? shouldShowButton != true
                                ? SizedBox()
                                : RoundShapeButton(
                                    title: "Add Bid".tr,
                                    buttonColor: AppThemData.primary500,
                                    buttonTextColor: AppThemData.black,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BidDialogBox(
                                            onPressConfirm: () async {
                                              if (Constant.isSubscriptionEnable == true) {
                                                if (Constant.userModel!.subscriptionPlanId != null && Constant.userModel!.subscriptionPlanId!.isNotEmpty) {
                                                  if (Constant.userModel!.subscriptionTotalBookings == '0') {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return SubscriptionAlertDialog(
                                                            title: "You can't Add the Bid. Upgrade your Plan.",
                                                            cancelText: "Cancel",
                                                            confirmText: "Upgrade",
                                                            themeChange: themeChange,
                                                          );
                                                        });
                                                    return;
                                                  }
                                                }

                                                if (Constant.userModel!.subscriptionExpiryDate != null && Constant.userModel!.subscriptionExpiryDate!.toDate().isBefore(DateTime.now())) {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SubscriptionAlertDialog(
                                                          title: "Your subscription has expired. Please renew your plan.",
                                                          cancelText: "Cancel",
                                                          confirmText: "Upgrade",
                                                          themeChange: themeChange,
                                                        );
                                                      });
                                                  return;
                                                }
                                              }

                                              controller.saveBidDetail();
                                              Navigator.pop(context);
                                            },
                                            themeChange: themeChange,
                                            onPressCancel: () {
                                              Get.back();
                                            },
                                          );
                                        },
                                      );
                                    },
                                    size: Size(Responsive.width(90, context), 52),
                                  )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RoundShapeButton(
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
                                                  negativeButtonColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                                                  negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                                  positiveButtonColor: AppThemData.danger500,
                                                  positiveButtonTextColor: AppThemData.grey25,
                                                  descriptions: "Are you sure you want cancel this ride?".tr,
                                                  positiveString: "Cancel Ride".tr,
                                                  negativeString: "Cancel".tr,
                                                  positiveClick: () async {
                                                    Navigator.pop(context);
                                                    List rejectedId = controller.interCityModel.value.rejectedDriverId ?? [];
                                                    rejectedId.add(FireStoreUtils.getCurrentUid());
                                                    controller.interCityModel.value.bookingStatus = BookingStatus.bookingRejected;
                                                    controller.interCityModel.value.rejectedDriverId = rejectedId;
                                                    controller.interCityModel.value.updateAt = Timestamp.now();
                                                    FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
                                                      if (value == true) {
                                                        ShowToastDialog.showToast("Intercity ride cancelled successfully!");
                                                        // DriverUserModel? driverModel =
                                                        //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                        UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId.toString());
                                                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.interCityModel.value.id};

                                                        await SendNotification.sendOneNotification(
                                                            type: "order",
                                                            token: receiverUserModel!.fcmToken.toString(),
                                                            title: 'Your Intercity Ride is Rejected',
                                                            customerId: receiverUserModel.id,
                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                            bookingId: controller.interCityModel.value.id.toString(),
                                                            driverId: controller.interCityModel.value.driverId.toString(),
                                                            body: 'Your ride #${controller.interCityModel.value.id.toString().substring(0, 5)} has been Rejected by Driver.',
                                                            // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                            payload: playLoad);

                                                        Navigator.pop(context);
                                                      } else {
                                                        ShowToastDialog.showToast("Something went wrong!".tr);
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
                                      size: Size(0, 52),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: RoundShapeButton(
                                      title: "Accept".tr,
                                      buttonColor: AppThemData.primary500,
                                      buttonTextColor: AppThemData.black,
                                      onTap: () {
                                        if (double.parse(Constant.userModel!.walletAmount.toString()) >= double.parse(Constant.minimumAmountToAcceptRide.toString())) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialogBox(
                                                  title: "Confirm Intercity Ride Request".tr,
                                                  descriptions: "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.".tr,
                                                  img: Image.asset(
                                                    "assets/icon/ic_green_right.png",
                                                    height: 58,
                                                    width: 58,
                                                  ),
                                                  positiveClick: () async {
                                                    if (Constant.isSubscriptionEnable == true) {
                                                      if (Constant.userModel!.subscriptionPlanId != null && Constant.userModel!.subscriptionPlanId!.isNotEmpty) {
                                                        if (Constant.userModel!.subscriptionTotalBookings == '0') {
                                                          Navigator.pop(context);
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return SubscriptionAlertDialog(
                                                                  title: "You can't accept more Rides.Upgrade your Plan.",
                                                                  cancelText: "Cancel",
                                                                  confirmText: "Upgrade",
                                                                  themeChange: themeChange,
                                                                );
                                                              });
                                                          // ShowToastDialog.showToast("You can't accept more Bookings.Upgrade your Plan.");
                                                          return;
                                                        }
                                                      }

                                                      if (Constant.userModel!.subscriptionExpiryDate != null && Constant.userModel!.subscriptionExpiryDate!.toDate().isBefore(DateTime.now())) {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SubscriptionAlertDialog(
                                                                title: "Your subscription has expired. Please renew your plan.",
                                                                cancelText: "Cancel",
                                                                confirmText: "Upgrade",
                                                                themeChange: themeChange,
                                                              );
                                                            });
                                                        // ShowToastDialog.showToast("Your subscription has expired. Please renew your plan.");
                                                        return;
                                                      }
                                                    }
                                                    VehicleTypeModel? vehicleModel = await FireStoreUtils.getVehicleTypeById(Constant.userModel!.driverVehicleDetails!.vehicleTypeId.toString());
                                                    controller.interCityModel.value.driverVehicleDetails = Constant.userModel!.driverVehicleDetails;
                                                    controller.interCityModel.value.vehicleType = vehicleModel;
                                                    controller.interCityModel.value.driverId = FireStoreUtils.getCurrentUid();
                                                    controller.interCityModel.value.bookingStatus = BookingStatus.bookingAccepted;
                                                    controller.interCityModel.value.updateAt = Timestamp.now();
                                                    FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
                                                      if (value == true) {
                                                        ShowToastDialog.showToast("Intercity Ride accepted successfully!".tr);
                                                        UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId.toString());
                                                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.interCityModel.value.id};

                                                        await SendNotification.sendOneNotification(
                                                            type: "order",
                                                            token: receiverUserModel!.fcmToken.toString(),
                                                            title: 'Your Intercity Ride is Accepted',
                                                            customerId: receiverUserModel.id,
                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                            bookingId: controller.interCityModel.value.id.toString(),
                                                            driverId: controller.interCityModel.value.driverId.toString(),
                                                            body: 'Your ride #${controller.interCityModel.value.id.toString().substring(0, 5)} has been confirmed.',
                                                            payload: playLoad);
                                                        if (Constant.isSubscriptionEnable == true &&
                                                            Constant.userModel!.subscriptionPlanId != null &&
                                                            Constant.userModel!.subscriptionPlanId!.isNotEmpty &&
                                                            Constant.userModel!.subscriptionTotalBookings != '0' &&
                                                            Constant.userModel!.subscriptionTotalBookings != '-1' &&
                                                            Constant.userModel!.subscriptionTotalBookings != null) {
                                                          int remainingBookings = int.parse(Constant.userModel!.subscriptionTotalBookings!) - 1;
                                                          Constant.userModel!.subscriptionTotalBookings = remainingBookings.toString();
                                                          await FireStoreUtils.updateDriverUser(Constant.userModel!);
                                                        }
                                                        Navigator.pop(context);
                                                      } else {
                                                        ShowToastDialog.showToast("Something went wrong!".tr);
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  negativeClick: () {
                                                    Navigator.pop(context);
                                                  },
                                                  positiveString: "Confirm".tr,
                                                  negativeString: "Cancel".tr,
                                                  themeChange: themeChange);
                                            },
                                          );
                                        } else {
                                          ShowToastDialog.showToast(
                                              "You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
                                        }
                                      },
                                      size: Size(0, 52),
                                    ),
                                  )
                                ],
                              )
                  },

                  if (controller.interCityModel.value.bookingStatus == BookingStatus.bookingAccepted && controller.interCityModel.value.driverId == FireStoreUtils.getCurrentUid()) ...{
                    Expanded(
                      child: RoundShapeButton(
                        title: "Cancel".tr,
                        buttonColor: AppThemData.grey50,
                        buttonTextColor: AppThemData.black,
                        onTap: () {
                          Get.to(() => ReasonForCancelInterCityView(
                                bookingInterCityModel: controller.interCityModel.value,
                              ));
                        },
                        size: Size(0, 52),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: RoundShapeButton(
                      title: "Pickup".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        Get.toNamed(Routes.ASK_FOR_OTP_INTERCITY, arguments: {
                          "bookingModel": controller.interCityModel.value,
                        });
                      },
                      size: Size(0, 52),
                    )),
                  },
                  if (controller.interCityModel.value.bookingStatus == BookingStatus.bookingOngoing) ...{
                    Expanded(
                      child: RoundShapeButton(
                        title: "Complete Ride".tr,
                        buttonColor: AppThemData.success500,
                        buttonTextColor: AppThemData.white,
                        onTap: () {
                          controller.getBookingDetails();
                          if (controller.interCityModel.value.paymentType != Constant.paymentModel!.cash!.name) {
                            if (controller.interCityModel.value.paymentStatus == true) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                      themeChange: themeChange,
                                      title: "Confirm Ride Completion".tr,
                                      descriptions: "Are you sure you want complete this ride?".tr,
                                      positiveString: "Complete".tr,
                                      negativeString: "Cancel".tr,
                                      positiveClick: () async {
                                        Navigator.pop(context);
                                        controller.completeInterCityBooking(controller.interCityModel.value);
                                        controller.getBookingDetails();
                                        Get.back();

                                        // Get.to(const HomeView());

                                        // Get.offAll(const HomeView());
                                      },
                                      negativeClick: () {
                                        Navigator.pop(context);
                                      },
                                      img: Icon(
                                        Icons.monetization_on,
                                        color: AppThemData.primary500,
                                        size: 40,
                                      ),
                                    );
                                  });
                            } else {
                              ShowToastDialog.showToast("Payment of this ride is Remaining From Customer".tr);
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    themeChange: themeChange,
                                    title: "Confirm Cash Payment".tr,
                                    descriptions: "Are you sure you want complete the ride with a cash payment?".tr,
                                    positiveString: "Complete".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      if (controller.interCityModel.value.paymentType == Constant.paymentModel!.cash!.name) {
                                        Navigator.pop(context);
                                        controller.interCityModel.value.paymentStatus = true;
                                        if (Constant.adminCommission != null && Constant.adminCommission!.active == true && num.parse(Constant.adminCommission!.value!) > 0) {
                                          WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
                                              id: Constant.getUuid(),
                                              amount:
                                                  "${Constant.calculateAdminCommission(amount: ((double.parse(controller.interCityModel.value.subTotal ?? '0.0')) - (double.parse(controller.interCityModel.value.discount ?? '0.0'))).toString(), adminCommission: controller.interCityModel.value.adminCommission)}",
                                              createdDate: Timestamp.now(),
                                              paymentType: "Wallet",
                                              transactionId: controller.interCityModel.value.id,
                                              isCredit: false,
                                              type: Constant.typeDriver,
                                              userId: controller.interCityModel.value.driverId,
                                              note: "Admin commission Debited".tr,
                                              adminCommission: controller.interCityModel.value.adminCommission);

                                          await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
                                            if (value == true) {
                                              await FireStoreUtils.updateDriverUserWallet(
                                                  amount:
                                                      "-${Constant.calculateAdminCommission(amount: ((double.parse(controller.interCityModel.value.subTotal ?? '0.0')) - (double.parse(controller.interCityModel.value.discount ?? '0.0'))).toString(), adminCommission: controller.interCityModel.value.adminCommission)}");
                                            }
                                          });
                                        }

                                        await FireStoreUtils.setInterCityBooking(controller.interCityModel.value).then((value) async {
                                          controller.completeInterCityBooking(controller.interCityModel.value);
                                          await FireStoreUtils.updateTotalEarning(
                                              amount: (double.parse(Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString()) -
                                                      double.parse(Constant.calculateAdminCommission(
                                                              amount: ((double.parse(controller.interCityModel.value.subTotal ?? '0.0')) -
                                                                      (double.parse(controller.interCityModel.value.discount ?? '0.0')))
                                                                  .toString(),
                                                              adminCommission: controller.interCityModel.value.adminCommission)
                                                          .toString()))
                                                  .toString());
                                          controller.getBookingDetails();
                                          Navigator.pop(context);
                                          Get.to(const HomeView());

                                          // Get.back();
                                          // Get.offAll(const HomeView());
                                        });
                                      } else {
                                        if (controller.interCityModel.value.paymentStatus == true) {
                                          controller.completeInterCityBooking(controller.interCityModel.value);
                                          controller.getBookingDetails();
                                          Navigator.pop(context);
                                          Get.to(const HomeView());
                                          // Get.back();
                                          // Get.offAll(const HomeView());
                                        } else {
                                          ShowToastDialog.showToast("Payment of this ride is remaining from Customer".tr);
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    negativeClick: () {
                                      Navigator.pop(context);
                                    },
                                    img: Icon(
                                      Icons.monetization_on,
                                      color: AppThemData.primary500,
                                      size: 40,
                                    ),
                                  );
                                });
                          }
                        },
                        size: Size(0, 52),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: RoundShapeButton(
                      title: "Track Ride".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        Get.to(() => TrackIntercityRideScreenView(), arguments: {"interCityModel": controller.interCityModel.value});
                      },
                      size: Size(0, 52),
                    )),
                  },
                  // if (controller.interCityModel.value.paymentStatus == true && controller.interCityModel.value.bookingStatus == BookingStatus.bookingCompleted)
                  //   SizedBox()
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => controller.getBookingDetails(),
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.interCityModel.value.bookingStatus == null) {
                    return Center(child: Text("No booking details available."));
                  }

                  return SingleChildScrollView(
                      child: controller.isLoading.value == true
                          ? Constant.loader()
                          : controller.interCityModel.value.bookingStatus == BookingStatus.bookingPlaced
                              ? controller.interCityModel.value.isPersonalRide == true
                                  ? Constant.isInterCityBid == true
                                      ? InterCityBidView()
                                      : IntercityDetailView()
                                  // : InterCityBidView()
                                  : Constant.isInterCitySharingBid == true
                                      ? InterCityBidView()
                                      : IntercityDetailView()
                              : IntercityDetailView());
                },
              ),
            ),
          );
        });
  }
}

class BidDialogBox extends StatelessWidget {
  BidDialogBox({
    super.key,
    required this.onPressConfirm,
    required this.onPressCancel,
    required this.themeChange,
  });

  final Function() onPressConfirm;
  final Function() onPressCancel;
  final DarkThemeProvider themeChange;

  final InterCityBookingDetailsController controller = Get.put(InterCityBookingDetailsController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Material(
          color: Colors.transparent,
          child: Wrap(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: Form(
                  key: controller.formKey.value, // ✅ Ensure FormKey is used
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/ic_Handshake.svg',
                        height: 52,
                        width: 52,
                        color: themeChange.isDarkTheme() ? AppThemData.grey200 : AppThemData.grey800,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter Bid Amount'.tr,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: themeChange.isDarkTheme() ? AppThemData.secondary900 : AppThemData.secondary100),
                        child: Text(
                          'Recommended Price For this Ride ${Constant.amountToShow(amount: controller.interCityModel.value.recommendedPrice)}',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: AppThemData.secondary500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        cursorColor: AppThemData.primary500,
                        controller: controller.enterBidAmountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Bid Amount'.tr;
                          }
                          return null; // ✅ No error if valid
                        },
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: "Enter Bid Amount".tr,
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppThemData.grey500,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppThemData.grey500),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppThemData.primary500, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: RoundShapeButton(
                              title: 'Cancel'.tr,
                              buttonColor: AppThemData.bookingCancelled,
                              buttonTextColor: AppThemData.white,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              size: const Size(100, 48),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: RoundShapeButton(
                              title: 'Bid'.tr,
                              buttonColor: AppThemData.primary500,
                              buttonTextColor: AppThemData.black,
                              onTap: () {
                                // ✅ Validate the form before proceeding
                                if (controller.formKey.value.currentState!.validate()) {
                                  onPressConfirm(); // Call the confirm function if valid
                                }
                              },
                              size: const Size(100, 48),
                            ),
                          ),
                        ],
                      ),
                    ],
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
