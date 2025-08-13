// ignore_for_file: unnecessary_overrides
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/parcel_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';

class ReasonForCancelParcelController extends GetxController {
  Rx<ParcelModel> parcelModel = ParcelModel().obs;
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

  Future<bool> cancelBooking(ParcelModel parcelModels) async {
    ParcelModel bookingParcelModel = parcelModels;
    bookingParcelModel.bookingStatus = BookingStatus.bookingRejected;
    bookingParcelModel.cancelledBy = FireStoreUtils.getCurrentUid();
    bookingParcelModel.driverId = FireStoreUtils.getCurrentUid();
    bookingParcelModel.cancelledReason = reasons[selectedIndex.value] != "Other"
        ? reasons[selectedIndex.value].toString()
        : "${reasons[selectedIndex.value].toString()} : ${otherReasonController.value.text}";
    List rejectedId = bookingParcelModel.rejectedDriverId ?? [];
    rejectedId.add(FireStoreUtils.getCurrentUid());
    bookingParcelModel.rejectedDriverId = rejectedId;
    bookingParcelModel.updateAt = Timestamp.now();
    bool? isCancelled = await FireStoreUtils.setParcelBooking(bookingParcelModel);
    sendNotification(parcelModels);
    return (isCancelled);
  }

  Future<void> sendNotification(ParcelModel parcelModel) async {
    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(parcelModel.customerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": parcelModel.id};

    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Your Parcel Ride is Rejected',
        customerId: receiverUserModel.id,
        senderId: FireStoreUtils.getCurrentUid(),
        bookingId: parcelModel.id.toString(),
        driverId: parcelModel.driverId.toString(),
        body: 'Your ride #${parcelModel.id.toString().substring(0, 5)} has been Rejected by Driver.',
        // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
        payload: playLoad);
  }

  // sendCancelRideNotification() async {
  //   UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.value.customerId.toString());
  //   Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.value.id};
  //   await SendNotification.sendOneNotification(
  //       type: "order",
  //       token: receiverUserModel!.fcmToken.toString(),
  //       title: 'Ride Cancelled'.tr,
  //       body: 'Ride #${bookingModel.value.id.toString().substring(0, 4)} is Rejected by Driver',
  //       bookingId: bookingModel.value.id,
  //       driverId: bookingModel.value.driverId.toString(),
  //       customerId: receiverUserModel.id,
  //       senderId: FireStoreUtils.getCurrentUid(),
  //       payload: playLoad);
  // }
}
