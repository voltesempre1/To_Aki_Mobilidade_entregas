// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/support_reason_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportReasonController extends GetxController {
  RxString title = "Support Reason".tr.obs;
  Rx<TextEditingController> supportReasonController = TextEditingController().obs;
  Rx<SupportReasonModel> supportReasonModel = SupportReasonModel().obs;
  RxList<SupportReasonModel> supportReasonList = <SupportReasonModel>[].obs;

  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;

  List<String> type = ["customer", "driver"];
  RxString selectedType = "customer".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    supportReasonList.clear();
    try {
      List<SupportReasonModel>? data = await FireStoreUtils.getSupportReason();
      supportReasonList.addAll(data);
        } catch (e) {
      ShowToastDialog.toast("Failed to fetch support reasons");
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    selectedType.value = "customer";
    supportReasonController.value.text = "";
    isEditing.value = false;
    isLoading.value = false;
  }

  bool _validateInput() {
    if (supportReasonController.value.text.trim().isEmpty) {
      ShowToastDialog.toast("Reason cannot be empty");
      return false;
    }
    if (!type.contains(selectedType.value)) {
      ShowToastDialog.toast("Invalid type selected");
      return false;
    }
    return true;
  }

  Future<void> addSupportReason() async {
    if (!_validateInput()) return;
    isLoading.value = true;
    supportReasonModel.value.id = Constant.getRandomString(20);
    supportReasonModel.value.reason = supportReasonController.value.text.trim();
    supportReasonModel.value.type = selectedType.value;
    try {
      await FireStoreUtils.addSupportReason(supportReasonModel.value);
      await getData();
      ShowToastDialog.toast("Support Reason Added");
    } catch (e) {
      ShowToastDialog.toast("Failed to add support reason");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSupportReason() async {
    supportReasonModel.value.reason = supportReasonController.value.text;
    supportReasonModel.value.type = selectedType.value;
    await FireStoreUtils.updateSupportReason(supportReasonModel.value);
    await getData();
  }

  Future<void> removeSupportReason(SupportReasonModel supportReasonModel) async {
    isLoading.value = true;
    await FirebaseFirestore.instance.collection(CollectionName.supportReason).doc(supportReasonModel.id).delete().then((value) {
      ShowToastDialog.toast("Support Reason Deleted..".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading.value = false;
  }
}
