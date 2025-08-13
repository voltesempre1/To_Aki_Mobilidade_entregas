// ignore_for_file: deprecated_member_use

import 'package:driver/app/models/subscription_model.dart';
import 'package:driver/app/modules/subscription_plan/controllers/subscription_plan_controller.dart';
import 'package:driver/app/modules/subscription_plan/views/select_payment_screen_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscriptionPlanView extends GetView {
  const SubscriptionPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionPlanController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBarWithBorder(title: "Subscription Plan".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            body: controller.isLoading.value
                ? Constant.loader()
                : (controller.subscriptionPlanList.isEmpty)
                    ? Constant.showEmptyView(message: "No Subscription Plan Found".tr)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        itemCount: controller.subscriptionPlanList.length,
                        itemBuilder: (context, index) {
                          SubscriptionModel subscriptionModel = controller.subscriptionPlanList[index];
                          controller.selectedSubscription.value = controller.subscriptionPlanList.first;
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.selectedSubscription.value = subscriptionModel;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: controller.selectedSubscription.value == subscriptionModel
                                      ? themeChange.isDarkTheme()
                                          ? AppThemData.primary950
                                          : AppThemData.primary50
                                      : themeChange.isDarkTheme()
                                          ? AppThemData.grey900
                                          : AppThemData.grey50,
                                  border: Border.all(
                                      color: controller.selectedSubscription.value == subscriptionModel ? AppThemData.primary500 : Colors.transparent),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            subscriptionModel.title.toString(),
                                            style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Radio(
                                              value: subscriptionModel,
                                              groupValue: controller.selectedSubscription.value,
                                              activeColor: AppThemData.primary500,
                                              onChanged: (value) {
                                                controller.selectedSubscription.value = value!;
                                              })
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Constant.amountShow(amount: subscriptionModel.price),
                                                style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight: FontWeight.w700,
                                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950)),
                                              ),
                                              Text(
                                                subscriptionModel.expireDays == "-1" ? "Unlimited Days" : "Active until ${subscriptionModel.expireDays} Days",
                                                style: GoogleFonts.inter(
                                                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppThemData.danger500)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            subscriptionModel.description.toString(),
                                            style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500)),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          if (subscriptionModel.features != null)
                                            Column(
                                              children: [featuresRow(context, title: "Rides", value: "${subscriptionModel.features!.bookings}")],
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: RoundShapeButton(
                    title: "Continue".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () {
                      if (controller.selectedSubscription.value.id == null) {
                        ShowToastDialog.showToast("Please Select Subscription Plan".tr);
                        return;
                      }
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                          builder: (context) {
                            return FractionallySizedBox(heightFactor: .8, child: SelectPaymentScreenView());
                          });
                    },
                    size: const Size(208, 52))),
          );
        });
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
          style: GoogleFonts.inter(
              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950)),
        ),
      ],
    );
  }
}
