import 'dart:developer' as developer;
import 'dart:developer';

import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CabDetailController extends GetxController {
  RxString title = "Cab Detail".tr.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = true.obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  Future<void> getArgument() async {
    isLoading.value = true;
    try {
      String? bookingId = Get.parameters['bookingId']!;
      log("==============> Booking ID: $bookingId");
      await FireStoreUtils.getBookingByBookingId(bookingId).then((value) async {
        if (value != null) {
          bookingModel.value = value;

        }
        await FireStoreUtils.getDriverByDriverID(bookingModel.value.driverId.toString()).then((driver) {
          if (driver != null) {
            log("==============> Driver ID: ${bookingModel.value.driverId}");
            driverModel.value = driver;
          }
        });
        await FireStoreUtils.getUserByUserID(bookingModel.value.customerId.toString()).then((user) {
          if (user != null) {
            log("==============> Customer ID: ${bookingModel.value.driverId}");
            userModel.value = user;
          }
        });
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      developer.log("Error in getArgument: $e");
    }
  }

// Future<void> argumentsAndFetchData() async {
//   try {
//     final argumentData = Get.arguments;
//     if (argumentData == null || argumentData['bookingModel'] == null) {
//       Get.offAllNamed(Routes.ERROR_SCREEN);
//       return;
//     }
//     bookingModel.value = argumentData['bookingModel'];
//     final driver = await FireStoreUtils.getDriverByDriverID(bookingModel.value.driverId?.toString() ?? '');
//     if (driver != null) {
//       driverModel.value = driver;
//     }
//     final user = await FireStoreUtils.getUserByUserID(bookingModel.value.customerId?.toString() ?? '');
//     if (user != null) {
//       userModel.value = user;
//     }
//   } catch (e) {
//     Get.offAllNamed(Routes.ERROR_SCREEN);
//   } finally {
//     isLoading.value = false;
//   }
// }
}
