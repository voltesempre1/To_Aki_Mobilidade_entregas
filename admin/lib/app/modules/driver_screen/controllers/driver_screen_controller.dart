// ignore_for_file: avoid_web_libraries_in_flutter, depend_on_referenced_packages, unused_local_variable

import 'dart:io';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class DriverScreenController extends GetxController {
  RxString title = "All Drivers".tr.obs;

  RxBool isLoading = true.obs;
  RxBool isSearchEnable = true.obs;

  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  RxString selectedSearchType = "Name".obs;
  RxString selectedSearchTypeForData = "slug".obs;
  List<String> searchType = [
    "Name",
    "Phone",
    "Email",
  ];

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<DriverUserModel> currentPageDriver = <DriverUserModel>[].obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<File> imagePath = File('').obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;
  RxString editingId = ''.obs;

  RxString totalItemPerPage = '0'.obs;
  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<void> getUser() async {
    isLoading.value = true;
    try {
      totalItemPerPage.value = Constant.numOfPageIemList.first;
      await fetchDrivers();
      dateFiledController.value.text = _formatDateRange(selectedDate.value);
    } catch (e, stack) {
      log('Error initializing driver screen: $e\n$stack');
      ShowToastDialog.toast('Failed to initialize driver data');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDateRange(DateTimeRange range) {
    return "${DateFormat('yyyy-MM-dd').format(range.start)} to ${DateFormat('yyyy-MM-dd').format(range.end)}";
  }

  Future<void> fetchDrivers() async {
    try {
      await FireStoreUtils.countDrivers();
      await setPagination(totalItemPerPage.value);
    } catch (e, stack) {
      log('Error fetching drivers: $e\n$stack');
      ShowToastDialog.toast('Failed to fetch drivers');
    }
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    try {
      totalItemPerPage.value = page;
      int itemPerPage = pageValue(page);
      totalPage.value = (Constant.driverLength! / itemPerPage).ceil();
      startIndex.value = (currentPage.value - 1) * itemPerPage;
      endIndex.value = (currentPage.value * itemPerPage) > Constant.driverLength! ? Constant.driverLength! : (currentPage.value * itemPerPage);
      if (endIndex.value < startIndex.value) {
        currentPage.value = 1;
        await setPagination(page);
      } else {
        try {
          final drivers = await FireStoreUtils.getDriver(currentPage.value, itemPerPage, searchController.value.text, selectedSearchTypeForData.value);
          currentPageDriver.value = drivers;
        } catch (error) {
          log('Error paginating drivers: $error');
        }
      }
      update();
    } finally {
      isLoading.value = false;
    }
  }

  int pageValue(String data) {
    if (data == 'All') return Constant.driverLength!;
    return int.tryParse(data) ?? 0;
  }

  Future<void> removeDriver(DriverUserModel driverUserModel) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection(CollectionName.drivers).doc(driverUserModel.id).delete();
      ShowToastDialog.toast("Driver deleted...!".tr);
      await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(driverUserModel.id).delete();
      log("Verify Driver Deleted...!");
    } catch (error) {
      log("Error deleting driver: $error");
      ShowToastDialog.toast("Something went wrong".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSearchType() async {
    isLoading.value = true;
    try {
      switch (selectedSearchType.value) {
        case "Phone":
          selectedSearchTypeForData.value = "phoneNumber";
          break;
        case "Email":
          selectedSearchTypeForData.value = "email";
          break;
        default:
          selectedSearchTypeForData.value = "slug";
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickPhoto() async {
    uploading.value = true;
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) return;
      final imageFile = File(img.path);
      imageController.value.text = img.name;
      imagePath.value = imageFile;
      imagePickedFileBytes.value = await img.readAsBytes();
      mimeType.value = img.mimeType ?? 'image/png';
    } catch (e) {
      log('Error picking photo: $e');
    } finally {
      uploading.value = false;
    }
  }

  void getArgument(DriverUserModel driverUserModel) {
    driverModel.value = driverUserModel;
    userNameController.value.text = driverModel.value.fullName ?? '';
    phoneNumberController.value.text = Constant.maskMobileNumber(mobileNumber: driverModel.value.phoneNumber, countryCode: driverModel.value.countryCode);
    emailController.value.text = Constant.maskEmail(email: driverModel.value.email ?? '');
    imageController.value.text = driverModel.value.profilePic ?? '';
    editingId.value = driverModel.value.id ?? '';
  }

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;
  List<DriverUserModel> pdfDriverList = [];

  Future<void> downloadDriverDataPdf() async {
    isLoading(true);
    pdfDriverList = await FireStoreUtils.dataForDriverPdf(selectedDateRangeForPdf.value);
    log("Pdf Data :: ${pdfDriverList.length}");
    await generateDriverDataPdf(pdfDriverList, selectedDateRangeForPdf.value);
    isLoading(false);
  }

  Future<void> generateDriverDataPdf(List<DriverUserModel> intercitybookingList, DateTimeRange selectedRange) async {
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
      TextCellValue("Id"),
      TextCellValue("FullName"),
      TextCellValue("Email"),
      TextCellValue("LoginType"),
      TextCellValue("DateOfBirth"),
      TextCellValue("CountryCode"),
      TextCellValue("PhoneNumber"),
      TextCellValue("WalletAmount"),
      TextCellValue("Gender"),
      TextCellValue("VehicleType"),
      TextCellValue("VehicleNumber"),
      TextCellValue("ModelName"),
      TextCellValue("SubscriptionExpiryDate"),
      TextCellValue("SubscriptionPlanTitle"),
      TextCellValue("SubscriptionPlanPrice"),
      TextCellValue("IsVerify"),
    ];

    sheet.appendRow(headers);

    for (var history in intercitybookingList) {
      List<CellValue?> data = [
        TextCellValue(" ${history.id?.substring(0, 4) ?? " "} "),
        TextCellValue(" ${history.fullName ?? " "} "),
        TextCellValue(" ${history.email ?? " "} "),
        TextCellValue(" ${history.loginType ?? " "} "),
        TextCellValue(" ${history.dateOfBirth ?? " "} "),
        TextCellValue(" ${history.countryCode ?? " "} "),
        TextCellValue(" ${history.phoneNumber ?? " "} "),
        TextCellValue(" ${history.walletAmount ?? " "} "),
        TextCellValue(" ${history.gender ?? " "} "),
        TextCellValue(" ${history.driverVehicleDetails!.vehicleTypeName ?? " "} "),
        TextCellValue(" ${history.driverVehicleDetails!.vehicleNumber ?? " "} "),
        TextCellValue(" ${history.driverVehicleDetails!.modelName ?? " "} "),
        TextCellValue(" ${history.subscriptionExpiryDate != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.subscriptionExpiryDate!.toDate()) : "N/A"} "),
        TextCellValue(" ${history.subscriptionPlan!.title ?? ""} "),
        TextCellValue(" ${history.subscriptionPlan!.price ?? ""} "),
        TextCellValue(" ${history.createdAt != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(history.createdAt!.toDate()) : "N/A"} "),
      ];

      sheet.appendRow(data);
    }

    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final blob = html.Blob([Uint8List.fromList(fileBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Driver_History_${formattedStartDate}_to_$formattedEndDate.xlsx")
        ..click();

      html.Url.revokeObjectUrl(url);
    }
  }
}
