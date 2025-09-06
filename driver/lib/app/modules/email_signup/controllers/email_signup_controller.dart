import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/signup/views/signup_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailSignupController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update();
  }

  Future<void> signupWithEmail() async {
    try {
      ShowToastDialog.showLoader("please_wait".tr);

      // Criar conta no Firebase Auth
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      ShowToastDialog.closeLoader();

      if (credential.user != null) {
        // Criar modelo do usuário
        DriverUserModel userModel = DriverUserModel();
        userModel.id = credential.user!.uid;
        userModel.email = credential.user!.email;
        userModel.fullName = "";
        userModel.loginType = Constant.emailLoginType;

        // Navegar para a tela de signup para completar os dados
        Get.to(() => const SignupView(), arguments: {
          "userModel": userModel,
        });
      }
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();

      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.'.tr;
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.'.tr;
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.'.tr;
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.'.tr;
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during signup.'.tr;
      }

      ShowToastDialog.showToast(errorMessage);
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Something went wrong!'.tr);
    }
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password".tr;
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters".tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password".tr;
    }
    if (value != passwordController.text) {
      return "Passwords do not match".tr;
    }
    return null;
  }
}
