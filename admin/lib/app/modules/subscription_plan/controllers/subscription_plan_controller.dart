// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/subscription_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlanController extends GetxController {
  RxString title = 'Subscription Plan'.tr.obs;

  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxString editingId = "".obs;

  Rx<SubscriptionModel> subscriptionModel = SubscriptionModel().obs;
  RxList<SubscriptionModel> subscriptionList = <SubscriptionModel>[].obs;

  Rx<TextEditingController> subscriptionNameController = TextEditingController().obs;
  Rx<TextEditingController> subscriptionDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> subscriptionPriceController = TextEditingController().obs;
  Rx<TextEditingController> expireDaysController = TextEditingController().obs;
  Rx<TextEditingController> subscriptionBookingsController = TextEditingController().obs;
  RxString subscriptionType = "free".obs;
  RxBool isEnable = false.obs;

  @override
  void onInit() {
    getSubscriptionPlan();
    super.onInit();
  }

  Future<void> getSubscriptionPlan() async {
    isLoading.value = true;
    subscriptionList.clear();
    try {
      List<SubscriptionModel> data = await FireStoreUtils.getSubscription();
      subscriptionList.addAll(data);
    } catch (e) {
      // Optionally log error or show toast
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (subscriptionNameController.value.text.trim().isEmpty ||
        subscriptionDescriptionController.value.text.trim().isEmpty ||
        subscriptionPriceController.value.text.trim().isEmpty ||
        expireDaysController.value.text.trim().isEmpty ||
        subscriptionBookingsController.value.text.trim().isEmpty) {
      ShowToast.errorToast('All fields are required.');
      return false;
    }
    if (double.tryParse(subscriptionPriceController.value.text) == null) {
      ShowToast.errorToast('Price must be a valid number.');
      return false;
    }
    if (int.tryParse(expireDaysController.value.text) == null) {
      ShowToast.errorToast('Expire days must be a valid integer.');
      return false;
    }
    if (int.tryParse(subscriptionBookingsController.value.text) == null) {
      ShowToast.errorToast('Bookings must be a valid integer.');
      return false;
    }
    return true;
  }

  Future<void> addSubscriptionPlan() async {
    if (!_validateInputs()) return;
    isLoading.value = true;
    subscriptionModel.value.id = Constant.getRandomString(20);
    subscriptionModel.value.title = subscriptionNameController.value.text.trim();
    subscriptionModel.value.description = subscriptionDescriptionController.value.text.trim();
    subscriptionModel.value.price = subscriptionPriceController.value.text.trim();
    subscriptionModel.value.expireDays = expireDaysController.value.text.trim();
    subscriptionModel.value.features = SubscriptionFeatures(
      bookings: subscriptionBookingsController.value.text.trim(),
    );
    subscriptionModel.value.isEnable = isEnable.value;
    subscriptionModel.value.type = subscriptionType.value;
    subscriptionModel.value.createdAt = Timestamp.now();

    bool isSaved = await FireStoreUtils.addSubscription(subscriptionModel.value);
    if (isSaved) {
      Get.back();
      getSubscriptionPlan();
      ShowToast.successToast("Subscription Plan Added Successfully");
    } else {
      ShowToast.errorToast("Something went wrong, Please try later!");
      isLoading.value = false;
    }
  }

  Future<void> updateSubscriptionPlan(SubscriptionModel subscriptionModel) async {
    isLoading.value = true;
    subscriptionModel.id = editingId.value;
    subscriptionModel.title = subscriptionNameController.value.text;
    subscriptionModel.description = subscriptionDescriptionController.value.text;
    subscriptionModel.price = subscriptionPriceController.value.text;
    subscriptionModel.expireDays = expireDaysController.value.text;
    subscriptionModel.features = SubscriptionFeatures(
      bookings: subscriptionBookingsController.value.text,
    );
    subscriptionModel.isEnable = isEnable.value;
    subscriptionModel.type = subscriptionType.value;

    bool isSaved = await FireStoreUtils.updateSubscription(subscriptionModel);
    if (isSaved) {
      Get.back();
      getSubscriptionPlan();
      ShowToast.successToast("Subscription Plan Updated Successfully".tr);
    } else {
      ShowToast.errorToast("Something went wrong, Please try later!");
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    subscriptionNameController.value.clear();
    subscriptionDescriptionController.value.clear();
    subscriptionPriceController.value.clear();
    expireDaysController.value.clear();
    subscriptionBookingsController.value.clear();
    isEnable.value = false;
    subscriptionType.value = "free";
    isEditing.value = false;
    editingId.value = "";
  }

  Future<bool> removeSubscription(String docId) {
    return FirebaseFirestore.instance.collection(CollectionName.subscriptionPlans).doc(docId).delete().then((value) async {
      return true;
    }).catchError((error) {
      return false;
    });
  }
}
