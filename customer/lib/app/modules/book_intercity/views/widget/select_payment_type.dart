// ignore_for_file: deprecated_member_use

import 'package:customer/app/modules/book_intercity/controllers/book_intercity_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectPaymentType extends StatelessWidget {
  const SelectPaymentType({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: BookIntercityController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Payment Methods'.tr,
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 0.09,
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            backgroundColor: themeChange.isDarkTheme() ? Color(0xff1D1D21) : AppThemData.grey50,
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB((Responsive.width(100, context) - 200) / 2, 0, (Responsive.width(100, context) - 200) / 2, 20),
              child: RoundShapeButton(
                  size: const Size(200, 45),
                  title: "Ride Placed".tr,
                  buttonColor: AppThemData.primary500,
                  buttonTextColor: AppThemData.black,
                  onTap: () {
                    controller.bookInterCity();
                    // Get.back();
                  }),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: Constant.paymentModel!.cash != null && Constant.paymentModel!.cash!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.cash!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/ic_cash.svg",
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.cash!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.cash!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.wallet != null && Constant.paymentModel!.wallet!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.wallet!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/ic_wallet.svg",
                                          height: 24,
                                          width: 24,
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.wallet!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.wallet!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.wallet!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.paypal != null && Constant.paymentModel!.paypal!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.paypal!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_paypal.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.paypal!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.paypal!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.paypal!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.strip != null && Constant.paymentModel!.strip!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.strip!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_stripe.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.strip!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.strip!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.strip!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.razorpay != null && Constant.paymentModel!.razorpay!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.razorpay!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_razorpay.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.razorpay!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.razorpay!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.razorpay!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.payStack != null && Constant.paymentModel!.payStack!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.payStack!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_paystack.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.payStack!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.payStack!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.payStack!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.mercadoPago != null && Constant.paymentModel!.mercadoPago!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.mercadoPago!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_marcadopago.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.mercadoPago!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.mercadoPago!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.mercadoPago!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.payFast != null && Constant.paymentModel!.payFast!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.payFast!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_payfast.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.payFast!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.payFast!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.payFast!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: Constant.paymentModel!.flutterWave != null && Constant.paymentModel!.flutterWave!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.flutterWave!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_flutterwave.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.flutterWave!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.flutterWave!.name.toString();
                                      controller.interCityModel.value.paymentType = Constant.paymentModel!.flutterWave!.name;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: Divider(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
