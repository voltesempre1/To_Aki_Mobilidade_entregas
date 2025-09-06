import 'dart:developer';

import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxBool isLoading = false.obs;
  RxBool emailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      final email = emailController.text.trim();
      log('🔐 Attempting to send password reset email to: $email');

      isLoading.value = true;
      ShowToastDialog.showLoader("Sending email...".tr);

      // Simple call without ActionCodeSettings to avoid domain authorization issues
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      log('✅ Password reset email sent successfully to: $email');

      isLoading.value = false;
      emailSent.value = true;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Password reset email sent successfully".tr);

      update();
    } on FirebaseAuthException catch (e) {
      log('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      isLoading.value = false;
      ShowToastDialog.closeLoader();

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email address'.tr;
          log('⚠️ User not found for email: ${emailController.text.trim()}');
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address'.tr;
          log('⚠️ Invalid email format: ${emailController.text.trim()}');
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later'.tr;
          log('⚠️ Too many requests for email: ${emailController.text.trim()}');
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection'.tr;
          log('⚠️ Network error while sending reset email');
          break;
        case 'missing-email':
          errorMessage = 'Email address is required'.tr;
          log('⚠️ Missing email address');
          break;
        default:
          errorMessage = e.message ?? 'Failed to send reset email'.tr;
          log('⚠️ Unknown Firebase error: ${e.code} - ${e.message}');
      }

      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      log('💥 General error: $e');
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Something went wrong!'.tr);
    }
  }

  // Alternative simpler method for debugging
  Future<void> sendPasswordResetEmailSimple() async {
    try {
      final email = emailController.text.trim();
      log('🔐 [SIMPLE] Attempting to send password reset email to: $email');

      isLoading.value = true;
      ShowToastDialog.showLoader("Sending email...".tr);

      // Simple call without ActionCodeSettings
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      log('✅ [SIMPLE] Password reset email sent successfully to: $email');

      isLoading.value = false;
      emailSent.value = true;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Password reset email sent successfully".tr);

      update();
    } on FirebaseAuthException catch (e) {
      log('❌ [SIMPLE] Firebase Auth Error: ${e.code} - ${e.message}');
      isLoading.value = false;
      ShowToastDialog.closeLoader();

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email address'.tr;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address'.tr;
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later'.tr;
          break;
        default:
          errorMessage = e.message ?? 'Failed to send reset email'.tr;
      }

      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      log('💥 [SIMPLE] General error: $e');
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Something went wrong!'.tr);
    }
  }

  void resendEmail() {
    emailSent.value = false;
    sendPasswordResetEmail();
  }

  void backToLogin() {
    Get.back();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email".tr;
    }
    if (!GetUtils.isEmail(value)) {
      return "Please enter a valid email".tr;
    }
    return null;
  }
}
