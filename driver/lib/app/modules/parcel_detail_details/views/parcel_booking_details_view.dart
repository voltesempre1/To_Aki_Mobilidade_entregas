// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/tax_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/booking_details/widget/price_row_view.dart';
import 'package:driver/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/reason_for_cancel_parcel/views/reason_for_cancel_parcel_view.dart';
import 'package:driver/app/modules/search_intercity_ride/controllers/search_ride_controller.dart';
import 'package:driver/app/modules/track_parcel_ride_screen/views/track_parcel_ride_screen_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/custom_loader.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/title_view.dart';
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
import '../controllers/parcel_booking_details_controller.dart';

class ParcelBookingDetailsView extends StatelessWidget {
  const ParcelBookingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ParcelBookingDetailsController(),
        builder: (controller) {
          bool shouldShowButton = controller.parcelModel.value.bidList?.any((bid) => bid.driverID == FireStoreUtils.getCurrentUid()) == false;
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(title: "Parcel Ride Detail".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (controller.parcelModel.value.bookingStatus == BookingStatus.bookingPlaced) ...{
                    Constant.isParcelBid == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RoundShapeButton(
                                  title: "Cancel Ride".tr,
                                  buttonColor: AppThemData.danger500,
                                  buttonTextColor: AppThemData.white,
                                  onTap: () {
                                    Get.to(() => ReasonForCancelParcelView(
                                          bookingInterCityModel: controller.parcelModel.value,
                                        ));
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
                                                List rejectedId = controller.parcelModel.value.rejectedDriverId ?? [];
                                                rejectedId.add(FireStoreUtils.getCurrentUid());
                                                controller.parcelModel.value.bookingStatus = BookingStatus.bookingRejected;
                                                controller.parcelModel.value.rejectedDriverId = rejectedId;
                                                controller.parcelModel.value.updateAt = Timestamp.now();
                                                FireStoreUtils.setParcelBooking(controller.parcelModel.value).then((value) async {
                                                  if (value == true) {
                                                    ShowToastDialog.showToast("Parcel ride cancelled successfully!".tr);
                                                    // DriverUserModel? driverModel =
                                                    //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.parcelModel.value.customerId.toString());
                                                    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.parcelModel.value.id};
                                                    await SendNotification.sendOneNotification(
                                                        type: "order",
                                                        token: receiverUserModel!.fcmToken.toString(),
                                                        title: 'Your Parcel Ride is Rejected',
                                                        customerId: receiverUserModel.id,
                                                        senderId: FireStoreUtils.getCurrentUid(),
                                                        bookingId: controller.parcelModel.value.id.toString(),
                                                        driverId: controller.parcelModel.value.driverId.toString(),
                                                        body: 'Your ride #${controller.parcelModel.value.id.toString().substring(0, 5)} has been Rejected by Driver.',
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
                                              title: "Confirm Parcel Ride Request".tr,
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
                                                      Get.back();
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return SubscriptionAlertDialog(
                                                              title: "You can't accept more Bookings.Upgrade your Plan.",
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
                                                    Get.back();
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
                                                controller.parcelModel.value.driverVehicleDetails = Constant.userModel!.driverVehicleDetails;
                                                controller.parcelModel.value.vehicleType = vehicleModel;
                                                controller.parcelModel.value.driverId = FireStoreUtils.getCurrentUid();
                                                controller.parcelModel.value.bookingStatus = BookingStatus.bookingAccepted;
                                                controller.parcelModel.value.updateAt = Timestamp.now();
                                                FireStoreUtils.setParcelBooking(controller.parcelModel.value).then((value) async {
                                                  if (value == true) {
                                                    ShowToastDialog.showToast("Parcel Ride accepted successfully!".tr);
                                                    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(controller.parcelModel.value.customerId.toString());
                                                    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.parcelModel.value.id};

                                                    if (controller.isSearch.value == true) {
                                                      SearchRideController searchController = Get.put(SearchRideController());
                                                      searchController.searchParcelList.removeWhere((parcel) => parcel.id == controller.parcelModel.value.id);
                                                      searchController.parcelBookingList.removeWhere((parcel) => parcel.id == controller.parcelModel.value.id);
                                                      ShowToastDialog.closeLoader();
                                                    }

                                                    await SendNotification.sendOneNotification(
                                                        type: "order",
                                                        token: receiverUserModel!.fcmToken.toString(),
                                                        title: 'Your Parcel Ride is Accepted',
                                                        customerId: receiverUserModel.id,
                                                        senderId: FireStoreUtils.getCurrentUid(),
                                                        bookingId: controller.parcelModel.value.id.toString(),
                                                        driverId: controller.parcelModel.value.driverId.toString(),
                                                        body: 'Your ride #${controller.parcelModel.value.id.toString().substring(0, 5)} has been confirmed.',
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
                        : shouldShowButton != true
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
                  },
                  if (
                      // controller.parcelModel.value.bookingStatus == BookingStatus.bookingAccepted
                      controller.parcelModel.value.bookingStatus == BookingStatus.bookingAccepted && controller.parcelModel.value.driverId == FireStoreUtils.getCurrentUid()) ...{
                    Expanded(
                      child: RoundShapeButton(
                        title: "Cancel".tr,
                        buttonColor: AppThemData.grey50,
                        buttonTextColor: AppThemData.black,
                        onTap: () {
                          Get.to(() => ReasonForCancelParcelView(
                                bookingInterCityModel: controller.parcelModel.value,
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
                        Get.toNamed(Routes.ASK_FOR_OTP_PARCEL, arguments: {
                          "bookingModel": controller.parcelModel.value,
                        });
                      },
                      size: Size(0, 52),
                    )),
                  },
                  if (controller.parcelModel.value.bookingStatus == BookingStatus.bookingOngoing) ...{
                    Expanded(
                        child: RoundShapeButton(
                      title: "Complete Ride".tr,
                      buttonColor: AppThemData.success500,
                      buttonTextColor: AppThemData.white,
                      onTap: () {
                        controller.getBookingDetails();
                        if (controller.parcelModel.value.paymentType != Constant.paymentModel!.cash!.name) {
                          if (controller.parcelModel.value.paymentStatus == true) {
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
                                      controller.completeInterCityBooking(controller.parcelModel.value);
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
                                    if (controller.parcelModel.value.paymentType == Constant.paymentModel!.cash!.name) {
                                      Navigator.pop(context);
                                      controller.parcelModel.value.paymentStatus = true;
                                      if (Constant.adminCommission != null && Constant.adminCommission!.active == true && num.parse(Constant.adminCommission!.value!) > 0) {
                                        WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
                                            id: Constant.getUuid(),
                                            amount:
                                                "${Constant.calculateAdminCommission(amount: ((double.parse(controller.parcelModel.value.subTotal ?? '0.0')) - (double.parse(controller.parcelModel.value.discount ?? '0.0'))).toString(), adminCommission: controller.parcelModel.value.adminCommission)}",
                                            createdDate: Timestamp.now(),
                                            paymentType: "Wallet",
                                            transactionId: controller.parcelModel.value.id,
                                            isCredit: false,
                                            type: Constant.typeDriver,
                                            userId: controller.parcelModel.value.driverId,
                                            note: "Admin commission Debited",
                                            adminCommission: controller.parcelModel.value.adminCommission);
                                        await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
                                          if (value == true) {
                                            await FireStoreUtils.updateDriverUserWallet(
                                                amount:
                                                    "-${Constant.calculateAdminCommission(amount: ((double.parse(controller.parcelModel.value.subTotal ?? '0.0')) - (double.parse(controller.parcelModel.value.discount ?? '0.0'))).toString(), adminCommission: controller.parcelModel.value.adminCommission)}");
                                          }
                                        });
                                      }

                                      await FireStoreUtils.setParcelBooking(controller.parcelModel.value).then((value) async {
                                        controller.completeInterCityBooking(controller.parcelModel.value);
                                        await FireStoreUtils.updateTotalEarning(
                                            amount: (double.parse(Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString()) -
                                                    double.parse(Constant.calculateAdminCommission(
                                                            amount: ((double.parse(controller.parcelModel.value.subTotal ?? '0.0')) - (double.parse(controller.parcelModel.value.discount ?? '0.0')))
                                                                .toString(),
                                                            adminCommission: controller.parcelModel.value.adminCommission)
                                                        .toString()))
                                                .toString());
                                        controller.getBookingDetails();
                                        Navigator.pop(context);
                                        Get.to(const HomeView());

                                        // Get.back();
                                        // Get.offAll(const HomeView());
                                      });
                                    } else {
                                      if (controller.parcelModel.value.paymentStatus == true) {
                                        controller.completeInterCityBooking(controller.parcelModel.value);
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
                    )),
                    SizedBox(width: 12),
                    Expanded(
                        child: RoundShapeButton(
                      title: "Track Ride".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        Get.toNamed(Routes.TRACK_PARCEL_RIDE_SCREEN, arguments: {"parcelModel": controller.parcelModel.value});
                      },
                      size: Size(0, 52),
                    )),
                  },
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

                  if (controller.parcelModel.value.bookingStatus == null) {
                    return Center(child: Text("No booking details available.".tr));
                  }

                  return SingleChildScrollView(
                    child: controller.isLoading.value == true
                        ? Constant.loader()
                        : controller.parcelModel.value.bookingStatus == BookingStatus.bookingPlaced && Constant.isParcelBid == true
                            ? Column(
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
                                              controller.parcelModel.value.bookingTime == null ? "" : controller.parcelModel.value.bookingTime!.toDate().dateMonthYear(),
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
                                                controller.parcelModel.value.bookingTime == null ? "" : controller.parcelModel.value.bookingTime!.toDate().time(),
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Icon(
                                            //   Icons.keyboard_arrow_right_sharp,
                                            //   color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                            // )
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
                                              FutureBuilder<UserModel?>(
                                                  future: FireStoreUtils.getUserProfile(controller.parcelModel.value.customerId ?? ''),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Container();
                                                    }
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      CustomLoader();
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
                                                        imageUrl: (customerModel.profilePic != null && customerModel.profilePic!.isNotEmpty) ? customerModel.profilePic! : Constant.profileConstant,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Center(
                                                          child: CustomLoader(),
                                                        ),
                                                        errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                                      ),
                                                    );
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
                                                    //       image: CachedNetworkImageProvider(
                                                    //         (Constant.userModel?.profilePic == null || Constant.userModel!.profilePic!.isEmpty)
                                                    //             ? Constant.profileConstant
                                                    //             : Constant.userModel!.profilePic.toString(),
                                                    //       ),
                                                    //       fit: BoxFit.cover,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  }),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'ID: ${controller.parcelModel.value.id!.substring(0, 5)}',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Ride Start Date: ${Constant.formatDate(Constant.parseDate(controller.parcelModel.value.startDate))}',
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
                                                    Constant.amountToShow(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString()),
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
                                                        '${controller.parcelModel.value.weight}',
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
                                                pickUpAddress: controller.parcelModel.value.pickUpLocationAddress ?? '', dropAddress: controller.parcelModel.value.dropLocationAddress ?? ''),
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
                                      () {
                                        BidModel? driverBid = controller.parcelModel.value.bidList!.firstWhereOrNull((bid) => bid.driverID == FireStoreUtils.getCurrentUid());
                                        return Column(
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
                                            driverBid == null
                                                ? Center(
                                                    child: Text(
                                                      'No Available Any Bid'.tr,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                : FutureBuilder<DriverUserModel?>(
                                                    future: FireStoreUtils.getDriverUserProfile(driverBid.driverID ?? ''),
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
                                                                side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // const SizedBox(height: 12),
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
                                                                          // imageUrl: (  Constant.userModel!.profilePic =='' || Constant.userModel!.profilePic == null) ? Constant.profileConstant : Constant.userModel!.profilePic.toString(),
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
                                                                                Constant.calculateReview(reviewCount: driverUserModel.reviewsCount, reviewSum: driverUserModel.reviewsSum).toString(),
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
                                                                    driverBid.bidStatus == 'close'
                                                                        ? Container(
                                                                            width: 77,
                                                                            height: 32,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2000), color: AppThemData.danger50),
                                                                            alignment: Alignment.center,
                                                                            child: Text(
                                                                              'Closed',
                                                                              style: GoogleFonts.inter(
                                                                                color: AppThemData.danger500,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            width: 77,
                                                                            height: 32,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2000), color: AppThemData.success50),
                                                                            alignment: Alignment.center,
                                                                            child: Text(
                                                                              'Active',
                                                                              style: GoogleFonts.inter(
                                                                                color: AppThemData.success500,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 8),
                                                                // Row(
                                                                //   mainAxisAlignment: MainAxisAlignment.start,
                                                                //   children: [
                                                                //     SvgPicture.asset(
                                                                //       "assets/icon/ic_map.svg",
                                                                //     ),
                                                                //     const SizedBox(width: 8),
                                                                //     // SvgPicture.asset(
                                                                //     //   "assets/icon/ic_ride.svg",
                                                                //     // ),
                                                                //     Text(
                                                                //       '2km away from your destination location'.tr,
                                                                //       style: GoogleFonts.inter(
                                                                //         color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                //         fontSize: 12,
                                                                //         fontWeight: FontWeight.w400,
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                                // const SizedBox(height: 4),
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
                                                                          Constant.amountToShow(amount: driverBid.amount),
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
                                                    }),
                                            // controller.parcelModel.value
                                            //         .bidList!.isEmpty
                                            //     ? Center(
                                            //         child: Text(
                                            //           'No Available Any Bid'
                                            //               .tr,
                                            //           style:
                                            //               GoogleFonts.inter(
                                            //             color: themeChange
                                            //                     .isDarkTheme()
                                            //                 ? AppThemData
                                            //                     .grey25
                                            //                 : AppThemData
                                            //                     .grey950,
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //                 FontWeight.w500,
                                            //           ),
                                            //         ),
                                            //       )
                                            //     : ListView.builder(
                                            //         itemCount: controller
                                            //             .parcelModel
                                            //             .value
                                            //             .bidList!
                                            //             .length,
                                            //         shrinkWrap: true,
                                            //         physics:
                                            //             NeverScrollableScrollPhysics(),
                                            //         // scrollDirection: Axis.vertical,
                                            //         itemBuilder:
                                            //             (contex, index) {
                                            //           BidModel bidModel =
                                            //               controller
                                            //                       .parcelModel
                                            //                       .value
                                            //                       .bidList![
                                            //                   index];
                                            //           return FutureBuilder<
                                            //                   DriverUserModel?>(
                                            //               future: FireStoreUtils
                                            //                   .getDriverUserProfile(
                                            //                       bidModel.driverID ??
                                            //                           ''),
                                            //               builder: (context,
                                            //                   snapshot) {
                                            //                 if (!snapshot
                                            //                     .hasData) {
                                            //                   return Container();
                                            //                 }
                                            //                 DriverUserModel
                                            //                     driverUserModel =
                                            //                     snapshot.data ??
                                            //                         DriverUserModel();
                                            //                 return Column(
                                            //                   crossAxisAlignment:
                                            //                       CrossAxisAlignment
                                            //                           .start,
                                            //                   children: [
                                            //                     Container(
                                            //                       width: Responsive
                                            //                           .width(
                                            //                               100,
                                            //                               context),
                                            //                       padding:
                                            //                           const EdgeInsets
                                            //                               .all(
                                            //                               16),
                                            //                       margin: const EdgeInsets
                                            //                           .only(
                                            //                           bottom:
                                            //                               14),
                                            //                       decoration:
                                            //                           ShapeDecoration(
                                            //                         shape:
                                            //                             RoundedRectangleBorder(
                                            //                           side: BorderSide(
                                            //                               width:
                                            //                                   1,
                                            //                               color: themeChange.isDarkTheme()
                                            //                                   ? AppThemData.grey800
                                            //                                   : AppThemData.grey100),
                                            //                           borderRadius:
                                            //                               BorderRadius.circular(12),
                                            //                         ),
                                            //                       ),
                                            //                       child:
                                            //                           Column(
                                            //                         mainAxisSize:
                                            //                             MainAxisSize
                                            //                                 .min,
                                            //                         mainAxisAlignment:
                                            //                             MainAxisAlignment
                                            //                                 .start,
                                            //                         crossAxisAlignment:
                                            //                             CrossAxisAlignment
                                            //                                 .start,
                                            //                         children: [
                                            //                           // const SizedBox(height: 12),
                                            //                           Row(
                                            //                             mainAxisSize:
                                            //                                 MainAxisSize.min,
                                            //                             mainAxisAlignment:
                                            //                                 MainAxisAlignment.start,
                                            //                             crossAxisAlignment:
                                            //                                 CrossAxisAlignment.center,
                                            //                             children: [
                                            //                               SizedBox(
                                            //                                 height: 48,
                                            //                                 width: 48,
                                            //                                 child: ClipRRect(
                                            //                                   borderRadius: BorderRadius.circular(2000),
                                            //                                   child: CachedNetworkImage(
                                            //                                     // imageUrl: (  Constant.userModel!.profilePic =='' || Constant.userModel!.profilePic == null) ? Constant.profileConstant : Constant.userModel!.profilePic.toString(),
                                            //                                     imageUrl: (driverUserModel.profilePic != null && driverUserModel.profilePic!.isNotEmpty) ? driverUserModel.profilePic! : Constant.profileConstant,
                                            //                                     fit: BoxFit.cover,
                                            //                                     placeholder: (context, url) => Constant.loader(),
                                            //                                     errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                            //                                   ),
                                            //                                 ),
                                            //                               ),
                                            //                               const SizedBox(width: 12),
                                            //                               Expanded(
                                            //                                 child: Column(
                                            //                                   mainAxisSize: MainAxisSize.min,
                                            //                                   mainAxisAlignment: MainAxisAlignment.center,
                                            //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                            //                                   children: [
                                            //                                     Text(
                                            //                                       '${driverUserModel.fullName}',
                                            //                                       style: GoogleFonts.inter(
                                            //                                         color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            //                                         fontSize: 14,
                                            //                                         fontWeight: FontWeight.w600,
                                            //                                       ),
                                            //                                     ),
                                            //                                     const SizedBox(height: 2),
                                            //                                     Row(
                                            //                                       mainAxisAlignment: MainAxisAlignment.start,
                                            //                                       crossAxisAlignment: CrossAxisAlignment.center,
                                            //                                       children: [
                                            //                                         const Icon(Icons.star_rate_rounded, color: AppThemData.warning500),
                                            //                                         Text(
                                            //                                           Constant.calculateReview(reviewCount: driverUserModel.reviewsCount, reviewSum: driverUserModel.reviewsSum).toString(),
                                            //                                           // driverUserModel.reviewsSum ?? '0.0',
                                            //                                           style: GoogleFonts.inter(
                                            //                                             color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            //                                             fontSize: 14,
                                            //                                             fontWeight: FontWeight.w400,
                                            //                                           ),
                                            //                                         ),
                                            //                                       ],
                                            //                                     ),
                                            //                                   ],
                                            //                                 ),
                                            //                               ),
                                            //                               const SizedBox(width: 16),
                                            //                               bidModel.bidStatus == 'close'
                                            //                                   ? Container(
                                            //                                       width: 77,
                                            //                                       height: 32,
                                            //                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(2000), color: AppThemData.danger50),
                                            //                                       alignment: Alignment.center,
                                            //                                       child: Text(
                                            //                                         'Closed',
                                            //                                         style: GoogleFonts.inter(
                                            //                                           color: AppThemData.danger500,
                                            //                                           fontSize: 16,
                                            //                                           fontWeight: FontWeight.w400,
                                            //                                         ),
                                            //                                       ),
                                            //                                     )
                                            //                                   : Container(
                                            //                                       width: 77,
                                            //                                       height: 32,
                                            //                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(2000), color: AppThemData.success50),
                                            //                                       alignment: Alignment.center,
                                            //                                       child: Text(
                                            //                                         'Active',
                                            //                                         style: GoogleFonts.inter(
                                            //                                           color: AppThemData.success500,
                                            //                                           fontSize: 16,
                                            //                                           fontWeight: FontWeight.w400,
                                            //                                         ),
                                            //                                       ),
                                            //                                     )
                                            //                             ],
                                            //                           ),
                                            //                           const SizedBox(
                                            //                               height:
                                            //                                   8),
                                            //                           // Row(
                                            //                           //   mainAxisAlignment: MainAxisAlignment.start,
                                            //                           //   children: [
                                            //                           //     SvgPicture.asset(
                                            //                           //       "assets/icon/ic_map.svg",
                                            //                           //     ),
                                            //                           //     const SizedBox(width: 8),
                                            //                           //     // SvgPicture.asset(
                                            //                           //     //   "assets/icon/ic_ride.svg",
                                            //                           //     // ),
                                            //                           //     Text(
                                            //                           //       '2km away from your destination location'.tr,
                                            //                           //       style: GoogleFonts.inter(
                                            //                           //         color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            //                           //         fontSize: 12,
                                            //                           //         fontWeight: FontWeight.w400,
                                            //                           //       ),
                                            //                           //     ),
                                            //                           //   ],
                                            //                           // ),
                                            //                           // const SizedBox(height: 4),
                                            //                           Divider(),
                                            //                           const SizedBox(
                                            //                               height:
                                            //                                   6),
                                            //                           Row(
                                            //                             mainAxisAlignment:
                                            //                                 MainAxisAlignment.spaceBetween,
                                            //                             children: [
                                            //                               Row(
                                            //                                 children: [
                                            //                                   SvgPicture.asset(
                                            //                                     "assets/icon/ic_ride.svg",
                                            //                                   ),
                                            //                                   const SizedBox(width: 8),
                                            //                                   Text(
                                            //                                     '${driverUserModel.driverVehicleDetails!.brandName}'.tr,
                                            //                                     style: GoogleFonts.inter(
                                            //                                       color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            //                                       fontSize: 12,
                                            //                                       fontWeight: FontWeight.w400,
                                            //                                     ),
                                            //                                   ),
                                            //                                 ],
                                            //                               ),
                                            //                               Row(
                                            //                                 children: [
                                            //                                   // SvgPicture.asset(
                                            //                                   //   "assets/icon/ic_ride.svg",
                                            //                                   // ),
                                            //                                   // const SizedBox(width: 8),
                                            //                                   Text(
                                            //                                     Constant.amountToShow(amount: bidModel.amount),
                                            //                                     style: GoogleFonts.inter(
                                            //                                       color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            //                                       fontSize: 14,
                                            //                                       fontWeight: FontWeight.w500,
                                            //                                     ),
                                            //                                   ),
                                            //                                 ],
                                            //                               ),
                                            //                               Row(
                                            //                                 children: [
                                            //                                   SvgPicture.asset(
                                            //                                     "assets/icon/ic_number.svg",
                                            //                                   ),
                                            //                                   const SizedBox(width: 8),
                                            //                                   Text(
                                            //                                     '${driverUserModel.driverVehicleDetails!.vehicleNumber}'.tr,
                                            //                                     style: GoogleFonts.inter(
                                            //                                       color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            //                                       fontSize: 12,
                                            //                                       fontWeight: FontWeight.w400,
                                            //                                     ),
                                            //                                   ),
                                            //                                 ],
                                            //                               )
                                            //                             ],
                                            //                           )
                                            //                         ],
                                            //                       ),
                                            //                     )
                                            //                   ],
                                            //                 );
                                            //               });
                                            //         }),
                                            // shouldShowButton != true ? SizedBox(height: 50,) : SizedBox(height: 50,),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: controller.isLoading.value == true
                                    ? Constant.loader()
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Ride Status'.tr,
                                                  style: GoogleFonts.inter(
                                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                BookingStatus.getBookingStatusTitle(controller.parcelModel.value.bookingStatus ?? ''),
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.inter(
                                                  color: BookingStatus.getBookingStatusTitleColor(controller.parcelModel.value.bookingStatus ?? ''),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder<UserModel?>(
                                              future: FireStoreUtils.getUserProfile(controller.parcelModel.value.customerId ?? ''),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                UserModel customerModel = snapshot.data ?? UserModel();
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TitleView(titleText: 'Customer Details'.tr, padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                                                    Container(
                                                      width: Responsive.width(100, context),
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: ShapeDecoration(
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: 44,
                                                            height: 44,
                                                            margin: const EdgeInsets.only(right: 10),
                                                            clipBehavior: Clip.antiAlias,
                                                            decoration: ShapeDecoration(
                                                              color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(200),
                                                              ),
                                                              image: DecorationImage(
                                                                image: NetworkImage(customerModel.profilePic != null
                                                                    ? customerModel.profilePic!.isNotEmpty
                                                                        ? customerModel.profilePic ?? Constant.profileConstant
                                                                        : Constant.profileConstant
                                                                    : Constant.profileConstant),
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              customerModel.fullName ?? '',
                                                              style: GoogleFonts.inter(
                                                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                Get.to(() => ChatScreenView(
                                                                      receiverId: controller.parcelModel.value.customerId ?? '',
                                                                    ));
                                                              },
                                                              child: SvgPicture.asset("assets/icon/ic_message.svg")),
                                                          const SizedBox(width: 12),
                                                          InkWell(
                                                              onTap: () {
                                                                Constant().launchCall("${customerModel.countryCode}${customerModel.phoneNumber}");
                                                              },
                                                              child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                  ],
                                                );
                                              }),
                                          PickDropPointView(
                                            pickUpAddress: controller.parcelModel.value.pickUpLocationAddress ?? '',
                                            dropAddress: controller.parcelModel.value.dropLocationAddress ?? '',
                                            parcelModel: controller.parcelModel.value,
                                            isDirectionIconShown: true,
                                            onDirectionTap: () {
                                              Get.to(() => TrackParcelRideScreenView(), arguments: {"parcelModel": controller.parcelModel.value});
                                            },
                                          ),
                                          TitleView(titleText: 'Ride Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                                          Container(
                                            width: Responsive.width(100, context),
                                            padding: const EdgeInsets.all(16),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/ic_calendar.svg",
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        'Date'.tr,
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.parcelModel.value.bookingTime == null ? "" : Constant.formatDate(Constant.parseDate(controller.parcelModel.value.startDate)),
                                                      textAlign: TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0.11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                const Divider(),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/ic_time.svg",
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        'Time'.tr,
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.parcelModel.value.rideStartTime.toString(),
                                                      textAlign: TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0.11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                const Divider(),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/ic_distance.svg",
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        'Distance'.tr,
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${double.parse(controller.parcelModel.value.distance!.distance!).toStringAsFixed(2)} ${controller.parcelModel.value.distance!.distanceType!}',
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                const Divider(),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/ic_weight.svg",
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        'Weight'.tr,
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.parcelModel.value.weight.toString(),
                                                      textAlign: TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0.11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                const Divider(),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/ic_time.svg",
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        'Dimension'.tr,
                                                        style: GoogleFonts.inter(
                                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.parcelModel.value.dimension.toString(),
                                                      textAlign: TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        height: 0.11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          TitleView(titleText: 'Price Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 0)),
                                          Container(
                                            width: Responsive.width(100, context),
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.only(top: 12),
                                            decoration: ShapeDecoration(
                                              color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Obx(
                                              () => Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  PriceRowView(
                                                    price: Constant.amountToShow(
                                                      amount: controller.parcelModel.value.subTotal.toString(),
                                                    ),
                                                    title: "Amount".tr,
                                                    priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                    titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  PriceRowView(
                                                      price: Constant.amountToShow(amount: controller.parcelModel.value.discount ?? '0.0'),
                                                      title: "Discount".tr,
                                                      priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                                  const SizedBox(height: 16),
                                                  ListView.builder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: controller.parcelModel.value.taxList!.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (context, index) {
                                                      TaxModel taxModel = controller.parcelModel.value.taxList![index];
                                                      return Column(
                                                        children: [
                                                          PriceRowView(
                                                              price: Constant.amountToShow(
                                                                  amount:
                                                                      Constant.calculateTax(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString(), taxModel: taxModel)
                                                                          .toString()),
                                                              title: "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                              priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                              titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                                          const SizedBox(height: 16),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Divider(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                                  const SizedBox(height: 12),
                                                  PriceRowView(
                                                    price: Constant.amountToShow(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString()),
                                                    title: "Total Amount".tr,
                                                    priceColor: AppThemData.primary500,
                                                    titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TitleView(titleText: 'Parcel Image'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              height: 180,
                                              width: Responsive.width(100, context),
                                              imageUrl: (controller.parcelModel.value.parcelImage != null && controller.parcelModel.value.parcelImage!.isNotEmpty)
                                                  ? controller.parcelModel.value.parcelImage!
                                                  : Constant.profileConstant,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) => Center(
                                                child: CustomLoader(),
                                              ),
                                              errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                            ),
                                          ),
                                          TitleView(titleText: 'Payment Method'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                                          Container(
                                            width: Responsive.width(100, context),
                                            height: 56,
                                            padding: const EdgeInsets.all(16),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                (controller.parcelModel.value.paymentType == Constant.paymentModel!.cash!.name)
                                                    ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                                    : (controller.parcelModel.value.paymentType == Constant.paymentModel!.wallet!.name)
                                                        ? SvgPicture.asset(
                                                            "assets/icon/ic_wallet.svg",
                                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                          )
                                                        : (controller.parcelModel.value.paymentType == Constant.paymentModel!.paypal!.name)
                                                            ? Image.asset("assets/images/ig_paypal.png", height: 24, width: 24)
                                                            : (controller.parcelModel.value.paymentType == Constant.paymentModel!.strip!.name)
                                                                ? Image.asset("assets/images/ig_stripe.png", height: 24, width: 24)
                                                                : (controller.parcelModel.value.paymentType == Constant.paymentModel!.razorpay!.name)
                                                                    ? Image.asset("assets/images/ig_razorpay.png", height: 24, width: 24)
                                                                    : (controller.parcelModel.value.paymentType == Constant.paymentModel!.payStack!.name)
                                                                        ? Image.asset("assets/images/ig_paystack.png", height: 24, width: 24)
                                                                        : (controller.parcelModel.value.paymentType == Constant.paymentModel!.mercadoPago!.name)
                                                                            ? Image.asset("assets/images/ig_marcadopago.png", height: 24, width: 24)
                                                                            : (controller.parcelModel.value.paymentType == Constant.paymentModel!.payFast!.name)
                                                                                ? Image.asset("assets/images/ig_payfast.png", height: 24, width: 24)
                                                                                : (controller.parcelModel.value.paymentType == Constant.paymentModel!.flutterWave!.name)
                                                                                    ? Image.asset("assets/images/ig_flutterwave.png", height: 24, width: 24)
                                                                                    : const SizedBox(height: 24, width: 24),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    controller.parcelModel.value.paymentType ?? '',
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                  );
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

  final ParcelBookingDetailsController controller = Get.put(ParcelBookingDetailsController());

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
                          'Recommended Price For this Ride ${Constant.amountToShow(amount: controller.parcelModel.value.recommendedPrice)}',
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
