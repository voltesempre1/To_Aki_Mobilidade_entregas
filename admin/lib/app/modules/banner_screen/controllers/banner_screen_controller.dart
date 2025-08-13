// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'dart:io';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/banner_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BannerScreenController extends GetxController {
  RxString title = "Banner".tr.obs;

  Rx<TextEditingController> bannerNameController = TextEditingController().obs;
  Rx<TextEditingController> bannerDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> bannerImageNameController = TextEditingController().obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  Rx<BannerModel> bannerModel = BannerModel().obs;

  RxBool isEditing = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;

  Rx<TextEditingController> offerTextController = TextEditingController().obs;
  RxBool isOfferBanner = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    bannerNameController.value.dispose();
    bannerDescriptionController.value.dispose();
    bannerImageNameController.value.dispose();
    offerTextController.value.dispose();
    super.onClose();
  }

  Future<void> getData() async {
    isLoading.value = true;
    bannerList.clear();
    try {
      final banners = await FireStoreUtils.getBanner();
      bannerList.assignAll(banners);
    } catch (e, stack) {
      log('Error fetching banners: $e\n$stack');
      ShowToast.errorToast('Failed to load banners');
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    bannerNameController.value.text = "";
    bannerDescriptionController.value.text = "";
    bannerImageNameController.value.text = "";
    isEditing.value = false;
    bannerNameController.value.clear();
    bannerDescriptionController.value.clear();
    bannerImageNameController.value.clear();
    imageFile.value = File('');
    mimeType.value = 'image/png';
    editingId.value = '';
    isEditing.value = false;
    isImageUpdated.value = false;
    imageURL.value = '';
    offerTextController.value.text = '';
    isOfferBanner.value = false;
  }

  Future<void> updateBanner(BuildContext context) async {
    Navigator.pop(context);
    isEditing.value = true;
    String docId = bannerModel.value.id!;
    if (imageFile.value.path.isNotEmpty) {
      String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "bannerImage", docId, mimeType.value);
      log('image url in update  $url');
      bannerModel.value.image = url;
    }
    bannerModel.value.bannerName = bannerNameController.value.text;
    bannerModel.value.bannerDescription = bannerDescriptionController.value.text;
    bannerModel.value.isOfferBanner = isOfferBanner.value;
    bannerModel.value.offerText = offerTextController.value.text;
    await FireStoreUtils.updateBanner(bannerModel.value);
    setDefaultData();
    await getData();
    isEditing.value = false;
  }

  Future<void> addBanner(BuildContext context) async {
    if (imageFile.value.path.isNotEmpty) {
      Navigator.pop(context);
      isLoading.value = true;
      String docId = Constant.getRandomString(20);
      String url = await FireStoreUtils.uploadPic(PickedFile(imageFile.value.path), "bannerImage", docId, mimeType.value);
      log('image url in addBanner  $url');
      bannerModel.value.id = docId;
      bannerModel.value.image = url;
      bannerModel.value.bannerName = bannerNameController.value.text;
      bannerModel.value.bannerDescription = bannerDescriptionController.value.text;
      bannerModel.value.isOfferBanner = isOfferBanner.value;

      bannerModel.value.offerText = offerTextController.value.text;

      await FireStoreUtils.addBanner(bannerModel.value);
      setDefaultData();
      await getData();
      isLoading.value = false;
    } else {
      ShowToastDialog.toast("Please select a valid banner image".tr);
    }
  }

  Future<void> removeBanner(BannerModel bannerModel) async {
    isLoading.value = true;
    await FirebaseFirestore.instance.collection(CollectionName.banner).doc(bannerModel.id).delete().then((value) {
      ShowToastDialog.toast("Banner deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading.value = false;
    getData();
  }
}
