import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/contact_us_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';

class ContactUsController extends GetxController {
  RxString title = "Contact Us".tr.obs;

  Rx<TextEditingController> emailSubjectController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;

  Rx<ContactUsModel> contactUsModel = ContactUsModel().obs;

  void setContactData() {
    if (_isAnyFieldEmpty()) {
      ShowToast.errorToast("Please fill all data".tr);
      return;
    }
    Constant.waitingLoader();
    contactUsModel.value.emailSubject = emailSubjectController.value.text;
    contactUsModel.value.email = emailController.value.text;
    contactUsModel.value.phoneNumber = phoneNumberController.value.text;
    contactUsModel.value.address = addressController.value.text;
    FireStoreUtils.setContactusSetting(contactUsModel.value).then((value) {
      Get.back();
      ShowToast.successToast("Contact data updated".tr);
    }).catchError((e) {
      ShowToast.errorToast("Failed to update contact data".tr);
    });
  }

  void getContactData() {
    FireStoreUtils.getContactusSetting().then((value) {
      if (value != null) {
        contactUsModel.value = value;
        emailSubjectController.value.text = value.emailSubject ?? '';
        emailController.value.text = value.email ?? '';
        phoneNumberController.value.text = value.phoneNumber ?? '';
        addressController.value.text = value.address ?? '';
      } else {
        _clearControllers();
      }
    }).catchError((e) {
      ShowToast.errorToast("Failed to load contact data".tr);
      _clearControllers();
    });
  }

  bool _isAnyFieldEmpty() {
    return emailSubjectController.value.text.isEmpty || emailController.value.text.isEmpty || phoneNumberController.value.text.isEmpty || addressController.value.text.isEmpty;
  }

  void _clearControllers() {
    emailSubjectController.value.clear();
    emailController.value.clear();
    phoneNumberController.value.clear();
    addressController.value.clear();
  }
}
