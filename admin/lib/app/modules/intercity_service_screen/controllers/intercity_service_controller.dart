// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:admin/app/models/intercity_document_model.dart';
import 'package:admin/app/models/time_slots_charges_model.dart';
import 'package:admin/app/models/intercity_time_model.dart';
import 'package:admin/app/modules/document_screen/views/document_screen_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntercityServiceController extends GetxController {
  RxString title = "Intercity Service".tr.obs;

  Rx<TextEditingController> minimumChargesController = TextEditingController().obs;
  Rx<TextEditingController> minimumChargeWithKmController = TextEditingController().obs;
  Rx<SideAt> documentSide = SideAt.isOneSide.obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  RxString editingId = "".obs;
  RxList<InterCityTimeModel> serviceList = <InterCityTimeModel>[].obs;
  RxList<TimeSlotsChargesModel> serviceSlots = <TimeSlotsChargesModel>[].obs;
  RxList<TextEditingController> perKmControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> minimumChargesControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> minimumChargeWithKmControllers = <TextEditingController>[].obs;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  var startTime = TimeOfDay.now().obs;
  var endTime = TimeOfDay.now().obs;

  final Map<String, TextEditingController> minChargeWithKmControllers = {};
  final Map<String, TextEditingController> minChargeControllers = {};

  RxList<TextEditingController> perKmController = <TextEditingController>[].obs;
  RxList<IntercityDocumentModel> intercityDocuments = <IntercityDocumentModel>[].obs;
  RxString selectedDocId = ''.obs;
  RxBool allFillChecked = false.obs;
  RxBool isFillAll = false.obs;

  final List<String> timeSlots = ["Early Morning 4-8 AM", "Morning 8-12 AM", "Afternoon 12-4 PM", "Evening 4-8 PM", "Night 8 PM-12 AM", "Midnight 12-4 AM"];

  void setDefaultData() {
    if (serviceList.isEmpty) {
      serviceList.add(InterCityTimeModel(title: "Default Title", timeZone: []));
    }
  }

  @override
  Future<void> onInit() async {
    initializeServiceSlots();
    fetchIntercityService();
    super.onInit();
  }

  void initializeServiceSlots() {
    serviceSlots.clear();

    for (var timeSlot in timeSlots) {
      serviceSlots.add(
        TimeSlotsChargesModel(
          timeSlot: timeSlot,
          fareMinimumChargesWithinKm: "",
          farMinimumCharges: "",
          farePerKm: "",
        ),
      );
    }
  }

  Future<void> fetchIntercityService() async {
    isLoading.value = true;
    try {
      intercityDocuments.clear();

      List<String> docNames = ["parcel", "intercity_sharing", "intercity"];

      for (String docName in docNames) {
        DocumentSnapshot doc = await fireStore.collection("intercity_service").doc(docName).get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          intercityDocuments.add(IntercityDocumentModel.fromJson(docName, data));
          log('==================> intercity document IntercityDocumentModel: ${IntercityDocumentModel.fromJson(docName, data)}');
        }
      }

      log('==================> intercity document count: ${intercityDocuments.length}');
    } catch (e) {
      log("Error fetching intercity services: $e");
    }
    isLoading.value = false;
  }

  void fillAllValues() {
    if (perKmControllers.isNotEmpty && minChargeControllers.isNotEmpty && minChargeWithKmControllers.isNotEmpty) {
      String minChargeWithKm = minChargeWithKmControllers.values.first.text;
      String farePerKm = perKmControllers.first.text;
      String minCharge = minChargeControllers.values.first.text;

      for (int i = 1; i < timeSlots.length; i++) {
        minChargeWithKmControllers.values.elementAt(i).text = minChargeWithKm;
        perKmControllers.elementAt(i).text = farePerKm;
        minChargeControllers.values.elementAt(i).text = minCharge;
      }
    }
  }

  void loadIntercityService(IntercityDocumentModel doc) {
    selectedDocId.value = doc.id;
    serviceSlots.value = doc.timeSlots;

    // Clear and refill controllers
    perKmControllers.clear();
    minChargeControllers.clear();
    minChargeWithKmControllers.clear();

    for (var slot in serviceSlots) {
      perKmControllers.add(TextEditingController(text: slot.fareMinimumChargesWithinKm.toString()));
      minimumChargesControllers.add(TextEditingController(text: slot.farMinimumCharges.toString()));
      minimumChargeWithKmControllers.add(TextEditingController(text: slot.farePerKm.toString()));
    }
  }

  Future<void> saveToFirestore() async {
    try {
      List<Map<String, dynamic>> updatedTimeSlots = [];

      for (int i = 0; i < serviceSlots.length; i++) {
        updatedTimeSlots.add({
          "timeSlot": serviceSlots[i].timeSlot,
          "farePerKm": perKmControllers[i].text,
          "fare_minimum_charges_within_km": minimumChargeWithKmControllers[i].text,
          "farMinimumCharges": minimumChargesControllers[i].text,
        });
      }

      await FirebaseFirestore.instance.collection("intercity_service").doc(selectedDocId.value).update({"timeSlots": updatedTimeSlots});

      Get.back();
      fetchIntercityService(); // Refresh data
    } catch (e) {
      log("Error saving data: $e");
    }
  }

  @override
  void onClose() {
    // Dispose all controllers to prevent memory leaks
    minimumChargesController.value.dispose();
    minimumChargeWithKmController.value.dispose();
    for (var controller in perKmControllers) {
      controller.dispose();
    }
    for (var controller in minChargeControllers.values) {
      controller.dispose();
    }
    for (var controller in minChargeWithKmControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

// getData() async {
//   isLoading(true);
//   documentsList.clear();
//   List<DocumentsModel> data = await FireStoreUtils.getDocument();
//   documentsList.addAll(data);
//   isLoading(false);
// }

// setDefaultData() {
//   perKmController.value.text = "";
//   editingId.value = "";
//   documentSide = SideAt.isOneSide.obs;
//   isActive.value = false;
//   isEditing.value = false;
//   startTime.value = TimeOfDay.now();
//   endTime.value = TimeOfDay.now();
// }
}
