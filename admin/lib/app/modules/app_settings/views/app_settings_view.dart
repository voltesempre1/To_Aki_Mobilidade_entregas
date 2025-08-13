import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_button.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/screen_size.dart';
import '../controllers/app_settings_controller.dart';

class AppSettingsView extends GetView<AppSettingsController> {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<AppSettingsController>(
      init: AppSettingsController(),
      builder: (appSettingsController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => ContainerCustom(
                  child: controller.isLoading.value
                      ? Padding(
                          padding: paddingEdgeInsets(),
                          child: Constant.loader(),
                        )
                      : ResponsiveWidget.isDesktop(context)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          GestureDetector(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(
                                                  title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(
                                              title: ' ${controller.title.value} ',
                                              fontSize: 14,
                                              fontFamily: AppThemeData.medium,
                                              color: AppThemData.primary500)
                                        ])
                                      ],
                                    ),
                                  ],
                                ),
                                spaceH(height: 20),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Admin Commission".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  maxLine: 1,
                                                  title: "Commission Type".tr,
                                                  fontSize: 14,
                                                ),
                                                spaceH(),
                                                Obx(
                                                  () => DropdownButtonFormField(
                                                    isExpanded: true,
                                                    style: TextStyle(
                                                      fontFamily: AppThemeData.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                    ),
                                                    hint: TextCustom(title: 'Select Tax Type'.tr),
                                                    onChanged: (String? taxType) {
                                                      appSettingsController.selectedAdminCommissionType.value = taxType ?? "Fix";
                                                    },
                                                    value: appSettingsController.selectedAdminCommissionType.value,
                                                    items: appSettingsController.adminCommissionType.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: TextCustom(
                                                          title: value,
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.primaryBlack,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    decoration: Constant.DefaultInputDecoration(context),
                                                  ),
                                                ),
                                                spaceH(height: 16)
                                              ],
                                            ),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Admin Commission".tr,
                                                hintText: "Enter admin commission".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: appSettingsController.adminCommissionController.value),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Status".tr,
                                              fontSize: 14,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.active,
                                                      groupValue: appSettingsController.isActive.value,
                                                      onChanged: (value) {
                                                        appSettingsController.isActive.value = value ?? Status.active;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    Text("Active".tr,
                                                        style: const TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: AppThemData.textGrey,
                                                        ))
                                                  ],
                                                ),
                                                spaceW(),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.inactive,
                                                      groupValue: appSettingsController.isActive.value,
                                                      onChanged: (value) {
                                                        appSettingsController.isActive.value = value ?? Status.inactive;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    Text("Inactive".tr,
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
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Document Verification".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      TextCustom(
                                        title: "Do you Want to Enable Document Verification Flow?".tr,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Obx(
                                            () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.active,
                                                      groupValue: controller.isDocumentVerificationActive.value,
                                                      onChanged: (value) {
                                                        controller.isDocumentVerificationActive.value = value ?? Status.active;
                                                        // controller.constantModel.value.isSubscriptionEnable = true;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Active",
                                                        style: TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: AppThemData.textGrey,
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.inactive,
                                                      groupValue: controller.isDocumentVerificationActive.value,
                                                      onChanged: (value) {
                                                        controller.isDocumentVerificationActive.value = value ?? Status.inactive;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Inactive",
                                                        style: TextStyle(
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
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Subscription Plan".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      TextCustom(
                                        title: "Do you Want to Enable Subscription Plan?".tr,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Obx(
                                        () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.active,
                                                      groupValue: controller.isSubscriptionActive.value,
                                                      onChanged: (value) {
                                                        controller.isSubscriptionActive.value = value ?? Status.active;
                                                        // controller.constantModel.value.isSubscriptionEnable = true;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Active",
                                                        style: TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: AppThemData.textGrey,
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.inactive,
                                                      groupValue: controller.isSubscriptionActive.value,
                                                      onChanged: (value) {
                                                        controller.isSubscriptionActive.value = value ?? Status.inactive;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Inactive",
                                                        style: TextStyle(
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
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Wallet Settings".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Minimum wallet amount to deposit".tr,
                                                // width: 0.35.sw,
                                                hintText: "Enter minimum wallet amount to deposit".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: appSettingsController.minimumDepositController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Minimum wallet amount to withdrawal".tr,
                                                // width: 0.35.sw,
                                                hintText: "Enter minimum wallet amount to withdrawal".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: appSettingsController.minimumWithdrawalController.value),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Driver Settings".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      // spaceH(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      // width: ResponsiveWidget.isDesktop(context) ? 250 : 80,
                                                      child: TextCustom(
                                                        maxLine: 1,
                                                        title: "Global Distance Type".tr,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Tooltip(
                                                      message: 'Calculation base on km and miles',
                                                      child: IconButton(
                                                        icon:  const Icon(Icons.info_outline_rounded,size: 20,color: AppThemData.greyShade400,),
                                                        onPressed: () {},
                                                      ),
                                                    )
                                                  ],
                                                ),

                                                Obx(
                                                  () => DropdownButtonFormField(
                                                    isExpanded: true,
                                                    style: TextStyle(
                                                      fontFamily: AppThemeData.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                    ),
                                                    hint: TextCustom(title: 'Global Distance Type'.tr),
                                                    onChanged: (String? taxType) {
                                                      appSettingsController.selectedDistanceType.value = taxType ?? "Km";
                                                    },
                                                    value: appSettingsController.selectedDistanceType.value,
                                                    items: appSettingsController.distanceType.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: TextCustom(
                                                          title: value,
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.primaryBlack,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    decoration: Constant.DefaultInputDecoration(context),
                                                  ),
                                                ),
                                                spaceH(height: 16)
                                              ],
                                            ),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child:    Expanded(
                                              child: CustomTextFormField(
                                                  tooltipsText: "Driver location update fro live tracking".tr,
                                                  // width: 0.35.sw,
                                                  tooltipsShow: true,
                                                  title: "Driver Location Update".tr,
                                                  hintText: "Enter Driver Location Update".tr,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                  ],
                                                  prefix: Padding(
                                                    padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                    child: Icon(Icons.location_on,
                                                        color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                                    // child: TextCustom(
                                                    //   title: '${Constant.currencyModel!.symbol}',
                                                    //   fontSize: 18,
                                                    // ),
                                                  ),
                                                  controller: appSettingsController.globalDriverLocationUpdateController.value),
                                            ),
                                             // CustomTextFormField(
                                             //    tooltipsText: "Driver location update fro live tracking",
                                             //    tooltipsShow: true,
                                             //    textInputType: TextInputType.name,
                                             //    title: "Driver Location Update".tr,
                                             //    // width: 0.35.sw,
                                             //    hintText: "Enter Driver Location Update".tr,
                                             //    prefix: Icon(Icons.location_on,
                                             //        color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                             //    inputFormatters: [
                                             //      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                             //    ],
                                             //    controller: appSettingsController.globalDriverLocationUpdateController.value),
                                            // Container(
                                            //   child: Icon(Icons.remove_red_eye,size: 20,),
                                            // ),
                                          ),
                                        ],
                                      ),
                                      // spaceH(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                textInputType: TextInputType.name,
                                                tooltipsText: "Near by driver fide out radius ",
                                                tooltipsShow: true,
                                                title: "Radius".tr,
                                                hintText: "Enter radius".tr,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Icon(Icons.location_on,
                                                      color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                controller: appSettingsController.globalRadiusController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Minimum amount to accept ride".tr,
                                                tooltipsText: "Minimum amount to accept ride",
                                                tooltipsShow: true,
                                                hintText: "Enter minimum amount to accept ride".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: appSettingsController.minimumAmountAcceptRideController.value),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Intercity Settings".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                textInputType: TextInputType.name,
                                                tooltipsText: "Near by ride fide out radius ",
                                                tooltipsShow: true,
                                                title: "Radius".tr,
                                                hintText: "Enter radius".tr,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Icon(Icons.location_on,
                                                      color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                controller: appSettingsController.globalInterCityRadiusController.value),
                                          ),
                                          spaceW(width: 16),
                                          const Expanded(child: SizedBox()),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Ride Cancellation Timing".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Seconds".tr,
                                                // width: 0.35.sw,
                                                hintText: "Enter second for cancel Ride".tr,
                                                maxLine: 1,
                                                controller: appSettingsController.secondsForRideCancelController.value,
                                                tooltipsShow: true,
                                                tooltipsText: "Enter seconds to cancel ride when Driver not accept the Ride",
                                                prefix: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: SvgPicture.asset(
                                                      "assets/icons/ic_clock.svg",
                                                      height: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack,
                                                    ))),
                                          ),
                                          spaceW(width: 16),
                                          const Expanded(child: SizedBox()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "App Theme".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "App Colors".tr,
                                                // width: 0.35.sw,
                                                hintText: "Select App Color".tr,
                                                maxLine: 1,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        Color newColor = await showColorPickerDialog(
                                                          context,
                                                          appSettingsController.selectedColor.value,
                                                          width: 40,
                                                          height: 40,
                                                          spacing: 0,
                                                          runSpacing: 0,
                                                          borderRadius: 0,
                                                          enableOpacity: true,
                                                          showColorCode: true,
                                                          colorCodeHasColor: true,
                                                          enableShadesSelection: false,
                                                          pickersEnabled: <ColorPickerType, bool>{
                                                            ColorPickerType.wheel: true,
                                                          },
                                                          copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                            copyButton: true,
                                                            pasteButton: false,
                                                            longPressMenu: false,
                                                          ),
                                                          actionButtons: const ColorPickerActionButtons(
                                                            okButton: true,
                                                            closeButton: true,
                                                            dialogActionButtons: false,
                                                          ),
                                                        );
                                                        appSettingsController.colourCodeController.value.text = "#${newColor.hex}";
                                                        appSettingsController.selectedColor.value = newColor;
                                                      },
                                                      child: Obx(
                                                        () => ClipRRect(
                                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                            child: Container(
                                                              height: 12,
                                                              width: 80,
                                                              color: appSettingsController.selectedColor.value,
                                                            )),
                                                      )),
                                                ),
                                                controller: appSettingsController.colourCodeController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "App Name".tr,
                                                // width: 0.35.sw,
                                                hintText: "Enter App Name".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                                                ],
                                                prefix: const Icon(Icons.drive_file_rename_outline_outlined),
                                                controller: appSettingsController.appNameController.value),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: ScreenSize.width(100, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Spacer(),
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        buttonTitle: "Save".tr,
                                        onPress: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            controller.saveSettingData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          GestureDetector(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(
                                                  title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(
                                              title: ' ${controller.title.value} ',
                                              fontSize: 14,
                                              fontFamily: AppThemeData.medium,
                                              color: AppThemData.primary500)
                                        ])
                                      ],
                                    ),
                                  ],
                                ),
                                spaceH(height: 20),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Admin Commission".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            maxLine: 1,
                                            title: "Commission Type".tr,
                                            fontFamily: AppThemeData.medium,
                                            fontSize: 12,
                                          ),
                                          spaceH(),
                                          Obx(
                                            () => DropdownButtonFormField(
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                              ),
                                              hint: TextCustom(title: 'Select Tax Type'.tr),
                                              onChanged: (String? taxType) {
                                                appSettingsController.selectedAdminCommissionType.value = taxType ?? "Fix";
                                              },
                                              value: appSettingsController.selectedAdminCommissionType.value,
                                              items: appSettingsController.adminCommissionType.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value,
                                                    fontFamily: AppThemeData.regular,
                                                    fontSize: 16,
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.primaryBlack,
                                                  ),
                                                );
                                              }).toList(),
                                              decoration: Constant.DefaultInputDecoration(context),
                                            ),
                                          ),
                                          spaceH(height: 16)
                                        ],
                                      ),
                                      spaceW(width: 16),
                                      CustomTextFormField(
                                          title: "Admin Commission".tr,
                                          hintText: "Enter admin commission".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: appSettingsController.adminCommissionController.value),
                                      Obx(
                                        () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Status".tr,
                                              fontSize: 14,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.active,
                                                      groupValue: appSettingsController.isActive.value,
                                                      onChanged: (value) {
                                                        appSettingsController.isActive.value = value ?? Status.active;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    Text("Active".tr,
                                                        style: const TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: AppThemData.textGrey,
                                                        ))
                                                  ],
                                                ),
                                                spaceW(),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.inactive,
                                                      groupValue: appSettingsController.isActive.value,
                                                      onChanged: (value) {
                                                        appSettingsController.isActive.value = value ?? Status.inactive;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    Text("Inactive".tr,
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
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Document Verification".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      TextCustom(
                                        title: "Do you Want to Enable Document Verification Flow?".tr,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Obx(
                                            () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.active,
                                                      groupValue: controller.isDocumentVerificationActive.value,
                                                      onChanged: (value) {
                                                        controller.isDocumentVerificationActive.value = value ?? Status.active;
                                                        // controller.constantModel.value.isSubscriptionEnable = true;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Active",
                                                        style: TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: AppThemData.textGrey,
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.inactive,
                                                      groupValue: controller.isDocumentVerificationActive.value,
                                                      onChanged: (value) {
                                                        controller.isDocumentVerificationActive.value = value ?? Status.inactive;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Inactive",
                                                        style: TextStyle(
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
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Subscription Plan".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 12),
                                      TextCustom(
                                        title: "Do you Want to Enable Subscription Plan?".tr,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Obx(
                                        () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.active,
                                                      groupValue: controller.isSubscriptionActive.value,
                                                      onChanged: (value) {
                                                        controller.isSubscriptionActive.value = value ?? Status.active;
                                                        // controller.constantModel.value.isSubscriptionEnable = true;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Active",
                                                        style: TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: AppThemData.textGrey,
                                                        ))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: Status.inactive,
                                                      groupValue: controller.isSubscriptionActive.value,
                                                      onChanged: (value) {
                                                        controller.isSubscriptionActive.value = value ?? Status.inactive;
                                                      },
                                                      activeColor: AppThemData.primary500,
                                                    ),
                                                    const Text("Inactive",
                                                        style: TextStyle(
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
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Wallet Settings".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(),
                                      CustomTextFormField(
                                          title: "Minimum wallet amount to deposit".tr,
                                          // width: 0.35.sw,
                                          hintText: "Enter minimum wallet amount to deposit".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: appSettingsController.minimumDepositController.value),
                                      CustomTextFormField(
                                          title: "Minimum wallet amount to withdrawal".tr,
                                          // width: 0.35.sw,
                                          hintText: "Enter minimum wallet amount to withdrawal".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: appSettingsController.minimumWithdrawalController.value),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: CustomTextFormField(
                                      //           title: "Minimum amount to accept ride ".tr,
                                      //           // width: 0.35.sw,
                                      //           hintText: "Enter minimum amount to accept ride".tr,
                                      //           inputFormatters: [
                                      //             FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                      //           ],
                                      //           prefix: Padding(
                                      //             padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                      //             child: TextCustom(
                                      //               title: '${Constant.currencyModel!.symbol}',
                                      //               fontSize: 18,
                                      //             ),
                                      //           ),
                                      //           controller: appSettingsController.minimumAmountAcceptRideController.value),
                                      //     ),
                                      //     spaceW(width: 16),
                                      //     Expanded(
                                      //       child: Container(),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Driver Settings".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                // width: ResponsiveWidget.isDesktop(context) ? 250 : 80,
                                                child: TextCustom(
                                                  maxLine: 1,
                                                  title: "Global Distance Type".tr,
                                                  // fontFamily: AppThemeData.medium,
                                                  // fontSize: 14,
                                                ),
                                              ),
                                              const Tooltip(
                                                message: 'Calculation base on km and miles',
                                                child:Icon(Icons.info_outline_rounded,size: 20,color: AppThemData.greyShade400,),
                                              )
                                            ],
                                          ),
                                          spaceH(height: 8),
                                          Obx(
                                            () => DropdownButtonFormField(
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: AppThemeData.medium,
                                                color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                              ),
                                              hint: TextCustom(title: 'Global Distance Type'.tr),
                                              onChanged: (String? taxType) {
                                                appSettingsController.selectedDistanceType.value = taxType ?? "Km";
                                              },
                                              value: appSettingsController.selectedDistanceType.value,
                                              items: appSettingsController.distanceType.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value,
                                                    fontFamily: AppThemeData.regular,
                                                    fontSize: 16,
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.primaryBlack,
                                                  ),
                                                );
                                              }).toList(),
                                              decoration: Constant.DefaultInputDecoration(context),
                                            ),
                                          ),
                                          spaceH(height: 12)
                                        ],
                                      ),
                                      CustomTextFormField(
                                          tooltipsText: "Driver location update fro live tracking",
                                          tooltipsShow: true,
                                          textInputType: TextInputType.name,
                                          title: " Driver Location Update".tr,
                                          // width: 0.35.sw,
                                          hintText: "Enter Driver Location Update".tr,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:
                                                Icon(Icons.location_on, color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          controller: appSettingsController.globalDriverLocationUpdateController.value),
                                      CustomTextFormField(
                                          textInputType: TextInputType.name,
                                          tooltipsText: "Near by driver fide out radius ",
                                          tooltipsShow: true,
                                          title: "Radius".tr,
                                          hintText: "Enter radius".tr,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child:
                                                Icon(Icons.location_on, color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          controller: appSettingsController.globalRadiusController.value),
                                      CustomTextFormField(
                                          title: "Minimum amount to accept ride ".tr,
                                          tooltipsText: "Minimum amount to accept ride",
                                          tooltipsShow: true,
                                          hintText: "Enter minimum amount to accept ride".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: appSettingsController.minimumAmountAcceptRideController.value)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Intercity Settings".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   children: [
                                          //     TextCustom(
                                          //       title: "Intercity Bid".tr,
                                          //       fontSize: 14,
                                          //     ),
                                          //     spaceW(width: 10),
                                          //     Row(
                                          //       children: [
                                          //         Radio(
                                          //           value: StatusInterCity.active,
                                          //           groupValue: appSettingsController.isInterBid.value,
                                          //           onChanged: (value) {
                                          //             appSettingsController.isInterBid.value = value ?? StatusInterCity.active;
                                          //           },
                                          //           activeColor: AppThemData.primary500,
                                          //         ),
                                          //         Text("Active".tr,
                                          //             style: const TextStyle(
                                          //               fontFamily: AppThemeData.regular,
                                          //               fontSize: 16,
                                          //               color: AppThemData.textGrey,
                                          //             ))
                                          //       ],
                                          //     ),
                                          //     spaceW(),
                                          //     Row(
                                          //       children: [
                                          //         Radio(
                                          //           value: StatusInterCity.inactive,
                                          //           groupValue: appSettingsController.isInterBid.value,
                                          //           onChanged: (value) {
                                          //             appSettingsController.isInterBid.value = value ?? StatusInterCity.inactive;
                                          //           },
                                          //           activeColor: AppThemData.primary500,
                                          //         ),
                                          //         Text("Inactive".tr,
                                          //             style: const TextStyle(
                                          //               fontFamily: AppThemeData.regular,
                                          //               fontSize: 16,
                                          //               color: AppThemData.textGrey,
                                          //             ))
                                          //       ],
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     TextCustom(
                                          //       title: "Parcel Bid".tr,
                                          //       fontSize: 14,
                                          //     ),
                                          //     spaceW(width: 10),
                                          //     Row(
                                          //       children: [
                                          //         Radio(
                                          //           value: StatusParcel.active,
                                          //           groupValue: appSettingsController.isParcelBid.value,
                                          //           onChanged: (value) {
                                          //             appSettingsController.isParcelBid.value = value ?? StatusParcel.active;
                                          //           },
                                          //           activeColor: AppThemData.primary500,
                                          //         ),
                                          //         Text("Active".tr,
                                          //             style: const TextStyle(
                                          //               fontFamily: AppThemeData.regular,
                                          //               fontSize: 16,
                                          //               color: AppThemData.textGrey,
                                          //             ))
                                          //       ],
                                          //     ),
                                          //     spaceW(),
                                          //     Row(
                                          //       children: [
                                          //         Radio(
                                          //           value: StatusParcel.inactive,
                                          //           groupValue: appSettingsController.isParcelBid.value,
                                          //           onChanged: (value) {
                                          //             appSettingsController.isParcelBid.value = value ?? StatusParcel.inactive;
                                          //           },
                                          //           activeColor: AppThemData.primary500,
                                          //         ),
                                          //         Text("Inactive".tr,
                                          //             style: const TextStyle(
                                          //               fontFamily: AppThemeData.regular,
                                          //               fontSize: 16,
                                          //               color: AppThemData.textGrey,
                                          //             ))
                                          //       ],
                                          //     ),
                                          //   ],
                                          // )
                                          CustomTextFormField(
                                              textInputType: TextInputType.name,
                                              tooltipsText: "Near by ride fide out radius ",
                                              tooltipsShow: true,
                                              title: "Radius".tr,
                                              hintText: "Enter radius".tr,
                                              prefix: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Icon(Icons.location_on,
                                                    color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                              ],
                                              controller: appSettingsController.globalInterCityRadiusController.value),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Ride Cancellation Timing".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "Seconds".tr,
                                          // width: 0.35.sw,
                                          hintText: "Enter second for cancel service".tr,
                                          maxLine: 1,
                                          controller: appSettingsController.secondsForRideCancelController.value,
                                          tooltipsShow: true,
                                          tooltipsText: "Enter seconds to cancel ride when Driver not accept the Ride",
                                          prefix: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: SvgPicture.asset(
                                                "assets/icons/ic_clock.svg",
                                                height: 16,
                                                color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack,
                                              ))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "App Theme".tr.toUpperCase(),
                                        fontFamily: AppThemeData.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "App Colors".tr,
                                          // width: 0.35.sw,
                                          hintText: "Select App Color".tr,
                                          maxLine: 1,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () async {
                                                  Color newColor = await showColorPickerDialog(
                                                    context,
                                                    appSettingsController.selectedColor.value,
                                                    width: 40,
                                                    height: 40,
                                                    spacing: 0,
                                                    runSpacing: 0,
                                                    borderRadius: 0,
                                                    enableOpacity: true,
                                                    showColorCode: true,
                                                    colorCodeHasColor: true,
                                                    enableShadesSelection: false,
                                                    pickersEnabled: <ColorPickerType, bool>{
                                                      ColorPickerType.wheel: true,
                                                    },
                                                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                      copyButton: true,
                                                      pasteButton: false,
                                                      longPressMenu: false,
                                                    ),
                                                    actionButtons: const ColorPickerActionButtons(
                                                      okButton: true,
                                                      closeButton: true,
                                                      dialogActionButtons: false,
                                                    ),
                                                  );
                                                  appSettingsController.colourCodeController.value.text = "#${newColor.hex}";
                                                  appSettingsController.selectedColor.value = newColor;
                                                },
                                                child: Obx(
                                                  () => ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                      child: Container(
                                                        height: 12,
                                                        width: 80,
                                                        color: appSettingsController.selectedColor.value,
                                                      )),
                                                )),
                                          ),
                                          controller: appSettingsController.colourCodeController.value),
                                      spaceW(width: 16),
                                      CustomTextFormField(
                                          title: "App Name".tr,
                                          // width: 0.35.sw,
                                          hintText: "Enter App Name".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                                          ],
                                          prefix: const Icon(Icons.drive_file_rename_outline_outlined),
                                          controller: appSettingsController.appNameController.value),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenSize.width(100, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Spacer(),
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        buttonTitle: "Save".tr,
                                        onPress: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            controller.saveSettingData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
