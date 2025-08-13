// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/currency_model.dart';
import 'package:admin/app/modules/currency/views/currency_view.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class CurrencyController extends GetxController {
  RxString title = "Currency".tr.obs;

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  Rx<TextEditingController> symbolController = TextEditingController().obs;
  Rx<TextEditingController> decimalDigitsController = TextEditingController().obs;
  Rx<bool> isActive = false.obs;
  Rx<SymbolAt> symbolAt = SymbolAt.symbolAtLeft.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxList<CurrencyModel> currencyList = <CurrencyModel>[].obs;
  Rx<CurrencyModel> currencyModel = CurrencyModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrencyList();
  }

  Future<void> fetchCurrencyList() async {
    try {
      isLoading.value = true;
      currencyList.clear();
      final data = await FireStoreUtils.getCurrencyList();
      if (data.isNotEmpty) {
        currencyList.addAll(data);
      }
    } catch (e) {
      ShowToast.errorToast('Failed to load currencies');
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    nameController.value.clear();
    codeController.value.clear();
    symbolController.value.clear();
    decimalDigitsController.value.clear();
    isActive.value = false;
    symbolAt.value = SymbolAt.symbolAtLeft;
    isEditing.value = false;
    currencyModel.value = CurrencyModel();
  }

  Future<void> updateCurrency() async {
    currencyModel.value.active = isActive.value;
    // currencyModel.value.createdAt = Timestamp.now();
    currencyModel.value.name = nameController.value.text;
    currencyModel.value.code = codeController.value.text;
    currencyModel.value.symbol = symbolController.value.text;
    currencyModel.value.decimalDigits = decimalDigitsController.value.text.toInt();
    currencyModel.value.symbolAtRight = symbolAt.value.name == SymbolAt.symbolAtRight.name ? true : false;
    await FireStoreUtils.updateCurrency(currencyModel.value);
    await fetchCurrencyList();
  }

  Future<void> addCurrency() async {
    isLoading = true.obs;
    currencyModel.value.id = Constant.getRandomString(20);
    currencyModel.value.active = isActive.value;
    currencyModel.value.createdAt = Timestamp.now();
    currencyModel.value.name = nameController.value.text;
    currencyModel.value.code = codeController.value.text;
    currencyModel.value.symbol = symbolController.value.text;
    currencyModel.value.decimalDigits = decimalDigitsController.value.text.toInt();
    currencyModel.value.symbolAtRight = symbolAt.value.name == SymbolAt.symbolAtRight.name ? true : false;
    await FireStoreUtils.addCurrency(currencyModel.value);
    await fetchCurrencyList();
    isLoading = false.obs;
  }

  Future<void> removeCurrency(CurrencyModel currencyModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.currencies).doc(currencyModel.id).delete().then((value) {
      ShowToastDialog.toast("Currency deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }
}
