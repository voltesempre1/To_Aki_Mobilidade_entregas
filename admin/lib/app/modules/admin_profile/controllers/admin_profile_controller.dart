// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:developer';
import 'dart:io';

import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/modules/home/controllers/home_controller.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AdminProfileController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> profileFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordFromKey = GlobalKey<FormState>();

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> contactNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> passwordResetController = TextEditingController().obs;
  Rx<TextEditingController> currentPasswordController = TextEditingController().obs;
  final isPasswordVisible = true.obs;

  RxInt selectedTabIndex = 0.obs;

  HomeController homeController = Get.put(HomeController());
  RxString selectedTab = "profile".tr.obs;

  Rx<File> imagePath = File('').obs;

  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;

  RxBool uploading = false.obs;
  RxString title = "Change Password".tr.obs;
  RxString profileTitle = "Profile".obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() {
    FireStoreUtils.getAdmin().then((adminData) async {
      if (adminData != null) {
        nameController.value.text = adminData.name ?? '';
        contactNumberController.value.text = adminData.contactNumber ?? '';
        emailController.value.text = adminData.email ?? '';
        imageController.value.text = adminData.image ?? '';

        final response = await http.get(Uri.parse(adminData.image!));

        if (adminData.image != null && adminData.image!.isNotEmpty) {
          try {
            if (response.statusCode == 200) {
              imagePickedFileBytes.value = response.bodyBytes;
              imagePath.value = File('assets/image/logo.png');
            }
          } catch (e) {
            ShowToast.errorToast('failed to load profile image: $e');
          }
        }
      }
    }).catchError((e, stack) {
      log('Error fetching admin data: $e\n$stack');
    });
  }

  Future<void> pickPhoto() async {
    uploading.value = true;
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        uploading.value = false;
        return;
      }
      final imageFile = File(img.path);
      imageController.value.text = img.name;
      imagePath.value = imageFile;
      imagePickedFileBytes.value = await img.readAsBytes();
      mimeType.value = img.mimeType ?? 'image/png';
    } catch (e, stack) {
      log('Error picking photo: $e\n$stack');
    } finally {
      uploading.value = false;
    }
  }

  Future<void> setAdminData() async {
    if (!profileFromKey.currentState!.validate()) {
      return;
    }
    try {
      Constant.waitingLoader();
      User? currentUser = FirebaseAuth.instance.currentUser;
      String newEmail = emailController.value.text.trim();

      if (currentUser != null && currentUser.email != newEmail) {
        if (currentPasswordController.value.text.isEmpty) {
          ShowToastDialog.closeLoader();
          ShowToast.errorToast("Please enter your current password to update the email.".tr);
          return;
        }
        try {
          AuthCredential authCredential = EmailAuthProvider.credential(
            email: currentUser.email!,
            password: currentPasswordController.value.text,
          );

          await currentUser.reauthenticateWithCredential(authCredential);
          await currentUser.verifyBeforeUpdateEmail(emailController.value.text);

          ShowToastDialog.closeLoader();
          ShowToast.successToast("Verification email sent to ${emailController.value.text}. Please verify to complete the update.".tr);
          currentPasswordController.value.clear();
        } on FirebaseAuthException catch (e) {
          ShowToastDialog.closeLoader();
          if (e.code == 'wrong-password') {
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("Current password is incorrect.".tr);
          } else if (e.code == 'user-mismatch') {
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("User mismatch during reauthentication.".tr);
          } else if (e.code == 'invalid-credential') {
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("Password does not match with current password.".tr);
          } else if (e.code == 'user-not-found') {
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("User not found.".tr);
          } else if (e.code == 'requires-recent-login') {
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("Please login again to update your email.".tr);
          } else {
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("Reauthentication failed: ${e.message}".tr);
          }
          return;
        } catch (e) {
          ShowToastDialog.closeLoader();
          ShowToast.errorToast("Unexpected error during reauthentication: $e".tr);
          return;
        }
      }
      if (imagePath.value.path.isNotEmpty) {
        String? downloadUrl = await FireStoreUtils.uploadPic(
          PickedFile(imagePath.value.path),
          "admin",
          "${FireStoreUtils.getCurrentUid()}",
          mimeType.value,
        );
        Constant.adminModel!.image = downloadUrl;
      }
      Constant.adminModel!
        ..email = emailController.value.text
        ..name = nameController.value.text.trim()
        ..contactNumber = contactNumberController.value.text.trim();

      await FireStoreUtils.setAdmin(Constant.adminModel!);
      await FireStoreUtils.getAdmin();

      Get.back();
      ShowToast.successToast("Profile updated successfully.".tr);
    } catch (e) {
      log("Error updating profile: $e");
      ShowToastDialog.closeLoader();
      ShowToast.errorToast("Failed to update profile.".tr);
    }
  }

  Future<void> setAdminPassword() async {
    String email = passwordResetController.value.text.trim();
    try {
      Constant.waitingLoader();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
      ShowToast.successToast("Password reset link has been sent to $email.");
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        default:
          errorMessage = 'Failed to send password reset email.';
      }
      ShowToast.errorToast(errorMessage);
    } catch (e) {
      ShowToastDialog.closeLoader();
      log("Error in setAdminPassword: $e");
      ShowToast.errorToast("Failed to send password reset link".tr);
    }
  }
}
