// ignore_for_file: deprecated_member_use

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/subscription_model.dart';
import 'package:admin/app/modules/subscription_plan/controllers/subscription_plan_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              leadingWidth: 200,
              // title: title,
              leading: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (!ResponsiveWidget.isDesktop(context)) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: !ResponsiveWidget.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                              ),
                            )
                          : SizedBox(
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/logo.png",
                                    height: 45,
                                    color: AppThemData.primary500,
                                  ),
                                  spaceW(),
                                  const TextCustom(
                                    title: 'My Taxi',
                                    color: AppThemData.primary500,
                                    fontSize: 30,
                                    fontFamily: AppThemeData.semiBold,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    if (themeChange.darkTheme == 1) {
                      themeChange.darkTheme = 0;
                    } else if (themeChange.darkTheme == 0) {
                      themeChange.darkTheme = 1;
                    } else if (themeChange.darkTheme == 2) {
                      themeChange.darkTheme = 0;
                    } else {
                      themeChange.darkTheme = 2;
                    }
                  },
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: AppThemData.yellow600,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: AppThemData.blue400,
                          height: 20,
                          width: 20,
                        ),
                ),
                spaceW(),
                const LanguagePopUp(),
                spaceW(),
                ProfilePopUp()
              ],
            ),
            drawer: Drawer(
              // key: scaffoldKey,
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                    child: Padding(
                  padding: paddingEdgeInsets(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContainerCustom(
                            child: Column(children: [
                          ResponsiveWidget.isDesktop(context)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
                                      spaceH(height: 2),
                                      Row(children: [
                                        GestureDetector(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(
                                                title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        TextCustom(
                                            title: ' ${controller.title.value} '.tr,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.medium,
                                            color: AppThemData.primary500)
                                      ])
                                    ]),
                                    CustomButtonWidget(
                                      padding: const EdgeInsets.symmetric(horizontal: 22),
                                      buttonTitle: "+ Add Subscription".tr,
                                      borderRadius: 10,
                                      onPress: () {
                                        controller.setDefaultData();
                                        showDialog(context: context, builder: (context) => const AddSubscriptionPlan());
                                      },
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
                                      spaceH(height: 2),
                                      Row(children: [
                                        GestureDetector(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(
                                                title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        TextCustom(
                                            title: ' ${controller.title.value} '.tr,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.medium,
                                            color: AppThemData.primary500)
                                      ])
                                    ]),
                                    spaceH(height: 16),
                                    CustomButtonWidget(
                                      padding: const EdgeInsets.symmetric(horizontal: 22),
                                      buttonTitle: "+ Add Subscription".tr,
                                      borderRadius: 10,
                                      onPress: () {
                                        controller.setDefaultData();
                                        showDialog(context: context, builder: (context) => const AddSubscriptionPlan());
                                      },
                                    ),
                                  ],
                                ),
                          spaceH(height: 20),
                          controller.isLoading.value
                              ? Constant.loader()
                              : (controller.subscriptionList.isEmpty)
                                  ? const Center(
                                      child: Text(
                                      "No Available Subscription Plan",
                                      style: TextStyle(
                                        fontFamily: AppThemeData.bold,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemData.textBlack,
                                        fontSize: 16,
                                      ),
                                    ))
                                  : Align(
                            alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 65,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: MaterialStateColor.resolveWith(
                                                  (states) => themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Description".tr, width: 150),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Price".tr, width: 100),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Expire Days".tr, width: 100),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Bookings".tr, width: 100),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Type".tr, width: 100),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Status".tr, width: 100),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Created Date".tr, width: 150),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Actions".tr, width: 110),
                                              ],
                                              rows: controller.subscriptionList
                                                  .map((subscriptionModel) => DataRow(cells: [
                                                        DataCell(
                                                          Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: TextCustom(title: subscriptionModel.id!.substring(0, 8))),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: TextCustom(
                                                              title: subscriptionModel.title ?? "N/A",
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: TextCustom(title: subscriptionModel.description ?? "N/A")),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: TextCustom(title: Constant.amountShow(amount: subscriptionModel.price.toString())),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: TextCustom(title: subscriptionModel.expireDays ?? "N/A")),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: TextCustom(title: subscriptionModel.features!.bookings ?? "N/A")),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: TextCustom(
                                                                title: subscriptionModel.type == "free" ? "Free" : "Paid",
                                                              )),
                                                        ),
                                                        DataCell(
                                                          Center(
                                                            child: Transform.scale(
                                                              scale: 0.8,
                                                              child: CupertinoSwitch(
                                                                value: subscriptionModel.isEnable ?? false,
                                                                onChanged: (bool value) async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    controller.isLoading.value = true;
                                                                    subscriptionModel.isEnable = value;
                                                                    bool isSaved = await FireStoreUtils.updateSubscription(subscriptionModel);
                                                                    if (isSaved) {
                                                                      controller.getSubscriptionPlan();
                                                                      ShowToast.successToast("Subscription status updated".tr);
                                                                    }
                                                                  }
                                                                },
                                                                activeColor: AppThemData.primary500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: Text(Constant.timestampToDate(subscriptionModel.createdAt!),
                                                                style: TextStyle(
                                                                    fontFeatures: const [FontFeature.proportionalFigures()],
                                                                    fontFamily: AppThemeData.regular,
                                                                    fontSize: 16,
                                                                    color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack)),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                IconButton(
                                                                  onPressed: () async {
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      controller.isEditing.value = true;
                                                                      controller.editingId.value = subscriptionModel.id!;
                                                                      controller.subscriptionNameController.value.text = subscriptionModel.title!;
                                                                      controller.subscriptionDescriptionController.value.text = subscriptionModel.description!;
                                                                      controller.subscriptionPriceController.value.text = subscriptionModel.price!;
                                                                      controller.expireDaysController.value.text = subscriptionModel.expireDays!;
                                                                      controller.subscriptionType.value = subscriptionModel.type!;
                                                                      controller.isEnable.value = subscriptionModel.isEnable!;
                                                                      controller.subscriptionBookingsController.value.text =
                                                                          subscriptionModel.features!.bookings!;
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => AddSubscriptionPlan(
                                                                                subscriptionModel: subscriptionModel,
                                                                              ));
                                                                    }
                                                                  },
                                                                  icon: SvgPicture.asset(
                                                                    "assets/icons/ic_edit.svg",
                                                                    color: AppThemData.greyShade400,
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  onPressed: () async {
                                                                    DialogBox.commonDialogBox(
                                                                      context: Get.context!,
                                                                      description: 'This action will permanently delete this Subscription.'.tr,
                                                                      deleteOnPress: () async {
                                                                        Get.back();
                                                                        if (Constant.isDemo) {
                                                                          DialogBox.demoDialogBox();
                                                                        } else {
                                                                          controller.isLoading.value = true;
                                                                          bool isDeleted = await controller.removeSubscription(subscriptionModel.id ?? "");
                                                                          if (isDeleted) {
                                                                            controller.getSubscriptionPlan();
                                                                            ShowToast.successToast("Subscription Plan Deleted".tr);
                                                                          } else {
                                                                            ShowToast.errorToast("Something went wrong!");
                                                                            controller.isLoading.value = false;
                                                                          }
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  icon: SvgPicture.asset(
                                                                    "assets/icons/ic_delete.svg",
                                                                    color: AppThemData.greyShade400,
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]))
                                                  .toList()),
                                        ),
                                      ),
                                  )
                        ]))
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        });
  }
}

