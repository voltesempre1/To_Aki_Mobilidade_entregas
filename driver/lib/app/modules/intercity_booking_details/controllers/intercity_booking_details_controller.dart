// ignore_for_file: unnecessary_overrides
import 'dart:developer';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/modules/search_intercity_ride/controllers/search_ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';

class InterCityBookingDetailsController extends GetxController {
  RxString bookingId = ''.obs;
  Rx<IntercityModel> interCityModel = IntercityModel().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  TextEditingController enterBidAmountController = TextEditingController();
  RxBool isLoading = true.obs;
  RxBool isSearch = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBookingDetails();
  }

  Future<void> getBookingDetails() async {
    isLoading.value = true;
    if (Get.arguments != null) {
      if (Get.arguments["bookingId"] != null) {
        bookingId.value = Get.arguments["bookingId"];
        isSearch.value = Get.arguments["isSearch"] ?? false;
      }
    }

    try {
      FireStoreUtils.getInterCityRideDetails(bookingId.value).listen((IntercityModel? model) {
        if (model != null) {
          interCityModel.value = model;
        } else {
          log("⚠️ No booking details found for ID: ${bookingId.value}");
        }
        isLoading.value = false;
      });
    } catch (error) {
      log(" Error fetching booking details: $error");
      isLoading.value = false;
    }
  }

  Future<bool> completeBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCompleted;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.dropTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setBooking(bookingModel);
    ShowToastDialog.showToast("Your ride is completed....");

    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};

    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Your Ride is Completed',
        customerId: receiverUserModel.id,
        senderId: FireStoreUtils.getCurrentUid(),
        bookingId: bookingModel.id.toString(),
        driverId: bookingModel.driverId.toString(),
        body: 'Your ride has been successfully completed. Please take a moment to review your experience.',
        payload: playLoad);

    // Get.offAll(const HomeView());
    return (isStarted);
  }

  Future<bool> completeInterCityBooking(IntercityModel bookingModels) async {
    IntercityModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCompleted;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.dropTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setInterCityBooking(bookingModel);
    ShowToastDialog.showToast("Your ride is completed....".tr);

    if (isStarted == true) {
      UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
      if (receiverUserModel != null && receiverUserModel.fcmToken != null && receiverUserModel.fcmToken!.isNotEmpty) {
        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};
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

  Future<void> saveBidDetail() async {
    ShowToastDialog.showLoader('Please Wait'.tr);

    BidModel bidModel = BidModel();

    bidModel.driverID = FireStoreUtils.getCurrentUid();
    bidModel.bidStatus = 'pending';
    bidModel.amount = enterBidAmountController.value.text;
    bidModel.id = Constant.getUuid();
    bidModel.createAt = Timestamp.now();
    interCityModel.value.driverBidIdList!.add(FireStoreUtils.getCurrentUid());
    interCityModel.value.bidList!.add(bidModel);

    await FireStoreUtils.setInterCityBooking(interCityModel.value);

    if (isSearch.value == true) {
      SearchRideController searchController = Get.put(SearchRideController());
      searchController.searchIntercityList.removeWhere((parcel) => parcel.id == interCityModel.value.id);
      searchController.intercityBookingList.removeWhere((parcel) => parcel.id == interCityModel.value.id);
      ShowToastDialog.closeLoader();
    }

    ShowToastDialog.closeLoader();
  }
}
