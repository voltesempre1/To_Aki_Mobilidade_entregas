// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:developer';

import 'package:customer/constant_widgets/place_picker/selected_location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class LocationController extends GetxController {
  GoogleMapController? mapController;
  var selectedLocation = Rxn<LatLng>();
  var selectedPlaceAddress = Rxn<Placemark>();
  var address = "Move the map to select a location".obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    searchController.addListener(() {
      // Only reset to current location, do not trigger any API or prediction fetch
      if (searchController.text.trim().isEmpty) {
        // Optionally reset the selected location/address
        getCurrentLocation();
      }
    });
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    selectedLocation.value = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLocation.value!, zoom: 15),
      ),
    );

    getAddressFromLatLng(selectedLocation.value!);
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        selectedPlaceAddress.value = place;
        address.value = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onMapMoved(CameraPosition position) {
    selectedLocation.value = position.target;
  }

  void confirmLocation() {
    if (selectedLocation.value != null) {
      SelectedLocationModel selectedLocationModel = SelectedLocationModel(address: selectedPlaceAddress.value, latLng: selectedLocation.value);
      log("Selected location model: ${selectedLocationModel.toJson()}");
      Get.back(result: selectedLocationModel);
    }
  }

  void moveCameraTo(LatLng target) {
    selectedLocation.value = target;
    mapController?.animateCamera(CameraUpdate.newLatLng(target));
    getAddressFromLatLng(target);
  }
}
