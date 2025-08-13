// ignore_for_file: deprecated_member_use

import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/subscription_plan/controllers/subscription_plan_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectPaymentScreenView extends StatelessWidget {
  const SelectPaymentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SubscriptionPlanController>(
        init: SubscriptionPlanController(),
        builder: (controller) {
          return Container(
            child: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Methods'.tr,
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Visibility(
                              visible: controller.paymentModel.value.wallet != null && controller.paymentModel.value.wallet!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context,
                                        controller: controller,
                                        value: controller.paymentModel.value.wallet!.name.toString(),
                                        image: themeChange.isDarkTheme() ? "assets/images/wallet_dark.png" : "assets/images/wallet.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.strip != null && controller.paymentModel.value.strip!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context, controller: controller, value: controller.paymentModel.value.strip!.name.toString(), image: "assets/images/ig_stripe.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.paypal != null && controller.paymentModel.value.paypal!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context, controller: controller, value: controller.paymentModel.value.paypal!.name.toString(), image: "assets/images/ig_paypal.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context, controller: controller, value: controller.paymentModel.value.razorpay!.name.toString(), image: "assets/images/ig_razorpay.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.flutterWave != null && controller.paymentModel.value.flutterWave!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context,
                                        controller: controller, value: controller.paymentModel.value.flutterWave!.name.toString(), image: "assets/images/ig_flutterwave.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.mercadoPago != null && controller.paymentModel.value.mercadoPago!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context,
                                        controller: controller, value: controller.paymentModel.value.mercadoPago!.name.toString(), image: "assets/images/ig_marcadopago.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.payStack != null && controller.paymentModel.value.payStack!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context, controller: controller, value: controller.paymentModel.value.payStack!.name.toString(), image: "assets/images/ig_paystack.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                              visible: controller.paymentModel.value.payFast != null && controller.paymentModel.value.payFast!.isActive == true,
                              child: Column(
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                    child: paymentDecoration(context, controller: controller, value: controller.paymentModel.value.payFast!.name.toString(), image: "assets/images/ig_payfast.png"),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 40, right: 10),
                                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                    child: Divider(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: RoundShapeButton(
                                  title: "Pay Now".tr,
                                  buttonColor: AppThemData.primary500,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () async {
                                    if (controller.selectedPaymentMethod.value == controller.paymentModel.value.wallet!.name) {
                                      double walletAmount = double.tryParse(Constant.userModel?.walletAmount.toString() ?? '0') ?? 0;
                                      double minRequired = double.tryParse(controller.selectedSubscription.value.price.toString()) ?? 0;
                                      if (walletAmount >= minRequired) {
                                        ShowToastDialog.showLoader("Please Wait..");
                                        WalletTransactionModel walletTransactionModel = WalletTransactionModel(
                                            id: Constant.getUuid(),
                                            amount: "${double.parse(controller.selectedSubscription.value.price.toString())}",
                                            type: "driver",
                                            userId: FireStoreUtils.getCurrentUid(),
                                            isCredit: false,
                                            paymentType: controller.selectedPaymentMethod.value,
                                            createdDate: Timestamp.now(),
                                            transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
                                            note: "Subscription Amount Debited");

                                        await FireStoreUtils.setWalletTransaction(walletTransactionModel).then((value) async {
                                          if (value == true) {
                                            await FireStoreUtils.updateDriverUserWallet(amount: "-${double.parse(controller.selectedSubscription.value.price.toString())}").then((value) async {
                                              DriverUserModel? driverModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid());
                                              if (driverModel != null) {
                                                controller.driverModel.value = driverModel;
                                              }
                                              controller.completeSubscription();
                                              ShowToastDialog.showToast("Payment Successful..");
                                            });
                                          }
                                        });
                                        ShowToastDialog.closeLoader();
                                      } else {
                                        ShowToastDialog.toast("Wallet Amount Insufficient".tr);
                                      }
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name) {
                                      await controller.razorpayMakePayment(amount: "${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name) {
                                      await controller.stripeMakePayment(amount: "${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.flutterWave!.name) {
                                      await controller.flutterWaveInitiatePayment(context: context, amount: "${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.mercadoPago!.name) {
                                      controller.mercadoPagoMakePayment(context: context, amount: "${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payFast!.name) {
                                      controller.payFastPayment(context: context, amount: "${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name) {
                                      await controller.payPalPayment(amount: "${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name) {
                                      await controller.payStackPayment("${double.parse(controller.selectedSubscription.value.price.toString())}");
                                    } else {
                                      ShowToastDialog.showToast("Select Payment Method");
                                    }
                                  },
                                  size: Size(208, 52)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}

Padding paymentDecoration(BuildContext context, {required SubscriptionPlanController controller, required String value, required String image}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: () {
        controller.selectedPaymentMethod.value = value.toString();
      },
      child: Row(
        children: [
          Image.asset(
            image,
            height: 24,
            width: 24,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    (value == "Wallet") ? "My Wallet" : value,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // if (value == "Wallet")
                //   Text("Available Balance:- ${Constant.amountShow(amount: controller.driverModel.value.walletAmount)}",
                //       style: TextStyle(fontWeight: FontWeight.w600, color: themeChange.isDarkTheme() ? AppThemData.grey200 : AppThemData.grey800))
              ],
            ),
          ),
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value.toString(),
            groupValue: controller.selectedPaymentMethod.value,
            activeColor: AppThemData.primary500,
            onChanged: (value) {
              controller.selectedPaymentMethod.value = value.toString();
            },
          )
        ],
      ),
    ),
  );
}
