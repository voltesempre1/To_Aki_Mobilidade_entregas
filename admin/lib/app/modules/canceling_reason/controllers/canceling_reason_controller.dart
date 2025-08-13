// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

class CancelingReasonController extends GetxController {
  RxString title = "Canceling Reason".tr.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxString editingValue = "".obs;
  RxList<String> cancelingReasonList = <String>[].obs;
  Rx<TextEditingController> reasonController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCancelingReasons();
  }

  Future<void> fetchCancelingReasons() async {
    try {
      isLoading.value = true;
      final reasons = await FireStoreUtils.getCancelingReason();
      cancelingReasonList.value = reasons;
    } catch (e) {
      ShowToast.errorToast('Failed to load reasons');
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    reasonController.value.clear();
    editingValue.value = "";
    isEditing.value = false;
    isLoading.value = false;
  }

  Future<void> updateReason() async {
    isEditing.value = true;
    cancelingReasonList[cancelingReasonList.indexWhere((element) => element == editingValue.value)] = reasonController.value.text;
    await FireStoreUtils.addCancelingReason(cancelingReasonList);
    setDefaultData();
    isEditing.value = false;
  }

  Future<void> removeReason(String reason) async {
    isLoading.value = true;
    cancelingReasonList.remove(reason);
    await FirebaseFirestore.instance.collection(CollectionName.settings).doc("canceling_reason").set(<String, List<String>>{"reasons": cancelingReasonList}).then((value) {
      ShowToastDialog.toast("Canceling Reason Deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    setDefaultData();
    isLoading.value = false;
  }

  Future<void> addReason() async {
    isLoading.value = true;
    cancelingReasonList.add(reasonController.value.text);
    await FireStoreUtils.addCancelingReason(cancelingReasonList);
    setDefaultData();
    isLoading.value = false;
  }
}
