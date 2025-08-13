import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/parcel_model.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/statement/generate_statment_cab.dart';
import 'package:driver/statement/generate_statment_interCity.dart';
import 'package:driver/statement/generate_statment_parcel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/fire_store_utils.dart';

class StatementController extends GetxController {
  RxBool isLoading = false.obs;

  RxString selectedSearchType = "Cab".obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Cab",
    "Intercity",
    "Parcel",
  ];

  DateTime? startDateForPdf;
  DateTime? endDateForPdf;

  RxBool isDatePickerEnableForPdf = true.obs;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  RxString selectedDateOption = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxBool isHistoryDownload = false.obs;

  List<IntercityModel> interCityDataList = [];
  List<ParcelModel> parcelDataList = [];
  List<BookingModel> bookingDataList = [];

  Future<void> dataGetForPdf() async {
    ShowToastDialog.showLoader("Please wait".tr);
    if (selectedSearchType.value == 'Cab') {
      bookingDataList = await FireStoreUtils.getDataForPdfCab(selectedDateRangeForPdf.value);
      await generateAndDownloadPdfMobileCab(bookingDataList, selectedDateRangeForPdf.value);

      ShowToastDialog.closeLoader();
    } else if (selectedSearchType.value == 'Intercity') {
      interCityDataList = await FireStoreUtils.getDataForPdfInterCity(selectedDateRangeForPdf.value);
      await generateAndDownloadPdfMobileInterCity(interCityDataList, selectedDateRangeForPdf.value);
      ShowToastDialog.closeLoader();
    } else {
      parcelDataList = await FireStoreUtils.getDataForPdfParcel(selectedDateRangeForPdf.value);
      await generateAndDownloadPdfParcel(parcelDataList, selectedDateRangeForPdf.value);
      ShowToastDialog.closeLoader();
    }
  }
}
