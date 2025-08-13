// ignore_for_file: unnecessary_overrides
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';

class ReasonForCancelInterCityController extends GetxController {
  Rx<IntercityModel> interCityModel = IntercityModel().obs;
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

  Future<bool> cancelBooking(IntercityModel interCityModels) async {
    IntercityModel bookingInterCityModel = interCityModels;
    bookingInterCityModel.bookingStatus = BookingStatus.bookingRejected;
    bookingInterCityModel.cancelledBy = FireStoreUtils.getCurrentUid();
    bookingInterCityModel.driverId = FireStoreUtils.getCurrentUid();
    bookingInterCityModel.cancelledReason = reasons[selectedIndex.value] != "Other"
        ? reasons[selectedIndex.value].toString()
        : "${reasons[selectedIndex.value].toString()} : ${otherReasonController.value.text}";
    List rejectedId = bookingInterCityModel.rejectedDriverId ?? [];
    rejectedId.add(FireStoreUtils.getCurrentUid());
    bookingInterCityModel.rejectedDriverId = rejectedId;
    bookingInterCityModel.updateAt = Timestamp.now();
    bool? isCancelled = await FireStoreUtils.setInterCityBooking(bookingInterCityModel);
    sendCancelRideNotification(interCityModels);
    return (isCancelled);
  }

  Future<void> sendCancelRideNotification(IntercityModel interCityModels) async {
    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(interCityModels.customerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": interCityModels.id};
    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Intercity Ride Cancelled'.tr,
        body: 'Ride #${interCityModels.id.toString().substring(0, 5)} is Rejected by Driver',
        bookingId: interCityModels.id,
        driverId: interCityModels.driverId.toString(),
        customerId: receiverUserModel.id,
        senderId: FireStoreUtils.getCurrentUid(),
        payload: playLoad);
  }
}

