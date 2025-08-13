// ignore_for_file: use_build_context_synchronously


import 'package:cached_network_image/cached_network_image.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/booking_details/views/booking_details_view.dart';
import 'package:driver/app/modules/reason_for_cancel_cab/views/reason_for_cancel_cab_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
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

class NewRideView extends StatelessWidget {
  final BookingModel? bookingModel;

  const NewRideView({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: () {
        Get.to(() => const BookingDetailsView(), arguments: {"bookingModel": bookingModel!});
      },
      child: Container(
        // width: Responsive.width(100, context),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
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
                  bookingModel == null ? "" : bookingModel!.bookingTime!.toDate().dateMonthYear(),
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
                    bookingModel == null ? "" : bookingModel!.bookingTime!.toDate().time(),
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_right_sharp,
                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
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
                  CachedNetworkImage(
                    imageUrl: bookingModel == null ? Constant.profileConstant : bookingModel!.vehicleType!.image,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookingModel == null ? "" : bookingModel!.vehicleType!.title,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (bookingModel!.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
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
                        bookingModel == null ? "" : Constant.amountShow(amount: Constant.calculateFinalAmount(bookingModel!).toStringAsFixed(2)),
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
                            bookingModel == null ? "" : bookingModel!.vehicleType!.persons,
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
            PickDropPointView(pickUpAddress: bookingModel == null ? "" : bookingModel!.pickUpLocationAddress ?? '', dropAddress: bookingModel == null ? "" : bookingModel!.dropLocationAddress ?? ''),
            if ((((bookingModel!.bookingStatus ?? '') == BookingStatus.bookingPlaced) || ((bookingModel!.bookingStatus ?? '') == BookingStatus.driverAssigned)) &&
                !bookingModel!.rejectedDriverId!.contains(FireStoreUtils.getCurrentUid())) ...{
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundShapeButton(
                    title: "Cancel Ride",
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
                                  List rejectedId = bookingModel!.rejectedDriverId ?? [];
                                  rejectedId.add(FireStoreUtils.getCurrentUid());
                                  bookingModel!.bookingStatus = BookingStatus.bookingRejected;
                                  bookingModel!.rejectedDriverId = rejectedId;
                                  bookingModel!.updateAt = Timestamp.now();
                                  FireStoreUtils.setBooking(bookingModel!).then((value) async {
                                    if (value == true) {
                                      ShowToastDialog.showToast("Ride cancelled successfully!");
                                      DriverUserModel? driverModel = await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                      driverModel!.bookingId = "";
                                      driverModel.status = "free";
                                      FireStoreUtils.updateDriverUser(driverModel);

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
                  RoundShapeButton(
                    title: "Accept".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () {
                      double walletAmount = double.tryParse(Constant.userModel?.walletAmount.toString() ?? '0') ?? 0;
                      double minRequired = double.tryParse(Constant.minimumAmountToAcceptRide.toString()) ?? 0;

                      if (walletAmount < 0) {
                        ShowToastDialog.showToast("Your wallet balance is negative. You cannot accept a ride.");
                      } else if (minRequired == 0 || walletAmount >= minRequired) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialogBox(
                                title: "Confirm Ride Request",
                                descriptions: "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.",
                                img: Image.asset(
                                  "assets/icon/ic_green_right.png",
                                  height: 58,
                                  width: 58,
                                ),
                                positiveClick: () {
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

                                  bookingModel!.driverId = FireStoreUtils.getCurrentUid();
                                  bookingModel!.bookingStatus = BookingStatus.bookingAccepted;
                                  bookingModel!.updateAt = Timestamp.now();
                                  FireStoreUtils.setBooking(bookingModel!).then((value) async {
                                    if (value == true) {
                                      ShowToastDialog.showToast("Ride accepted successfully!");

                                      UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel!.customerId.toString());
                                      Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel!.id};

                                      await SendNotification.sendOneNotification(
                                          type: "order",
                                          token: receiverUserModel!.fcmToken.toString(),
                                          title: 'Your Ride is Accepted',
                                          customerId: receiverUserModel.id,
                                          senderId: FireStoreUtils.getCurrentUid(),
                                          bookingId: bookingModel!.id.toString(),
                                          driverId: bookingModel!.driverId.toString(),
                                          body: 'Your ride #${bookingModel!.id.toString().substring(0, 4)} has been confirmed.',
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
                    size: Size(Responsive.width(40, context), 42),
                  )
                ],
              )
            },
            if ((bookingModel!.bookingStatus ?? '') == BookingStatus.bookingAccepted &&
                !bookingModel!.rejectedDriverId!.contains(FireStoreUtils.getCurrentUid()) &&
                bookingModel!.driverId!.contains(FireStoreUtils.getCurrentUid())) ...{
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundShapeButton(
                    title: "Cancel Ride",
                    buttonColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                    buttonTextColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                    onTap: () {
                      Get.to(() => ReasonForCancelCabView(
                            bookingModel: bookingModel ?? BookingModel(),
                          ));
                    },
                    size: Size(Responsive.width(40, context), 42),
                  ),
                  RoundShapeButton(
                    title: "Pickup",
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () {
                      Get.toNamed(Routes.ASK_FOR_OTP, arguments: {"bookingModel": bookingModel!});
                    },
                    size: Size(Responsive.width(40, context), 42),
                  )
                ],
              )
            }
          ],
        ),
      ),
    );
  }
}
