import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:admin/app/modules/support_reason/controllers/support_reason_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SupportReasonView extends GetView<SupportReasonController> {
  const SupportReasonView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SupportReasonController>(
        init: SupportReasonController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ResponsiveWidget.isDesktop(context)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
                              spaceH(height: 2),
                              Row(children: [
                                GestureDetector(
                                    onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                    child: TextCustom(
                                        title: 'Dashboard'.tr,
                                        fontSize: 14,
                                        fontFamily: AppThemeData.medium,
                                        color: AppThemData.greyShade500)),
                                const TextCustom(
                                    title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                TextCustom(
                                    title: 'Settings'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                const TextCustom(
                                    title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                TextCustom(
                                    title: ' ${controller.title.value} '.tr,
                                    fontSize: 14,
                                    fontFamily: AppThemeData.medium,
                                    color: AppThemData.primary500)
                              ])
                            ],
                          )
                        : TextCustom(
                            title: ' ${controller.title.value} '.tr,
                            fontSize: 14,
                            fontFamily: AppThemeData.medium,
                            color: AppThemData.primaryBlack),
                    CustomButtonWidget(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      buttonTitle: "+ Add Reason".tr,
                      onPress: () {
                        controller.setDefaultData();
                        showDialog(context: context, builder: (context) => const AddReasonDialog());
                      },
                    ),
                  ],
                ),
                spaceH(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: controller.supportReasonList.isEmpty
                        ? Padding(
                            padding: paddingEdgeInsets(),
                            child: Constant.loader(),
                          )
                        : DataTable(
                            horizontalMargin: 20,
                            columnSpacing: 30,
                            dataRowMaxHeight: 65,
                            headingRowHeight: 65,
                            border: TableBorder.all(
                              color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) => themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
                            columns: [
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Id".tr,
                                  width: ResponsiveWidget.isMobile(context) ? 20 : MediaQuery.of(context).size.width * 0.07),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Reason".tr,
                                  width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.32),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Type".tr,
                                  width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.13),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Actions".tr,
                                  width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.12),
                            ],
                            rows: controller.supportReasonList
                                .map((supportReasonModel) => DataRow(cells: [
                                      DataCell(TextCustom(
                                        title: "${controller.supportReasonList.indexWhere((element) => element == supportReasonModel) + 1}",
                                      )),
                                      DataCell(TextCustom(
                                        title: supportReasonModel.reason ?? "N/A",
                                      )),
                                      DataCell(TextCustom(title: supportReasonModel.type == "customer" ? "Customer".tr : "Driver".tr)),
                                      DataCell(
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (Constant.isDemo) {
                                                    DialogBox.demoDialogBox();
                                                  } else {
                                                    controller.isEditing.value = true;
                                                    controller.supportReasonModel.value.id = supportReasonModel.id;
                                                    controller.supportReasonController.value.text = supportReasonModel.reason!;
                                                    controller.selectedType.value = supportReasonModel.type!;
                                                    showDialog(context: context, builder: (context) => const AddReasonDialog());
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/icons/ic_edit.svg",
                                                  color: AppThemData.greyShade400,
                                                  height: 16,
                                                  width: 16,
                                                ),
                                              ),
                                              spaceW(width: 20),
                                              InkWell(
                                                onTap: () async {
                                                  if (Constant.isDemo) {
                                                    DialogBox.demoDialogBox();
                                                  } else {
                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                    if (confirmDelete) {
                                                      await controller.removeSupportReason(supportReasonModel);
                                                      controller.getData();
                                                    }
                                                  }
                                                },
                                                child: SvgPicture.asset(
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
                )
              ],
            ),
          );
        });
  }
}

class AddReasonDialog extends StatelessWidget {
  const AddReasonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SupportReasonController>(
        init: SupportReasonController(),
        builder: (controller) {
          return Dialog(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                            color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextCustom(title: '${controller.title}'.tr, fontSize: 18),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 25,
                                ),
                              )
                            ],
                          )).expand(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                            hintText: 'Enter Support Reason'.tr,
                            controller: controller.supportReasonController.value,
                            title: 'Reason *'.tr),
                        spaceH(height: 10),
                        TextCustom(
                          title: "Type *".tr,
                          fontSize: 14,
                        ),
                        spaceH(height: 10),
                        DropdownButtonFormField(
                          isExpanded: true,
                          isDense: true,
                          decoration: Constant.DefaultInputDecoration(context),
                          onChanged: (String? type) {
                            controller.selectedType.value = type ?? "customer";
                          },
                          value: controller.selectedType.value,
                          items: controller.type.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value == "customer" ? "Customer".tr : "Driver".tr,
                                style: TextStyle(
                                  fontFamily: AppThemeData.regular,
                                  fontSize: 16,
                                  color: AppThemData.primaryBlack,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        spaceH(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              buttonTitle: "Close".tr,
                              buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                              onPress: () {},
                            ),
                            spaceW(),
                            CustomButtonWidget(
                              buttonTitle: controller.isEditing.value ? "Save".tr : "Save".tr,
                              onPress: () {
                                if (Constant.isDemo) {
                                  DialogBox.demoDialogBox();
                                } else {
                                  if (controller.supportReasonController.value.text.isNotEmpty &&
                                      controller.selectedType.value.isNotEmpty) {
                                    controller.isEditing.value ? controller.updateSupportReason() : controller.addSupportReason();
                                    controller.setDefaultData();
                                    Navigator.pop(context);
                                  } else {
                                    ShowToastDialog.toast("All Fields are Required...".tr);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
