// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/menu_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/intercity_service_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterCityServiceScreenView extends GetView<IntercityServiceController> {
  const InterCityServiceScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<IntercityServiceController>(
      init: IntercityServiceController(),
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
                                TextCustom(
                                  title: 'My Taxi'.tr,
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
                  child: Obx(
                    () => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                            TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
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
                                                  title: ' ${controller.title.value} ',
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.medium,
                                                  color: AppThemData.primary500)
                                            ])
                                          ]),
                                          // CustomButtonWidget(
                                          //   padding: const EdgeInsets.symmetric(horizontal: 22),
                                          //   buttonTitle: "+ Add Intercity Service".tr,
                                          //   borderRadius: 10,
                                          //   onPress: () {
                                          //     controller.setDefaultData();
                                          //     showDialog(context: context, builder: (context) => InterCityServiceDialog());
                                          //   },
                                          // ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
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
                                                  title: ' ${controller.title.value} ',
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.medium,
                                                  color: AppThemData.primary500)
                                            ])
                                          ]),
                                          spaceH(),
                                          // CustomButtonWidget(
                                          //   width: MediaQuery.sizeOf(context).width * 0.7,
                                          //   padding: const EdgeInsets.symmetric(horizontal: 22),
                                          //   buttonTitle: "+ Add Document".tr,
                                          //   borderRadius: 10,
                                          //   onPress: () {
                                          //     controller.setDefaultData();
                                          //     showDialog(context: context, builder: (context) => InterCityServiceDialog());
                                          //   },
                                          // ),
                                        ],
                                      ),
                                spaceH(height: 20),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: controller.isLoading.value
                                          ? Padding(
                                              padding: paddingEdgeInsets(),
                                              child: Constant.loader(),
                                            )
                                          : Obx(() {
                                              if (controller.isLoading.value) {
                                                return const Center(child: CircularProgressIndicator());
                                              }

                                              if (controller.intercityDocuments.isEmpty) {
                                                return TextCustom(title: "No Data Available".tr);
                                              }

                                              return DataTable(
                                                horizontalMargin: 20,
                                                columnSpacing: 30,
                                                dataRowMaxHeight: 65,
                                                headingRowHeight: 65,
                                                border: TableBorder.all(
                                                  color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                headingRowColor: MaterialStateColor.resolveWith(
                                                  (states) => themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                ),
                                                columns: [
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Title".tr, width: MediaQuery.of(context).size.width * 0.2),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Bid Status".tr, width: MediaQuery.of(context).size.width * 0.2),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Status".tr, width: MediaQuery.of(context).size.width * 0.2),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Actions".tr, width: MediaQuery.of(context).size.width * 0.1),
                                                ],
                                                rows: controller.intercityDocuments.map((doc) {
                                                  return DataRow(cells: [
                                                    DataCell(TextCustom(
                                                        title: doc.id == "intercity_sharing"
                                                            ? 'Intercity Sharing'
                                                            : doc.id == "intercity"
                                                                ? 'Intercity Personal'
                                                                : doc.id)),
                                                    // DataCell(TextCustom(title: doc.isParcel ? "True" : "False")),
                                                    DataCell(
                                                      Transform.scale(
                                                        scale: 0.8,
                                                        child: CupertinoSwitch(
                                                          activeColor: AppThemData.primary500,
                                                          value: doc.isBidEnable,
                                                          onChanged: (value) async {
                                                            if(Constant.isDemo){
                                                              DialogBox.demoDialogBox();
                                                            }else{
                                                              await FirebaseFirestore.instance
                                                                  .collection("intercity_service")
                                                                  .doc(doc.id)
                                                                  .update({"isBidEnable": value});
                                                              doc.isBidEnable = value;
                                                              controller.intercityDocuments.refresh();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Transform.scale(
                                                        scale: 0.8,
                                                        child: CupertinoSwitch(
                                                          activeColor: AppThemData.primary500,
                                                          value: doc.isAvailable,
                                                          onChanged: (value) async {
                                                            if(Constant.isDemo){
                                                              DialogBox.demoDialogBox();
                                                            }else {
                                                              await FirebaseFirestore.instance
                                                                  .collection("intercity_service")
                                                                  .doc(doc.id)
                                                                  .update({"isAvailable": value});

                                                              doc.isAvailable = value;
                                                              controller.intercityDocuments.refresh();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              controller.loadIntercityService(doc);
                                                              controller.isFillAll.value = false;
                                                              controller.allFillChecked.value = false;
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) => InterCityServiceDialog(docId: doc.id),
                                                              );
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/icons/ic_edit.svg",
                                                              color: AppThemData.greyShade400,
                                                              height: 16,
                                                              width: 16,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ]);
                                                }).toList(),
                                              );
                                            })),
                                ),
                                spaceH(),
                              ]),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InterCityServiceDialog extends StatelessWidget {
  late final String docId;
  final IntercityServiceController controller = Get.find();

  InterCityServiceDialog({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      alignment: Alignment.topCenter,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(docId == "intercity_sharing" ? 'InterCity Sharing' : docId.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  spaceH(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${docId == "intercity_sharing" ? 'Intercity Sharing' : docId.toString()} Service Settings",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.close,
                            size: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                  spaceH(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.serviceSlots.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: controller.serviceSlots[index].timeSlot,
                            fontSize: 16,
                            color: AppThemData.primary500,
                          ),
                          spaceH(),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: "Enter Minimum Distance (in Km)".tr,
                                  controller: controller.minimumChargeWithKmControllers[index],
                                  title: "Minimum Distance (in Km)".tr,
                                ),
                              ),
                              spaceW(),
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: "Enter Minimum Distance Fare".tr,
                                  controller: controller.minimumChargesControllers[index],
                                  title: "Minimum Distance Fare".tr,
                                ),
                              ),
                              spaceW(),
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: "Enter Rate per Extra Kilometer".tr,
                                  controller: controller.perKmControllers[index],
                                  title: "Rate per Extra Kilometer".tr,
                                ),
                              ),
                            ],
                          ),
                          if (index == 0)
                            Row(
                              children: [
                                Obx(() => Checkbox(
                                      value: controller.allFillChecked.value,
                                      checkColor: AppThemData.gallery500,
                                      fillColor: MaterialStateProperty.all(AppThemData.greyShade200),
                                      // side: controller.allFillChecked.value
                                      //     ? BorderSide.none // Remove border when checked
                                      //     : BorderSide(color: Colors.black, width: 2),

                                      onChanged: (value) {
                                        if (controller.perKmControllers[0].text.trim().isEmpty) {
                                          return ShowToastDialog.toast('Enter your Per Km charge for ${controller.serviceSlots[0].timeSlot}');
                                        }
                                        if (controller.minimumChargeWithKmControllers[0].text.trim().isEmpty) {
                                          return ShowToastDialog.toast('Enter Min Charge With Km for ${controller.serviceSlots[0].timeSlot}');
                                        }
                                        if (controller.minimumChargesControllers[0].text.trim().isEmpty) {
                                          return ShowToastDialog.toast('Enter Minimum Charge for ${controller.serviceSlots[0].timeSlot}');
                                        }

                                        log('=======================> value of check box $value');
                                        if (controller.isFillAll.value != true) {
                                          controller.allFillChecked.value = value!;
                                          controller.isFillAll.value = value;
                                          if (value) {
                                            controller.fillAllValues();
                                          }
                                        }
                                      },
                                    )),
                                const TextCustom(
                                  title: 'Apply for all',
                                  fontSize: 14,
                                  color: AppThemData.gallery500,
                                ),
                                // ),
                              ],
                            ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: CustomTextFormField(
                          //         hintText: "Enter per km".tr,
                          //         controller: controller.perKmControllers[index],
                          //         title: "Per Km".tr,
                          //       ),
                          //     ),
                          //     spaceW(),
                          //     Expanded(
                          //       child: CustomTextFormField(
                          //         hintText: "Enter Min Charge With Km".tr,
                          //         controller: controller.minimumChargeWithKmControllers[index],
                          //         title: "Min Charge With Km".tr,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // spaceH(),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: CustomTextFormField(
                          //         hintText: "Enter Minimum Charge".tr,
                          //         controller: controller.minimumChargesControllers[index],
                          //         title: "Minimum Charge".tr,
                          //       ),
                          //     ),
                          //     const Expanded(child: SizedBox())
                          //   ],
                          // ),
                          // spaceH(),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButtonWidget(buttonTitle: "Close".tr, onPress: () => Get.back()),
                      spaceW(),
                      CustomButtonWidget(buttonTitle: "Save".tr, onPress: () {
                        if(Constant.isDemo){
                          DialogBox.demoDialogBox();
                        }else{
                         controller.saveToFirestore();
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// class InterCityServiceDialog extends StatelessWidget {
//   const InterCityServiceDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     final controller = Get.find<IntercityServiceController>();
//
//     return Dialog(
//       backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       alignment: Alignment.topCenter,
//       child: SizedBox(
//         width: 600,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
//                   color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const TextCustom(title: "Intercity Service Settings", fontSize: 18),
//                     InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: const Icon(Icons.close, size: 25),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.timeSlots.length,
//                     itemBuilder: (context, index) {
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextCustom(title: controller.timeSlots[index], fontSize: 16),
//                           spaceH(),
//                                Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//
//                                   spaceH(),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: CustomTextFormField(
//                                           hintText: 'Enter per km'.tr,
//                                           controller: controller.perKmController.value,
//                                           title: 'Per Km'.tr,
//                                           onChanged: (value) => ()
//
//                                         ),
//                                       ),
//                                       spaceW(),
//                                       Expanded(
//                                         child: CustomTextFormField(
//                                           hintText: 'Enter Min Charge With Km'.tr,
//                                           controller: controller.minimumChargesController.value,
//                                           title: 'Min Charge With Km'.tr,
//                                           onChanged: (value) => ()
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   spaceH(),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: CustomTextFormField(
//                                           hintText: 'Enter Minimum Charge'.tr,
//                                           controller: controller.minimumChargeWithKmController.value,
//                                           title: 'Minimum Charge'.tr,
//                                           onChanged: (value) => ()
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   spaceH(),
//                                 ],
//
//                             )
//                         ],
//                       );
//                     },
//                   );
//                 }),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     CustomButtonWidget(
//                       buttonTitle: "Close".tr,
//                       buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
//                       onPress: () => Navigator.pop(context),
//                     ),
//                     spaceW(),
//                     CustomButtonWidget(
//                       buttonTitle: "Save".tr,
//                       onPress: () => controller.saveToFirestore(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InterCityServiceDialog extends StatelessWidget {
//   const InterCityServiceDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     return GetX<IntercityServiceController>(
//       init: IntercityServiceController(),
//       builder: (controller) {
//         return CustomDialog(
//           title: controller.title.value,
//           widgetList: [
//             CustomTextFormField(hintText: 'Enter Title'.tr, controller: controller.documentNameController.value, title: 'Title *'.tr),
//             spaceH(),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                     child: GestureDetector(
//                         onTap: () {
//                           log('=====> select time start');
//                           controller.selectTime(Get.context!, controller.startTimeController);
//                         },
//                         child: CustomTextFormField(
//                           hintText: 'Enter start time'.tr,
//                           controller: controller.documentNameController.value,
//                           title: 'Start Time'.tr,
//                           isReadOnly: true,
//                         ))),
//                 spaceW(),
//                 Expanded(
//                     child: GestureDetector(
//                   onTap: () {
//                     log('---------------> select end time ');
//                     controller.selectTime(Get.context!, controller.endTimeController);
//                   },
//                   child: CustomTextFormField(
//                     hintText: 'Enter end time'.tr,
//                     controller: controller.documentNameController.value,
//                     title: 'End Time'.tr,
//                     isReadOnly: true,
//                   ),
//                 )),
//               ],
//             ),
//           ],
//           bottomWidgetList: [
//             CustomButtonWidget(
//               buttonTitle: "Close".tr,
//               buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
//               onPress: () {
//                 controller.setDefaultData();
//                 Navigator.pop(context);
//               },
//             ),
//             spaceW(),
//             CustomButtonWidget(
//               buttonTitle: controller.isEditing.value ? "Edit".tr : "Save".tr,
//               onPress: () {
//                 if (Constant.isDemo) {
//                   DialogBox.demoDialogBox();
//                 } else {
//                   if (controller.documentNameController.value.text != "") {
//                     controller.isEditing.value ? controller.updateDocument() : controller.addDocument();
//                     controller.setDefaultData();
//                     Navigator.pop(context);
//                   } else {
//                     ShowToastDialog.toast("All Fields are Required...".tr);
//                   }
//                 }
//               },
//             ),
//           ],
//           controller: controller,
//         );
//       },
//     );
//   }
// }
