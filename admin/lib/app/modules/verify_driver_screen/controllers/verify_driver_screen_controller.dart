// ignore_for_file: depend_on_referenced_packages, strict_top_level_inference

import 'dart:developer';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/verify_driver_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerifyDriverScreenController extends GetxController {
  RxString title = "Verify Driver".tr.obs;
  RxBool isLoading = true.obs;

  RxBool isLoadingVehicleDetails = false.obs;
  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;
  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;

  // RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  Rx<DriverUserModel> driverUserDetails = DriverUserModel().obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<DriverUserModel> currentPageVerifyDriver = <DriverUserModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;

  RxBool isVerify = false.obs;
  RxString editingVerifyDocumentId = "".obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    // tempList.value = await FireStoreUtils.getVerifyDriverModel();
    // driverList.value = await FireStoreUtils.getVerifyDriverModel();
    await FireStoreUtils.countDrivers();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.driverLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.driverLength! ? Constant.driverLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<DriverUserModel> currentPageDriverData = await FireStoreUtils.getDriver(currentPage.value, itemPerPage, "", "");
        currentPageVerifyDriver.value = currentPageDriverData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  Future<void> removeVerifyDocument(VerifyDriverModel verifyDriverModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(verifyDriverModel.driverId).delete().then((value) {
      ShowToastDialog.toast("Verify Driver deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }

  Rx<DateTimeRange> selectedDate =
      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
          .obs;

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return driverList.length;
    } else {
      return int.parse(data);
    }
  }

  Future<void> saveData() async {
    isLoading.value = true;
    int trueCount = 0;
    for (var element in verifyDocumentList) {
      updateVerifyStatus(element);
      if (element.isVerify == true) {
        trueCount++;
      }
    }

    driverUserDetails.update((val) {
      val!.isVerified = trueCount == verifyDocumentList.length;
      if (trueCount == verifyDocumentList.length) {
        if (driverUserDetails.value.driverVehicleDetails!.isVerified == true) {
          val.isVerified = true;
        } else {
          val.isVerified = false;
        }
      } else {
        val.isVerified = false;
      }
    });

    if (driverUserDetails.value.driverVehicleDetails!.isVerified == true) {
      trueCount++;
    }

    await FireStoreUtils.updateDriver(driverUserDetails.value);
    isLoading.value = false;
    ShowToast.successToast("Status Update".tr);
    // print('after changes${driverUserDetails.value.driverVehicleDetails!.isVerified} ');
  }

  Future<void> updateVerifyStatus(VerifyDocumentModel verifyDocumentModel) async {
    bool isSaved = await FireStoreUtils.updateVerifyDocuments(verifyDriverModel.value, verifyDriverModel.value.driverId.toString());
    if (isSaved) {
      await getData();
    }
  }

  Future<void> getDriverDetails(driverId) async {
    isLoadingVehicleDetails.value = true;
    final value = await FireStoreUtils.getDriverByDriverID(driverId.toString());
    if (value != null) {
      driverUserDetails.value = value;
      driverUserDetails.value.isVerified = verifyDocumentList.every((element) => element.isVerify == true);
    }
    isLoadingVehicleDetails.value = false;
  }
}
