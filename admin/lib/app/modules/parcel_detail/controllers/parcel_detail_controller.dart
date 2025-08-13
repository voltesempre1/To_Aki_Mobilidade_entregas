import 'dart:developer';

import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/parcel_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ParcelDetailController extends GetxController {
  RxString title = "Parcel Detail".tr.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = true.obs;
  Rx<ParcelModel> parcelModel = ParcelModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  // BitmapDescriptor? pickUpIcon;
  // BitmapDescriptor? dropIcon;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      String parcelId = Get.parameters['parcelId']!;

      log("==============> Parcel ID: $parcelId");

      await FireStoreUtils.getParcelBookingById(parcelId).then((value) async {
        if (value != null) {
          parcelModel.value = value;
        }
      });

      await FireStoreUtils.getDriverByDriverID(parcelModel.value.driverId?.toString() ?? '').then((driver) {
        if (driver != null) {
          log("==============> Driver ID: ${parcelModel.value.driverId}");
          driverModel.value = driver;
        }
      });

      await FireStoreUtils.getUserByUserID(parcelModel.value.customerId?.toString() ?? '').then((user) {
        if (user != null) {
          log("==============> Customer ID: ${parcelModel.value.customerId}");
          userModel.value = user;
        }
      });


    } catch (e) {
      // Optionally log error
      Get.offAllNamed(Routes.ERROR_SCREEN);
    } finally {
      isLoading.value = false;
    }
  }
}
