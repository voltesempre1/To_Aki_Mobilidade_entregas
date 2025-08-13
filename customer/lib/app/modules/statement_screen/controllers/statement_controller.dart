
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/app/models/parcel_model.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/language_model.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class StatementController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  RxString selectedSearchType = "Cab".obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Cab",
    "Intercity",
    "Parcel",
  ];
  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxBool isHistoryDownload = false.obs;

  DateTime? startDateForPdf;
  DateTime? endDateForPdf;

  RxBool isDatePickerEnableForPdf = true.obs;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  List<IntercityModel> interCityDataList = [];
  List<ParcelModel> parcelDataList = [];
  List<BookingModel> bookingDataList = [];

  Future<void> dataGetForPdf() async {
    ShowToastDialog.showLoader("Please wait".tr);
    try {
      if (selectedSearchType.value == 'Cab') {
        bookingDataList = await FireStoreUtils.getDataForPdfCab(selectedDateRangeForPdf.value);
        await generateCabBookingPdf(bookingDataList, selectedDateRangeForPdf.value);
      } else if (selectedSearchType.value == 'InterCity') {
        interCityDataList = await FireStoreUtils.getDataForPdfInterCity(selectedDateRangeForPdf.value);
        await generateIntercityBookingPdf(interCityDataList, selectedDateRangeForPdf.value);
      } else {
        parcelDataList = await FireStoreUtils.getDataForPdfParcel(selectedDateRangeForPdf.value);
        await generateParcelBookingPdf(parcelDataList, selectedDateRangeForPdf.value);
      }
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> generateIntercityBookingPdf(List<IntercityModel> bookingList, DateTimeRange selectedRange) async {
    if (bookingList.isEmpty) {
      debugPrint("❌ No data found for the selected date range.");
      return;
    }

    String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

    var excel = Excel.createExcel();
    Sheet sheet = excel['Intercity_History'];
    excel.setDefaultSheet('Intercity_History');

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
      TextCellValue(" ID "),
      TextCellValue(" Pickup "),
      TextCellValue(" Drop "),
      TextCellValue(" Distance "),
      TextCellValue(" Status "),
      TextCellValue(" Booking Date "),
      TextCellValue(" Price "),
      TextCellValue(" Drop Time "),
      TextCellValue(" Pickup Time "),
      TextCellValue(" Payment Type "),
      TextCellValue(" Reason For Cancel "),
      TextCellValue(" Cab Name "),
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

    for (var e in bookingList) {
      List<CellValue?> data = [
        TextCellValue(e.id?.substring(0, 5) ?? '-'),
        TextCellValue(e.pickUpLocationAddress ?? '-'),
        TextCellValue(e.dropLocationAddress ?? '-'),
        TextCellValue(e.distance?.distance?.toString() ?? '-'),
        TextCellValue(getReadableBookingStatus(e.bookingStatus)),
        TextCellValue(e.createAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.createAt!.toDate()) : '-'),
        TextCellValue(e.subTotal?.toString() ?? '-'),
        TextCellValue(e.dropTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.dropTime!.toDate()) : '-'),
        TextCellValue(e.pickupTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.pickupTime!.toDate()) : '-'),
        TextCellValue(e.paymentType ?? '-'),
        TextCellValue(e.cancelledReason?.toString() ?? '-'),
        TextCellValue(e.vehicleType?.title ?? '-'),
      ];

      sheet.appendRow(data);

      for (int i = 0; i < data.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: sheet.maxRows - 1));
        cell.cellStyle = dataStyle;
      }
    }

    // Save file to local storage
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/Intercity_Bookings_${formattedStartDate}_to_$formattedEndDate.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(fileBytes, flush: true);

      debugPrint("✅ Excel file saved at: $filePath");

      // Open the file
      await OpenFile.open(filePath);
    }
  }

  Future<void> generateCabBookingPdf(List<BookingModel> bookingList, DateTimeRange selectedRange) async {
    if (bookingList.isEmpty) {
      debugPrint("❌ No data found for the selected date range.");
      return;
    }

    String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

    var excel = Excel.createExcel();
    Sheet sheet = excel['CabBooking_History'];
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
      TextCellValue(" Order Id "),
      TextCellValue(" Pickup Location "),
      TextCellValue(" Drop Location "),
      TextCellValue(" Distance "),
      TextCellValue(" Status "),
      TextCellValue(" Booking Date "),
      TextCellValue(" Price "),
      TextCellValue(" Drop Time "),
      TextCellValue(" Pickup Time "),
      TextCellValue(" Payment Type "),
      TextCellValue(" Reason For Cancel "),
      TextCellValue(" Cab Name "),
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

    for (var e in bookingList) {
      List<CellValue> data = [
        TextCellValue(e.id?.substring(0, 5) ?? '-'),
        TextCellValue(e.pickUpLocationAddress ?? '-'),
        TextCellValue(e.dropLocationAddress ?? '-'),
        TextCellValue(e.distance?.distance?.toString() ?? '-'),
        TextCellValue(getReadableBookingStatus(e.bookingStatus)),
        TextCellValue(e.createAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.createAt!.toDate()) : '-'),
        TextCellValue(e.subTotal?.toString() ?? '-'),
        TextCellValue(e.dropTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.dropTime!.toDate()) : '-'),
        TextCellValue(e.pickupTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.pickupTime!.toDate()) : '-'),
        TextCellValue(e.paymentType ?? '-'),
        TextCellValue(e.cancelledReason?.toString() ?? '-'),
        TextCellValue(e.vehicleType?.title ?? '-'),
      ];
      sheet.appendRow(data);

      for (int i = 0; i < data.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: sheet.maxRows - 1));
        cell.cellStyle = dataStyle;
      }
    }

    // Save file to local storage
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/Cab_Bookings_${formattedStartDate}_to_$formattedEndDate.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(fileBytes, flush: true);

      debugPrint("✅ Excel file saved at: $filePath");

      // Open the file
      await OpenFile.open(filePath);
    }
  }

  Future<void> generateParcelBookingPdf(List<ParcelModel> bookingList, DateTimeRange selectedRange) async {
    if (bookingList.isEmpty) {
      debugPrint("❌ No data found for the selected date range.");
      return;
    }

    String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

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
      TextCellValue(" ID "),
      TextCellValue(" Pickup "),
      TextCellValue(" Drop "),
      TextCellValue(" Distance "),
      TextCellValue(" Status "),
      TextCellValue(" Booking Date "),
      TextCellValue(" Price "),
      TextCellValue(" Drop Time "),
      TextCellValue(" Pickup Time "),
      TextCellValue(" Payment Type "),
      TextCellValue(" Reason For Cancel "),
      TextCellValue(" Cab Name "),
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

    for (var e in bookingList) {
      List<CellValue?> data = [
        TextCellValue(e.id?.substring(0, 5) ?? '-'),
        TextCellValue(e.pickUpLocationAddress ?? '-'),
        TextCellValue(e.dropLocationAddress ?? '-'),
        TextCellValue(e.distance?.distance?.toString() ?? '-'),
        TextCellValue(getReadableBookingStatus(e.bookingStatus)),
        TextCellValue(e.createAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.createAt!.toDate()) : '-'),
        TextCellValue(e.subTotal?.toString() ?? '-'),
        TextCellValue(e.dropTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.dropTime!.toDate()) : '-'),
        TextCellValue(e.pickupTime != null ? DateFormat('yyyy-MM-dd HH:mm').format(e.pickupTime!.toDate()) : '-'),
        TextCellValue(e.paymentType ?? '-'),
        TextCellValue(e.cancelledReason?.toString() ?? '-'),
        TextCellValue(e.vehicleType?.title ?? '-'),
      ];
      sheet.appendRow(data);
      for (int i = 0; i < data.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: sheet.maxRows - 1));
        cell.cellStyle = dataStyle;
      }
    }

    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/Parcel_Bookings_${formattedStartDate}_to_$formattedEndDate.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(fileBytes, flush: true);

      debugPrint("✅ Excel file saved at: $filePath");

      // Open the file
      await OpenFile.open(filePath);
    }
  }
}
