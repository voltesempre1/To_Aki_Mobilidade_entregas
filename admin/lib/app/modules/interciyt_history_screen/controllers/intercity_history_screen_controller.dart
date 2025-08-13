// ignore_for_file: depend_on_referenced_packages, body_might_complete_normally_catch_error, use_build_context_synchronously, unused_local_variable

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/intercity_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class InterCityHistoryScreenController extends GetxController {
  RxString title = "Intercity History".obs;
  RxBool isLoading = true.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<IntercityModel> currentPageBooking = <IntercityModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  DateTime? startDate;
  DateTime? endDate;
  RxString selectedBookingStatus = "All".obs;
  RxString selectedBookingStatusForData = "All".obs;
  List<String> bookingStatus = [
    "All",
    "Placed",
    "Completed",
    "Rejected",
    "Cancelled",
    "Accepted",
    "OnGoing",
  ];

  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  Rx<DateTimeRange> selectedDateRange =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxBool isDatePickerEnableForPdf = true.obs;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  Rx<DriverUserModel?> selectedDriver = Rx<DriverUserModel?>(DriverUserModel(id: 'All'));
  RxString selectedFilterBookingStatus = "All".obs;
  RxBool isHistoryDownload = false.obs;
  RxString selectedFilterBookingCabStatus = "All".obs;

  RxList<DriverUserModel> allDriverList = <DriverUserModel>[].obs;
  RxString driverId = "All".obs;

  RxString totalItemPerPage = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      totalItemPerPage.value = Constant.numOfPageIemList.first;
      await Future.wait([
        getBookings(),
        getAllDriver(),
      ]);
    } catch (e, stack) {
      log('Error initializing IntercityHistoryScreenController: $e\n$stack');
      ShowToastDialog.toast('Failed to initialize data');
    }
  }

  Future<void> getAllDriver() async {
    try {
      final value = await FireStoreUtils.getAllDriver();
      value.insert(0, DriverUserModel(id: "All", fullName: 'All Driver'));
      allDriverList.assignAll(value);
      log('Loaded drivers: ${value.length}');
    } catch (error) {
      log('Error loading drivers: $error');
    }
  }

  List<IntercityModel> currentPageBookingData = [];

  Future<void> downloadInterCityBookingPdf(BuildContext context) async {
    selectedFilterBookingCabStatus.value = _mapBookingStatus(selectedFilterBookingStatus.value);
    isHistoryDownload.value = true;
    try {
      currentPageBookingData = await FireStoreUtils.getDataForPdfInterCity(
        selectedDateRangeForPdf.value,
        selectedDriver.value?.id ?? '',
        selectedFilterBookingCabStatus.value,
        selectedDateOption.value,
      );
      log('PDF data for booking list: ${currentPageBookingData.length}');
      await generateInterCityAndDownloadPdfWeb(currentPageBookingData, selectedDateRangeForPdf.value);
      Navigator.pop(context);
    } catch (e, stack) {
      log('Error generating PDF: $e\n$stack');
      ShowToastDialog.toast('Failed to generate PDF');
    } finally {
      isHistoryDownload.value = false;
    }
  }

  String _mapBookingStatus(String status) {
    const statusMap = {
      "Rejected": "booking_rejected",
      "Placed": "booking_placed",
      "Completed": "booking_completed",
      "Cancelled": "booking_cancelled",
      "Accepted": "booking_accepted",
      "OnGoing": "booking_ongoing",
    };
    return statusMap[status] ?? "All";
  }

  Future<void> getBookingDataByBookingStatus() async {
    isLoading.value = true;
    try {
      selectedBookingStatusForData.value = _mapBookingStatus(selectedBookingStatus.value);
      if (selectedBookingStatusForData.value != "All") {
        await FireStoreUtils.countStatusWiseInterCity(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
        await setPagination(totalItemPerPage.value);
      } else {
        await getBookings();
      }
    } catch (e, stack) {
      log('Error filtering bookings: $e\n$stack');
      ShowToastDialog.toast('Failed to filter bookings');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeBooking(IntercityModel parcelModel) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection(CollectionName.interCityRide).doc(parcelModel.id).delete();
      ShowToastDialog.toast("Intercity booking deleted...!".tr);
    } catch (error) {
      ShowToastDialog.toast("Something went wrong".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getBookings() async {
    isLoading.value = true;
    try {
      await FireStoreUtils.countInterCityBooking();
      await setPagination(totalItemPerPage.value);
    } catch (e, stack) {
      log('Error loading bookings: $e\n$stack');
      ShowToastDialog.toast('Failed to load bookings');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    try {
      totalItemPerPage.value = page;
      int itemPerPage = pageValue(page);
      totalPage.value = (Constant.interCityBookingLength! / itemPerPage).ceil();
      startIndex.value = (currentPage.value - 1) * itemPerPage;
      endIndex.value = (currentPage.value * itemPerPage) > Constant.interCityBookingLength! ? Constant.interCityBookingLength! : (currentPage.value * itemPerPage);
      if (endIndex.value < startIndex.value) {
        currentPage.value = 1;
        await setPagination(page);
      } else {
        try {
          final data = await FireStoreUtils.getInterCityBooking(driverId.value, currentPage.value, itemPerPage, selectedBookingStatusForData.value, selectedDateRange.value);
          currentPageBooking.value = data;
        } catch (error) {
          log('Error paginating bookings: $error');
        }
      }
      update();
    } finally {
      isLoading.value = false;
    }
  }

  int pageValue(String data) {
    if (data == 'All') return Constant.interCityBookingLength!;
    return int.tryParse(data) ?? 0;
  }

  Future<void> generateInterCityAndDownloadPdfWeb(List<IntercityModel> intercitybookingList, DateTimeRange selectedRange) async {
    String formattedStartDate = "${selectedRange.start.day}-${selectedRange.start.month}-${selectedRange.start.year}";
    String formattedEndDate = "${selectedRange.end.day}-${selectedRange.end.month}-${selectedRange.end.year}";
    var excel = Excel.createExcel();
    Sheet sheet = excel['Intercity_History_'];
    excel.setDefaultSheet('Intercity_History_');

    CellStyle headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    CellStyle dataStyle = CellStyle(
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
    );

    List<CellValue?> headers = [
      TextCellValue(" Id "),
      TextCellValue(" PickUpLocationAddress "),
      TextCellValue(" DropLocationAddress "),
      TextCellValue(" Distance "),
      TextCellValue(" Total "),
      TextCellValue(" Payment Type "),
      TextCellValue(" Status "),
      TextCellValue(" Pickup Time "),
      TextCellValue(" Drop Time "),
      TextCellValue(" Create Time "),
    ];

    sheet.appendRow(headers);

    String getReadableBookingStatus(String? status) {
      switch (status) {
        case "booking_placed":
          return "Placed";
        case "booking_accepted":
          return "Accepted";
        case "booking_ongoing":
          return "Ongoing";
        case "booking_cancelled":
          return "Cancelled";
        case "booking_completed":
          return "Completed";
        case "booking_rejected":
          return "Rejected";
        default:
          return "-";
      }
    }

    for (int i = 0; i < headers.length; i++) {
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.cellStyle = headerStyle;
    }

    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    sheet.setDefaultRowHeight(28);

    sheet.appendRow(List<CellValue?>.filled(headers.length, null));

    for (var history in intercitybookingList) {
      List<CellValue?> data = [
        TextCellValue(" ${history.id?.substring(0, 4) ?? " "} "),
        TextCellValue(" ${history.pickUpLocationAddress ?? " "} "),
        TextCellValue(" ${history.dropLocationAddress ?? " "} "),
        TextCellValue(" ${history.distance!.distance?.toString() ?? " "} "),
        TextCellValue(" ${history.subTotal?.toString() ?? " "} "),
        TextCellValue(" ${history.paymentType ?? " "} "),
        TextCellValue(" ${getReadableBookingStatus(history.bookingStatus)} "),
        TextCellValue(" ${history.pickupTime != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.pickupTime!.toDate()) : "N/A"} "),
        TextCellValue(" ${history.dropTime != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.dropTime!.toDate()) : "N/A"} "),
        TextCellValue(" ${history.createAt != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.createAt!.toDate()) : "N/A"} "),
      ];

      sheet.appendRow(data);
    }

    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final blob = html.Blob([Uint8List.fromList(fileBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Intercity_History_${formattedStartDate}_to_$formattedEndDate.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