class AddSubscriptionPlan extends StatelessWidget {
  final SubscriptionModel? subscriptionModel;

  const AddSubscriptionPlan({super.key, this.subscriptionModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SubscriptionPlanController>(
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          controller: controller,
          widgetList: [
             Text(
              "If -1 is added, the Bookings and Expiry Days will be set to unlimited.".tr,
              style: const TextStyle(fontSize: 16, fontFamily: AppThemeData.medium, color: AppThemData.red500),
            ),
            spaceH(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hintText: "Enter Name".tr,
                    controller: controller.subscriptionNameController.value,
                    title: "Name".tr,
                  ),
                ),
                spaceW(width: 20),
                Expanded(
                  child: CustomTextFormField(
                    hintText: "Enter Price".tr,
                    controller: controller.subscriptionPriceController.value,
                    title: "Price".tr,
                  ),
                ),
              ],
            ),
            spaceH(),
            CustomTextFormField(
              title: "Description".tr,
              hintText: "Enter Description".tr,
              controller: controller.subscriptionDescriptionController.value,
            ),
            spaceH(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    title: "Expire Days".tr,
                    controller: controller.expireDaysController.value,
                    hintText: "ex. 30",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^-?$|^-1$|^[1-9]\d*$')),
                      // FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*')),
                    ],
                  ),
                ),
                spaceW(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Type'.tr,
                        fontSize: 12,
                      ),
                      spaceH(height: 10),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "free",
                                groupValue: controller.subscriptionType.value,
                                onChanged: (value) {
                                  controller.subscriptionType.value = value ?? "free";
                                },
                                activeColor: AppThemData.primary500,
                              ),
                               Text("Free".tr,
                                  style: const TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    fontSize: 16,
                                    color: AppThemData.textGrey,
                                  ))
                            ],
                          ),
                          spaceW(width: 10),
                          Row(
                            children: [
                              Radio(
                                value: "paid",
                                groupValue: controller.subscriptionType.value,
                                onChanged: (value) {
                                  controller.subscriptionType.value = value ?? "paid";
                                },
                                activeColor: AppThemData.primary500,
                              ),
                               Text("Paid".tr,
                                  style: const TextStyle(
                                    fontFamily: AppThemeData.regular,
                                    fontSize: 16,
                                    color: AppThemData.textGrey,
                                  ))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            spaceH(height: 20),
            TextCustom(
              title: 'Status'.tr,
              fontSize: 12,
            ),
            spaceH(),
            Obx(
              () => Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: AppThemData.primary500,
                  value: controller.isEnable.value,
                  onChanged: (value) {
                    controller.isEnable.value = value;
                  },
                ),
              ),
            ),
            spaceH(height: 20),
            Text("Features".tr,
                style: TextStyle(
                    fontSize: 18, fontFamily: AppThemeData.medium, color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack)),
            spaceH(height: 20),
            CustomTextFormField(
              title: "Number of Bookings".tr,
              controller: controller.subscriptionBookingsController.value,
              hintText: "ex. 3",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?$|^-1$|^[1-9]\d*$')),
              ],
            ),
          ],
          bottomWidgetList: [
            CustomButtonWidget(
              buttonTitle: "Cancel".tr,
              buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
              onPress: () {
                controller.setDefaultData();
                Get.back();
              },
            ),
            spaceW(width: 16),
            CustomButtonWidget(
              buttonTitle: "Save".tr,
              onPress: () {
                if(Constant.isDemo){
                  DialogBox.demoDialogBox();
                }else{
                  if(controller.subscriptionNameController.value.text.isNotEmpty &&
                      controller.subscriptionDescriptionController.value.text.isNotEmpty &&
                      controller.subscriptionPriceController.value.text.isNotEmpty &&
                      controller.expireDaysController.value.text.isNotEmpty &&
                      controller.subscriptionBookingsController.value.text.isNotEmpty){
                    controller.isEditing.value == true ? controller.updateSubscriptionPlan(subscriptionModel!) : controller.addSubscriptionPlan();
                  }else{
                    ShowToast.errorToast("Please Enter Valid Details..");
                  }
                }

              },
            )
          ],
        );
      },
    );
  }
}
