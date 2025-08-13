// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:customer/app/modules/payment_method/views/widgets/price_row_view.dart';
import 'package:customer/app/modules/reason_for_parcel_cancel/views/parcel_reason_for_cancel_view.dart';
import 'package:customer/app/modules/review_screen/views/review_screen_view.dart';
import 'package:customer/app/routes/app_pages.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/custom_dialog_box.dart';
import 'package:customer/constant_widgets/custom_loader.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/constant_widgets/title_view.dart';
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
import '../controllers/parcel_ride_details_controller.dart';
import 'widgets/parcel_payment_dialog_view.dart';

class ParcelRideDetailsView extends GetView<ParcelRideDetailsController> {
  const ParcelRideDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ParcelRideDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Parcel Ride Details".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            bottomNavigationBar: controller.parcelModel.value.bookingStatus != BookingStatus.bookingPlaced
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
                                if (controller.parcelModel.value.paymentStatus != true && controller.parcelModel.value.bookingStatus == BookingStatus.bookingOngoing) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    isDismissible: true,
                                    enableDrag: true,
                                    constraints: BoxConstraints(maxHeight: Responsive.height(90, context), maxWidth: Responsive.width(100, context)),
                                    builder: (BuildContext context) {
                                      return const ParcelPaymentDialogView();
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
                          if (controller.parcelModel.value.bookingStatus != BookingStatus.bookingCompleted &&
                              controller.parcelModel.value.bookingStatus != BookingStatus.bookingRejected &&
                              controller.parcelModel.value.bookingStatus != BookingStatus.bookingOngoing &&
                              controller.parcelModel.value.bookingStatus != BookingStatus.bookingCancelled)
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
                                      Get.to(const ParcelReasonForCancelView(), arguments: {"parcelModel": controller.parcelModel.value});
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
                                      Get.toNamed(Routes.TRACK_PARCEL_RIDE_SCREEN, arguments: {
                                        "ParcelModel": controller.parcelModel.value,
                                      });
                                    },
                                    size: Size(0, 52),
                                  ),
                                )
                              ],
                            ),
                          if (controller.parcelModel.value.paymentStatus != true && controller.parcelModel.value.bookingStatus == BookingStatus.bookingOngoing)
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
                                          if (double.parse(controller.userModel.value.walletAmount!) < Constant.calculateParcelFinalAmount(controller.parcelModel.value)) {
                                            ShowToastDialog.showToast("Your wallet amount is insufficient to Payment".tr);
                                          } else {
                                            ShowToastDialog.showLoader("Please wait".tr);
                                            await controller.walletPaymentMethod();
                                            ShowToastDialog.showToast("Payment successful".tr);
                                            ShowToastDialog.closeLoader();
                                          }
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name) {
                                          await controller.payPalPayment(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
                                          // await controller
                                          //     .paypalPaymentSheet(Constant.calculateFinalAmount(controller.bookingModel.value).toString());
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await controller.stripeMakePayment(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name) {
                                          await controller.razorpayMakePayment(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await controller.flutterWaveInitiatePayment(context: context, amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await controller.payStackPayment(Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          controller.mercadoPagoMakePayment(context: context, amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
                                          ShowToastDialog.closeLoader();
                                        } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name) {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          controller.payFastPayment(context: context, amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toString());
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
                                      Get.toNamed(Routes.TRACK_PARCEL_RIDE_SCREEN, arguments: {
                                        "ParcelModel": controller.parcelModel.value,
                                      });
                                    },
                                    size: Size(0, 52),
                                  ),
                                )
                              ],
                            ),
                          if (controller.parcelModel.value.paymentStatus == true && controller.parcelModel.value.bookingStatus == BookingStatus.bookingOngoing)
                            RoundShapeButton(
                              title: "Track Ride".tr,
                              buttonColor: AppThemData.primary500,
                              buttonTextColor: AppThemData.black,
                              onTap: () {
                                Get.toNamed(Routes.TRACK_PARCEL_RIDE_SCREEN, arguments: {
                                  "ParcelModel": controller.parcelModel.value,
                                });
                              },
                              size: Size(Responsive.width(45, context), 52),
                            ),
                          if (controller.parcelModel.value.paymentStatus == true &&
                              controller.parcelModel.value.bookingStatus == BookingStatus.bookingCompleted &&
                              !controller.reviewList.any((review) => review.id == controller.parcelModel.value.id.toString()))
                            RoundShapeButton(
                              title: "Review".tr,
                              buttonColor: AppThemData.primary500,
                              buttonTextColor: AppThemData.black,
                              onTap: () {
                                // Get.to(const ReviewScreenView(), arguments: {"bookingModel": controller.interCityModel});
                                Get.to(
                                  const ReviewScreenView(),
                                  arguments: {
                                    "bookingModel": controller.parcelModel.value,
                                    "isParcel": true,
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
                    child: controller.parcelModel.value.bookingStatus == BookingStatus.bookingPlaced && Constant.isParcelBid == true
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
                                          SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(2000),
                                              child: CachedNetworkImage(
                                                // imageUrl: (  Constant.userModel!.profilePic =='' || Constant.userModel!.profilePic == null) ? Constant.profileConstant : Constant.userModel!.profilePic.toString(),
                                                imageUrl:
                                                    (Constant.userModel?.profilePic != null && Constant.userModel!.profilePic!.isNotEmpty) ? Constant.userModel!.profilePic! : Constant.profileConstant,
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
                                                  'ID: ${controller.parcelModel.value.id!.substring(0, 5)}',
                                                  style: GoogleFonts.inter(
                                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Visibility(
                                                  visible: controller.parcelModel.value.bookingStatus == BookingStatus.bookingAccepted,
                                                  child: Text(
                                                    'OTP: ${controller.parcelModel.value.otp}',
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
                                        PickDropPointView(pickUpAddress: controller.parcelModel.value.pickUpLocationAddress ?? '', dropAddress: controller.parcelModel.value.dropLocationAddress ?? ''),
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
                                      controller.parcelModel.value.bidList!.isEmpty
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
                                              itemCount: controller.parcelModel.value.bidList!.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (contex, index) {
                                                BidModel bidModel = controller.parcelModel.value.bidList![index];
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
                                                                    bidModel.bidStatus == 'close'
                                                                        ? Container(
                                                                            width: 77,
                                                                            height: 32,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2000), color: AppThemData.danger50),
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
                                                                                                title: "Cancel Bide".tr,
                                                                                                negativeButtonColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                                                                                                negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                                                                                positiveButtonColor: AppThemData.danger500,
                                                                                                positiveButtonTextColor: AppThemData.grey25,
                                                                                                descriptions: "Are you sure you want cancel this bid?".tr,
                                                                                                positiveString: "Cancel Bid".tr,
                                                                                                negativeString: "Cancel".tr,
                                                                                                positiveClick: () async {
                                                                                                  Navigator.pop(context);
                                                                                                  ShowToastDialog.showLoader('Please Wait'.tr);
                                                                                                  controller.parcelModel.value.bidList![index].bidStatus = 'close';
                                                                                                  await FireStoreUtils.setParcelBooking(controller.parcelModel.value).then((value) {
                                                                                                    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.parcelModel.value.id};
                                                                                                    if (value == true) {
                                                                                                      SendNotification.sendOneNotification(
                                                                                                          type: "order",
                                                                                                          token: driverUserModel.fcmToken.toString(),
                                                                                                          title: 'Your Bid is close',
                                                                                                          customerId: FireStoreUtils.getCurrentUid(),
                                                                                                          senderId: FireStoreUtils.getCurrentUid(),
                                                                                                          bookingId: controller.parcelModel.value.id,
                                                                                                          driverId: driverUserModel.id,
                                                                                                          body:
                                                                                                              'Your ride #${controller.parcelModel.value.id.toString().substring(0, 5)} bid has been close.',
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
                                                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemData.danger500),
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
                                                                                                  "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.",
                                                                                              img: Image.asset(
                                                                                                "assets/icon/ic_green_right.png",
                                                                                                height: 58,
                                                                                                width: 58,
                                                                                              ),
                                                                                              positiveClick: () async {
                                                                                                VehicleTypeModel? vehicleModel = await FireStoreUtils.getVehicleTypeById(
                                                                                                    driverUserModel.driverVehicleDetails!.vehicleTypeId.toString());
                                                                                                controller.parcelModel.value.driverId = driverUserModel.id;
                                                                                                controller.parcelModel.value.bookingStatus = BookingStatus.bookingAccepted;
                                                                                                controller.parcelModel.value.updateAt = Timestamp.now();
                                                                                                controller.parcelModel.value.driverVehicleDetails = driverUserModel.driverVehicleDetails;
                                                                                                controller.parcelModel.value.vehicleType = vehicleModel;
                                                                                                controller.parcelModel.value.subTotal = bidModel.amount;
                                                                                                controller.parcelModel.value.bidList![index].bidStatus = 'Accept';
                                                                                                controller.parcelModel.value.driverBidIdList!.clear();

                                                                                                FireStoreUtils.setParcelBooking(controller.parcelModel.value).then((value) async {
                                                                                                  if (value == true) {
                                                                                                    ShowToastDialog.showToast("Ride accepted successfully!".tr);
                                                                                                    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.parcelModel.value.id};

                                                                                                    await SendNotification.sendOneNotification(
                                                                                                        type: "order",
                                                                                                        token: driverUserModel.fcmToken.toString(),
                                                                                                        title: 'Your Ride is Accepted',
                                                                                                        customerId: FireStoreUtils.getCurrentUid(),
                                                                                                        senderId: FireStoreUtils.getCurrentUid(),
                                                                                                        bookingId: controller.parcelModel.value.id,
                                                                                                        driverId: driverUserModel.id,
                                                                                                        body:
                                                                                                            'Your ride #${controller.parcelModel.value.id.toString().substring(0, 5)} has been confirmed.',
                                                                                                        payload: playLoad);
                                                                                                    Navigator.pop(context);
                                                                                                    controller.update();
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
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 32,
                                                                                      width: 32,
                                                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemData.success500),
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
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
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
                                const SizedBox(height: 16),
                                Visibility(
                                  visible: controller.parcelModel.value.bookingStatus == BookingStatus.bookingAccepted,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Your OTP for Ride'.tr,
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        controller.parcelModel.value.otp ?? '',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.inter(
                                          color: AppThemData.primary500,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                TitleView(titleText: 'Cab Details'.tr, padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                                Container(
                                  width: Responsive.width(100, context),
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: CachedNetworkImage(
                                              imageUrl: controller.parcelModel.value.vehicleType == null ? Constant.profileConstant : controller.parcelModel.value.vehicleType!.image,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) => Constant.loader(),
                                              errorWidget: (context, url, error) => Image.asset(
                                                    Constant.userPlaceHolder,
                                                    fit: BoxFit.cover,
                                                  )),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.parcelModel.value.vehicleType == null ? "" : controller.parcelModel.value.vehicleType!.title,
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                (controller.parcelModel.value.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
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
                                              Constant.amountToShow(amount: Constant.calculateParcelFinalAmount(controller.parcelModel.value).toStringAsFixed(2)),
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
                                                  'No'.tr,
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
                                ),
                                if (controller.parcelModel.value.bookingStatus != BookingStatus.bookingPlaced) ...{
                                  FutureBuilder<DriverUserModel?>(
                                      future: FireStoreUtils.getDriverUserProfile(controller.parcelModel.value.driverId ?? ''),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        DriverUserModel driverUserModel = snapshot.data ?? DriverUserModel();
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TitleView(titleText: 'Driver Details'.tr, padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
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
                                                        image: NetworkImage(driverUserModel.profilePic != null
                                                            ? driverUserModel.profilePic!.isNotEmpty
                                                                ? driverUserModel.profilePic ?? Constant.profileConstant
                                                                : Constant.profileConstant
                                                            : Constant.profileConstant),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          driverUserModel.fullName ?? '',
                                                          style: GoogleFonts.inter(
                                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Row(
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
                                                  InkWell(
                                                      onTap: () {
                                                        Get.to(ChatScreenView(
                                                          receiverId: driverUserModel.id ?? '',
                                                        ));
                                                      },
                                                      child: SvgPicture.asset("assets/icon/ic_message.svg")),
                                                  const SizedBox(width: 12),
                                                  InkWell(
                                                      onTap: () {
                                                        Constant().launchCall("${driverUserModel.countryCode}${driverUserModel.phoneNumber}");
                                                      },
                                                      child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            )
                                          ],
                                        );
                                      })
                                },
                                PickDropPointView(
                                  pickUpAddress: controller.parcelModel.value.pickUpLocationAddress ?? '',
                                  dropAddress: controller.parcelModel.value.dropLocationAddress ?? '',
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
                                            // controller.interCityModel.value.bookingTime == null ? "" : controller.interCityModel.value.bookingTime!.toDate().dateMonthYear(),
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
                                          price: Constant.amountToShow(amount: controller.parcelModel.value.subTotal.toString()),
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
                                                        amount: Constant.calculateTax(
                                                                amount:
                                                                    ((double.parse(controller.parcelModel.value.subTotal ?? '0.0')) - (double.parse(controller.parcelModel.value.discount ?? '0.0')))
                                                                        .toString(),
                                                                taxModel: taxModel)
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
                                TitleView(titleText: 'Parcel Image'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 0)),
                                const SizedBox(height: 12),
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
