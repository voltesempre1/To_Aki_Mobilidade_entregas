// ignore_for_file: unnecessary_overrides
import 'dart:developer';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/parcel_model.dart';
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

class ParcelBookingDetailsController extends GetxController {
  RxString bookingId = ''.obs;
  Rx<ParcelModel> parcelModel = ParcelModel().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  TextEditingController enterBidAmountController = TextEditingController();
  RxBool isLoading = true.obs;
  RxBool isSearch = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBookingDetails();
  }

  // getBookingDetails() async {
  //
  //   if (Get.arguments != null && Get.arguments["interCityModel"] != null) {
  //     bookingId.value = Get.arguments["interCityModel"];
  //   }
  //  await FireStoreUtils.getInterCityRideDetails(bookingId.value).listen((IntercityModel? model) {
  //     interCityModel.value = model ?? IntercityModel(); // Updates UI automatically with GetX
  //   });
  //
  //   isLoading.value = false;
  //
  // }

  Future<void> getBookingDetails() async {
    isLoading.value = true;
    final args = Get.arguments;
    if (args != null && args["bookingId"] != null) {
      bookingId.value = args["bookingId"];
      isSearch.value = args["isSearch"] ?? false;
      log('=-==============> is search  parcel view of \\${isSearch.value}');
      try {
        FireStoreUtils.getParcelRideDetails(bookingId.value).listen((ParcelModel? model) {
          if (model != null) {
            parcelModel.value = model;
          } else {
            log("⚠️ No booking details found for ID: \\${bookingId.value}");
          }
          isLoading.value = false;
        });
      } catch (error) {
        log(" Error fetching booking details: $error");
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<bool> completeBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCompleted;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.dropTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setBooking(bookingModel);
    ShowToastDialog.showToast("Your ride is completed....".tr);

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

  Future<bool> completeInterCityBooking(ParcelModel bookingModels) async {
    ParcelModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCompleted;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.dropTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setParcelBooking(bookingModel);
    ShowToastDialog.showToast("Your parcel ride is completed....".tr);

    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};

    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Your Parcel Ride is Completed',
        customerId: receiverUserModel.id,
        senderId: FireStoreUtils.getCurrentUid(),
        bookingId: bookingModel.id.toString(),
        driverId: bookingModel.driverId.toString(),
        body: 'Your parcel ride has been successfully completed. Please take a moment to review your experience.',
        payload: playLoad);

    // Get.offAll(const HomeView());
    return (isStarted);
  }

  Future<void> saveBidDetail() async {
    ShowToastDialog.showLoader('Please Wait'.tr);
    BidModel bidModel = BidModel();
    bidModel.driverID = FireStoreUtils.getCurrentUid();
    bidModel.bidStatus = 'pending';
    bidModel.amount = enterBidAmountController.value.text;
    bidModel.id = Constant.getUuid();
    bidModel.createAt = Timestamp.now();
    // bidModel.driverVehicleDetails = Constant.userModel!.driverVehicleDetails;
    parcelModel.value.driverBidIdList!.add(FireStoreUtils.getCurrentUid());
    parcelModel.value.bidList!.add(bidModel);

    await FireStoreUtils.setParcelBooking(parcelModel.value);

    if (isSearch.value == true) {
      SearchRideController searchController = Get.put(SearchRideController());
      searchController.searchParcelList.removeWhere((parcel) => parcel.id == parcelModel.value.id);
      searchController.parcelBookingList.removeWhere((parcel) => parcel.id == parcelModel.value.id);
      ShowToastDialog.closeLoader();
    }
  }
}
