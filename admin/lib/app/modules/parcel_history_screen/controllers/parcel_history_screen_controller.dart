// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, body_might_complete_normally_catch_error, unused_local_variable

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/parcel_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class ParcelHistoryScreenController extends GetxController {
  RxString title = "Parcel History".obs;
  RxBool isLoading = true.obs;
  RxBool isDatePickerEnable = true.obs;
  RxBool isDatePickerEnableForPdf = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<ParcelModel> currentPageBooking = <ParcelModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
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

  Rx<DateTimeRange> selectedDateRange =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxString selectedFilterBookingCabStatus = "All".obs;
  RxString selectedFilterBookingStatus = "All".obs;
  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxList<DriverUserModel> allDriverList = <DriverUserModel>[].obs;
  Rx<DriverUserModel?> selectedDriver = Rx<DriverUserModel?>(DriverUserModel(id: 'All'));
  RxBool isHistoryDownload = false.obs;
  RxString driverId = "".obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getBookings();
    getAllDriver();
    super.onInit();
  }

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  List<ParcelModel> currentPageBookingData = [];

  Future<void> getAllDriver() async {
    await FireStoreUtils.getAllDriver().then((value) {
      value.insert(0, DriverUserModel(id: "All", fullName: 'All Driver'));
      allDriverList.addAll(value);
      log('=====================> values  ${value.length}');
      return value;
    }).catchError((error) {
      log('==================> get error $error');
    });
  }

  /// Maps user-friendly booking status to internal cab status.
  String _mapBookingStatusToCabStatus(String status) {
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

  Future<void> downloadParcelBookingPdf(BuildContext context) async {
    final cabStatus = _mapBookingStatusToCabStatus(selectedFilterBookingStatus.value);
    selectedFilterBookingCabStatus.value = cabStatus;

    isHistoryDownload(true);
    try {
      final driverId = selectedDriver.value?.id?.toString();
      if (driverId == null || driverId.isEmpty) {
        throw Exception('Driver not selected or invalid.');
      }
      currentPageBookingData = await FireStoreUtils.getDataForPdf(
        selectedDateRangeForPdf.value,
        driverId,
        cabStatus,
        selectedDateOption.value,
      );
      log('Fetched PDF data for booking list: \\${currentPageBookingData.length}');
      await generateAndDownloadPdfWeb(currentPageBookingData, selectedDateRangeForPdf.value);
    } catch (e, stack) {
      log('Error downloading PDF: $e\\n$stack');
      ShowToastDialog.toast("Failed to download PDF. Please try again.");
    } finally {
      isHistoryDownload(false);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  /// Maps user-friendly booking status to internal data status.
  String _mapBookingStatusToDataStatus(String status) {
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
      final dataStatus = _mapBookingStatusToDataStatus(selectedBookingStatus.value);
      selectedBookingStatusForData.value = dataStatus;
      if (dataStatus == "All") {
        await getBookings();
      } else {
        await FireStoreUtils.countStatusParcel('', dataStatus, selectedDateRange.value);
        await setPagination(totalItemPerPage.value);
      }
    } catch (e, stack) {
      log('Error fetching booking data: $e\\n$stack');
      ShowToastDialog.toast("Failed to fetch booking data.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeBooking(ParcelModel parcelModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.parcelRide).doc(parcelModel.id).delete().then((value) {
      ShowToastDialog.toast("Parcel booking deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }

  Future<void> getBookings() async {
    isLoading.value = true;
    await FireStoreUtils.countParcelBooking();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.parcelBookingLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.parcelBookingLength! ? Constant.parcelBookingLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<ParcelModel> currentPageBookingData =
            await FireStoreUtils.getParcelBooking(driverId.value, currentPage.value, itemPerPage, selectedBookingStatusForData.value, selectedDateRange.value);
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
    if (data == 'All') {
      return Constant.parcelBookingLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> generateAndDownloadPdfWeb(List<ParcelModel> bookingList, DateTimeRange selectedRange) async {
    String formattedStartDate = "${selectedRange.start.day}-${selectedRange.start.month}-${selectedRange.start.year}";
    String formattedEndDate = "${selectedRange.end.day}-${selectedRange.end.month}-${selectedRange.end.year}";

    var excel = Excel.createExcel();
    Sheet sheet = excel['ParcelBooking_History'];
    excel.setDefaultSheet('ParcelBooking_History');

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
        TextCellValue(" ${history.pickUpLocationAddress ?? ""} "),
        TextCellValue(" ${history.dropLocationAddress ?? ""} "),
        TextCellValue(" ${history.distance!.distance?.toString() ?? ""} "),
        TextCellValue(" ${history.subTotal?.toString() ?? ""} "),
        TextCellValue(" ${history.paymentType ?? ""} "),
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
        ..setAttribute("download", "Parcel_Booking_History_${formattedStartDate}_to_$formattedEndDate.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
