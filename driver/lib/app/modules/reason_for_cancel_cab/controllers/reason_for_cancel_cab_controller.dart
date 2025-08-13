// ignore_for_file: unnecessary_overrides
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';

class ReasonForCancelCabController extends GetxController {
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<TextEditingController> otherReasonController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxInt selectedIndex = 0.obs;

  List<dynamic> reasons = Constant.cancellationReason;

  Future<bool> cancelBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingRejected;
    bookingModel.cancelledBy = FireStoreUtils.getCurrentUid();
    bookingModel.driverId = FireStoreUtils.getCurrentUid();
    bookingModel.cancelledReason = reasons[selectedIndex.value] != "Other" ? reasons[selectedIndex.value] : otherReasonController.value.text.trim();
    bookingModel.updateAt = Timestamp.now();
    bool result = await FireStoreUtils.setBooking(bookingModel);
    return result;
  }
}
