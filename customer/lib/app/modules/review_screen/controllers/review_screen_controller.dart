import 'dart:developer';

import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/app/models/parcel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/review_customer_model.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/utils/fire_store_utils.dart';

class ReviewScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxDouble rating = 0.0.obs;
  Rx<TextEditingController> commentController = TextEditingController().obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<IntercityModel> intercityModel = IntercityModel().obs;
  Rx<ParcelModel> parcelModel = ParcelModel().obs;
  RxString driverId = ''.obs;
  RxString bookingId = ''.obs;


  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bool isIntercity = argumentData["isIntercity"] ?? false;
      bool isParcel = argumentData["isParcel"] ?? false;


      if (isIntercity) {
        intercityModel.value = argumentData["bookingModel"];
        driverId.value = intercityModel.value.driverId!;
        bookingId.value = intercityModel.value.id!;
        log('======= Intercity Booking: driverId=$driverId, bookingId=$bookingId');
      } else if (isParcel) {
        parcelModel.value = argumentData["bookingModel"];
        driverId.value = parcelModel.value.driverId!;
        bookingId.value = parcelModel.value.id!;
        log('======= Parcel Booking: driverId=$driverId, bookingId=$bookingId');
      } else {
        bookingModel.value = argumentData["bookingModel"];
        driverId.value = bookingModel.value.driverId!;
        bookingId.value = bookingModel.value.id!;
        log('======= Normal Booking: driverId=$driverId, bookingId=$bookingId');
      }
    }

    log("----->1");
    await FireStoreUtils.getDriverUserProfile(driverId.value.toString()).then((value) {
      if (value != null) {
        log("----->2");
        driverModel.value = value;
      }
    });
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        log("----->3");
        userModel.value = value;
      }
    });
    await FireStoreUtils.getReview(bookingId.value.toString()).then((value) {
      if (value != null) {
        log("----->4");
        reviewModel.value = value;
        rating.value = double.parse(reviewModel.value.rating.toString());
        commentController.value.text = reviewModel.value.comment.toString();
      }
    });
    isLoading.value = false;
    update();
  }
}
