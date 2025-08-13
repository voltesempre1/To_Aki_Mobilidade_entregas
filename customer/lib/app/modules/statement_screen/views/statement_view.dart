import 'dart:developer';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/statement_controller.dart';

class StatementView extends StatelessWidget {
  const StatementView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: StatementController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.bgScreen,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        "assets/icon/gif_statement.gif",
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Download Ride Statement'.tr,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Select your preferred cab type, choose a date range and download your ride statement'.tr,
                        style: GoogleFonts.inter(
                          color: AppThemData.grey500,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Ride Type'.tr,
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            return DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(15),
                              isExpanded: true,
                              style: TextStyle(
                                color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                fontSize: 16,
                              ),
                              onChanged: (String? searchType) {
                                controller.selectedSearchType.value = searchType ?? "Name";
                              },
                              value: controller.selectedSearchType.value,
                              items: controller.searchType.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: Constant.defaultInputDecoration(context),
                            );
                          }),
                          const SizedBox(height: 8),
                          Text(
                            'Select Time '.tr,
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            return DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(15),
                              isExpanded: true,
                              style: TextStyle(
                                color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                fontSize: 16,
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
                              },
                              value: controller.selectedDateOption.value,
                              items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: Constant.defaultInputDecoration(context),
                            );
                          }),
                          const SizedBox(height: 20),
                          Obx( ()=>
                             Visibility(
                              visible: controller.isCustomVisible.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Star date to End Date'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () {
                                      showDateRangePickerForPdf(context, controller);
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width * 0.9,
                                      padding: const EdgeInsets.all(12),
                                      height: 56,
                                      margin: const EdgeInsets.only(top: 4),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(
                                            () => Text(
                                              controller.selectedDateRangeForPdf.value.start == DateTime(DateTime.now().year, DateTime.january, 1) &&
                                                      controller.selectedDateRangeForPdf.value.end == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0)
                                                  ? "Select Date"
                                                  : "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}",
                                              style: GoogleFonts.inter(
                                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            size: 24,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RoundShapeButton(
                                size: Size(Responsive.width(100, context), 54),
                                title: "Download".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () {

                                  if (controller.selectedDateOption.value == 'Custom') {
                                    final selected = controller.selectedDateRangeForPdf.value;
                                    final defaultStart = DateTime(DateTime.now().year, DateTime.january, 1);
                                    final defaultEnd = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0);

                                    final isDefaultRange = selected.start == defaultStart && selected.end == defaultEnd;

                                    if (isDefaultRange) {
                                      ShowToastDialog.toast("Please select a valid custom date range.");
                                      return;
                                    }
                                  }
                                  controller.dataGetForPdf();

                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> showDateRangePickerForPdf(BuildContext context, StatementController controller) async {
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
                  controller.selectedDateRangeForPdf.value = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(start: controller.startDateForPdf!, end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));

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
}
