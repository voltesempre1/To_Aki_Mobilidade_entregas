// ignore_for_file: unnecessary_overrides

import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterCityReasonForCancelController extends GetxController {
  Rx<IntercityModel> bookingModel = IntercityModel().obs;
  Rx<TextEditingController> otherReasonController = TextEditingController().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  void getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['interCityModel'];
    }
  }

  RxInt selectedIndex = 0.obs;

  List<dynamic> reasons = Constant.cancellationReason;

  Future<bool> cancelBooking(IntercityModel bookingModels) async {
    IntercityModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCancelled;
    bookingModel.cancelledBy = FireStoreUtils.getCurrentUid();
    bookingModel.cancelledReason = reasons[selectedIndex.value] != "Other" ? reasons[selectedIndex.value].toString() : "${reasons[selectedIndex.value]} : ${otherReasonController.value.text}";
    final isCancelled = await FireStoreUtils.setInterCityBooking(bookingModel);
    return isCancelled ?? false;
  }

  Future<void> sendCancelRideNotification() async {
    final receiverUserModel = await FireStoreUtils.getDriverUserProfile(bookingModel.value.driverId.toString());
    if (receiverUserModel == null) return;
    final playLoad = {"bookingId": bookingModel.value.id};
    await SendNotification.sendOneNotification(
      type: "order",
      token: receiverUserModel.fcmToken.toString(),
      title: 'Ride Cancelled'.tr,
      body: 'Ride #${bookingModel.value.id.toString().substring(0, 5)} is cancelled by Customer',
      bookingId: bookingModel.value.id,
      driverId: bookingModel.value.driverId.toString(),
      senderId: FireStoreUtils.getCurrentUid(),
      payload: playLoad,
    );
  }
}
