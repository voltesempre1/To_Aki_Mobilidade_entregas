// ignore_for_file: deprecated_member_use

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/components/network_image_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/responsive.dart';
import '../controllers/driver_screen_controller.dart';

class DriverScreenView extends GetView<DriverScreenController> {
  const DriverScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DriverScreenController>(
      init: DriverScreenController(),
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                        ])
                                      ]),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Obx(
                                              () => DropdownButtonFormField(
                                                borderRadius: BorderRadius.circular(15),
                                                isExpanded: true,
                                                style: TextStyle(
                                                  fontFamily: AppThemeData.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                ),
                                                onChanged: (String? searchType) {
                                                  controller.selectedSearchType.value = searchType ?? "Name";
                                                  controller.getSearchType();
                                                },
                                                value: controller.selectedSearchType.value,
                                                items: controller.searchType.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: TextCustom(
                                                      title: value,
                                                      fontFamily: AppThemeData.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                    ),
                                                  );
                                                }).toList(),
                                                decoration: Constant.DefaultInputDecoration(context),
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          SizedBox(
                                            height: 41,
                                            width: ResponsiveWidget.isDesktop(context) ? MediaQuery.of(context).size.width * 0.15 : 200,
                                            child: CustomTextFormField(
                                              bottom: 0,
                                              hintText: "Search here",
                                              controller: controller.searchController.value,
                                              onSubmit: (value) async {
                                                if (controller.isSearchEnable.value) {
                                                  await FireStoreUtils.countSearchDrivers(
                                                      controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                  controller.isSearchEnable.value = false;
                                                } else {
                                                  controller.searchController.value.text = "";
                                                  controller.getUser();
                                                  controller.isSearchEnable.value = true;
                                                }
                                              },
                                              suffix: IconButton(
                                                onPressed: () async {
                                                  if (controller.isSearchEnable.value) {
                                                    await FireStoreUtils.countSearchDrivers(
                                                        controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                    controller.setPagination(controller.totalItemPerPage.value);
                                                    controller.isSearchEnable.value = false;
                                                  } else {
                                                    controller.searchController.value.text = "";
                                                    controller.getUser();
                                                    controller.isSearchEnable.value = true;
                                                  }
                                                },
                                                icon: Icon(
                                                  controller.isSearchEnable.value ? Icons.search : Icons.clear,
                                                ),
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                          ContainerCustom(
                                              padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                              color: AppThemData.primary500,
                                              child: IconButton(
                                                onPressed: () {
                                                  controller.dateRangeController.value.text = "";
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => CustomDialog(
                                                        controller: controller,
                                                        title: "Drivers Data Download",
                                                        widgetList: [
                                                          CustomTextFormField(
                                                            validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                            hintText: "Select Start & End Date",
                                                            controller: controller.dateRangeController.value,
                                                            title: "Start & End Date",
                                                            onPress: () {
                                                              showDateRangePickerForPdf(context);
                                                            },
                                                            isReadOnly: true,
                                                            suffix: const Icon(
                                                              Icons.calendar_month_outlined,
                                                              color: AppThemData.greyShade500,
                                                              size: 24,
                                                            ),
                                                          )
                                                        ],
                                                        bottomWidgetList: [
                                                          CustomButtonWidget(
                                                            buttonTitle: "Close",
                                                            textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                            buttonColor: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade900
                                                                : AppThemData.greyShade100,
                                                            onPress: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          spaceW(),
                                                          CustomButtonWidget(
                                                            buttonTitle: "Download".tr,
                                                            onPress: () {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                              } else {
                                                                if(controller.dateRangeController.value.text.isNotEmpty){
                                                                  controller.downloadDriverDataPdf();
                                                                  Navigator.pop(context);
                                                                }else {
                                                                  ShowToast.successToast("Please Select the Date..");
                                                                }
                                                                // Add your download logic here
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                                },
                                                icon: SvgPicture.asset(
                                                  "assets/icons/ic_downlod.svg",
                                                  color: AppThemData.primaryWhite,
                                                  height: 18,
                                                  width: 18,
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          GestureDetector(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
                                      SizedBox(
                                        width: MediaQuery.sizeOf(context).width *0.8,
                                        child: Obx(
                                          () => DropdownButtonFormField(
                                            borderRadius: BorderRadius.circular(15),
                                            isExpanded: true,
                                            style: TextStyle(
                                              fontFamily: AppThemeData.medium,
                                              color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                            ),
                                            onChanged: (String? searchType) {
                                              controller.selectedSearchType.value = searchType ?? "Name";
                                              controller.getSearchType();
                                            },
                                            value: controller.selectedSearchType.value,
                                            items: controller.searchType.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: TextCustom(
                                                  title: value,
                                                  fontFamily: AppThemeData.regular,
                                                  fontSize: 16,
                                                ),
                                              );
                                            }).toList(),
                                            decoration: Constant.DefaultInputDecoration(context),
                                          ),
                                        ),
                                      ),
                                      spaceH(),
                                      SizedBox(
                                        height: 50,
                                        width: MediaQuery.sizeOf(context).width *0.8,
                                        child: CustomTextFormField(
                                          bottom: 0,
                                          hintText: "Search here",
                                          controller: controller.searchController.value,
                                          onSubmit: (value) async {
                                            if (controller.isSearchEnable.value) {
                                              await FireStoreUtils.countSearchDrivers(
                                                  controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                              controller.setPagination(controller.totalItemPerPage.value);
                                              controller.isSearchEnable.value = false;
                                            } else {
                                              controller.searchController.value.text = "";
                                              controller.getUser();
                                              controller.isSearchEnable.value = true;
                                            }
                                          },
                                          suffix: IconButton(
                                            onPressed: () async {
                                              if (controller.isSearchEnable.value) {
                                                await FireStoreUtils.countSearchDrivers(
                                                    controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                controller.setPagination(controller.totalItemPerPage.value);
                                                controller.isSearchEnable.value = false;
                                              } else {
                                                controller.searchController.value.text = "";
                                                controller.getUser();
                                                controller.isSearchEnable.value = true;
                                              }
                                            },
                                            icon: Icon(
                                              controller.isSearchEnable.value ? Icons.search : Icons.clear,
                                            ),
                                          ),
                                        ),
                                      ),
                                      spaceH(),
                                      Row(
                                        children: [
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                          ContainerCustom(
                                              padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                              color: AppThemData.primary500,
                                              child: IconButton(
                                                onPressed: () {
                                                  controller.dateRangeController.value.text = "";
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => CustomDialog(
                                                        controller: controller,
                                                        title: "Drivers Data Download",
                                                        widgetList: [
                                                          CustomTextFormField(
                                                            validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                            hintText: "Select Start & End Date",
                                                            controller: controller.dateRangeController.value,
                                                            title: "Start & End Date",
                                                            onPress: () {
                                                              showDateRangePickerForPdf(context);
                                                            },
                                                            isReadOnly: true,
                                                            suffix: const Icon(
                                                              Icons.calendar_month_outlined,
                                                              color: AppThemData.greyShade500,
                                                              size: 24,
                                                            ),
                                                          )
                                                        ],
                                                        bottomWidgetList: [
                                                          CustomButtonWidget(
                                                            buttonTitle: "Close",
                                                            textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                            buttonColor: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade900
                                                                : AppThemData.greyShade100,
                                                            onPress: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          spaceW(),
                                                          CustomButtonWidget(
                                                            buttonTitle: "Download".tr,
                                                            onPress: () {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                              } else {
                                                                if(controller.dateRangeController.value.text.isNotEmpty){
                                                                  controller.downloadDriverDataPdf();
                                                                  Navigator.pop(context);
                                                                }else {
                                                                  ShowToast.successToast("Please Select the Date..");
                                                                }
                                                                // Add your download logic here
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                                },
                                                icon: SvgPicture.asset(
                                                  "assets/icons/ic_downlod.svg",
                                                  color: AppThemData.primaryWhite,
                                                  height: 18,
                                                  width: 18,
                                                ),
                                              )),
                                        ],
                                      )
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
                                    : controller.currentPageDriver.isEmpty
                                        ? TextCustom(title: "No Data available".tr)
                                        : DataTable(
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
                                              CommonUI.dataColumnWidget(context, columnTitle: "Profile Image".tr, width: 150),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Full Name".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Gender".tr, width: 150),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "CreatedAt".tr,
                                                  width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Is Verify".tr, width: 150),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Wallet Amount".tr, width: 140),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Status".tr, width: 100),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: 100),
                                            ],
                                            rows: controller.currentPageDriver
                                                .map((driverUserModel) => DataRow(cells: [
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: NetworkImageWidget(
                                                            imageUrl: '${driverUserModel.profilePic}',
                                                            height: 37,
                                                            width: 37,
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(TextCustom(
                                                          title:
                                                              "${driverUserModel.fullName!.isEmpty || driverUserModel.fullName == null ? "N/A".tr : driverUserModel.fullName.toString() == "Unknown User" ? "User Deleted".tr : driverUserModel.fullName.toString()}\n${Constant.maskMobileNumber(mobileNumber: driverUserModel.phoneNumber, countryCode: driverUserModel.countryCode)}")),
                                                      DataCell(TextCustom(title: "${driverUserModel.gender}")),
                                                      DataCell(TextCustom(
                                                          title: driverUserModel.createdAt == null ? '' : Constant.timestampToDateTime(driverUserModel.createdAt!))),
                                                      DataCell(
                                                        TextCustom(
                                                            title: driverUserModel.isVerified! == true ? "Verify" : "Not Verified",
                                                            color: driverUserModel.isVerified! == true ? const Color(0xff10A944) : const Color(0xffEB4848)),
                                                      ),
                                                      DataCell(TextCustom(title: Constant.amountShow(amount: driverUserModel.walletAmount))),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            activeColor: AppThemData.primary500,
                                                            value: driverUserModel.isActive ?? false,
                                                            onChanged: (value) async {
                                                              if(Constant.isDemo){
                                                                DialogBox.demoDialogBox();
                                                              }else{
                                                                driverUserModel.isActive = value;
                                                                await FireStoreUtils.updateDriver(driverUserModel);
                                                                controller.getUser();
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  // print("::::::::::::::::::::::::::::::::::::::${driverUserModel.toJson()}");
                                                                //  Get.toNamed(Routes.DRIVER_DETAIL_SCREEN, arguments: {'driverModel': driverUserModel});
                                                                  // Get.toNamed(Routes.BOOKING_DETAIL, arguments: {'bookingModel': bookingModel});
                                                                  // Get.toNamed(Routes.BOOKING_DETAIL, arguments: {'bookingModel': bookingModel});
                                                                  // BookingHistoryDetailController bookingHistoryDetailController = Get.put(BookingHistoryDetailController());
                                                                  // await bookingHistoryDetailController.getArgument(bookingModel);
                                                                  //
                                                                  // HomeController homeController = Get.put(HomeController());

                                                                  Get.toNamed('${Routes.DRIVER_DETAIL_SCREEN}/${driverUserModel.id}');

                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_eye.svg",
                                                                  color: AppThemData.greyShade400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () {
                                                                  controller.getArgument(driverUserModel);
                                                                  showGlobalDrawer(
                                                                      duration: const Duration(milliseconds: 200),
                                                                      barrierDismissible: true,
                                                                      context: context,
                                                                      builder: horizontalDrawerBuilder(),
                                                                      direction: AxisDirection.right);
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
                                                                    // await controller.removeDriver(driverUserModel);
                                                                    // controller.getUser();
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      await controller.removeDriver(driverUserModel);
                                                                      controller.getUser();
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
                            ),
                            spaceH(),
                            ResponsiveWidget.isMobile(context)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: WebPagination(
                                                currentPage: controller.currentPage.value,
                                                totalPage: controller.totalPage.value,
                                                displayItemCount: controller.pageValue("5"),
                                                onPageChanged: (page) {
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                          ]),
                        )
                      ]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> showDateRangePickerForPdf(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDateForPdf = (args.value as PickerDateRange).startDate;
                  controller.endDateForPdf = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(
                      start: DateTime(DateTime.now().year, DateTime.january, 1),
                      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(
                      start: controller.startDateForPdf!,
                      end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));
                  controller.dateRangeController.value.text =
                  "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}";
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  WidgetBuilder horizontalDrawerBuilder() {
    return (BuildContext context) {
      final themeChange = Provider.of<DarkThemeProvider>(context);

      return GetX<DriverScreenController>(
          init: DriverScreenController(),
          builder: (taxController) {
            return Drawer(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
              width: 500,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.arrow_back_ios_new_outlined)),
                    ),
                  ),
                  Padding(
                    padding: paddingEdgeInsets(vertical: 24, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextCustom(title: controller.title.value, fontSize: 20),
                          ],
                        ),
                        spaceH(height: 24),
                        SizedBox(
                          height: 1,
                          child: ContainerCustom(
                            color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                          ),
                        ),
                        spaceH(height: 40),
                        controller.imagePath.value.path.isEmpty
                            ? SizedBox(
                                height: 100,
                                width: 100,
                                child: Stack(
                                  children: [
                                    NetworkImageWidget(
                                      borderRadius: 60,
                                      imageUrl: controller.imageController.value.text.toString(),
                                      height: 100,
                                      width: 100,
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      child: InkWell(
                                        onTap: () {
                                          controller.pickPhoto();
                                        },
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : controller.uploading.value
                                ? Center(child: Constant.loader())
                                : SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: Image.memory(
                                            controller.imagePickedFileBytes.value,
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional.bottomEnd,
                                          child: InkWell(
                                            onTap: () {
                                              controller.pickPhoto();
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        spaceH(height: 40),
                        Column(
                          children: [
                            CustomTextFormField(
                              title: "First Name *".tr,
                              hintText: "Enter first name".tr,
                              controller: controller.userNameController.value,
                            ),
                            spaceH(height: 20),
                            CustomTextFormField(
                              isReadOnly: true,
                              title: "Phone Number *".tr,
                              hintText: "Enter phone number".tr,
                              controller: controller.phoneNumberController.value,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              isReadOnly: true,
                              title: "Email Address *".tr,
                              hintText: "Enter email".tr,
                              controller: controller.emailController.value,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            CustomButtonWidget(
                                buttonTitle: "Save".tr,
                                onPress: () async {
                                  if (Constant.isDemo) {
                                    DialogBox.demoDialogBox();
                                  } else {
                                    Constant.waitingLoader();
                                    if (controller.imagePath.value.path.isNotEmpty) {
                                      String? downloadUrl = await FireStoreUtils.uploadPic(
                                          PickedFile(controller.imagePath.value.path), "profileImage".tr, controller.editingId.value, controller.mimeType.value);
                                      controller.driverModel.value.profilePic = downloadUrl;
                                      log(downloadUrl.toString());
                                    }
                                    controller.driverModel.value.id = controller.editingId.value;
                                    controller.driverModel.value.fullName = controller.userNameController.value.text;
                                    bool isSaved = await FireStoreUtils.updateDriver(controller.driverModel.value);
                                    if (isSaved) {
                                      Get.back();
                                      ShowToast.successToast("Users data updated".tr);
                                    } else {
                                      ShowToast.errorToast("Something went wrong, Please try later!".tr);
                                      Get.back();
                                    }
                                  }
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    };
  }
}
