// ignore_for_file: body_might_complete_normally_catch_error, depend_on_referenced_packages, use_build_context_synchronously, unused_local_variable

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class CabBookingController extends GetxController {
  RxString title = "Cab Bookings".obs;
  RxBool isLoading = true.obs;
  RxBool isHistoryDownload = false.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<BookingModel> currentPageBooking = <BookingModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  DateTime? startDate;
  DateTime? endDate;
  RxString selectedBookingStatus = "All".obs;
  RxString selectedBookingStatusForData = "All".obs;
  RxString selectedFilterBookingCabStatus = "All".obs;
  RxString selectedFilterBookingStatus = "All".obs;

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
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxList<DriverUserModel> allDriverList = <DriverUserModel>[].obs;
  Rx<DriverUserModel?> selectedDriver = Rx<DriverUserModel?>(DriverUserModel(id: 'All'));
  RxString driverId = "".obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getBookings();
    getAllDriver();
    super.onInit();
  }

  List<BookingModel> pdfCabBookingList = [];

  Future<void> downloadCabBookingPdf(BuildContext context) async {
    if (selectedFilterBookingStatus.value == "Rejected") {
      selectedFilterBookingCabStatus.value = "booking_rejected";
    } else if (selectedFilterBookingStatus.value == "Placed") {
      selectedFilterBookingCabStatus.value = "booking_placed";
    } else if (selectedFilterBookingStatus.value == "Completed") {
      selectedFilterBookingCabStatus.value = "booking_completed";
    } else if (selectedFilterBookingStatus.value == "Cancelled") {
      selectedFilterBookingCabStatus.value = 'booking_cancelled';
    } else if (selectedFilterBookingStatus.value == "Accepted") {
      selectedFilterBookingCabStatus.value = 'booking_accepted';
    } else if (selectedFilterBookingStatus.value == "OnGoing") {
      selectedFilterBookingCabStatus.value = 'booking_ongoing';
    } else {
      selectedFilterBookingCabStatus.value = "All";
    }

    isHistoryDownload(true);
    pdfCabBookingList =
        await FireStoreUtils.getDataForPdfCab(selectedDateRangeForPdf.value, selectedDriver.value!.id.toString(), selectedFilterBookingCabStatus.value, selectedDateOption.value);
    log("Pdf Data :: ${pdfCabBookingList.length}");
    // for(var booking in pdfCabBookingList){
    //   log("Id : ${booking.id}, Pickup : ${booking.pickUpLocationAddress}, DropLocation : ${booking.dropLocationAddress}");
    // }
    await generateCabAndDownloadPdfWeb(pdfCabBookingList, selectedDateRangeForPdf.value);
    isHistoryDownload(false);
    Navigator.pop(context);
  }

  Future<void> getAllDriver() async {
    await FireStoreUtils.getAllDriver().then((value) {
      value.insert(0, DriverUserModel(id: "All", fullName: 'All Driver'));
      allDriverList.addAll(value);
      return value;
    }).catchError((error) {
      log('==================> get error $error');
    });
  }

  Future<void> getBookingDataByBookingStatus() async {
    isLoading.value = true;
    if (selectedBookingStatus.value == "Rejected") {
      selectedBookingStatusForData.value = "booking_rejected";
      await FireStoreUtils.countStatusWiseBooking(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Placed") {
      selectedBookingStatusForData.value = "booking_placed";
      await FireStoreUtils.countStatusWiseBooking(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Completed") {
      selectedBookingStatusForData.value = "booking_completed";
      await FireStoreUtils.countStatusWiseBooking(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Cancelled") {
      selectedBookingStatusForData.value = 'booking_cancelled';
      await FireStoreUtils.countStatusWiseBooking(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "Accepted") {
      selectedBookingStatusForData.value = 'booking_accepted';
      await FireStoreUtils.countStatusWiseBooking(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedBookingStatus.value == "OnGoing") {
      selectedBookingStatusForData.value = 'booking_ongoing';
      await FireStoreUtils.countStatusWiseBooking(driverId.value, selectedBookingStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else {
      // booking_accepted
      selectedBookingStatusForData.value = "All";
      getBookings();
    }

    isLoading.value = false;
  }

  Future<void> removeBooking(BookingModel bookingModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.bookings).doc(bookingModel.id).delete().then((value) {
      ShowToastDialog.toast("Booking deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }

  Future<void> getBookings() async {
    isLoading.value = true;
    await FireStoreUtils.countBooking();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.bookingLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.bookingLength! ? Constant.bookingLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<BookingModel> currentPageBookingData =
            await FireStoreUtils.getBooking(currentPage.value, itemPerPage, selectedBookingStatusForData.value, selectedDateRange.value, driverId.value);
        currentPageBooking.value = currentPageBookingData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') return Constant.bookingLength!;
    return int.tryParse(data) ?? 0;
  }

  Future<void> generateCabAndDownloadPdfWeb(List<BookingModel> bookingList, DateTimeRange selectedRange) async {
    final formattedStartDate = "${selectedRange.start.day}-${selectedRange.start.month}-${selectedRange.start.year}";
    final formattedEndDate = "${selectedRange.end.day}-${selectedRange.end.month}-${selectedRange.end.year}";

    final excel = Excel.createExcel();
    final Sheet sheet = excel['CabBooking_History'];
    excel.setDefaultSheet('CabBooking_History');

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

    for (var history in bookingList) {
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

    // Convert the file to bytes
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final blob = html.Blob([Uint8List.fromList(fileBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "CabBooking_History_${formattedStartDate}_to_$formattedEndDate.xlsx")
        ..click();

      html.Url.revokeObjectUrl(url);
    }
  }
}
