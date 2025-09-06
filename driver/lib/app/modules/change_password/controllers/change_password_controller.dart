import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxBool isCurrentPasswordVisible = false.obs;
  RxBool isNewPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
    update();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update();
  }

  Future<void> changePassword() async {
    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("User not logged in".tr);
        return;
      }

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPasswordController.text);

      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Password updated successfully".tr);

      // Clear form and go back
      _clearForm();
      Get.back();
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();

      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect'.tr;
          break;
        case 'weak-password':
          errorMessage = 'New password is too weak'.tr;
          break;
        case 'requires-recent-login':
          errorMessage = 'Please login again before changing password'.tr;
          break;
        case 'user-disabled':
          errorMessage = 'User account has been disabled'.tr;
          break;
        case 'user-not-found':
          errorMessage = 'User not found'.tr;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address'.tr;
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later'.tr;
          break;
        default:
          errorMessage = e.message ?? 'Failed to update password'.tr;
      }

      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Something went wrong!'.tr);
    }
  }

  void _clearForm() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your current password".tr;
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a new password".tr;
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters".tr;
    }
    if (value == currentPasswordController.text) {
      return "New password must be different from current password".tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your new password".tr;
    }
    if (value != newPasswordController.text) {
      return "Passwords do not match".tr;
    }
    return null;
  }

  bool get isEmailUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    // Check if user has email/password provider
    return user.providerData.any((provider) => provider.providerId == 'password');
  }
}
