// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/tax_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

class TaxController extends GetxController {
  RxString title = "Tax".tr.obs;

  Rx<TextEditingController> taxTitle = TextEditingController().obs;
  Rx<TextEditingController> taxAmount = TextEditingController().obs;
  Rx<bool> isActive = true.obs;
  RxString selectedCountry = "India".obs;

  List<String> taxType = ["Percentage", "Fix"];
  RxString selectedTaxType = "Percentage".obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxList<TaxModel> taxesList = <TaxModel>[].obs;
  Rx<TaxModel> taxModel = TaxModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    taxesList.clear();
    try {
      List<TaxModel>? data = await FireStoreUtils.getTax();
      if (data != null) {
        taxesList.addAll(data);
      }
    } catch (e) {
      ShowToastDialog.toast("Failed to fetch tax data");
    } finally {
      isLoading(false);
    }
  }

  void setDefaultData() {
    selectedCountry.value = "India";
    selectedTaxType.value = "Fix";
    taxTitle.value.text = "";
    taxAmount.value.text = "";
    isEditing.value = false;
    isLoading.value = false;
  }

  Future<void> updateTax() async {
    taxModel.value.active = isActive.value;
    taxModel.value.country = selectedCountry.value;
    taxModel.value.isFix = selectedTaxType.value == "Fix" ? true : false;
    taxModel.value.name = taxTitle.value.text;
    taxModel.value.value = taxAmount.value.text;
    await FireStoreUtils.updateTax(taxModel.value);
    await getData();
  }

  Future<void> addTax() async {
    isLoading = true.obs;
    taxModel.value.id = Constant.getRandomString(20);
    taxModel.value.active = isActive.value;
    taxModel.value.country = selectedCountry.value;
    taxModel.value.isFix = selectedTaxType.value == "Fix" ? true : false;
    taxModel.value.name = taxTitle.value.text;
    taxModel.value.value = taxAmount.value.text;
    await FireStoreUtils.addTaxes(taxModel.value);
    await getData();

    isLoading = false.obs;
  }

  Future<void> removeTax(TaxModel taxModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.countryTax).doc(taxModel.id).delete().then((value) {
      ShowToastDialog.toast("Country Tax deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }
}
