// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/models/coupon_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/collection_name.dart';
import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';

class OffersScreenController extends GetxController {
  RxString title = "Offers".tr.obs;
  RxList<CouponModel> couponList = <CouponModel>[].obs;
  Rx<TextEditingController> couponTitleController = TextEditingController().obs;
  Rx<TextEditingController> couponCodeController = TextEditingController().obs;
  Rx<TextEditingController> couponAmountController = TextEditingController().obs;
  Rx<TextEditingController> couponMinAmountController = TextEditingController().obs;
  Rx<TextEditingController> expireDateController = TextEditingController().obs;
  DateTime selectedDate = DateTime.now();

  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  Rx<String> editingId = "".obs;

  RxString selectedAdminCommissionType = "Fix".obs;
  final List<String> adminCommissionType = ["Fix", "Percentage"];

  RxString couponPrivacyType = "Public".obs;
  final List<String> couponType = ["Private", "Public"];

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      expireDateController.value.text = selectedDate.toString();
    }
  }

  Future<void> fetchCoupons() async {
    isLoading.value = true;
    try {
      couponList.clear();
      final data = await FireStoreUtils.getCoupon();
      if (data.isNotEmpty) {
        couponList.addAll(data);
      }
    } catch (e) {
      ShowToast.errorToast('Failed to load coupons');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCoupon() async {
    isLoading = true.obs;
    await FireStoreUtils.addCoupon(CouponModel(
      id: Constant.getRandomString(20),
      active: isActive.value,
      minAmount: couponMinAmountController.value.text,
      title: couponTitleController.value.text,
      code: couponCodeController.value.text,
      amount: couponAmountController.value.text,
      isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
      isPrivate: couponPrivacyType.value == "Public" ? false : true,
      expireAt: Timestamp.fromDate(selectedDate),
    ));

    await fetchCoupons();
    isLoading = false.obs;
  }

  Future<void> updateCoupon() async {
    isEditing = true.obs;
    await FireStoreUtils.updateCoupon(CouponModel(
      id: editingId.value,
      active: isActive.value,
      minAmount: couponMinAmountController.value.text,
      title: couponTitleController.value.text,
      code: couponCodeController.value.text,
      amount: couponAmountController.value.text,
      isFix: selectedAdminCommissionType.value == "Fix" ? true : false,
      isPrivate: couponPrivacyType.value == "Public" ? false : true,
      expireAt: Timestamp.fromDate(selectedDate),
    ));
    await fetchCoupons();
    isEditing = false.obs;
  }

  Future<void> removeCoupon(CouponModel couponModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.coupon).doc(couponModel.id).delete().then((value) {
      ShowToastDialog.toast("Coupon deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Coupon went wrong".tr);
    });
    await fetchCoupons();
    isLoading = false.obs;
  }

  void setDefaultData() {
    couponTitleController.value.clear();
    couponCodeController.value.clear();
    couponAmountController.value.clear();
    couponMinAmountController.value.clear();
    expireDateController.value.clear();
    isEditing.value = false;
    isActive.value = false;
    editingId.value = "";
    selectedAdminCommissionType.value = "Fix";
    couponPrivacyType.value = "Public";
    selectedDate = DateTime.now();
  }

  @override
  void onClose() {
    couponTitleController.value.dispose();
    couponCodeController.value.dispose();
    couponAmountController.value.dispose();
    couponMinAmountController.value.dispose();
    expireDateController.value.dispose();
    super.onClose();
  }
}
