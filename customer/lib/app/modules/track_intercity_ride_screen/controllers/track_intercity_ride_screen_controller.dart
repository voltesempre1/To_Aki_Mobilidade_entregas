// ignore_for_file: deprecated_member_use

import 'dart:developer';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackInterCityRideScreenController extends GetxController {
  GoogleMapController? mapController;

  @override
  void onInit() {
    addMarkerSetup();
    getArgument();
    // playSound();
    super.onInit();
  }

  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  Rx<IntercityModel> bookingModel = IntercityModel().obs;

  RxBool isLoading = true.obs;
  RxString type = "".obs;

  LatLng? lastDriverLocation;
  String? lastBookingStatus;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];

      log("---------------------------> ${bookingModel.value.toJson()}");
      FirebaseFirestore.instance.collection(CollectionName.bookings).doc(bookingModel.value.id).snapshots().listen((bookingEvent) {
        if (bookingEvent.data() != null) {
          log("---------------------------> Booking data received");
          IntercityModel updatedBooking = IntercityModel.fromJson(bookingEvent.data()!);
          bookingModel.value = updatedBooking;

          FirebaseFirestore.instance
              .collection(CollectionName.drivers)
              .doc(bookingModel.value.driverId)
              .snapshots()
              .distinct((prev, next) => prev.data()?['location'] == next.data()?['location'])
              .listen((driverEvent) {
            if (driverEvent.data() != null) {
              DriverUserModel updatedDriver = DriverUserModel.fromJson(driverEvent.data()!);
              driverUserModel.value = updatedDriver;
              log("Driver Model :: ${updatedDriver.toJson()}");

              bool shouldUpdatePolyline = false;

              // Check if driver location changed significantly
              if (lastDriverLocation == null ||
                  lastDriverLocation!.latitude != updatedDriver.location!.latitude ||
                  lastDriverLocation!.longitude != updatedDriver.location!.longitude ||
                  lastBookingStatus != bookingModel.value.bookingStatus) {
                shouldUpdatePolyline = true;
                // Move camera to driver's new location with higher zoom
                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(updatedDriver.location!.latitude!, updatedDriver.location!.longitude!),
                    20.0, // Increased zoom for closer view
                  ),
                );
              }

              lastDriverLocation = LatLng(updatedDriver.location!.latitude!, updatedDriver.location!.longitude!);
              lastBookingStatus = bookingModel.value.bookingStatus.toString();

              log("---------------------------> 5");
              if (shouldUpdatePolyline) {
                if (bookingModel.value.bookingStatus == BookingStatus.bookingOngoing) {
                  log("---------------------------> 6");
                  getPolyline(
                    sourceLatitude: updatedDriver.location!.latitude,
                    sourceLongitude: updatedDriver.location!.longitude,
                    destinationLatitude: bookingModel.value.dropLocation!.latitude,
                    destinationLongitude: bookingModel.value.dropLocation!.longitude,
                  );
                } else {
                  log("---------------------------> 7");
                  getPolyline(
                    sourceLatitude: updatedDriver.location!.latitude,
                    sourceLongitude: updatedDriver.location!.longitude,
                    destinationLatitude: bookingModel.value.pickUpLocation!.latitude,
                    destinationLongitude: bookingModel.value.pickUpLocation!.longitude,
                  );
                }
              }
            }
          });

          if (updatedBooking.bookingStatus == BookingStatus.bookingCompleted) {
            log("---------------------------> 9");
            Get.back();
          }
        }
      });
    }
    isLoading.value = false;
    update();
  }

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  void getPolyline({required double? sourceLatitude, required double? sourceLongitude, required double? destinationLatitude, required double? destinationLongitude}) async {
    if (sourceLatitude != null && sourceLongitude != null && destinationLatitude != null && destinationLongitude != null) {
      List<LatLng> polylineCoordinates = [];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Constant.mapAPIKey,
        request: PolylineRequest(
          origin: PointLatLng(sourceLatitude, sourceLongitude),
          destination: PointLatLng(destinationLatitude, destinationLongitude),
          mode: TravelMode.driving,
          // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        log(result.errorMessage.toString());
      }

      // Only add the driver marker, comment out pickup and drop-off markers
      addMarker(
          latitude: bookingModel.value.pickUpLocation!.latitude,
          longitude: bookingModel.value.pickUpLocation!.longitude,
          id: "Departure",
          descriptor: departureIcon!,
          rotation: 0.0);
      addMarker(
          latitude: bookingModel.value.dropLocation!.latitude,
          longitude: bookingModel.value.dropLocation!.longitude,
          id: "Destination",
          descriptor: destinationIcon!,
          rotation: 0.0);
      addMarker(
          latitude: driverUserModel.value.location!.latitude,
          longitude: driverUserModel.value.location!.longitude,
          id: "Driver",
          descriptor: driverIcon!,
          rotation: driverUserModel.value.rotation);

      _addPolyLine(polylineCoordinates);
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  void addMarker({required double? latitude, required double? longitude, required String id, required BitmapDescriptor descriptor, required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: LatLng(latitude ?? 0.0, longitude ?? 0.0), rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  Future<void> addMarkerSetup() async {
    final Uint8List departure = await Constant().getBytesFromAsset('assets/icon/ic_pick_up_map.png', 100);
    final Uint8List destination = await Constant().getBytesFromAsset('assets/icon/ic_drop_in_map.png', 100);
    final Uint8List driver = await Constant().getBytesFromAsset('assets/icon/ic_car.png', 50);
    departureIcon = BitmapDescriptor.fromBytes(departure);
    destinationIcon = BitmapDescriptor.fromBytes(destination);
    driverIcon = BitmapDescriptor.fromBytes(driver);
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  void _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, points: polylineCoordinates, consumeTapEvents: true, startCap: Cap.roundCap, width: 6, color: AppThemData.primary500);
    polyLines[id] = polyline;
    // Focus camera only on driver icon (latest location) with higher zoom
    if (driverUserModel.value.location != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(driverUserModel.value.location!.latitude!, driverUserModel.value.location!.longitude!),
          20.0, // Increased zoom for closer view
        ),
      );
    }
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: LatLng(source.latitude, destination.longitude), northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(southwest: LatLng(destination.latitude, source.longitude), northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 60);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    try {
      // Smoothly animate camera to the new bounds (no zoom in/out flicker)
      await mapController.animateCamera(cameraUpdate);
    } catch (e) {
      if (kDebugMode) {
        print('Error in checkCameraLocation: $e');
      }
    }
  }
}
