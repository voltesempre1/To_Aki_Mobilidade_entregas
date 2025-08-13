// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

class LanguageController extends GetxController {
  RxString title = "Language".tr.obs;
  Rx<LanguageModel> languageModel = LanguageModel().obs;
  Rx<TextEditingController> languageController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  final DashboardScreenController dashboardScreenController = Get.put(DashboardScreenController());

  @override
  void onInit() {
    super.onInit();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    isLoading.value = true;
    try {
      languageList.clear();
      final data = await FireStoreUtils.getLanguage();
      if (data.isNotEmpty) {
        languageList.addAll(data);
      }
    } catch (e) {
      ShowToast.errorToast('Failed to load languages');
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    languageController.value.clear();
    codeController.value.clear();
    isEditing.value = false;
    isActive.value = false;
    languageModel.value = LanguageModel();
  }

  @override
  void onClose() {
    languageController.value.dispose();
    codeController.value.dispose();
    super.onClose();
  }

  Future<void> updateLanguage() async {
    // languageModel.value.id = Constant.getRandomString(20);
    languageModel.value.name = languageController.value.text;
    languageModel.value.code = codeController.value.text;
    languageModel.value.active = isActive.value;
    await FireStoreUtils.updateLanguage(languageModel.value);
    await dashboardScreenController.getLanguage();
    await fetchLanguages();
  }

  Future<void> addLanguage() async {
    isLoading = true.obs;
    languageModel.value.id = Constant.getRandomString(20);
    languageModel.value.name = languageController.value.text;
    languageModel.value.code = codeController.value.text;
    languageModel.value.active = isActive.value;
    await FireStoreUtils.addLanguage(languageModel.value);
    await dashboardScreenController.getLanguage();
    await fetchLanguages();
    isLoading = false.obs;
  }

  Future<void> removeLanguage(LanguageModel languageModel) async {
    isLoading = true.obs;

    await FirebaseFirestore.instance.collection(CollectionName.languages).doc(languageModel.id).delete().then((value) {
      ShowToastDialog.toast("Language deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await dashboardScreenController.getLanguage();
    isLoading = false.obs;
  }
}
