import 'dart:developer';

import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/intercity_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class InterCityDetailController extends GetxController {
  RxString title = "Intercity Detail".tr.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = true.obs;
  Rx<IntercityModel> interCityModel = IntercityModel().obs;
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
      String intercityId = Get.parameters['intercityId']!;
      log("==============> Intercity ID: $intercityId");

      await FireStoreUtils.getInterCityBookingById(intercityId).then((value) async {
        if (value != null) {
          interCityModel.value = value;
        }
      });

      await FireStoreUtils.getDriverByDriverID(interCityModel.value.driverId?.toString() ?? '').then((driver) {
        if (driver != null) {
          log("==============> Driver ID: ${interCityModel.value.driverId}");
          driverModel.value = driver;
        }
      });

      await FireStoreUtils.getUserByUserID(interCityModel.value.customerId?.toString() ?? '').then((user) {
        if (user != null) {
          log("==============> Customer ID: ${interCityModel.value.customerId}");
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
