// ignore_for_file: deprecated_member_use

import 'package:customer/app/modules/reason_for_intercity_cancel/views/intercity_reason_for_cancel_view.dart';
import 'package:customer/app/modules/review_screen/views/review_screen_view.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/intercity_ride_details_controller.dart';
import 'widgets/intercity_bid_widget_view.dart';
import 'widgets/intercity_details_widget_view.dart';
import 'widgets/intercity_payment_dialog_view.dart';

class InterCityRideDetailsView extends GetView<InterCityRideDetailsController> {
  const InterCityRideDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: InterCityRideDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Intercity Ride Details".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            bottomNavigationBar: controller.interCityModel.value.bookingStatus != BookingStatus.bookingPlaced
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () async {
                                if (controller.interCityModel.value.paymentStatus != true && controller.interCityModel.value.bookingStatus == BookingStatus.bookingOngoing) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    isDismissible: true,
                                    enableDrag: true,
                                    constraints: BoxConstraints(maxHeight: Responsive.height(90, context), maxWidth: Responsive.width(100, context)),
                                    builder: (BuildContext context) {
                                      return const InterCityPaymentDialogView();
                                    },
                                  );
                                }
                              },
                              child: Obx(
                                () => Container(
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
                                      // controller.selectedPaymentMethod.value == Constant.paymentModel!.cash!.name
                                      //     ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                      //     : SvgPicture.asset("assets/icon/ic_cash.svg"),
                                      (controller.selectedPaymentMethod.value == Constant.paymentModel!.cash!.name)
                                          ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                          : (controller.selectedPaymentMethod.value == Constant.paymentModel!.wallet!.name)
                                              ? SvgPicture.asset(
                                                  "assets/icon/ic_wallet.svg",
                                                  color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                )
                                              : (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name)
                                                  ? Image.asset("assets/images/ig_paypal.png", height: 24, width: 24)
                                                  : (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name)
                                                      ? Image.asset("assets/images/ig_stripe.png", height: 24, width: 24)
                                                      : (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name)
                                                          ? Image.asset("assets/images/ig_razorpay.png", height: 24, width: 24)
                                                          : (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name)
                                                              ? Image.asset("assets/images/ig_paystack.png", height: 24, width: 24)
                                                              : (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name)
                                                                  ? Image.asset("assets/images/ig_marcadopago.png", height: 24, width: 24)
                                                                  : (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name)
                                                                      ? Image.asset("assets/images/ig_payfast.png", height: 24, width: 24)
                                                                      : (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name)
                                                                          ? Image.asset("assets/images/ig_flutterwave.png", height: 24, width: 24)
                                                                          : const SizedBox(height: 24, width: 24),

                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          controller.selectedPaymentMethod.value.toString(),
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.interCityModel.value.bookingStatus != BookingStatus.bookingCompleted &&
                              controller.interCityModel.value.bookingStatus != BookingStatus.bookingRejected &&
                              controller.interCityModel.value.bookingStatus != BookingStatus.bookingOngoing &&
                              controller.interCityModel.value.bookingStatus != BookingStatus.bookingCancelled)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RoundShapeButton(
                                    title: "Cancel Ride".tr,
                                    buttonColor: AppThemData.danger_500p,
                                    buttonTextColor: AppThemData.white,
                                    onTap: () {
                                      Get.to(const InterCityReasonForCancelView(), arguments: {"interCityModel": controller.interCityModel.value});
                                    },
                                    size: Size(0, 52),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RoundShapeButton(
                                    title: "Track Ride".tr,
                                    buttonColor: AppThemData.primary500,
                                    buttonTextColor: AppThemData.black,
                                    onTap: () {
                                      Get.toNamed(Routes.TRACK_INTERCITY_RIDE_SCREEN, arguments: {
                                        "IntercityModel": controller.interCityModel.value,
                                      });
                                    },
                                    size: Size(0, 52),
                                  ),
                                )
                              ],
                            ),
                          if (controller.interCityModel.value.paymentStatus != true && controller.interCityModel.value.bookingStatus == BookingStatus.bookingOngoing)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: controller.selectedPaymentMethod.value != Constant.paymentModel!.cash!.name,
                                  child: Expanded(
                                    child: RoundShapeButton(
                                      title: "Pay Now".tr,
                                      buttonColor: AppThemData.success500,
                                      buttonTextColor: AppThemData.black,
                                      onTap: () async {
                                        if (controller.selectedPaymentMethod.value == Constant.paymentModel!.wallet!.name) {
                                          controller.getProfileData();
                                          if (double.parse(controller.userModel.value.walletAmount!) < Constant.calculateInterCityFinalAmount(controller.interCityModel.value)) {
                                            ShowToastDialog.showToast("Your wallet amount is insufficient to Payment".tr);
                                          } else {
                                            ShowToastDialog.showLoader("Please wait".tr);
                                            await controller.walletPaymentMethod();
                                            ShowToastDialog.showToast("Payment successful".tr);
                                            ShowToastDialog.closeLoader();
                                          }
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name) {
                                          await controller.payPalPayment(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                          // await controller
                                          //     .paypalPaymentSheet(Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await controller.stripeMakePayment(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name) {
                                          await controller.razorpayMakePayment(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await controller.flutterWaveInitiatePayment(context: context, amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await controller.payStackPayment(Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          controller.mercadoPagoMakePayment(context: context, amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          controller.payFastPayment(context: context, amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        }
                                      },
                                      size: Size(0, 52),
                                    ),
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
                                      Get.toNamed(Routes.TRACK_INTERCITY_RIDE_SCREEN, arguments: {
                                        "IntercityModel": controller.interCityModel.value,
                                      });
                                    },
                                    size: Size(0, 52),
                                  ),
                                )
                              ],
                            ),
                          if (controller.interCityModel.value.paymentStatus == true && controller.interCityModel.value.bookingStatus == BookingStatus.bookingOngoing)
                            RoundShapeButton(
                              title: "Track Ride".tr,
                              buttonColor: AppThemData.primary500,
                              buttonTextColor: AppThemData.black,
                              onTap: () {
                                Get.toNamed(Routes.TRACK_RIDE_SCREEN, arguments: {
                                  "bookingModel": controller.interCityModel.value,
                                });
                              },
                              size: Size(Responsive.width(45, context), 52),
                            ),
                          if (controller.interCityModel.value.paymentStatus == true &&
                              controller.interCityModel.value.bookingStatus == BookingStatus.bookingCompleted &&
                              !controller.reviewList.any((review) => review.id == controller.interCityModel.value.id.toString()))
                            RoundShapeButton(
                              title: "Review".tr,
                              buttonColor: AppThemData.primary500,
                              buttonTextColor: AppThemData.black,
                              onTap: () {
                                // Get.to(const ReviewScreenView(), arguments: {"bookingModel": controller.interCityModel});
                                Get.to(
                                  const ReviewScreenView(),
                                  arguments: {
                                    "isIntercity": true,
                                    "bookingModel": controller.interCityModel.value,
                                  },
                                );
                                controller.getReview();
                              },
                              size: Size(Responsive.width(45, context), 52),
                            ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            body: RefreshIndicator(
              onRefresh: () => controller.getBookingDetails(),
              child: FutureBuilder(
                future: controller.getBookingDetails(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return SingleChildScrollView(
                      child: controller.interCityModel.value.bookingStatus == BookingStatus.bookingPlaced
                          ? controller.interCityModel.value.isPersonalRide == true
                              ? Constant.isInterCityBid == true
                                  ? InterCityBidView()
                                  : InterCityDetailsView()
                              // ? InterCityBidView()

                              : Constant.isInterCitySharingBid == true
                                  ? InterCityBidView()
                                  : InterCityDetailsView()
                          : InterCityDetailsView());
                },
              ),
            ),
          );
        });
  }
}
