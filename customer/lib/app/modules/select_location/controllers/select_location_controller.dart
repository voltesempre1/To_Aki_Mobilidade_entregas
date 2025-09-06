// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/cab_time_slots_charges_model.dart';
import 'package:customer/app/models/coupon_model.dart';
import 'package:customer/app/models/distance_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/map_model.dart';
import 'package:customer/app/models/positions.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/place_picker/selected_location_model.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/services/recent_location_search.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class SelectLocationController extends GetxController {
  FocusNode pickUpFocusNode = FocusNode();
  FocusNode dropFocusNode = FocusNode();
  TextEditingController dropLocationController = TextEditingController();
  TextEditingController pickupLocationController = TextEditingController(text: 'Current Location');
  LatLng? sourceLocation;
  LatLng? destination;
  Position? currentLocationPosition;
  GoogleMapController? mapController;
  RxBool isLoading = true.obs;
  RxInt popupIndex = 0.obs;
  RxInt selectVehicleTypeIndex = 0.obs;
  Rx<MapModel?> mapModel = MapModel().obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<DistanceModel> distanceOfKm = DistanceModel().obs;

  // RxDouble estimatePrice = 0.0.obs;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  RxString selectedPaymentMethod = 'Cash'.obs;
  RxString couponCode = "Enter coupon code".obs;
  RxBool isCouponCode = false.obs;
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;
  RxList<TaxModel> taxList = (Constant.taxList ?? []).obs;

  RxList<SelectedLocationModel> recentSearches = <SelectedLocationModel>[].obs;

  void changeVehicleType(int index) {
    // CabTimeSlotModel? selectedCab;
    bool isCabAvailable = false;
    selectVehicleTypeIndex.value = index;
    bookingModel.value.vehicleType = Constant.vehicleTypeList![index];
    isCabAvailable = Constant.cabTimeSlotList.any(
      (cab) => cab.id == bookingModel.value.vehicleType!.id,
    );

    if (isCabAvailable == true) {
      // updateCalculation(bookingModel.value.vehicleType!.id.toString());
      double finalPrice = updateCalculation(bookingModel.value.vehicleType!.id);
      bookingModel.value.subTotal = finalPrice.toString();
    } else {
      bookingModel.value.subTotal =
          amountShow(Constant.vehicleTypeList![selectVehicleTypeIndex.value], mapModel.value!);
    }
    if (bookingModel.value.coupon != null) {
      bookingModel.value.discount = applyCoupon().toString();
    }
    bookingModel.value = BookingModel.fromJson(bookingModel.value.toJson());
  }

  @override
  void onInit() {
    super.onInit();
    Constant.checkAndLoadGoogleMapAPIKey().then((_) {
      getData();
      getRecentSearches();
    });

    pickupLocationController.addListener(() {
      getRecentSearches();
      update();
    });
    dropLocationController.addListener(() {
      getRecentSearches();
      update();
    });
  }

  Future<void> getRecentSearches() async {
    recentSearches.value = await RecentSearchLocation.getLocationFromHistory();
    log("Recent Searches Count: ${recentSearches.length}");
  }

  Future<void> getTax() async {
    await FireStoreUtils().getTaxList().then((value) {
      if (value != null) {
        Constant.taxList = value;
        taxList.value = value;
      }
    });
  }

  Future<void> getData() async {
    currentLocationPosition = await Utils.getCurrentLocation();
    Constant.country =
        (await placemarkFromCoordinates(currentLocationPosition!.latitude, currentLocationPosition!.longitude))[0]
                .country ??
            'Unknown';
    getTax();
    sourceLocation = LatLng(currentLocationPosition!.latitude, currentLocationPosition!.longitude);
    await addMarkerSetup();
    if (destination != null && sourceLocation != null) {
      getPolyline(
          sourceLatitude: sourceLocation!.latitude,
          sourceLongitude: sourceLocation!.longitude,
          destinationLatitude: destination!.latitude,
          destinationLongitude: destination!.longitude);
    } else {
      if (destination != null) {
        addMarker(
            latitude: destination!.latitude,
            longitude: destination!.longitude,
            id: "drop",
            descriptor: dropIcon!,
            rotation: 0.0);
        updateCameraLocation(destination!, destination!, mapController);
      } else {
        MarkerId markerId = const MarkerId("drop");
        if (markers.containsKey(markerId)) {
          markers.removeWhere((key, value) => key == markerId);
        }
        log("==> ${markers.containsKey(markerId)}");
      }
      if (sourceLocation != null) {
        addMarker(
            latitude: sourceLocation!.latitude,
            longitude: sourceLocation!.longitude,
            id: "pickUp",
            descriptor: pickUpIcon!,
            rotation: 0.0);
        updateCameraLocation(sourceLocation!, sourceLocation!, mapController);
      } else {
        MarkerId markerId = const MarkerId("pickUp");
        if (markers.containsKey(markerId)) {
          markers.removeWhere((key, value) => key == markerId);
          updateCameraLocation(sourceLocation!, sourceLocation!, mapController);
        }
        log("==> ${markers.containsKey(markerId)}");
      }
    }
    dropFocusNode.requestFocus();
    isLoading.value = false;
  }

  void setBookingData(bool isClear) {
    if (isClear) {
      bookingModel.value = BookingModel();
    } else {
      bookingModel.value.customerId = FireStoreUtils.getCurrentUid();
      bookingModel.value.bookingStatus = BookingStatus.bookingPlaced;
      bookingModel.value.pickUpLocation =
          LocationLatLng(latitude: sourceLocation!.latitude, longitude: sourceLocation!.longitude);
      bookingModel.value.dropLocation =
          LocationLatLng(latitude: destination!.latitude, longitude: destination!.longitude);
      GeoFirePoint position =
          GeoFlutterFire().point(latitude: sourceLocation!.latitude, longitude: sourceLocation!.longitude);

      bookingModel.value.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);

      bookingModel.value.distance = DistanceModel(
        distance: distanceCalculate(mapModel.value),
        distanceType: Constant.distanceType,
      );
      bookingModel.value.vehicleType = Constant.vehicleTypeList![selectVehicleTypeIndex.value];

      bool isCabAvailable = Constant.cabTimeSlotList.any(
        (cab) => cab.id == (Constant.vehicleTypeList![selectVehicleTypeIndex.value]).id,
      );
      if (isCabAvailable == true) {
        double finalPrice = updateCalculation(bookingModel.value.vehicleType!.id);

        bookingModel.value.subTotal = finalPrice.toString();
      } else {
        bookingModel.value.subTotal =
            amountShow(Constant.vehicleTypeList![selectVehicleTypeIndex.value], mapModel.value!);
      }
      bookingModel.value.otp = Constant.getOTPCode();
      bookingModel.value.paymentType = Constant.paymentModel!.cash!.name;
      bookingModel.value.paymentStatus = false;
      bookingModel.value.taxList = taxList;
      bookingModel.value.adminCommission = Constant.adminCommission!;
      bookingModel.value = BookingModel.fromJson(bookingModel.value.toJson());
    }
  }

  Future<void> updateData() async {
    if (destination != null && sourceLocation != null) {
      getPolyline(
          sourceLatitude: sourceLocation!.latitude,
          sourceLongitude: sourceLocation!.longitude,
          destinationLatitude: destination!.latitude,
          destinationLongitude: destination!.longitude);
      ShowToastDialog.showLoader("Aguarde por favor".tr);
      
      // Verificar se a chave da API está vazia antes de fazer a chamada
      if (Constant.mapAPIKey.isEmpty) {
        await Constant.checkAndLoadGoogleMapAPIKey();
        if (Constant.mapAPIKey.isEmpty) {
          ShowToastDialog.closeLoader();
          ShowToastDialog.showToast("Erro ao carregar a chave da API do Google Maps. Por favor, tente novamente mais tarde.");
          return;
        }
      }
      
      try {
        mapModel.value = await Constant.getDurationDistance(sourceLocation!, destination!);
        
        if (mapModel.value == null || 
            mapModel.value!.destinationAddresses == null || 
            mapModel.value!.originAddresses == null || 
            mapModel.value!.destinationAddresses!.isEmpty || 
            mapModel.value!.originAddresses!.isEmpty) {
          ShowToastDialog.closeLoader();
          popupIndex.value = 0;
          ShowToastDialog.showToast("Erro ao obter informações de rota. Por favor, tente novamente.");
          return;
        }
        
        bookingModel.value.dropLocationAddress = mapModel.value!.destinationAddresses!.first;
        bookingModel.value.pickUpLocationAddress = mapModel.value!.originAddresses!.first;
        bookingModel.value = BookingModel.fromJson(bookingModel.value.toJson());

        distanceOfKm.value = DistanceModel(
          distance: distanceCalculate(mapModel.value),
          distanceType: Constant.distanceType,
        );

        ShowToastDialog.closeLoader();
        log("Data : ${mapModel.value!.toJson()}");
        
        if (sourceLocation != null && destination != null) {
          if (popupIndex.value == 0) popupIndex.value = 1;
          setBookingData(false);
        } else {
          ShowToastDialog.showToast(
              sourceLocation == null ? "Por favor, selecione o local de partida" : "Por favor, selecione o destino");
        }
      } catch (e) {
        ShowToastDialog.closeLoader();
        log("Erro ao processar dados do mapa: $e");
        popupIndex.value = 0;
        ShowToastDialog.showToast("Algo deu errado! Por favor, selecione o local novamente.");
      }
    } else {
      if (destination != null) {
        addMarker(
            latitude: destination!.latitude,
            longitude: destination!.longitude,
            id: "drop",
            descriptor: dropIcon!,
            rotation: 0.0);
        updateCameraLocation(destination!, destination!, mapController);
      } else {
        MarkerId markerId = const MarkerId("drop");
        if (markers.containsKey(markerId)) {
          markers.removeWhere((key, value) => key == markerId);
          updateCameraLocation(LatLng(currentLocationPosition!.latitude, currentLocationPosition!.longitude),
              LatLng(currentLocationPosition!.latitude, currentLocationPosition!.longitude), mapController);
        }
        log("==> ${markers.containsKey(markerId)}");
      }
      if (sourceLocation != null) {
        addMarker(
            latitude: sourceLocation!.latitude,
            longitude: sourceLocation!.longitude,
            id: "pickUp",
            descriptor: pickUpIcon!,
            rotation: 0.0);
        updateCameraLocation(sourceLocation!, sourceLocation!, mapController);
      } else {
        MarkerId markerId = const MarkerId("pickUp");
        if (markers.containsKey(markerId)) {
          markers.removeWhere((key, value) => key == markerId);
          updateCameraLocation(LatLng(currentLocationPosition!.latitude, currentLocationPosition!.longitude),
              LatLng(currentLocationPosition!.latitude, currentLocationPosition!.longitude), mapController);
        }
        log("==> ${markers.containsKey(markerId)}");
      }
    }
  }

  double updateCalculation(String vehicleTypeId) {
    double calculatedEstimatePrice = 0.0;

    CabTimeSlotsChargesModel? intercityModel = calculationOfEstimatePrice(vehicleTypeId);

    if (intercityModel != null) {
      if (double.parse(distanceOfKm.value.distance!) < double.parse(intercityModel.fareMinimumChargesWithinKm)) {
        calculatedEstimatePrice = double.parse(intercityModel.farMinimumCharges);
      } else {
        calculatedEstimatePrice = double.parse(
          (double.parse(intercityModel.farePerKm) * double.parse(distanceOfKm.value.distance!)).toStringAsFixed(2),
        );
      }
    } else {
      log("----------------> No matching time slot found.");
    }

    return calculatedEstimatePrice;
  }

  RxList<CabTimeSlotsChargesModel> cabTimeSlotList = <CabTimeSlotsChargesModel>[].obs;

  CabTimeSlotsChargesModel? calculationOfEstimatePrice(String vehicleTypeId) {
    dynamic currentTime = DateFormat.jm().format(DateTime.now());

    log('===============> select time $currentTime');
    if (currentTime.isNotEmpty) {
      log('====> Selected time of ride: $currentTime');

      DateTime selectedDateTime = convertToDateTime(currentTime);

      // intercitySharingList.value = ;

      bool isCabAvailable = Constant.cabTimeSlotList.any(
        (cab) => cab.id == vehicleTypeId,
      );
      var defaultCab = VehicleTypeModel(
        id: '',
        image: '',
        isActive: false,
        isTimeSlotEnable: false,
        title: '',
        persons: '',
        charges: Charges(fareMinimumChargesWithinKm: '0', farePerKm: '0', farMinimumCharges: '0'),
        // Provide a valid instance
        timeSlots: [],
      );

      List<CabTimeSlotsChargesModel>? selectedTimeSlots;

      if (isCabAvailable) {
        var selectedCab = Constant.cabTimeSlotList.firstWhere(
          (cab) => cab.id == vehicleTypeId,
          orElse: () => defaultCab, // Returns null if no match
        );

        selectedTimeSlots = selectedCab.timeSlots;
      }

      if (isCabAvailable == true) {
        cabTimeSlotList.value = selectedTimeSlots!;
        // selectedTimeSlots = selectedCab?.timeSlots;
      }

      for (var model in cabTimeSlotList) {
        log('Checking time slot: ${model.farePerKm}');

        if (isTimeInRange(selectedDateTime, model.timeSlot)) {
          log('✅ Matched time slot: ${model.timeSlot}');
          log('✅ Matched time slot: ${model.fareMinimumChargesWithinKm}');

          return model;
        }
      }
    }
    log("❌ No matching time slot found.");
    return null;
  }

  bool isTimeInRange(DateTime selectedTime, String timeSlot) {
    log("Checking time slot: $timeSlot");
    RegExp fullRangeRegEx = RegExp(r"(\d+)\s*(AM|PM)?\s*-\s*(\d+)\s*(AM|PM)", caseSensitive: false);
    Match? match = fullRangeRegEx.firstMatch(timeSlot);

    if (match == null) {
      log("❌ Could not extract numeric range from: $timeSlot");
      return false;
    }

    int startHour = int.parse(match.group(1)!);
    String startPeriod = (match.group(2) ?? match.group(4))!.toUpperCase();
    int endHour = int.parse(match.group(3)!);
    String endPeriod = match.group(4)!.toUpperCase();

    if (timeSlot.toLowerCase().contains("morning") && endHour == 12 && startPeriod == "AM") {
      endPeriod = "PM";
    }

    int startMinutes = convertToMinutes(startHour, startPeriod);
    int endMinutes = convertToMinutes(endHour, endPeriod);
    int selectedMinutes = selectedTime.hour * 60 + selectedTime.minute;

    bool inRange;
    if (startMinutes < endMinutes) {
      inRange = (selectedMinutes >= startMinutes && selectedMinutes < endMinutes);
    } else {
      inRange = (selectedMinutes >= startMinutes || selectedMinutes < endMinutes);
    }

    log("Extracted range: '$startHour $startPeriod - $endHour $endPeriod'");
    log("Comparing: selected time ${selectedTime.hour}:${selectedTime.minute} ($selectedMinutes minutes) with range $startMinutes-$endMinutes -> Result: $inRange");

    return inRange;
  }

  int convertToMinutes(int hour, String period) {
    if (period == "PM" && hour != 12) {
      hour += 12;
    }
    if (period == "AM" && hour == 12) {
      hour = 0;
    }
    return hour * 60;
  }

  DateTime convertToDateTime(String time) {
    final format = DateFormat("h:mm a");
    time = time.replaceAll(RegExp(r'\s+'), ' ').trim();
    DateTime dateTime = format.parse(time);
    return dateTime;
  }

  BitmapDescriptor? pickUpIcon;
  BitmapDescriptor? dropIcon;

  void getPolyline(
      {required double? sourceLatitude,
      required double? sourceLongitude,
      required double? destinationLatitude,
      required double? destinationLongitude}) async {
    if (sourceLatitude != null &&
        sourceLongitude != null &&
        destinationLatitude != null &&
        destinationLongitude != null) {
      // Log para debug da chave da API
      log("Valor atual da chave da API: '${Constant.mapAPIKey}'");
      log("Chave está vazia? ${Constant.mapAPIKey.isEmpty}");
      
      if (Constant.mapAPIKey.isEmpty) {
        log("ERRO: Chave da API do Google Maps está vazia - tentando carregar do Firestore");
        await Constant.checkAndLoadGoogleMapAPIKey();
        log("Após carregamento - Chave da API: '${Constant.mapAPIKey}'");
        
        if (Constant.mapAPIKey.isEmpty) {
          log("ERRO: Chave da API continua vazia após tentativa de carregamento");
          ShowToastDialog.showToast("Erro ao carregar a chave da API do Google Maps. Por favor, tente novamente mais tarde.");
          return;
        }
      }
      
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

      addMarker(
          latitude: sourceLatitude, longitude: sourceLongitude, id: "pickUp", descriptor: pickUpIcon!, rotation: 0.0);
      addMarker(
          latitude: destinationLatitude,
          longitude: destinationLongitude,
          id: "drop",
          descriptor: dropIcon!,
          rotation: 0.0);
      _addPolyLine(polylineCoordinates);
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  void addMarker(
      {required double? latitude,
      required double? longitude,
      required String id,
      required BitmapDescriptor descriptor,
      required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
        rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  Future<void> addMarkerSetup() async {
    final Uint8List pickUpUint8List = await Constant().getBytesFromAsset('assets/icon/ic_pick_up_map.png', 100);
    final Uint8List dropUint8List = await Constant().getBytesFromAsset('assets/icon/ic_drop_in_map.png', 100);
    pickUpIcon = BitmapDescriptor.fromBytes(pickUpUint8List);
    dropIcon = BitmapDescriptor.fromBytes(dropUint8List);
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  Future<void> _addPolyLine(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      consumeTapEvents: true,
      color: AppThemData.primary500,
      startCap: Cap.roundCap,
      width: 4,
    );
    polyLines[id] = polyline;
    updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, mapController);
  }

  Future<void> updateCameraLocation(
    LatLng? source,
    LatLng? destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    if (source != null && destination != null) {
      LatLngBounds bounds;

      if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
        bounds = LatLngBounds(southwest: destination, northeast: source);
      } else if (source.longitude > destination.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude),
        );
      } else if (source.latitude > destination.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: source, northeast: destination);
      }

      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 40);
      return checkCameraLocation(cameraUpdate, mapController);
    } else if (source != null) {
      // Zoom to source only
      CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
        CameraPosition(target: source, zoom: 10),
      );
      mapController.animateCamera(cameraUpdate);
    }
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  String amountShow(VehicleTypeModel vehicleType, MapModel value) {
    if (Constant.distanceType == "Km") {
      var distance = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000);
      if (distance > double.parse(vehicleType.charges.fareMinimumChargesWithinKm)) {
        return Constant.amountCalculate(vehicleType.charges.farePerKm.toString(), distance.toString())
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      } else {
        return Constant.amountCalculate(vehicleType.charges.farMinimumCharges.toString(), distance.toString())
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    } else {
      var distance = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34);
      if (distance > double.parse(vehicleType.charges.fareMinimumChargesWithinKm)) {
        return Constant.amountCalculate(vehicleType.charges.farePerKm.toString(), distance.toString())
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      } else {
        return Constant.amountCalculate(vehicleType.charges.farMinimumCharges.toString(), distance.toString())
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
  }

  String distanceCalculate(MapModel? value) {
    if (Constant.distanceType == "Km") {
      return (value!.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
    } else {
      return (value!.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
    }
  }

  double applyCoupon() {
    if (bookingModel.value.coupon != null) {
      if (bookingModel.value.coupon!.id != null) {
        if (bookingModel.value.coupon!.isFix == true) {
          return double.parse(bookingModel.value.coupon!.amount.toString());
        } else {
          return double.parse(bookingModel.value.subTotal ?? '0.0') *
              double.parse(bookingModel.value.coupon!.amount.toString()) /
              100;
        }
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }
}
