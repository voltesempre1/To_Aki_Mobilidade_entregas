// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/admin_model.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/show_toast.dart' show ShowToastDialog;

class LoginPageController extends GetxController {
  var isPasswordVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  RxString password = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
    // _initializeData();
  }

  Future<void> checkAndLoginOrCreateAdmin() async {
    ShowToastDialog.showLoader("Please wait...".tr);

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      final adminSnapshot = await FirebaseFirestore.instance.collection(CollectionName.admin).get();

      if (adminSnapshot.docs.isEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        AdminModel adminModel = AdminModel(
          email: email,
          name: "",
          image: "",
          contactNumber: "",
          isDemo: false,
        );

        Constant.isDemoSet(adminModel);

        await FirebaseFirestore.instance
            .collection(CollectionName.admin)
            .doc(userCredential.user!.uid)
            .set(adminModel.toJson());

        ShowToast.successToast("logged in successfully!".tr);
        ShowToastDialog.closeLoader();
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      } else {
        // Normal login flow
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) async {
          final AdminModel? adminData = await FireStoreUtils.getAdminProfile(value.user!.uid);

          if (adminData != null) {
            Constant.isLogin = await FireStoreUtils.isLogin();
            Constant.isDemoSet(adminData);

            ShowToastDialog.closeLoader();
            ShowToast.successToast("Logged in successfully!".tr);
            Get.offAllNamed(Routes.DASHBOARD_SCREEN);
          } else {
            await FirebaseAuth.instance.signOut();
            ShowToastDialog.closeLoader();
            ShowToast.errorToast("Admin not active or unauthorized.".tr);
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is invalid.'.tr;
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.'.tr;
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.'.tr;
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.'.tr;
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.'.tr;
          break;
        case 'invalid-credential':
          errorMessage = 'Email or password is invalid.'.tr;
          break;
        case 'weak-password':
          errorMessage = 'Password should be at least 6 characters.'.tr;
          break;
        default:
          errorMessage = 'Login failed. Please try again.'.tr;
      }

      ShowToast.errorToast(errorMessage);
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToast.errorToast("Something went wrong. Please try again.".tr);
    }
  }

  Future<void> getData() async {
    // email.value = Constant.adminModel!.name.toString();
    // password.value = Constant.adminModel!.password.toString();
    await Constant.getCurrencyData();
    await Constant.getLanguageData();
  }
}
