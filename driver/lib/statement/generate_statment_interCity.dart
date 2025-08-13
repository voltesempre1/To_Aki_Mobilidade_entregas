// ignore_for_file: file_names, depend_on_referenced_packages, deprecated_member_use
import 'dart:io';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> generateAndDownloadPdfMobileInterCity(List<IntercityModel> bookingList, DateTimeRange selectedRange) async {
  if (bookingList.isEmpty) {
    debugPrint("❌ No data found for the selected date range.");
    ShowToastDialog.toast('No data found');
    return;
  }

  String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
  String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

  var excel = Excel.createExcel();
  Sheet sheet = excel['InterCity_History'];
  excel.setDefaultSheet('InterCity_History');

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
    final String filePath = '${directory.path}/InterCity_Bookings_${formattedStartDate}_to_$formattedEndDate.xlsx';

    final File file = File(filePath);
    await file.writeAsBytes(fileBytes, flush: true);

    debugPrint("✅ Excel file saved at: $filePath");

    // Open the file
    await OpenFile.open(filePath);
  }
}
