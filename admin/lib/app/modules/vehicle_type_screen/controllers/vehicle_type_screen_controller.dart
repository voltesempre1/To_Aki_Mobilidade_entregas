// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:admin/app/models/time_slots_charges_model.dart';
import 'package:admin/app/models/vehicle_type_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/collection_name.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';

class VehicleTypeScreenController extends GetxController {
  Rx<TextEditingController> vehicleTitle = TextEditingController().obs;
  Rx<TextEditingController> person = TextEditingController().obs;
  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  Rx<TextEditingController> vehicleTypeImage = TextEditingController().obs;
  RxString title = "VehicleType".obs;
  RxBool isEnable = false.obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;

  final List<String> timeSlots = ["Early Morning 4-8 AM", "Morning 8-12 AM", "Afternoon 12-4 PM", "Evening 4-8 PM", "Night 8 PM-12 AM", "Midnight 12-4 AM"];
  RxList<TimeSlotsChargesModel> serviceSlots = <TimeSlotsChargesModel>[].obs;
  RxList<TextEditingController> perKmControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> minimumChargesControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> minimumChargeWithKmControllers = <TextEditingController>[].obs;
  List<TimeSlotsChargesModel> updatedTimeSlots = [];
  RxBool allFillChecked = false.obs;
  RxBool isFillAll = false.obs;

  @override
  void onInit() {
    getData();
    initializeServiceSlots();
    for (int i = 0; i < timeSlots.length; i++) {
      perKmControllers.add(TextEditingController());
      minimumChargesControllers.add(TextEditingController());
      minimumChargeWithKmControllers.add(TextEditingController());
    }
    super.onInit();
  }

  void fillAllValues() {
    if (perKmControllers.isNotEmpty && minimumChargesControllers.isNotEmpty && minimumChargeWithKmControllers.isNotEmpty) {
      String minChargeWithKm = minimumChargeWithKmControllers[0].text;
      String farePerKm = perKmControllers[0].text;
      String minCharge = minimumChargesControllers[0].text;

      for (int i = 1; i < timeSlots.length; i++) {
        minimumChargeWithKmControllers[i].text = minChargeWithKm;
        perKmControllers[i].text = farePerKm;
        minimumChargesControllers[i].text = minCharge;
      }
    }
  }

  Future<void> getData() async {
    isLoading(true);
    vehicleTypeList.clear();
    serviceSlots.clear();
    perKmControllers.clear();
    minimumChargesControllers.clear();
    minimumChargeWithKmControllers.clear();
    isFillAll.value = false;
    List<VehicleTypeModel> data = await FireStoreUtils.getVehicleType();
    vehicleTypeList.addAll(data);
    isLoading(false);
  }

  void initializeServiceSlots() {
    isEditing.value = false;
    serviceSlots.clear();
    perKmControllers.clear();
    minimumChargesControllers.clear();
    minimumChargeWithKmControllers.clear();

    for (var timeSlot in timeSlots) {
      serviceSlots.add(
        TimeSlotsChargesModel(
          timeSlot: timeSlot,
          fareMinimumChargesWithinKm: "",
          farMinimumCharges: "",
          farePerKm: "",
        ),
      );
      updatedTimeSlots.clear();
      perKmControllers.add(TextEditingController());
      minimumChargesControllers.add(TextEditingController());
      minimumChargeWithKmControllers.add(TextEditingController());
    }
  }

  void loadIntercityService(List<TimeSlotsChargesModel> doc) {
    serviceSlots.value = doc;
    perKmControllers.clear();
    minimumChargesControllers.clear();
    minimumChargeWithKmControllers.clear();
    for (var slot in serviceSlots) {
      perKmControllers.add(TextEditingController(text: slot.farePerKm.toString()));
      minimumChargesControllers.add(TextEditingController(text: slot.farMinimumCharges.toString()));
      minimumChargeWithKmControllers.add(TextEditingController(text: slot.fareMinimumChargesWithinKm.toString()));
    }
  }

  void setDefaultData() {
    vehicleTitle.value.text = "";
    vehicleTypeImage.value.clear();
    person.value.text = "";
    imageFile.value = File('');
    mimeType.value = 'image/png';
    imageURL.value = '';
    editingId.value = '';
    isEditing.value = false;
    isEnable.value = false;
    isImageUpdated.value = false;
    isFillAll.value = false;
    allFillChecked.value = false;
  }

  Future<void> updateVehicleType() async {
    isLoading = true.obs;
    updatedTimeSlots.clear();
    for (int i = 0; i < serviceSlots.length; i++) {
      updatedTimeSlots.add(TimeSlotsChargesModel(
        timeSlot: serviceSlots[i].timeSlot,
        fareMinimumChargesWithinKm: minimumChargeWithKmControllers[i].text.trim(),
        farePerKm: perKmControllers[i].text.trim(),
        farMinimumCharges: minimumChargesControllers[i].text.trim(),
      ));
    }
    String docId = editingId.value;
    String vehicleUrl = imageURL.value;
    if (isImageUpdated.value && imageFile.value.path.isNotEmpty) {
      vehicleUrl = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "vehicleTyepImage", docId, mimeType.value);
    }
    await FireStoreUtils.updateVehicleType(VehicleTypeModel(
      timeSlots: updatedTimeSlots,
      id: docId,
      image: vehicleUrl,
      isActive: isEnable.value,
      title: vehicleTitle.value.text,
      persons: person.value.text,
    ));
    await getData();
    isLoading = false.obs;
  }

  Future<void> addVehicleType() async {
    isLoading = true.obs;
    String docId = Constant.getRandomString(20);
    String url = '';
    if (imageFile.value.path.isNotEmpty) {
      url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "vehicleTyepImage", docId, mimeType.value);
    }
    updatedTimeSlots.clear();
    for (int i = 0; i < serviceSlots.length; i++) {
      updatedTimeSlots.add(TimeSlotsChargesModel(
        timeSlot: serviceSlots[i].timeSlot,
        fareMinimumChargesWithinKm: minimumChargeWithKmControllers[i].text.trim(),
        farePerKm: perKmControllers[i].text.trim(),
        farMinimumCharges: minimumChargesControllers[i].text.trim(),
      ));
    }
    await FireStoreUtils.addVehicleType(VehicleTypeModel(
      timeSlots: updatedTimeSlots,
      id: docId,
      image: url,
      isActive: isEnable.value,
      title: vehicleTitle.value.text,
      persons: person.value.text,
    ));
    await getData();
    isLoading = false.obs;
  }

  Future<void> removeVehicleTypeModel(VehicleTypeModel vehicleTypeModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.vehicleType).doc(vehicleTypeModel.id).delete().then((value) {
      ShowToastDialog.toast("VehicleType deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await getData();
    isLoading = false.obs;
  }
}
