// ignore_for_file: deprecated_member_use

import 'package:driver/app/models/person_model.dart';
import 'package:driver/app/models/tax_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/booking_details/widget/price_row_view.dart';
import 'package:driver/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:driver/app/modules/intercity_booking_details/controllers/intercity_booking_details_controller.dart';
import 'package:driver/app/modules/track_intercity_ride_screen/views/track_intercity_ride_screen_view.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/constant_widgets/title_view.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class IntercityDetailView extends StatelessWidget {
  const IntercityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: InterCityBookingDetailsController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Obx(
            () => Padding(
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
                              BookingStatus.getBookingStatusTitle(controller.interCityModel.value.bookingStatus ?? ''),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                color: BookingStatus.getBookingStatusTitleColor(controller.interCityModel.value.bookingStatus ?? ''),
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
                            future: FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId ?? ''),
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
                                                    receiverId: controller.interCityModel.value.customerId ?? '',
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
                          pickUpAddress: controller.interCityModel.value.pickUpLocationAddress ?? '',
                          dropAddress: controller.interCityModel.value.dropLocationAddress ?? '',
                          intercityModel: controller.interCityModel.value,
                          isDirectionIconShown: true,
                          onDirectionTap: () {
                            Get.to(() => TrackIntercityRideScreenView(), arguments: {"interCityModel": controller.interCityModel.value});
                          },
                        ),
                        Visibility(
                          visible: controller.interCityModel.value.isPersonalRide == false ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleView(titleText: 'Ride Sharing'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                              const SizedBox(height: 8),
                              Container(
                                width: Responsive.width(100, context),
                                padding: const EdgeInsets.all(16),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: ListView.builder(
                                    itemCount: controller.interCityModel.value.sharingPersonList!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonModel personModel = controller.interCityModel.value.sharingPersonList![index];
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            personModel.name.toString(),
                                            style: GoogleFonts.inter(
                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            personModel.mobileNumber.toString(),
                                            style: GoogleFonts.inter(
                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (index != controller.interCityModel.value.sharingPersonList!.length - 1) const Divider(),
                                        ],
                                      );
                                    }),
                              ),
                              // Container(
                              //   width: Responsive.width(100, context),
                              //   padding: const EdgeInsets.all(16),
                              //   decoration: ShapeDecoration(
                              //     shape: RoundedRectangleBorder(
                              //       side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //   ),
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text(
                              //         'Umag Souvaratha',
                              //         style: GoogleFonts.inter(
                              //           color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              //           fontSize: 14,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 2,
                              //       ),
                              //       Text(
                              //         '9874563214',
                              //         style: GoogleFonts.inter(
                              //           color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              //           fontSize: 14,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //       const Divider(),
                              //       // const SizedBox(width: 12),
                              //       // InkWell(
                              //       //     onTap: () {
                              //       //       Constant().launchCall("${customerModel.countryCode}${customerModel.phoneNumber}");
                              //       //     },
                              //       //     child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
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
                                    controller.interCityModel.value.bookingTime == null ? "" : Constant.formatDate(Constant.parseDate(controller.interCityModel.value.startDate)),
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
                                    controller.interCityModel.value.rideStartTime.toString(),
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
                                    '${double.parse(controller.interCityModel.value.distance!.distance!).toStringAsFixed(2)} ${controller.interCityModel.value.distance!.distanceType!}',
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // FutureBuilder<String>(
                                  //   future: controller.getDistanceInKm(),
                                  //   initialData: '',
                                  //   builder: (context, snapshot) {
                                  //     if (!snapshot.hasData) {
                                  //       return Container();
                                  //     }
                                  //     return Text(
                                  //       snapshot.data ?? '',
                                  //       textAlign: TextAlign.right,
                                  //       style: GoogleFonts.inter(
                                  //         color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  //         fontSize: 14,
                                  //         fontWeight: FontWeight.w600,
                                  //         height: 0.11,
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
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
                                  price: Constant.amountToShow(amount: controller.interCityModel.value.subTotal.toString()),
                                  title: "Amount".tr,
                                  priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                ),
                                const SizedBox(height: 16),
                                PriceRowView(
                                    price: Constant.amountToShow(amount: controller.interCityModel.value.discount ?? '0.0'),
                                    title: "Discount".tr,
                                    priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.interCityModel.value.taxList!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    TaxModel taxModel = controller.interCityModel.value.taxList![index];
                                    return Column(
                                      children: [
                                        PriceRowView(
                                            price: Constant.amountToShow(
                                                amount: Constant.calculateTax(amount: Constant.amountInterCityBeforeTax(controller.interCityModel.value).toString(), taxModel: taxModel).toString()),
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
                                  price: Constant.amountToShow(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString()),
                                  title: "Total Amount".tr,
                                  priceColor: AppThemData.primary500,
                                  titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                ),
                              ],
                            ),
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
                              (controller.interCityModel.value.paymentType == Constant.paymentModel!.cash!.name)
                                  ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                  : (controller.interCityModel.value.paymentType == Constant.paymentModel!.wallet!.name)
                                      ? SvgPicture.asset(
                                          "assets/icon/ic_wallet.svg",
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                        )
                                      : (controller.interCityModel.value.paymentType == Constant.paymentModel!.paypal!.name)
                                          ? Image.asset("assets/images/ig_paypal.png", height: 24, width: 24)
                                          : (controller.interCityModel.value.paymentType == Constant.paymentModel!.strip!.name)
                                              ? Image.asset("assets/images/ig_stripe.png", height: 24, width: 24)
                                              : (controller.interCityModel.value.paymentType == Constant.paymentModel!.razorpay!.name)
                                                  ? Image.asset("assets/images/ig_razorpay.png", height: 24, width: 24)
                                                  : (controller.interCityModel.value.paymentType == Constant.paymentModel!.payStack!.name)
                                                      ? Image.asset("assets/images/ig_paystack.png", height: 24, width: 24)
                                                      : (controller.interCityModel.value.paymentType == Constant.paymentModel!.mercadoPago!.name)
                                                          ? Image.asset("assets/images/ig_marcadopago.png", height: 24, width: 24)
                                                          : (controller.interCityModel.value.paymentType == Constant.paymentModel!.payFast!.name)
                                                              ? Image.asset("assets/images/ig_payfast.png", height: 24, width: 24)
                                                              : (controller.interCityModel.value.paymentType == Constant.paymentModel!.flutterWave!.name)
                                                                  ? Image.asset("assets/images/ig_flutterwave.png", height: 24, width: 24)
                                                                  : const SizedBox(height: 24, width: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.interCityModel.value.paymentType ?? '',
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
          ),
        );
      },
    );
  }
}
