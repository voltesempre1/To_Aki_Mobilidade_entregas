// ignore_for_file: body_might_complete_normally_catch_error, use_build_context_synchronously, avoid_web_libraries_in_flutter, unused_local_variable

import 'dart:developer';

import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/payout_request_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class PayoutRequestController extends GetxController {
  RxString title = "Payout Request".tr.obs;

  RxBool isLoading = true.obs;

  RxList<WithdrawModel> payoutRequestList = <WithdrawModel>[].obs;
  RxList<WithdrawModel> currentPagePayOutRequest = <WithdrawModel>[].obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<TextEditingController> adminNoteController = TextEditingController().obs;

  RxString userSelectedPaymentStatus = "Pending".obs;
  List<String> paymentStatusType = ["Pending", "Complete", "Rejected"];
  List<String> payoutStatus = [
    "All",
    "Pending",
    "Complete",
    "Rejected",
  ];

  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxBool isHistoryDownload = false.obs;
  RxString driverId = "".obs;
  RxString selectedBookingStatusForData = "All".obs;
  Rx<DateTimeRange> selectedDateRange =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;
  DateTime? startDate;
  DateTime? endDate;

  RxList<DriverUserModel> allDriverList = <DriverUserModel>[].obs;
  Rx<DriverUserModel?> selectedDriver = Rx<DriverUserModel?>(DriverUserModel(id: 'All'));
  RxString selectedBookingStatus = "All".obs;
  RxString selectedPayoutStatus = "All".obs;
  RxString selectedFilterBookingStatus = "All".obs;

  RxString totalItemPerPage = '0'.obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getPayoutRequest();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    getAllDriver();
    super.onInit();
  }

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

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  Future<void> getPayoutRequest() async {
    isLoading.value = true;
    payoutRequestList.value = await FireStoreUtils.getPayoutRequest(status: selectedPayoutStatus.value, dateTimeRange: selectedDateRange.value, driverId: driverId.value);
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  void setPagination(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (payoutRequestList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > payoutRequestList.length ? payoutRequestList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPagePayOutRequest.value = payoutRequestList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  int pageValue(String data) {
    if (data == 'All') {
      return payoutRequestList.length;
    } else {
      return int.parse(data);
    }
  }

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;
  List<WithdrawModel> pdfPayoutRequestList = [];

  Future<void> downloadPayoutRequestPdf(BuildContext context) async {
    isHistoryDownload(true);
    pdfPayoutRequestList = await FireStoreUtils.dataForPayoutRequestPdf(
        selectedDateRangeForPdf.value, selectedDriver.value!.id.toString(), selectedFilterBookingStatus.value, selectedDateOption.value);
    log("Pdf Data :: ${pdfPayoutRequestList.length}");
    await generatePayoutRequestDataPdf(pdfPayoutRequestList, selectedDateRangeForPdf.value);
    isHistoryDownload(false);
    Navigator.pop(context);
  }

  Future<void> generatePayoutRequestDataPdf(List<WithdrawModel> payoutRequestList, DateTimeRange selectedRange) async {
    String formattedStartDate = "${selectedRange.start.day}-${selectedRange.start.month}-${selectedRange.start.year}";
    String formattedEndDate = "${selectedRange.end.day}-${selectedRange.end.month}-${selectedRange.end.year}";
    var excel = Excel.createExcel();
    Sheet sheet = excel['Driver_History_'];
    excel.setDefaultSheet('Driver_History_');

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
      TextCellValue(" BankName "),
      TextCellValue(" Amount "),
      TextCellValue(" Note "),
      TextCellValue(" AdminNote "),
      TextCellValue(" PaymentStatus "),
      TextCellValue(" PaymentDate "),
      TextCellValue(" CreatedAt "),
    ];
    sheet.appendRow(headers);

    // Apply header style to header row in a single loop
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.cellStyle = headerStyle;
      sheet.setColumnAutoFit(i); // Auto-fit columns in the same loop
    }

    sheet.setDefaultRowHeight(28);

    for (var history in payoutRequestList) {
      List<CellValue?> data = [
        TextCellValue(" ${history.id?.substring(0, 4) ?? ""} "),
        TextCellValue(" ${history.bankDetails!.bankName ?? ""} "),
        TextCellValue(" ${history.amount ?? ""} "),
        TextCellValue(" ${history.adminNote ?? ""} "),
        TextCellValue(" ${history.paymentStatus ?? ""} "),
        TextCellValue(" ${history.paymentDate != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.paymentDate!.toDate()) : "N/A"} "),
        TextCellValue(" ${history.createdDate != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.createdDate!.toDate()) : "N/A"} "),
      ];

      sheet.appendRow(data);
    }

    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final blob = html.Blob([Uint8List.fromList(fileBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Payout_Request_${formattedStartDate}_to_$formattedEndDate.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
