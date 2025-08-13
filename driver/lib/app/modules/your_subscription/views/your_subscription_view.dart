// ignore_for_file: deprecated_member_use

import 'package:driver/app/models/subscription_plan_history.dart';
import 'package:driver/app/modules/your_subscription/controllers/your_subscription_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class YourSubscriptionView extends GetView<YourSubscriptionController> {
  const YourSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: YourSubscriptionController(),
      builder: (controller) {
        return Scaffold(
          // appBar: AppBarWithBorder(title: "Your Subscription".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
          body: controller.isLoading.value
              ? Constant.loader()
              : controller.subscriptionHistory.isEmpty
                  ? Text("No Subscription History Found")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.subscriptionHistory.length,
                      padding: EdgeInsets.only(bottom: 16),
                      itemBuilder: (context, index) {
                        SubscriptionHistoryModel subscriptionHistory = controller.subscriptionHistory[index];
                        return Container(
                          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subscriptionHistory.subscriptionPlan!.title.toString(),
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Constant.amountShow(amount: subscriptionHistory.subscriptionPlan!.price),
                                    style:
                                        GoogleFonts.inter(textStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (subscriptionHistory.expiryDate == null || subscriptionHistory.expiryDate!.toDate().isAfter(DateTime.now()))
                                          ? AppThemData.success500.withOpacity(.2)
                                          : AppThemData.danger500.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text((subscriptionHistory.expiryDate == null || subscriptionHistory.expiryDate!.toDate().isAfter(DateTime.now())) ? "Active" : "Expired",
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: (subscriptionHistory.expiryDate == null || subscriptionHistory.expiryDate!.toDate().isAfter(DateTime.now()))
                                              ? AppThemData.success500
                                              : AppThemData.danger500,
                                        ))),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                subscriptionHistory.subscriptionPlan!.description.toString(),
                                style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500)),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              if (subscriptionHistory.subscriptionPlan!.features != null)
                                Column(
                                  children: [featuresRow(context, title: "Rides", value: "${subscriptionHistory.subscriptionPlan!.features!.bookings}")],
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Divider(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey100,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Payment Method",
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500))),
                                  Row(
                                    children: [
                                      Image.asset(
                                        subscriptionHistory.paymentType == "Wallet"
                                            ? themeChange.isDarkTheme()
                                                ? "assets/images/wallet_dark.png"
                                                : "assets/images/wallet.png"
                                            : subscriptionHistory.paymentType == "Razorpay"
                                                ? "assets/images/ig_razorpay.png"
                                                : subscriptionHistory.paymentType == "Paypal"
                                                    ? "assets/images/ig_paypal.png"
                                                    : subscriptionHistory.paymentType == "Strip"
                                                        ? "assets/images/ig_stripe.png"
                                                        : subscriptionHistory.paymentType == "PayStack"
                                                            ? "assets/images/ig_paystack.png"
                                                            : subscriptionHistory.paymentType == "Mercado Pago"
                                                                ? "assets/images/ig_marcadopago.png"
                                                                : subscriptionHistory.paymentType == "payfast"
                                                                    ? "assets/images/ig_payfast.png"
                                                                    : subscriptionHistory.paymentType == "Flutter Wave"
                                                                        ? "assets/images/ig_flutterwave.png"
                                                                        : themeChange.isDarkTheme()
                                                                            ? "assets/images/wallet_dark.png"
                                                                            : "assets/images/wallet.png",
                                        height: 24,
                                      ),
                                      // SvgPicture.asset(
                                      //   "assets/icons/ic_wallet.svg",
                                      //   color: themeChange.isDarkTheme() ? AppThemData.grey200 : AppThemData.grey800,
                                      // ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(subscriptionHistory.paymentType.toString(),
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950))),
                                    ],
                                  ),
                                ],
                              ),
                              if (subscriptionHistory.expiryDate != null)
                                Row(
                                  children: [
                                    Text("Expire At : ", style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppThemData.danger500))),
                                    Text(Constant.timestampToDate(subscriptionHistory.expiryDate!),
                                        style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppThemData.danger500))),
                                  ],
                                ).paddingOnly(top: 10),
                            ],
                          ),
                        );
                      }),
        );
      },
    );
  }

  Row featuresRow(BuildContext context, {required String title, required String value}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icon/ic_check_circle.svg",
          height: 20,
          color: AppThemData.primary500,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "${value == "-1" ? "Unlimited" : value} $title",
          style: GoogleFonts.inter(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950)),
        ),
      ],
    );
  }
}
