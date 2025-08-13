// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
// ignore_for_file: deprecated_member_use
import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/payout_request_model.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../widget/common_ui.dart';
import '../../../../widget/container_custom.dart';
import '../../../../widget/global_widgets.dart';
import '../../../../widget/text_widget.dart';
import '../../../constant/constants.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_them_data.dart';
import '../../../utils/dark_theme_provider.dart';
import '../../../utils/fire_store_utils.dart';
import '../../../utils/responsive.dart';
import '../controllers/payout_request_controller.dart';

class PayoutRequestView extends GetView<PayoutRequestController> {
  const PayoutRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PayoutRequestController>(
      init: PayoutRequestController(),
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
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerCustom(
                              child: Column(children: [
                                if (ResponsiveWidget.isDesktop(context))
                                  Row(
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
                                      Row(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              width: 160,
                                              child: DropdownSearch<DriverUserModel>(
                                                items: (f, cs) => controller.allDriverList,
                                                itemAsString: (DriverUserModel item) => '${item.fullName}',
                                                compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                                onChanged: (DriverUserModel? selectedItem) async {
                                                  controller.driverId.value = selectedItem!.id!;
                                                  log('==================> on change driver id # => ${selectedItem.id}');
                                                  controller.getPayoutRequest();
                                                },
                                                dropdownBuilder: (context, selectedItem) {
                                                  return Text(
                                                    selectedItem != null ? '${selectedItem.fullName}' : 'All Driver',
                                                    style: TextStyle(
                                                      fontFamily: AppThemeData.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                    ),
                                                  );
                                                },
                                                popupProps: PopupProps.menu(
                                                    showSearchBox: true,
                                                    showSelectedItems: true,
                                                    searchFieldProps: TextFieldProps(
                                                        cursorColor: AppThemData.appColor,
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                          hintText: "Search Driver",
                                                          hintStyle: TextStyle(
                                                            fontFamily: AppThemeData.regular,
                                                            fontSize: 16,
                                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                                            ),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: BorderSide(
                                                              width: 0.5,
                                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                                            ),
                                                          ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(width: 0.5, color: AppThemData.red400),
                                                          ),
                                                        )),
                                                    itemBuilder: (context, item, isDisabled, isSelected) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        child: TextCustom(
                                                          title: item.fullName.toString(),
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                        ),
                                                        // Text(
                                                        //   '${item.fullName}',
                                                        //   style: const TextStyle(fontFamily: AppThemeData.regular, color: Colors.black),
                                                        // ),
                                                      );
                                                    }),
                                                suffixProps: const DropdownSuffixProps(
                                                    dropdownButtonProps: DropdownButtonProps(
                                                  iconClosed: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: AppThemData.greyShade500,
                                                  ),
                                                  iconOpened: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: AppThemData.greyShade500,
                                                  ),
                                                )),
                                                decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                              ),
                                            ),
                                          ),
                                          spaceW(),
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
                                                onChanged: (String? statusType) async {
                                                  final now = DateTime.now();
                                                  controller.selectedDateOption.value = statusType ?? "All";
                                                  switch (statusType) {
                                                    case 'Last Month':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: now.subtract(const Duration(days: 30)),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      controller.getPayoutRequest();
                                                      break;
                                                    case 'Last 6 Months':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, now.month - 6, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      controller.getPayoutRequest();

                                                      break;
                                                    case 'Last Year':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year - 1, now.month, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      controller.getPayoutRequest();
                                                      break;
                                                    case 'Custom':
                                                      showDateRangePicker(context);
                                                      break;
                                                    case 'All':
                                                      controller.getPayoutRequest();
                                                      break;
                                                    default:
                                                      // No specific filter, maybe assign null or a full year
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, 1, 1),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      break;
                                                  }
                                                  // controller.isCustomVisible.value = statusType == 'Custom';
                                                  final selectedRange = controller.selectedDateRange.value;
                                                  debugPrint("Selected Date Option: $statusType");
                                                  debugPrint("Start: ${selectedRange.start.toIso8601String()}");
                                                  debugPrint("End: ${selectedRange.end.toIso8601String()}");
                                                  // controller.getBookingDataByBookingStatus(); // if needed
                                                },
                                                value: controller.selectedDateOption.value,
                                                items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem(
                                                      value: value,
                                                      child: TextCustom(
                                                        title: value,
                                                        fontFamily: AppThemeData.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                      ));
                                                }).toList(),
                                                decoration: Constant.DefaultInputDecoration(context),
                                              ),
                                            ),
                                          ),
                                          spaceW(),
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
                                                hint: TextCustom(title: 'Payment Status'.tr),
                                                onChanged: (String? taxType) {
                                                  controller.selectedPayoutStatus.value = taxType ?? "All";
                                                  controller.getPayoutRequest();
                                                },
                                                value: controller.selectedPayoutStatus.value,
                                                items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
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
                                          ),
                                          spaceW(),
                                          NumberOfRowsDropDown(controller: controller),
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
                                                            title: "Payout Request Download",
                                                            widgetList: [
                                                              const TextCustom(
                                                                title: 'Select Time',
                                                                fontFamily: AppThemeData.regular,
                                                                fontSize: 16,
                                                              ),
                                                              spaceH(),
                                                              SizedBox(
                                                                width: 200,
                                                                child: Obx(
                                                                  () => DropdownButtonFormField(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    isExpanded: true,
                                                                    style: TextStyle(
                                                                      fontFamily: AppThemeData.medium,
                                                                      color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                                    ),
                                                                    onChanged: (String? statusType) {
                                                                      final now = DateTime.now();
                                                                      controller.selectedDateOption.value = statusType ?? "All";

                                                                      switch (statusType) {
                                                                        case 'Last Month':
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: now.subtract(const Duration(days: 30)),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                        case 'Last 6 Months':
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: DateTime(now.year, now.month - 6, now.day),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                        case 'Last Year':
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: DateTime(now.year - 1, now.month, now.day),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                        case 'Custom':
                                                                          controller.isCustomVisible.value = true;
                                                                          break;
                                                                        case 'All':
                                                                        default:
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: DateTime(now.year, 1, 1),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                      }

                                                                      controller.isCustomVisible.value = statusType == 'Custom';

                                                                      final selectedRange = controller.selectedDateRangeForPdf.value;
                                                                      debugPrint("Selected Date Option: $statusType");
                                                                      debugPrint("Start: ${selectedRange.start.toIso8601String()}");
                                                                      debugPrint("End: ${selectedRange.end.toIso8601String()}");

                                                                      // controller.getBookingDataByBookingStatus(); // if needed
                                                                    },
                                                                    value: controller.selectedDateOption.value,
                                                                    items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem(
                                                                        value: value,
                                                                        child: TextCustom(
                                                                          title: value,
                                                                          fontFamily: AppThemeData.regular,
                                                                          fontSize: 16,
                                                                          color: themeChange.isDarkTheme()
                                                                              ? AppThemData.greyShade500
                                                                              : AppThemData.greyShade800,
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    decoration: Constant.DefaultInputDecoration(context),
                                                                  ),
                                                                ),
                                                              ),
                                                              spaceH(),
                                                              Obx(
                                                                () => Visibility(
                                                                  visible: controller.isCustomVisible.value,
                                                                  child: CustomTextFormField(
                                                                    validator: (value) =>
                                                                        value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
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
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const TextCustom(
                                                                        title: 'Select Driver',
                                                                        fontFamily: AppThemeData.regular,
                                                                        fontSize: 16,
                                                                      ),
                                                                      spaceH(),
                                                                      SizedBox(
                                                                        width: 250,
                                                                        child: DropdownSearch<DriverUserModel>(
                                                                          items: (filter, infiniteScrollProps) => controller.allDriverList,
                                                                          // items: (f, cs) => controller.getAllDriver(),
                                                                          // selectedItem: controller.selectedDriver.value,
                                                                          itemAsString: (DriverUserModel? driver) => driver?.fullName ?? "",
                                                                          compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                                                          onChanged: (DriverUserModel? driver) {
                                                                            controller.selectedDriver.value = driver;
                                                                          },
                                                                          dropdownBuilder: (context, DriverUserModel? driver) {
                                                                            return Text(driver?.fullName ?? "All Driver");
                                                                          },
                                                                          popupProps: PopupProps.menu(
                                                                              showSearchBox: true,
                                                                              showSelectedItems: true,
                                                                              searchFieldProps: TextFieldProps(
                                                                                  cursorColor: AppThemData.primary500,
                                                                                  decoration: InputDecoration(
                                                                                    fillColor: themeChange.isDarkTheme()
                                                                                        ? AppThemData.background
                                                                                        : AppThemData.greyShade500,
                                                                                    contentPadding:
                                                                                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                    hintText: "Search Provider",
                                                                                    hintStyle: const TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontFamily: AppThemeData.regular,
                                                                                        color: AppThemData.lightGrey08),
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      borderSide:
                                                                                          const BorderSide(width: 0.5, color: AppThemData.appColor),
                                                                                    ),
                                                                                    border: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      borderSide:
                                                                                          BorderSide(width: 0.5, color: AppThemData.primaryBlack),
                                                                                    ),
                                                                                    errorBorder: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      borderSide:
                                                                                          const BorderSide(width: 0.5, color: AppThemData.red500),
                                                                                    ),
                                                                                  )),
                                                                              itemBuilder: (context, item, isDisabled, isSelected) {
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                  child: Text(
                                                                                    '${item.fullName}',
                                                                                    style: TextStyle(
                                                                                        fontFamily: AppThemeData.regular,
                                                                                        color: themeChange.isDarkTheme()
                                                                                            ? AppThemData.greyShade500
                                                                                            : AppThemData.greyShade950),
                                                                                  ),
                                                                                );
                                                                              }),
                                                                          decoratorProps: DropDownDecoratorProps(
                                                                              decoration: defaultInputDecorationForSearchDropDown(context)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  spaceW(width: 30),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const TextCustom(
                                                                        title: 'Booking Status',
                                                                        fontFamily: AppThemeData.regular,
                                                                        fontSize: 16,
                                                                      ),
                                                                      spaceH(),
                                                                      SizedBox(
                                                                        width: 120,
                                                                        child: Obx(
                                                                          () => DropdownButtonFormField(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            isExpanded: true,
                                                                            style: TextStyle(
                                                                              fontFamily: AppThemeData.medium,
                                                                              color: themeChange.isDarkTheme()
                                                                                  ? AppThemData.textBlack
                                                                                  : AppThemData.textGrey,
                                                                            ),
                                                                            onChanged: (String? statusType) {
                                                                              controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                              // controller.getBookingDataByBookingStatus();
                                                                            },
                                                                            value: controller.selectedFilterBookingStatus.value,
                                                                            items:
                                                                                controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
                                                                              return DropdownMenuItem(
                                                                                value: value,
                                                                                child: TextCustom(
                                                                                  title: value,
                                                                                  fontFamily: AppThemeData.regular,
                                                                                  fontSize: 16,
                                                                                  color: themeChange.isDarkTheme()
                                                                                      ? AppThemData.greyShade500
                                                                                      : AppThemData.greyShade800,
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            decoration: Constant.DefaultInputDecoration(context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                            bottomWidgetList: [
                                                              CustomButtonWidget(
                                                                buttonTitle: "Close",
                                                                textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                                buttonColor:
                                                                    themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                                                                onPress: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                              spaceW(),
                                                              Obx(
                                                                () => controller.isHistoryDownload.value
                                                                    ? Constant.loader()
                                                                    : CustomButtonWidget(
                                                                        buttonTitle: "Download".tr,
                                                                        onPress: () {
                                                                          if (Constant.isDemo) {
                                                                            DialogBox.demoDialogBox();
                                                                          } else {
                                                                            if (controller.selectedDriver.value == null ||
                                                                                controller.selectedDriver.value!.id == null ||
                                                                                controller.selectedDriver.value!.id!.isEmpty) {
                                                                              ShowToast.errorToast('Select Driver');
                                                                              return;
                                                                            }
                                                                            if (controller.selectedDateOption.value == 'Custom' &&
                                                                                controller.dateRangeController.value.text.isEmpty) {
                                                                              ShowToast.errorToast("Please select the start & end date.");
                                                                              return;
                                                                            }
                                                                            // controller.downloadCabBookingPdf(context);
                                                                            controller.downloadPayoutRequestPdf(context);
                                                                          }
                                                                          // if (Constant.isDemo) {
                                                                          //   DialogBox.demoDialogBox();
                                                                          // } else {

                                                                          // else {
                                                                          // if (controller.dateRangeController.value.text.isNotEmpty) {
                                                                          //   controller.downloadPayoutRequestPdf(context);
                                                                          //   Navigator.pop(context);
                                                                          // } else {
                                                                          //   ShowToast.successToast("Please Select the Date..");
                                                                          // }
                                                                          // Add your download logic here
                                                                          // }
                                                                        },
                                                                      ),
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
                                      ),
                                    ],
                                  )
                                else
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      spaceH(height: 16),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          spaceH(),
                                          SizedBox(
                                            width: 160,
                                            child: DropdownSearch<DriverUserModel>(
                                              items: (f, cs) => controller.allDriverList,
                                              itemAsString: (DriverUserModel item) => '${item.fullName}',
                                              compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                              onChanged: (DriverUserModel? selectedItem) async {
                                                controller.driverId.value = selectedItem!.id!;
                                                if (selectedItem.id == 'All') {
                                                  log('===========> call all ');
                                                  controller.driverId.value = 'All';
                                                  controller.getPayoutRequest();
                                                  // await FireStoreUtils.countPayoutRequestWithdraw(
                                                  //   controller.driverId.value,
                                                  //   controller.selectedPayoutStatus.value,
                                                  //   controller.selectedDateRange.value,
                                                  // );
                                                  // await controller.setPagination(controller.totalItemPerPage.value);
                                                } else {
                                                  controller.getPayoutRequest();
                                                  // await FireStoreUtils.countPayoutRequestWithdraw(
                                                  //   controller.driverId.value,
                                                  //   controller.selectedPayoutStatus.value,
                                                  //   controller.selectedDateRange.value,
                                                  // );
                                                  // await controller.setPagination(controller.totalItemPerPage.value);
                                                }
                                              },
                                              dropdownBuilder: (context, selectedItem) {
                                                return Text(
                                                  selectedItem != null ? '${selectedItem.fullName}' : 'All Driver',
                                                  style: TextStyle(
                                                    fontFamily: AppThemeData.regular,
                                                    fontSize: 16,
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                  ),
                                                );
                                              },
                                              popupProps: PopupProps.menu(
                                                  showSearchBox: true,
                                                  showSelectedItems: true,
                                                  searchFieldProps: TextFieldProps(
                                                      cursorColor: AppThemData.appColor,
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                        hintText: "Search Driver",
                                                        hintStyle: TextStyle(
                                                          fontFamily: AppThemeData.regular,
                                                          fontSize: 16,
                                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                                          ),
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                                          ),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: const BorderSide(width: 0.5, color: AppThemData.red400),
                                                        ),
                                                      )),
                                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      child: TextCustom(
                                                        title: item.fullName.toString(),
                                                        fontFamily: AppThemeData.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                      ),
                                                      // Text(
                                                      //   '${item.fullName}',
                                                      //   style: const TextStyle(fontFamily: AppThemeData.regular, color: Colors.black),
                                                      // ),
                                                    );
                                                  }),
                                              suffixProps: const DropdownSuffixProps(
                                                  dropdownButtonProps: DropdownButtonProps(
                                                iconClosed: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: AppThemData.greyShade500,
                                                ),
                                                iconOpened: Icon(
                                                  Icons.arrow_drop_up,
                                                  color: AppThemData.greyShade500,
                                                ),
                                              )),
                                              decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                            ),
                                          ),
                                          spaceH(),
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
                                                    onChanged: (String? statusType) async {
                                                      final now = DateTime.now();
                                                      controller.selectedDateOption.value = statusType ?? "All";

                                                      log('============================> status of type $statusType');

                                                      switch (statusType) {
                                                        case 'Last Month':
                                                          controller.selectedDateRange.value = DateTimeRange(
                                                            start: now.subtract(const Duration(days: 30)),
                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                          );
                                                          controller.getPayoutRequest();
                                                          break;
                                                        case 'Last 6 Months':
                                                          controller.selectedDateRange.value = DateTimeRange(
                                                            start: DateTime(now.year, now.month - 6, now.day),
                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                          );
                                                          // await FireStoreUtils.countPayoutRequestWithdraw(
                                                          //   controller.driverId.value,
                                                          //   controller.selectedPayoutStatus.value,
                                                          //   controller.selectedDateRange.value,
                                                          // );
                                                          // await controller.setPagination(controller.totalItemPerPage.value);
                                                          controller.getPayoutRequest();
                                                          break;
                                                        case 'Last Year':
                                                          controller.selectedDateRange.value = DateTimeRange(
                                                            start: DateTime(now.year - 1, now.month, now.day),
                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                          );
                                                          controller.getPayoutRequest();
                                                          break;
                                                        case 'Custom':
                                                          showDateRangePicker(context);
                                                          break;
                                                        case 'All':
                                                          controller.getPayoutRequest();
                                                          break;
                                                        default:
                                                          controller.selectedDateRange.value = DateTimeRange(
                                                            start: DateTime(now.year, 1, 1),
                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                          );
                                                          showDateRangePicker(context);
                                                          break;
                                                      }
                                                      final selectedRange = controller.selectedDateRange.value;
                                                      debugPrint("Selected Date Option: $statusType");
                                                      debugPrint("Start: ${selectedRange.start.toIso8601String()}");
                                                      debugPrint("End: ${selectedRange.end.toIso8601String()}");
                                                      // controller.getBookingDataByBookingStatus(); // if needed
                                                    },
                                                    value: controller.selectedDateOption.value,
                                                    items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                          value: value,
                                                          child: TextCustom(
                                                            title: value,
                                                            fontFamily: AppThemeData.regular,
                                                            fontSize: 16,
                                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
                                                          ));
                                                    }).toList(),
                                                    decoration: Constant.DefaultInputDecoration(context),
                                                  ),
                                                ),
                                              ),
                                              spaceW(),
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
                                                    hint: TextCustom(title: 'Payment Status'.tr),
                                                    onChanged: (String? taxType) {
                                                      controller.selectedPayoutStatus.value = taxType ?? "All";
                                                      controller.getPayoutRequest();
                                                    },
                                                    value: controller.selectedPayoutStatus.value,
                                                    items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
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
                                              ),
                                            ],
                                          ),
                                          spaceH(),
                                          Row(
                                            children: [
                                              NumberOfRowsDropDown(controller: controller),
                                              spaceW(),
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
                                                                title: "Payout Request Download",
                                                                widgetList: [
                                                                  const TextCustom(
                                                                    title: 'Select Time',
                                                                    fontFamily: AppThemeData.regular,
                                                                    fontSize: 16,
                                                                  ),
                                                                  spaceH(),
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Obx(
                                                                      () => DropdownButtonFormField(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                        isExpanded: true,
                                                                        style: TextStyle(
                                                                          fontFamily: AppThemeData.medium,
                                                                          color: themeChange.isDarkTheme()
                                                                              ? AppThemData.textBlack
                                                                              : AppThemData.textGrey,
                                                                        ),
                                                                        onChanged: (String? statusType) {
                                                                          final now = DateTime.now();
                                                                          controller.selectedDateOption.value = statusType ?? "All";

                                                                          switch (statusType) {
                                                                            case 'Last Month':
                                                                              controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                                start: now.subtract(const Duration(days: 30)),
                                                                                end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                              );
                                                                              break;
                                                                            case 'Last 6 Months':
                                                                              controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                                start: DateTime(now.year, now.month - 6, now.day),
                                                                                end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                              );
                                                                              break;
                                                                            case 'Last Year':
                                                                              controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                                start: DateTime(now.year - 1, now.month, now.day),
                                                                                end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                              );
                                                                              break;
                                                                            case 'Custom':
                                                                              controller.isCustomVisible.value = true;
                                                                              break;
                                                                            case 'All':
                                                                            default:
                                                                              controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                                start: DateTime(now.year, 1, 1),
                                                                                end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                              );
                                                                              break;
                                                                          }

                                                                          controller.isCustomVisible.value = statusType == 'Custom';

                                                                          final selectedRange = controller.selectedDateRangeForPdf.value;
                                                                          debugPrint("Selected Date Option: $statusType");
                                                                          debugPrint("Start: ${selectedRange.start.toIso8601String()}");
                                                                          debugPrint("End: ${selectedRange.end.toIso8601String()}");

                                                                          // controller.getBookingDataByBookingStatus(); // if needed
                                                                        },
                                                                        value: controller.selectedDateOption.value,
                                                                        items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                                          return DropdownMenuItem(
                                                                            value: value,
                                                                            child: TextCustom(
                                                                              title: value,
                                                                              fontFamily: AppThemeData.regular,
                                                                              fontSize: 16,
                                                                              color: themeChange.isDarkTheme()
                                                                                  ? AppThemData.greyShade500
                                                                                  : AppThemData.greyShade800,
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        decoration: Constant.DefaultInputDecoration(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  spaceH(),
                                                                  Obx(
                                                                    () => Visibility(
                                                                      visible: controller.isCustomVisible.value,
                                                                      child: CustomTextFormField(
                                                                        validator: (value) =>
                                                                            value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
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
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          const TextCustom(
                                                                            title: 'Select Driver',
                                                                            fontFamily: AppThemeData.regular,
                                                                            fontSize: 16,
                                                                          ),
                                                                          spaceH(),
                                                                          SizedBox(
                                                                            width: 250,
                                                                            child: DropdownSearch<DriverUserModel>(
                                                                              items: (filter, infiniteScrollProps) => controller.allDriverList,
                                                                              itemAsString: (DriverUserModel? driver) => driver?.fullName ?? "",
                                                                              compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                                                              onChanged: (DriverUserModel? driver) {
                                                                                controller.selectedDriver.value = driver;
                                                                              },
                                                                              dropdownBuilder: (context, DriverUserModel? driver) {
                                                                                return Text(driver?.fullName ?? "All Driver");
                                                                              },
                                                                              popupProps: PopupProps.menu(
                                                                                  showSearchBox: true,
                                                                                  showSelectedItems: true,
                                                                                  searchFieldProps: TextFieldProps(
                                                                                      cursorColor: AppThemData.primary500,
                                                                                      decoration: InputDecoration(
                                                                                        fillColor: themeChange.isDarkTheme()
                                                                                            ? AppThemData.background
                                                                                            : AppThemData.greyShade500,
                                                                                        contentPadding:
                                                                                            const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                        hintText: "Search Provider",
                                                                                        hintStyle: const TextStyle(
                                                                                            fontSize: 14,
                                                                                            fontFamily: AppThemeData.regular,
                                                                                            color: AppThemData.lightGrey08),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          borderSide: const BorderSide(
                                                                                              width: 0.5, color: AppThemData.appColor),
                                                                                        ),
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          borderSide:
                                                                                              BorderSide(width: 0.5, color: AppThemData.primaryBlack),
                                                                                        ),
                                                                                        errorBorder: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          borderSide:
                                                                                              const BorderSide(width: 0.5, color: AppThemData.red500),
                                                                                        ),
                                                                                      )),
                                                                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                                                                    return Padding(
                                                                                      padding:
                                                                                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                      child: Text(
                                                                                        '${item.fullName}',
                                                                                        style: TextStyle(
                                                                                            fontFamily: AppThemeData.regular,
                                                                                            color: themeChange.isDarkTheme()
                                                                                                ? AppThemData.greyShade500
                                                                                                : AppThemData.greyShade950),
                                                                                      ),
                                                                                    );
                                                                                  }),
                                                                              decoratorProps: DropDownDecoratorProps(
                                                                                  decoration: defaultInputDecorationForSearchDropDown(context)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      spaceW(width: 30),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          const TextCustom(
                                                                            title: 'Booking Status',
                                                                            fontFamily: AppThemeData.regular,
                                                                            fontSize: 16,
                                                                          ),
                                                                          spaceH(),
                                                                          SizedBox(
                                                                            width: 120,
                                                                            child: Obx(
                                                                              () => DropdownButtonFormField(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                isExpanded: true,
                                                                                style: TextStyle(
                                                                                  fontFamily: AppThemeData.medium,
                                                                                  color: themeChange.isDarkTheme()
                                                                                      ? AppThemData.textBlack
                                                                                      : AppThemData.textGrey,
                                                                                ),
                                                                                onChanged: (String? statusType) {
                                                                                  controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                                  // controller.getBookingDataByBookingStatus();
                                                                                },
                                                                                value: controller.selectedFilterBookingStatus.value,
                                                                                items: controller.payoutStatus
                                                                                    .map<DropdownMenuItem<String>>((String value) {
                                                                                  return DropdownMenuItem(
                                                                                    value: value,
                                                                                    child: TextCustom(
                                                                                      title: value,
                                                                                      fontFamily: AppThemeData.regular,
                                                                                      fontSize: 16,
                                                                                      color: themeChange.isDarkTheme()
                                                                                          ? AppThemData.greyShade500
                                                                                          : AppThemData.greyShade800,
                                                                                    ),
                                                                                  );
                                                                                }).toList(),
                                                                                decoration: Constant.DefaultInputDecoration(context),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                                  Obx(
                                                                    () => controller.isHistoryDownload.value
                                                                        ? Constant.loader()
                                                                        : CustomButtonWidget(
                                                                            buttonTitle: "Download".tr,
                                                                            onPress: () {
                                                                              if (Constant.isDemo) {
                                                                                DialogBox.demoDialogBox();
                                                                              } else {
                                                                                if (controller.selectedDriver.value == null ||
                                                                                    controller.selectedDriver.value!.id == null ||
                                                                                    controller.selectedDriver.value!.id!.isEmpty) {
                                                                                  ShowToast.errorToast('Select Driver');
                                                                                  return;
                                                                                }
                                                                                if (controller.selectedDateOption.value == 'Custom' &&
                                                                                    controller.dateRangeController.value.text.isEmpty) {
                                                                                  ShowToast.errorToast("Please select the start & end date.");
                                                                                  return;
                                                                                }
                                                                                // controller.downloadCabBookingPdf(context);
                                                                                controller.downloadPayoutRequestPdf(context);
                                                                              }
                                                                              // if (Constant.isDemo) {
                                                                              //   DialogBox.demoDialogBox();
                                                                              // } else {

                                                                              // else {
                                                                              // if (controller.dateRangeController.value.text.isNotEmpty) {
                                                                              //   controller.downloadPayoutRequestPdf(context);
                                                                              //   Navigator.pop(context);
                                                                              // } else {
                                                                              //   ShowToast.successToast("Please Select the Date..");
                                                                              // }
                                                                              // Add your download logic here
                                                                              // }
                                                                            },
                                                                          ),
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
                                          ),
                                        ],
                                      ),
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
                                        : controller.currentPagePayOutRequest.isEmpty
                                            ? TextCustom(title: "No Data available".tr.tr)
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
                                                  // CommonUI.dataColumnWidget(context, columnTitle: "DriverId", width:  ResponsiveWidget.isMobile(context) ?  150  :MediaQuery.of(context).size.width * 0.10 ),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Amount".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Name".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Email".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Phone Number".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Note".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.13),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "PaymentDate".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "PaymentStatus".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.08),
                                                  // CommonUI.dataColumnWidget(context, columnTitle: "PaymentDate", width: ResponsiveWidget.isMobile(context) ? 140 :MediaQuery.of(context).size.width * 0.10),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Created Date".tr,
                                                      width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(
                                                    context,
                                                    columnTitle: "Action".tr,
                                                    width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.08,
                                                  ),
                                                ],
                                                rows: controller.currentPagePayOutRequest
                                                    .map(
                                                      (payoutRequestModel) => DataRow(
                                                        cells: [
                                                          // DataCell(
                                                          //   TextCustom(
                                                          //     title: payoutRequestModel.driverId.toString(),
                                                          //   ),
                                                          // ),
                                                          DataCell(
                                                            TextCustom(title: payoutRequestModel.amount.toString()),
                                                          ),
                                                          DataCell(
                                                            FutureBuilder<DriverUserModel?>(
                                                                future: FireStoreUtils.getDriverByDriverID(
                                                                    payoutRequestModel.driverId.toString()), // async work
                                                                builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
                                                                  switch (snapshot.connectionState) {
                                                                    case ConnectionState.waiting:
                                                                      // return Center(child: Constant.loader());
                                                                      return const SizedBox();
                                                                    default:
                                                                      if (snapshot.hasError) {
                                                                        return TextCustom(
                                                                          title: 'Error: ${snapshot.error}',
                                                                        );
                                                                      } else {
                                                                        DriverUserModel driverUserModel = snapshot.data!;
                                                                        return Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          child: TextButton(
                                                                            onPressed: () {},
                                                                            child: TextCustom(
                                                                              title: driverUserModel.fullName!.isEmpty
                                                                                  ? "N/A"
                                                                                  : driverUserModel.fullName.toString() == "Unknown User"
                                                                                      ? "User Deleted"
                                                                                      : driverUserModel.fullName.toString(),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  }
                                                                }),
                                                          ),
                                                          DataCell(
                                                            FutureBuilder<DriverUserModel?>(
                                                                future: FireStoreUtils.getDriverByDriverID(
                                                                    payoutRequestModel.driverId.toString()), // async work
                                                                builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
                                                                  switch (snapshot.connectionState) {
                                                                    case ConnectionState.waiting:
                                                                      // return Center(child: Constant.loader());
                                                                      return const SizedBox();
                                                                    default:
                                                                      if (snapshot.hasError) {
                                                                        return TextCustom(
                                                                          title: 'Error: ${snapshot.error}',
                                                                        );
                                                                      } else {
                                                                        DriverUserModel driverUserModel = snapshot.data!;
                                                                        return Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          child: TextButton(
                                                                            onPressed: () {},
                                                                            child: TextCustom(
                                                                              title: driverUserModel.email!.isEmpty
                                                                                  ? "N/A"
                                                                                  : driverUserModel.email.toString() == "Unknown User"
                                                                                      ? "User Deleted"
                                                                                      : Constant.maskEmail(email: driverUserModel.email.toString()),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  }
                                                                }),
                                                          ),
                                                          DataCell(
                                                            FutureBuilder<DriverUserModel?>(
                                                                future: FireStoreUtils.getDriverByDriverID(
                                                                    payoutRequestModel.driverId.toString()), // async work
                                                                builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
                                                                  switch (snapshot.connectionState) {
                                                                    case ConnectionState.waiting:
                                                                      // return Center(child: Constant.loader());
                                                                      return const SizedBox();
                                                                    default:
                                                                      if (snapshot.hasError) {
                                                                        return TextCustom(
                                                                          title: 'Error: ${snapshot.error}',
                                                                        );
                                                                      } else {
                                                                        DriverUserModel driverUserModel = snapshot.data!;
                                                                        return Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          child: TextButton(
                                                                            onPressed: () {},
                                                                            child: TextCustom(
                                                                              title: driverUserModel.phoneNumber!.isEmpty
                                                                                  ? "N/A"
                                                                                  : driverUserModel.phoneNumber.toString() == "Unknown User"
                                                                                      ? "User Deleted"
                                                                                      : Constant.maskMobileNumber(
                                                                                          mobileNumber: driverUserModel.phoneNumber.toString(),
                                                                                          countryCode: driverUserModel.countryCode.toString()),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  }
                                                                }),
                                                          ),

                                                          // Constant.bookingStatusText(context, e.bookingStatus.toString()),
                                                          DataCell(
                                                            TextCustom(
                                                                title: payoutRequestModel.note == null ||
                                                                        payoutRequestModel.note == "" ||
                                                                        payoutRequestModel.note!.isEmpty
                                                                    ? "N/A"
                                                                    : payoutRequestModel.note.toString()),
                                                          ),
                                                          DataCell(
                                                            TextCustom(
                                                                title: payoutRequestModel.paymentDate == null
                                                                    ? 'N/A'
                                                                    : Constant.timestampToDate(payoutRequestModel.paymentDate!)),
                                                          ),
                                                          DataCell(
                                                            Constant.bookingStatusText(context, payoutRequestModel.paymentStatus.toString()),
                                                          ),
                                                          DataCell(
                                                            TextCustom(
                                                                title: payoutRequestModel.createdDate == null
                                                                    ? 'N/A'
                                                                    : Constant.timestampToDate(payoutRequestModel.createdDate!)),
                                                          ),
                                                          DataCell(
                                                            Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  // InkWell(
                                                                  //   onTap: () {
                                                                  //     controller.userSelectedPaymentStatus.value = payoutRequestModel.paymentStatus!;
                                                                  //     controller.adminNoteController.value.text = payoutRequestModel.adminNote!;
                                                                  //
                                                                  //     showDialog(
                                                                  //       context: context,
                                                                  //       builder: (context) => CouponDialog( payoutRequest: payoutRequestModel, ),
                                                                  //     );
                                                                  //   },
                                                                  //   child: SvgPicture.asset(
                                                                  //     "assets/icons/ic_eye.svg",
                                                                  //     color: AppColors.greyShade400,
                                                                  //     height: 16,
                                                                  //     width: 16,
                                                                  //   ),
                                                                  // ),
                                                                  payoutRequestModel.paymentStatus == "Pending"
                                                                      ? CustomButtonWidget(
                                                                          width: ResponsiveWidget.isMobile(context)
                                                                              ? 80
                                                                              : MediaQuery.of(context).size.width * 0.07,
                                                                          textColor: AppThemData.primaryWhite,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 22),
                                                                          buttonTitle: "Allow",
                                                                          // borderRadius: 14,
                                                                          onPress: () async {
                                                                            controller.userSelectedPaymentStatus.value =
                                                                                payoutRequestModel.paymentStatus.toString();
                                                                            payoutRequestModel.adminNote == null
                                                                                ? controller.adminNoteController.value.text = ""
                                                                                : controller.adminNoteController.value.text =
                                                                                    payoutRequestModel.adminNote.toString();

                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) => CouponDialog(
                                                                                payoutRequest: payoutRequestModel,
                                                                              ),
                                                                            );
                                                                          },
                                                                        )
                                                                      : TextCustom(title: 'Payment ${payoutRequestModel.paymentStatus.toString()}'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
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
                                      )
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

  Future<void> showDateRangePicker(BuildContext context) async {
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
                  controller.startDate = (args.value as PickerDateRange).startDate;
                  controller.endDate = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRange.value = DateTimeRange(
                      start: DateTime(DateTime.now().year, DateTime.january, 1),
                      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  controller.selectedBookingStatus.value = "All";
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value = DateTimeRange(
                      start: controller.startDate!,
                      end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  await FireStoreUtils.countStatusWiseBooking(
                    controller.driverId.value,
                    controller.selectedBookingStatusForData.value,
                    controller.selectedDateRange.value,
                  );
                  controller.setPagination(controller.totalItemPerPage.value);
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
                  // controller.selectedPayoutStatus == ;
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
}

class CouponDialog extends StatelessWidget {
  final WithdrawModel payoutRequest;

  const CouponDialog({super.key, required this.payoutRequest});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PayoutRequestController>(
      init: PayoutRequestController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          widgetList: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                spaceH(),
                ContainerCustom(
                  padding: const EdgeInsets.all(0),
                  borderColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                  child:

                      // controller.isLoadingVehicleDetails.value ?  Padding(
                      //   padding: paddingEdgeInsets(),
                      //   child: Constant.loader(),
                      // ) :
                      Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          child: !ResponsiveWidget.isDesktop(context)
                              ? Column(
                                  children: [
                                    TextCustom(
                                      title: 'Payment ID'.tr,
                                      maxLine: 3,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width * 0.6,
                                      child: TextCustom(
                                        maxLine: 3,
                                        title: payoutRequest.id ?? 'N/A',
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      title: 'Payment ID'.tr,
                                      maxLine: 3,
                                    ),
                                    TextCustom(
                                      maxLine: 3,
                                      title: payoutRequest.id ?? 'N/A',
                                    ),
                                  ],
                                )),
                      // spaceH(),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'HolderName'.tr,
                            ),
                            TextCustom(
                              title: (payoutRequest.bankDetails!.holderName ?? 'N/A').toString(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'AccountNumber'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.accountNumber ?? 'N/A').toString()),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'BankName'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.bankName ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'SwiftCode'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.swiftCode ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Branch City'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.branchCity ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Branch Country'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.branchCountry ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                spaceH(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            maxLine: 1,
                            title: "Payment Status".tr,
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
                              hint: TextCustom(title: 'Payment Status'.tr),
                              onChanged: (String? taxType) {
                                controller.userSelectedPaymentStatus.value = taxType ?? "Pending";
                              },
                              value: controller.userSelectedPaymentStatus.value,
                              items: controller.paymentStatusType.map<DropdownMenuItem<String>>((String value) {
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                10.height,
                CustomTextFormField(
                  hintText: 'Enter note'.tr,
                  controller: controller.adminNoteController.value,
                  title: 'Enter Note'.tr,
                  maxLine: 2,
                ),
              ],
            ),
            spaceH(),
          ],
          bottomWidgetList: [
            CustomButtonWidget(
              buttonTitle: "Close".tr,
              buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
              onPress: () {
                // controller.setDefaultData();
                Navigator.pop(context);
              },
            ),
            spaceW(),
            CustomButtonWidget(
              // borderRadius: 12,
              buttonTitle: "Save".tr,
              textColor: AppThemData.primaryWhite,
              // buttonColor: AppColors.green500,
              onPress: () async {
                if (Constant.isDemo) {
                  DialogBox.demoDialogBox();
                } else {
                  payoutRequest.paymentStatus = controller.userSelectedPaymentStatus.value;
                  payoutRequest.adminNote = controller.adminNoteController.value.text;
                  payoutRequest.paymentDate = Timestamp.now();
                  if (controller.userSelectedPaymentStatus.value == "Rejected") {
                    if (controller.adminNoteController.value.text.isEmpty || controller.adminNoteController.value.text == "") {
                      return ShowToast.errorToast("Please Enter Rejected Note ".tr);
                    }
                    Navigator.pop(context);
                    await FireStoreUtils.updatePayoutRequest(payoutRequest);
                    controller.getPayoutRequest();
                    return;
                  }
                  Navigator.pop(context);
                  await FireStoreUtils.updatePayoutRequest(payoutRequest);
                  controller.getPayoutRequest();
                }
              },
            ),
          ],
          controller: controller,
        );
      },
    );
  }
}
