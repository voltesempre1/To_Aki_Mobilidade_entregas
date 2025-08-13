// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/routes/app_pages.dart';
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
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../utils/responsive.dart';
import '../controllers/parcel_history_screen_controller.dart';

class ParcelHistoryScreenView extends GetView<ParcelHistoryScreenController> {
  const ParcelHistoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ParcelHistoryScreenController>(
      init: ParcelHistoryScreenController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
            // key: controller.scaffoldKeysDrawer,
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
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
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
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                            TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.primary500)
                                          ])
                                        ]),
                                        Row(
                                          children: [
                                            // ContainerCustom(
                                            //   padding: paddingEdgeInsets(vertical: 0, horizontal: 0),
                                            //   color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade100,
                                            //   child: IconButton(
                                            //       onPressed: () async {
                                            //         if (controller.isDatePickerEnable.value) {
                                            //           showDateRangePicker(context);
                                            //         } else {
                                            //           controller.getBookings();
                                            //         }
                                            //       },
                                            //       icon: const Icon(
                                            //         Icons.date_range_outlined,
                                            //       )),
                                            // ),
                                            Center(
                                              child: SizedBox(
                                                width: 160,
                                                child: DropdownSearch<DriverUserModel>(
                                                  // mode: Mode.form,
                                                  items: (f, cs) => controller.allDriverList,
                                                  itemAsString: (DriverUserModel item) => '${item.fullName}',
                                                  compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                                  onChanged: (DriverUserModel? selectedItem) async {
                                                    controller.driverId.value = selectedItem!.id!;
                                                    if (selectedItem.id == 'All') {
                                                      log('===========> call all ');
                                                      controller.driverId.value = 'All';
                                                      await FireStoreUtils.countStatusParcel(
                                                        controller.driverId.value,
                                                        controller.selectedBookingStatusForData.value,
                                                        controller.selectedDateRange.value,
                                                      );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                    } else {
                                                      await FireStoreUtils.countStatusParcel(
                                                        controller.driverId.value,
                                                        controller.selectedBookingStatusForData.value,
                                                        controller.selectedDateRange.value,
                                                      );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
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
                                                        await FireStoreUtils.countStatusParcel(
                                                          controller.driverId.value,
                                                          controller.selectedBookingStatusForData.value,
                                                          controller.selectedDateRange.value,
                                                        );
                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                        break;
                                                      case 'Last 6 Months':
                                                        controller.selectedDateRange.value = DateTimeRange(
                                                          start: DateTime(now.year, now.month - 6, now.day),
                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                        );
                                                        await FireStoreUtils.countStatusParcel(
                                                          controller.driverId.value,
                                                          controller.selectedBookingStatusForData.value,
                                                          controller.selectedDateRange.value,
                                                        );
                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                        break;
                                                      case 'Last Year':
                                                        controller.selectedDateRange.value = DateTimeRange(
                                                          start: DateTime(now.year - 1, now.month, now.day),
                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                        );
                                                        await FireStoreUtils.countStatusParcel(
                                                          controller.driverId.value,
                                                          controller.selectedBookingStatusForData.value,
                                                          controller.selectedDateRange.value,
                                                        );
                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                        break;
                                                      case 'Custom':
                                                        // controller.isCustomVisible.value = true;
                                                        // controller.selectedBookingStatus.value = statusType ?? "All";
                                                        showDateRangePicker(context);
                                                        break;
                                                      case 'All':
                                                      default:
                                                        // No specific filter, maybe assign null or a full year
                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                          start: DateTime(now.year, 1, 1),
                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                        );
                                                        break;
                                                    }
                                                    // controller.isCustomVisible.value = statusType == 'Custom';
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
                                                  onChanged: (String? statusType) {
                                                    controller.selectedBookingStatus.value = statusType ?? "All";
                                                    controller.getBookingDataByBookingStatus();
                                                  },
                                                  value: controller.selectedBookingStatus.value,
                                                  items: controller.bookingStatus.map<DropdownMenuItem<String>>((String value) {
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
                                                              title: "Parcel  History Download",
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
                                                                        // controller.selectedDateOption.value = statusType ?? "All";
                                                                        // if (statusType == 'Custom') {
                                                                        //   controller.isCustomVisible.value = true;
                                                                        // } else {
                                                                        //   controller.isCustomVisible.value = false;
                                                                        // }
                                                                        // controller.getBookingDataByBookingStatus();

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
                                                                            // No specific filter, maybe assign null or a full year
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
                                                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
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
                                                                    ),
                                                                  ),
                                                                ),
                                                                spaceH(),
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
                                                                              log('===================> cab bookings ${controller.selectedDriver.value!.fullName}');
                                                                              log('===================> cab bookings id  ${controller.selectedDriver.value!.id}');
                                                                            },
                                                                            dropdownBuilder: (context, DriverUserModel? driver) {
                                                                              return Text(
                                                                                driver?.fullName ?? "All Driver",
                                                                                style: TextStyle(color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800),
                                                                              );
                                                                            },
                                                                            popupProps: PopupProps.menu(
                                                                                showSearchBox: true,
                                                                                showSelectedItems: true,
                                                                                searchFieldProps: TextFieldProps(
                                                                                    cursorColor: AppThemData.primary500,
                                                                                    decoration: InputDecoration(
                                                                                      fillColor: themeChange.isDarkTheme() ? AppThemData.background : AppThemData.greyShade500,
                                                                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                      hintText: "Search Driver",
                                                                                      hintStyle: const TextStyle(fontSize: 14, fontFamily: AppThemeData.regular, color: AppThemData.lightGrey08),
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        borderSide: const BorderSide(width: 0.5, color: AppThemData.appColor),
                                                                                      ),
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        borderSide: BorderSide(width: 0.5, color: AppThemData.primaryBlack),
                                                                                      ),
                                                                                      errorBorder: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        borderSide: const BorderSide(width: 0.5, color: AppThemData.red500),
                                                                                      ),
                                                                                    )),
                                                                                itemBuilder: (context, item, isDisabled, isSelected) {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                    child: Text(
                                                                                      '${item.fullName}',
                                                                                      style: TextStyle(
                                                                                          fontFamily: AppThemeData.regular,
                                                                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800),
                                                                                    ),
                                                                                  );
                                                                                }),
                                                                            decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
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
                                                                                color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                                              ),
                                                                              onChanged: (String? statusType) {
                                                                                controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                                // controller.getBookingDataByBookingStatus();
                                                                              },
                                                                              value: controller.selectedFilterBookingStatus.value,
                                                                              items: controller.bookingStatus.map<DropdownMenuItem<String>>((String value) {
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
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                              bottomWidgetList: [
                                                                CustomButtonWidget(
                                                                  buttonTitle: "Close",
                                                                  textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                                  buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
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
                                                                              if (controller.selectedDateOption.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                                ShowToast.errorToast("Please select the start & end date.");
                                                                                return;
                                                                              }
                                                                              controller.downloadParcelBookingPdf(context);
                                                                            }
                                                                          },
                                                                        ),
                                                                )
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                        spaceH(height: 16),
                                        SizedBox(
                                          width: 160,
                                          child: DropdownSearch<DriverUserModel>(
                                            // mode: Mode.form,
                                            items: (f, cs) => controller.allDriverList,
                                            itemAsString: (DriverUserModel item) => '${item.fullName}',
                                            compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                            onChanged: (DriverUserModel? selectedItem) async {
                                              controller.driverId.value = selectedItem!.id!;
                                              if (selectedItem.id == 'All') {
                                                log('===========> call all ');
                                                controller.driverId.value = 'All';
                                                await FireStoreUtils.countStatusParcel(
                                                  controller.driverId.value,
                                                  controller.selectedBookingStatusForData.value,
                                                  controller.selectedDateRange.value,
                                                );
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                              } else {
                                                await FireStoreUtils.countStatusParcel(
                                                  controller.driverId.value,
                                                  controller.selectedBookingStatusForData.value,
                                                  controller.selectedDateRange.value,
                                                );
                                                await controller.setPagination(controller.totalItemPerPage.value);
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
                                          mainAxisSize: MainAxisSize.min,
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

                                                    switch (statusType) {
                                                      case 'Last Month':
                                                        controller.selectedDateRange.value = DateTimeRange(
                                                          start: now.subtract(const Duration(days: 30)),
                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                        );
                                                        await FireStoreUtils.countStatusParcel(
                                                          controller.driverId.value,
                                                          controller.selectedBookingStatusForData.value,
                                                          controller.selectedDateRange.value,
                                                        );
                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                        break;
                                                      case 'Last 6 Months':
                                                        controller.selectedDateRange.value = DateTimeRange(
                                                          start: DateTime(now.year, now.month - 6, now.day),
                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                        );
                                                        await FireStoreUtils.countStatusParcel(
                                                          controller.driverId.value,
                                                          controller.selectedBookingStatusForData.value,
                                                          controller.selectedDateRange.value,
                                                        );
                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                        break;
                                                      case 'Last Year':
                                                        controller.selectedDateRange.value = DateTimeRange(
                                                          start: DateTime(now.year - 1, now.month, now.day),
                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                        );
                                                        await FireStoreUtils.countStatusParcel(
                                                          controller.driverId.value,
                                                          controller.selectedBookingStatusForData.value,
                                                          controller.selectedDateRange.value,
                                                        );
                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                        break;
                                                      case 'Custom':
                                                        // controller.isCustomVisible.value = true;
                                                        // controller.selectedBookingStatus.value = statusType ?? "All";
                                                        showDateRangePicker(context);
                                                        break;
                                                      case 'All':
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
                                                  onChanged: (String? statusType) {
                                                    controller.selectedBookingStatus.value = statusType ?? "All";
                                                    controller.getBookingDataByBookingStatus();
                                                  },
                                                  value: controller.selectedBookingStatus.value,
                                                  items: controller.bookingStatus.map<DropdownMenuItem<String>>((String value) {
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
                                          ],
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
                                                              title: "Parcel History Download",
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
                                                                        // controller.selectedDateOption.value = statusType ?? "All";
                                                                        // if (statusType == 'Custom') {
                                                                        //   controller.isCustomVisible.value = true;
                                                                        // } else {
                                                                        //   controller.isCustomVisible.value = false;
                                                                        // }
                                                                        // controller.getBookingDataByBookingStatus();

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
                                                                            // No specific filter, maybe assign null or a full year
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
                                                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800,
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
                                                                    ),
                                                                  ),
                                                                ),
                                                                spaceH(),
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
                                                                          return Text(
                                                                            driver?.fullName ?? "All Driver",
                                                                            style: TextStyle(color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800),
                                                                          );
                                                                        },
                                                                        popupProps: PopupProps.menu(
                                                                            showSearchBox: true,
                                                                            showSelectedItems: true,
                                                                            searchFieldProps: TextFieldProps(
                                                                                cursorColor: AppThemData.primary500,
                                                                                decoration: InputDecoration(
                                                                                  fillColor: themeChange.isDarkTheme() ? AppThemData.background : AppThemData.greyShade500,
                                                                                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                  hintText: "Search Provider",
                                                                                  hintStyle: const TextStyle(fontSize: 14, fontFamily: AppThemeData.regular, color: AppThemData.lightGrey08),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: const BorderSide(width: 0.5, color: AppThemData.appColor),
                                                                                  ),
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(width: 0.5, color: AppThemData.primaryBlack),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: const BorderSide(width: 0.5, color: AppThemData.red500),
                                                                                  ),
                                                                                )),
                                                                            itemBuilder: (context, item, isDisabled, isSelected) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                child: Text(
                                                                                  '${item.fullName}',
                                                                                  style: TextStyle(
                                                                                      fontFamily: AppThemeData.regular,
                                                                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade500 : AppThemData.greyShade800),
                                                                                ),
                                                                              );
                                                                            }),
                                                                        decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                spaceH(),
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
                                                                            color: themeChange.isDarkTheme() ? AppThemData.textBlack : AppThemData.textGrey,
                                                                          ),
                                                                          onChanged: (String? statusType) {
                                                                            controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                            // controller.getBookingDataByBookingStatus();
                                                                          },
                                                                          value: controller.selectedFilterBookingStatus.value,
                                                                          items: controller.bookingStatus.map<DropdownMenuItem<String>>((String value) {
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
                                                                  ],
                                                                ),
                                                              ],
                                                              bottomWidgetList: [
                                                                CustomButtonWidget(
                                                                  buttonTitle: "Close",
                                                                  textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                                  buttonColor: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
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
                                                                              if (controller.selectedDateOption.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                                ShowToast.errorToast("Please select the start & end date.");
                                                                                return;
                                                                              }
                                                                              controller.downloadParcelBookingPdf(context);
                                                                            }
                                                                          },
                                                                        ),
                                                                )
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
                                        spaceH(),
                                      ],
                                    ),
                              spaceH(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                    height: 200,
                                    width: 800,
                                    child: const Center(
                                      child: CircularProgressIndicator(color: AppThemData.primary500),
                                    ),
                                  )
                                      : controller.currentPageBooking.isEmpty
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
                                              headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Booking Date".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.17),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Payment Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Booking Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),

                                                CommonUI.dataColumnWidget(context, columnTitle: "Total".tr, width: 140),
                                                // CommonUI.dataColumnWidget(context,
                                                //     columnTitle: "Status", width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(
                                                  context,
                                                  columnTitle: "Action".tr,
                                                  width: 100,
                                                ),
                                              ],
                                              rows: controller.currentPageBooking
                                                  .map((parcelModel) => DataRow(cells: [
                                                        DataCell(
                                                          TextCustom(
                                                            title: parcelModel.id!.isEmpty ? "N/A".tr : "#${parcelModel.id!.substring(0, 8)}",
                                                          ),
                                                        ),
                                                        DataCell(
                                                          FutureBuilder<UserModel?>(
                                                              future: FireStoreUtils.getUserByUserID(parcelModel.customerId.toString()), // async work
                                                              builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
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
                                                                      UserModel userModel = snapshot.data!;
                                                                      return Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                        child: TextCustom(
                                                                          title: userModel.fullName!.isEmpty
                                                                              ? "N/A".tr
                                                                              : userModel.fullName.toString() == "Unknown User"
                                                                                  ? "User Deleted".tr
                                                                                  : userModel.fullName.toString(),
                                                                        ),
                                                                      );
                                                                    }
                                                                }
                                                              }),
                                                        ),
                                                        DataCell(TextCustom(title: parcelModel.createAt == null ? '' : Constant.timestampToDateTime(parcelModel.createAt!))),
                                                        DataCell(TextCustom(title: bool.parse(parcelModel.paymentStatus!.toString()) ? "Paid".tr : "Unpaid".tr)),
                                                        DataCell(
                                                          // e.bookingStatus.toString()
                                                          Constant.bookingStatusText(context, parcelModel.bookingStatus.toString()),
                                                        ),
                                                        // DataCell(TextCustom(title: Constant.amountShow(amount: bookingModel.subTotal))),
                                                        DataCell(TextCustom(title: Constant.amountShow(amount: Constant.calculateParcelFinalAmount(parcelModel).toString()))),
                                                        DataCell(
                                                          Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () async {
                                                                   // Get.toNamed(Routes.PARCEL_DETAIL, arguments: {'bookingModel': parcelModel});
                                                                    Get.toNamed('${Routes.PARCEL_DETAIL}/${parcelModel.id}');
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/ic_eye.svg",
                                                                    color: AppThemData.greyShade400,
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      // await controller.removeBooking(bookingModel);
                                                                      // controller.getBookings();
                                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                      if (confirmDelete) {
                                                                        await controller.removeBooking(parcelModel);
                                                                        controller.getBookings();
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
            ));
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
                  controller.selectedDateRange.value =
                      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  controller.selectedBookingStatus.value = "All";
                  controller.getBookingDataByBookingStatus();
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value =
                      DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  await FireStoreUtils.countStatusParcel(
                    controller.driverId.value,
                    controller.selectedBookingStatusForData.value,
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);
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
          title: const Text('Select Ride Booking Date'),
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
                  controller.selectedDateRangeForPdf.value =
                      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value =
                      DateTimeRange(start: controller.startDateForPdf!, end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));
                  controller.dateRangeController.value.text =
                      "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}";
                  log('--------------------==================> ${controller.startDateForPdf} and end data ${controller.endDateForPdf}');
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

      return GetX<ParcelHistoryScreenController>(
          init: ParcelHistoryScreenController(),
          builder: (taxController) {
            return Drawer(
              backgroundColor: AppThemData.primaryWhite,
              width: 500,
              child: Padding(
                padding: paddingEdgeInsets(vertical: 24, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(title: controller.title.value, fontSize: 20),
                    spaceH(height: 24),
                    SizedBox(
                      height: 1,
                      child: ContainerCustom(
                        color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    };
  }
}
