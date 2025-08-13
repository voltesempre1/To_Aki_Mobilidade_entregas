// ignore_for_file: unnecessary_overrides

// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/map_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingDetailsController extends GetxController {
  Rx<BookingModel> bookingModel = BookingModel().obs;

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  void getArguments() {
    if (Get.arguments != null) {
      bookingModel.value = Get.arguments['bookingModel'];
      getBookingDetails();
    }
  }

  Future<void> getBookingDetails() async {
    FireStoreUtils.fireStore.collection(CollectionName.bookings).doc(bookingModel.value.id).snapshots().listen((value) {
      if (value.exists) {
        bookingModel.value = BookingModel.fromJson(value.data()!);
        update();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<String> getDistanceInKm() async {
    String km = '';
    LatLng departureLatLong = LatLng(bookingModel.value.pickUpLocation!.latitude ?? 0.0, bookingModel.value.pickUpLocation!.longitude ?? 0.0);
    LatLng destinationLatLong = LatLng(bookingModel.value.dropLocation!.latitude ?? 0.0, bookingModel.value.dropLocation!.longitude ?? 0.0);
    MapModel? mapModel = await Constant.getDurationDistance(departureLatLong, destinationLatLong);
    if (mapModel != null) {
      km = mapModel.rows!.first.elements!.first.distance!.text!;
    }
    return km;
  }

  Future<bool> completeBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCompleted;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.dropTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setBooking(bookingModel);
    ShowToastDialog.showToast("Your ride is completed....");

    // Fetch user profile and send notification only if booking update succeeded
    if (isStarted == true) {
      UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
      if (receiverUserModel != null && receiverUserModel.fcmToken != null && receiverUserModel.fcmToken!.isNotEmpty) {
        Map<String, dynamic> playLoad = {"bookingId": bookingModel.id};
        await SendNotification.sendOneNotification(
          type: "order",
          token: receiverUserModel.fcmToken!,
          title: 'Your Ride is Completed',
          customerId: receiverUserModel.id,
          senderId: FireStoreUtils.getCurrentUid(),
          bookingId: bookingModel.id.toString(),
          driverId: bookingModel.driverId.toString(),
          body: 'Your ride has been successfully completed. Please take a moment to review your experience.',
          payload: playLoad,
        );
      }
    }
    return isStarted;
  }
}
