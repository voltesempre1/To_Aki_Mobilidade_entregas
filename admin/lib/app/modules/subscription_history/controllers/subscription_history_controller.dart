// ignore_for_file: depend_on_referenced_packages, body_might_complete_normally_catch_error, use_build_context_synchronously, avoid_web_libraries_in_flutter, unused_local_variable
import 'dart:developer';

import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/subscription_plan_history.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../constant/collection_name.dart';

class SubscriptionHistoryController extends GetxController {
  RxString title = "Subscription History".tr.obs;

  RxBool isLoading = false.obs;

  RxList<SubscriptionHistoryModel> subscriptionHistoryList = <SubscriptionHistoryModel>[].obs;

  RxString totalItemPerPage = '0'.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf = (DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.january, 1),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0)))
      .obs;

  RxString selectedBookingStatus = "All".obs;
  RxString selectedFilterBookingCabStatus = "All".obs;
  RxString selectedFilterBookingStatus = "All".obs;
  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxList<DriverUserModel> allDriverList = <DriverUserModel>[].obs;
  Rx<DriverUserModel?> selectedDriver = Rx<DriverUserModel?>(DriverUserModel(id: 'All'));
  RxBool isHistoryDownload = false.obs;
  RxList<SubscriptionHistoryModel> currentPageBooking = <SubscriptionHistoryModel>[].obs;

  RxString driverId = "".obs;
  RxString selectedBookingStatusForData = "All".obs;
  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.january, 1),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0)))
      .obs;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    getAllDriver();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    // subscriptionHistoryList.clear();
    // List<SubscriptionHistoryModel> data = await FireStoreUtils.getSubscriptionHistory(driverId.value, );
    // subscriptionHistoryList.addAll(data);
    await FireStoreUtils.countSubscriptionHistory();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
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

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.subscriptionLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value =
    (currentPage.value * itemPerPage) > Constant.subscriptionLength! ? Constant.subscriptionLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<SubscriptionHistoryModel> currentPageBookingData = await FireStoreUtils.getSubscriptionHistory(
          driverId.value,
          currentPage.value,
          itemPerPage,
          selectedDateRange.value,
        );

        currentPageBooking.value = currentPageBookingData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  int pageValue(String data) {
    if (data == 'All') {
      return subscriptionHistoryList.length;
    } else {
      return int.parse(data);
    }
  }

  List<SubscriptionHistoryModel> pdfSubscriptionHistoryList = [];

  Future<void> downloadSubscriptionHistoryPdf(BuildContext context) async {
    isHistoryDownload(true);
    pdfSubscriptionHistoryList = await FireStoreUtils.dataForSubscriptionHistoryPdf(
        selectedDateRangeForPdf.value, selectedDriver.value!.id.toString(), selectedDateOption.value);
    log("Pdf Data :: ${pdfSubscriptionHistoryList.length}");
    await generateSubscriptionHistoryDataPdf(pdfSubscriptionHistoryList, selectedDateRangeForPdf.value);
    Navigator.pop(context);
    isHistoryDownload(false);
  }

  Future<bool> removeSubscriptionHistory(String docId) {
    return FirebaseFirestore.instance.collection(CollectionName.subscriptionHistory).doc(docId).delete().then((value) async {
      return true;
    }).catchError((error) {
      return false;
    });
  }


  Future<void> generateSubscriptionHistoryDataPdf(List<SubscriptionHistoryModel> subHistoryList, DateTimeRange selectedRange) async {
    String formattedStartDate = "${selectedRange.start.day}-${selectedRange.start.month}-${selectedRange.start.year}";
    String formattedEndDate = "${selectedRange.end.day}-${selectedRange.end.month}-${selectedRange.end.year}";
    var excel = Excel.createExcel();
    Sheet sheet = excel['Subscription_History_'];
    excel.setDefaultSheet('Subscription_History_');

    sheet.appendRow([
      TextCellValue("Id"),
      TextCellValue("Title"),
      TextCellValue("Description"),
      TextCellValue("Price"),
      TextCellValue("ExpireDays"),
      TextCellValue("Features"),
      TextCellValue("ExpireDate"),
      TextCellValue("Create"),

    ]);

    for (var history in subHistoryList) {
      sheet.appendRow([
        TextCellValue(history.id?.substring(0, 4) ?? ""),
        TextCellValue(history.subscriptionPlan!.title ?? ""),
        TextCellValue(history.subscriptionPlan!.description ?? ""),
        TextCellValue(history.subscriptionPlan!.price ?? ""),
        TextCellValue(history.subscriptionPlan!.type ?? ""),
        TextCellValue(history.subscriptionPlan!.expireDays ?? ""),
        TextCellValue(history.expiryDate != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.expiryDate!.toDate()) : "N/A"),
        TextCellValue(history.createdAt != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.createdAt!.toDate()) : "N/A"),
      ]);
    }

    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final blob = html.Blob([Uint8List.fromList(fileBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Subscription_History_${formattedStartDate}_to_$formattedEndDate.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
