// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/distance_model.dart';
import 'package:customer/app/models/time_slots_charges_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/map_model.dart';
import 'package:customer/app/models/parcel_model.dart';
import 'package:customer/app/models/payment_method_model.dart';
import 'package:customer/app/models/positions.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/models/vehicle_model_model.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class BookParcelController extends GetxController {
  FocusNode pickUpFocusNode = FocusNode();
  FocusNode dropFocusNode = FocusNode();
  TextEditingController dropLocationController = TextEditingController();
  TextEditingController pickupLocationController = TextEditingController();
  LatLng? sourceLocation;
  LatLng? destination;
  Position? currentLocationPosition;
  Rx<DateTime?> selectedDate = DateTime.now().obs;
  RxBool isLoading = true.obs;

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  Rx<TextEditingController> addPriceController = TextEditingController().obs;
  Rx<TextEditingController> weightController = TextEditingController().obs;
  Rx<TextEditingController> dimensionController = TextEditingController().obs;

  final ImagePicker imagePicker = ImagePicker();
  Rxn<File> selectedImage = Rxn<File>();

  RxString parcelImage = ''.obs;

  Rx<ParcelModel> parcelModel = ParcelModel().obs;
  RxList<TaxModel> taxList = (Constant.taxList ?? []).obs;

  RxString pikUpAddress = ''.obs;
  RxString dropAddress = ''.obs;
  Rx<MapModel?> mapModel = MapModel().obs;

  RxString selectedPaymentMethod = 'Cash'.obs;

  RxString mimeType = 'image/png'.obs;

  Rx<VehicleTypeModel> vehicleTypeModel = VehicleTypeModel(
      timeSlots: [],
      id: "",
      image: "",
      isActive: false,
      title: "",
      persons: "0",
      charges: Charges(
        fareMinimumChargesWithinKm: "0",
        farMinimumCharges: "0",
        farePerKm: "0",
      )).obs;
  RxList<VehicleModelModel> vehicleModelList = <VehicleModelModel>[].obs;
  List<VehicleTypeModel> vehicleTypeList = Constant.vehicleTypeList ?? [];

  RxDouble estimatePrice = 0.0.obs;
  RxBool isEstimatePriceVisible = false.obs;

  Rx<DistanceModel> distanceOfKm = DistanceModel().obs;

  @override
  void onInit() {
    vehicleTypeModel.value =  vehicleTypeList[0];
    if (Constant.taxList == null || Constant.taxList!.isEmpty) {
      getTax();
    } else {
      taxList.value = Constant.taxList!;
      isLoading.value = false;
    }
    super.onInit();
  }

  Future<void> updateData() async {
    if (destination != null && sourceLocation != null) {
      ShowToastDialog.showLoader("Please wait".tr);
      mapModel.value = await Constant.getDurationDistance(sourceLocation!, destination!);
      distanceOfKm.value = DistanceModel(
        distance: distanceCalculate(mapModel.value),
        distanceType: Constant.distanceType,
      );
      updateCalculation();
      ShowToastDialog.closeLoader();
    }
  }

  void updateCalculation() {
    if (selectedTime.value != 'Select Time' && selectedTime.value.isNotEmpty) {
      ChargesModel? intercityModel = calculationOfEstimatePrice();
      if (intercityModel != null) {
        final distance = double.tryParse(distanceOfKm.value.distance ?? '0') ?? 0;
        final minKm = double.tryParse(intercityModel.fareMinimumChargesWithinKm) ?? 0;
        final minCharge = double.tryParse(intercityModel.farMinimumCharges) ?? 0;
        final perKm = double.tryParse(intercityModel.farePerKm) ?? 0;
        if (distance < minKm) {
          estimatePrice.value = minCharge;
        } else {
          estimatePrice.value = double.parse((perKm * distance).toStringAsFixed(2));
        }
        addPriceController.value.text = estimatePrice.value.toString();
        isEstimatePriceVisible.value = true;
      } else {
        isEstimatePriceVisible.value = false;
      }
    }
  }

  ChargesModel? calculationOfEstimatePrice() {
    if (selectedTime.value != 'Select Time' && selectedTime.value.isNotEmpty) {
      DateTime selectedDateTime = convertToDateTime(selectedTime.value);
      for (var model in Constant.parcelDocuments.first.timeSlots) {
        if (isTimeInRange(selectedDateTime, model.timeSlot)) {
          return model;
        }
      }
    }
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
    DateTime dateTime = format.parse(time);
    return dateTime;
  }

  Future<void> getTax() async {
    final value = await FireStoreUtils().getTaxList();
    if (value != null) {
      Constant.taxList = value;
      taxList.value = value;
    }
    isLoading.value = false;
  }

  RxString selectedTime = "Select Time".obs;

  void pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedTime.value = pickedTime.format(context);
      ChargesModel? intercityModel = calculationOfEstimatePrice();

      if (intercityModel != null) {
        if (double.parse(distanceOfKm.value.distance!) < double.parse(intercityModel.fareMinimumChargesWithinKm)) {
          log("Distance is less than the minimum charge threshold");
          estimatePrice.value = double.parse(intercityModel.farMinimumCharges);
          isEstimatePriceVisible.value = true;

        } else {
          estimatePrice.value =
              double.parse((double.parse(intercityModel.farePerKm) * double.parse(distanceOfKm.value.distance!)).toStringAsFixed(2));
          addPriceController.value.text = double.parse(estimatePrice.toString()).toString();
          isEstimatePriceVisible.value = true;


          log("Distance is greater than or equal to the minimum charge threshold");
        }
      } else {
        log("No matching time slot found.");
      }
    }
  }

  Future<void> getData() async {
    currentLocationPosition = await Utils.getCurrentLocation();
    Constant.country =
        (await placemarkFromCoordinates(currentLocationPosition!.latitude, currentLocationPosition!.longitude))[0].country ?? 'Unknown';
    sourceLocation = LatLng(currentLocationPosition!.latitude, currentLocationPosition!.longitude);

    isLoading.value = false;
  }

  Future<void> saveParcelData() async {
    if (selectedImage.value == null) {
      ShowToastDialog.toast("Please add an image");
      return;
    }
    ShowToastDialog.showLoader('Please Wait');
    parcelModel.value.id = Constant.getUuid();
    if (selectedImage.value!.path.isNotEmpty) {
      mimeType.value = 'image/png';
      String docId = parcelModel.value.id.toString();
      String url = await Constant.uploadPic(PickedFile(selectedImage.value!.path), "parcelImage", docId, mimeType.value);
      parcelModel.value.parcelImage = url;
    }
    parcelModel.value.dropLocationAddress = dropAddress.value;
    parcelModel.value.pickUpLocationAddress = pikUpAddress.value;
    parcelModel.value.customerId = FireStoreUtils.getCurrentUid();
    parcelModel.value.bookingStatus = BookingStatus.bookingPlaced;
    parcelModel.value.vehicleType = vehicleTypeModel.value;
    parcelModel.value.vehicleTypeID = vehicleTypeModel.value.id;
    parcelModel.value.createAt = Timestamp.now();
    parcelModel.value.updateAt = Timestamp.now();
    parcelModel.value.bookingTime = Timestamp.now();
    parcelModel.value.rideStartTime = selectedTime.value;
    parcelModel.value.pickUpLocation = LocationLatLng(latitude: sourceLocation!.latitude, longitude: sourceLocation!.longitude);
    parcelModel.value.dropLocation = LocationLatLng(latitude: destination!.latitude, longitude: destination!.longitude);
    GeoFirePoint position = GeoFlutterFire().point(latitude: sourceLocation!.latitude, longitude: sourceLocation!.longitude);
    parcelModel.value.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
    parcelModel.value.distance = DistanceModel(
      distance: distanceCalculate(mapModel.value),
      distanceType: Constant.distanceType,
    );
    parcelModel.value.otp = Constant.getOTPCode();
    parcelModel.value.paymentType = selectedPaymentMethod.value;
    parcelModel.value.paymentStatus = false;
    parcelModel.value.taxList = taxList;
    parcelModel.value.adminCommission = Constant.adminCommission;
    parcelModel.value.startDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    parcelModel.value.subTotal = addPriceController.value.text;
    parcelModel.value.setPrice = addPriceController.value.text;
    parcelModel.value.weight = weightController.value.text;
    parcelModel.value.dimension = dimensionController.value.text;
    parcelModel.value.recommendedPrice = estimatePrice.value.toString();
    parcelModel.value = ParcelModel.fromJson(parcelModel.value.toJson());
    await FireStoreUtils.setParcelBooking(parcelModel.value);
    ShowToastDialog.closeLoader();
    Get.back();
    Get.back();
  }

  Future<void> pickFile({required ImageSource source}) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source, imageQuality: 100);
      if (image == null) return;
      Get.back();

      final tempDir = await getTemporaryDirectory();
      final compressedFilePath = '${tempDir.path}/compressed_${image.name}';

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      if (compressedBytes == null) {
        Get.snackbar("Error", "Failed to compress image.");
        return;
      }

      File compressedFile = File(compressedFilePath);
      await compressedFile.writeAsBytes(compressedBytes);

      log('==========> compressedFile ${compressedFile.path}');
      selectedImage.value = compressedFile; // Store the File object, not a string
    } on PlatformException catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  String distanceCalculate(MapModel? value) {
    if (Constant.distanceType == "Km") {
      return (value!.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
    } else {
      return (value!.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
    }
  }
}
