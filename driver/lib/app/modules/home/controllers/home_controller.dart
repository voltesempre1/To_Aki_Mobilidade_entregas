// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/app/models/positions_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  RxString profilePic = Constant.profileConstant.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxBool isOnline = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLocationLoading = false.obs;
  Rx<DriverUserModel> userModel = DriverUserModel().obs;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  RxInt drawerIndex = 0.obs;
  List<Color> colorList = [AppThemData.bookingNew, AppThemData.bookingOngoing, AppThemData.bookingCompleted, AppThemData.bookingRejected, AppThemData.bookingCancelled];
  RxMap<String, double> dataMap = <String, double>{
    "New": 0,
    "Ongoing": 0,
    "Completed": 0,
    "Rejected": 0,
    "Cancelled": 0,
  }.obs;
  RxList color = [AppThemData.secondary50, AppThemData.success50, AppThemData.danger50, AppThemData.info50].obs;
  RxList colorDark = [AppThemData.secondary950, AppThemData.success950, AppThemData.danger950, AppThemData.info950].obs;

  RxInt totalRides = 0.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    await getUserData();
    await getChartData();
    await updateCurrentLocation();
    isLoading.value = false;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getUserData() async {
    FireStoreUtils.fireStore.collection(CollectionName.drivers).doc(FireStoreUtils.getCurrentUid()).snapshots().listen(
      (event) async {
        if (event.exists) {
          userModel.value = DriverUserModel.fromJson(event.data()!);
          Constant.userModel = userModel.value;
          isOnline.value = userModel.value.isOnline ?? false;
          profilePic.value = (userModel.value.profilePic ?? "").isNotEmpty ? userModel.value.profilePic ?? Constant.profileConstant : Constant.profileConstant;
          name.value = userModel.value.fullName ?? '';
          phoneNumber.value = (userModel.value.countryCode ?? '') + (userModel.value.phoneNumber ?? '');

          if (userModel.value.bookingId != null && userModel.value.bookingId!.isNotEmpty) {
            FireStoreUtils.fireStore.collection(CollectionName.bookings).doc(userModel.value.bookingId).snapshots().listen(
              (event) async {
                if (event.exists) {
                  bookingModel.value = BookingModel.fromJson(event.data()!);
                }
              },
            );
          }else{
            bookingModel.value = BookingModel();
          }
          await checkActiveStatus();
          await getReviews();
          await getFcm();
        }
      },
    );
  }

  Future<void> getReviews() async {
    await FireStoreUtils.getReviewList(userModel.value).then((value) {
      if (value != null) {
        reviewList.addAll(value);
      }
    });
    log("=======> Get User Data");
  }

  Future<void> checkActiveStatus() async {
    if (userModel.value.isActive == false) {
      Get.defaultDialog(
          titlePadding: const EdgeInsets.only(top: 16),
          title: "Account Disabled",
          middleText: "Your account has been disabled. Please contact the administrator.",
          titleStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
          barrierDismissible: false,
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          });
    }
    // log("=======> Check Active Status");
  }

  Future<void> getChartData() async {
    // totalRides.value = int.parse((await FireStoreUtils.getTotalRide()).toString());
    int newRide = int.parse((await FireStoreUtils.getNewRide()).toString());
    int onGoingRide = int.parse((await FireStoreUtils.getOngoingRide()).toString());
    int completedRide = int.parse((await FireStoreUtils.getCompletedRide()).toString());
    int rejectedRide = int.parse((await FireStoreUtils.getRejectedRide()).toString());
    int cancelledRide = int.parse((await FireStoreUtils.getCancelledRide()).toString());
    // log(" +++++++++");
    totalRides.value = newRide + onGoingRide + completedRide + rejectedRide + cancelledRide;
    dataMap.value = {
      "New": newRide.toDouble(),
      "Ongoing": onGoingRide.toDouble(),
      "Completed": completedRide.toDouble(),
      "Rejected": rejectedRide.toDouble(),
      "Cancelled": cancelledRide.toDouble(),
    };
    // isLoading.value = false;
    log("=======> Get Chart Data");
  }

  Future<void> getFcm() async {
    final token = await NotificationService.getToken();

    if (userModel.value.id != null && userModel.value.id!.isNotEmpty && userModel.value.fcmToken != token) {
      userModel.value.fcmToken = token;
      await FireStoreUtils.updateDriverUser(userModel.value);
      log("FCM Token updated: $token");
    } else {
      log("Skipped FCM update - userModel not loaded or token unchanged");
    }
  }

  Location location = Location();

  Future<void> updateCurrentLocation() async {
    isLocationLoading.value = true;
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      location.enableBackgroundMode(enable: true);
      location.changeSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: double.parse(Constant.driverLocationUpdate.toString()),
        interval: 2000,
      );
      location.onLocationChanged.listen((locationData) async {
        log("------>");
        log(locationData.toString());
        Constant.currentLocation = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
        if (userModel.value.isOnline == true) {
          userModel.value.location = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
          GeoFirePoint position = GeoFlutterFire().point(latitude: locationData.latitude!, longitude: locationData.longitude!);
          userModel.value.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
          userModel.value.rotation = locationData.heading;
          await FireStoreUtils.updateDriverUser(userModel.value);
        }
        isLocationLoading.value = false;
        log("------>1");
      });
      log("------>2");
    } else {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        location.enableBackgroundMode(enable: true);
        location.changeSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: double.parse(Constant.driverLocationUpdate.toString()),
          interval: 2000,
        );
        location.onLocationChanged.listen((locationData) async {
          Constant.currentLocation = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
          if (userModel.value.isOnline == true) {
            userModel.value.location = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
            userModel.value.rotation = locationData.heading;
            GeoFirePoint position = GeoFlutterFire().point(latitude: locationData.latitude!, longitude: locationData.longitude!);
            userModel.value.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
            await FireStoreUtils.updateDriverUser(userModel.value);
          }
        });
      }
      isLocationLoading.value = false;
    }
    update();
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.drivers).doc(FireStoreUtils.getCurrentUid()).delete();

      FirebaseFirestore.instance.collection(CollectionName.verifyDriver).where("driverId", isEqualTo: FireStoreUtils.getCurrentUid()).get().then((snapshot) {
        for (DocumentSnapshot documentSnapshot in snapshot.docs) {
          documentSnapshot.reference.delete();
        }
      });
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuth Exception :: $e");
    } catch (error) {
      log("Error in delete user :: $error");
    }
  }
}
