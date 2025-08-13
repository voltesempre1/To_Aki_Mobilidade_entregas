// ignore_for_file: library_prefixes

import 'dart:developer' as developer;

import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/map_model.dart';
import 'package:driver/app/models/parcel_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map_math/flutter_geo_math.dart' as fmp;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;

class SearchRideController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isParcel = true.obs;
  RxBool isSearchInterCity = false.obs;
  RxBool isSearchParcelCity = false.obs;
  RxBool isFetchingDropLatLng = false.obs;

  Rx<DateTime?> selectedDate = DateTime.now().obs;
  Rx<DateTime?> selectedParcelDate = DateTime.now().obs;
  TextEditingController dropLocationController = TextEditingController();
  TextEditingController pickupLocationController = TextEditingController();

  gmaps.LatLng? sourceLocation;
  gmaps.LatLng? destination;
  Position? currentLocationPosition;
  Rx<MapModel?> mapModel = MapModel().obs;
  RxString intercityPickUpAddress = ''.obs;
  RxString intercityDropAddress = ''.obs;
  RxString parcelPickUpAddress = ''.obs;
  RxString parcelDropAddress = ''.obs;

  FocusNode pickUpFocusNode = FocusNode();
  FocusNode dropFocusNode = FocusNode();

  RxList<IntercityModel> intercityBookingList = <IntercityModel>[].obs;
  RxList<ParcelModel> parcelBookingList = <ParcelModel>[].obs;
  RxList<IntercityModel> searchIntercityList = <IntercityModel>[].obs;
  RxList<ParcelModel> searchParcelList = <ParcelModel>[].obs;

  @override
  Future<void> onInit() async {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = false;
  }

  Future<void> fetchNearestIntercityRide() async {
    try {
      isSearchInterCity.value = true;

      String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
      String pickupAddress = intercityPickUpAddress.value.trim();
      String dropAddress = intercityDropAddress.value.trim();

      List<IntercityModel> bookings = await FireStoreUtils.getNearestIntercityRide(sourceLocation, selectedDateStr);

      String normalizeAddress(String address) {
        return address.replaceAll(RegExp(r'\s+'), ' ').replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '').trim().toLowerCase();
      }

      searchIntercityList.assignAll(bookings.where((ride) {
        if (ride.startDate == null || ride.pickUpLocationAddress == null) return false;

        String rideDateStr = ride.startDate!.split('T')[0];
        bool dateMatches = selectedDateStr == rideDateStr;

        bool pickupMatches = normalizeAddress(ride.pickUpLocationAddress!) == normalizeAddress(pickupAddress);

        if (!dateMatches || ride.pickUpLocation == null) return false;

        if (dropAddress.isEmpty) {
          return dateMatches && pickupMatches;
        }

        if (ride.dropLocation == null) return false;

        bool dropMatches = normalizeAddress(ride.dropLocationAddress!) == normalizeAddress(dropAddress);

        latLng.LatLng point1 = latLng.LatLng(sourceLocation!.latitude, sourceLocation!.longitude);
        latLng.LatLng point2 = latLng.LatLng(destination!.latitude, destination!.longitude);
        latLng.LatLng rideMidPoint = fmp.FlutterMapMath.midpointBetween(point1, point2);

        double totalDistance = fmp.FlutterMapMath.distanceBetween(sourceLocation!.latitude, sourceLocation!.longitude, destination!.latitude, destination!.longitude, "meters");

        latLng.LatLng rideDrop = latLng.LatLng(
          ride.dropLocation!.latitude!,
          ride.dropLocation!.longitude!,
        );

        double distanceFromMid = fmp.FlutterMapMath.distanceBetween(
          rideDrop.latitude,
          rideDrop.longitude,
          rideMidPoint.latitude,
          rideMidPoint.longitude,
          "meters",
        );
        double radius = totalDistance / 2;

        bool isInRoute = distanceFromMid <= radius;

        return pickupMatches && (dropMatches || isInRoute);
      }).toList());
      isSearchInterCity.value = false;
      developer.log('-------------------> Filtered Intercity Bookings: ${searchIntercityList.length}');
    } catch (e) {
      developer.log('Error fetching nearest intercity rides: $e');
    }
  }

  Future<void> fetchNearestParcelRide() async {
    try {
      isSearchParcelCity.value = true;
      String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
      String pickupAddress = parcelPickUpAddress.value.trim();
      String dropAddress = parcelDropAddress.value.trim();

      List<ParcelModel> bookings = await FireStoreUtils.getNearestParcelRide(sourceLocation, selectedDateStr);

      String normalizeAddress(String address) {
        return address.replaceAll(RegExp(r'\s+'), ' ').replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '').trim().toLowerCase();
      }

      searchParcelList.assignAll(bookings.where((ride) {
        if (ride.startDate == null || ride.pickUpLocationAddress == null) return false;

        String rideDateStr = ride.startDate!.split('T')[0];
        bool dateMatches = selectedDateStr == rideDateStr;

        bool pickupMatches = normalizeAddress(ride.pickUpLocationAddress!) == normalizeAddress(pickupAddress);

        if (!dateMatches || ride.pickUpLocation == null) return false;

        if (dropAddress.isEmpty || destination == null) {
          return dateMatches && pickupMatches;
        }

        if (ride.dropLocation == null) return false;

        bool dropMatches = normalizeAddress(ride.dropLocationAddress!) == normalizeAddress(dropAddress);

        latLng.LatLng point1 = latLng.LatLng(sourceLocation!.latitude, sourceLocation!.longitude);
        latLng.LatLng point2 = latLng.LatLng(destination!.latitude, destination!.longitude);
        latLng.LatLng rideMidPoint = fmp.FlutterMapMath.midpointBetween(point1, point2);

        double totalDistance = fmp.FlutterMapMath.distanceBetween(sourceLocation!.latitude, sourceLocation!.longitude, destination!.latitude, destination!.longitude, "meters");

        latLng.LatLng rideDrop = latLng.LatLng(
          ride.dropLocation!.latitude!,
          ride.dropLocation!.longitude!,
        );

        double distanceFromMid = fmp.FlutterMapMath.distanceBetween(
          rideDrop.latitude,
          rideDrop.longitude,
          rideMidPoint.latitude,
          rideMidPoint.longitude,
          "meters",
        );

        // You can adjust radius threshold here
        double radius = totalDistance / 2;

        bool isInRoute = distanceFromMid <= radius;

        developer.log("Drop Matches :: $dropMatches, Is In Route :: $isInRoute,  Address :: ${ride.dropLocationAddress}");

        return pickupMatches && (dropMatches || isInRoute);
      }).toList());
      isSearchParcelCity.value = false;
      developer.log('-------------------> Filtered Parcel Bookings: ${searchParcelList.length}');
    } catch (e) {
      developer.log('Error fetching nearest Parcel rides: $e');
    }
  }
}
