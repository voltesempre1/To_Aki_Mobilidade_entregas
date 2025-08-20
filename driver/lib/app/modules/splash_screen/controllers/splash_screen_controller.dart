// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:driver/app/modules/subscription_plan/views/subscription_plan_view.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/intro_screen/views/intro_screen_view.dart';
import 'package:driver/app/modules/login/views/login_view.dart';
import 'package:driver/app/modules/permission/views/permission_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> redirectScreen() async {
    if ((await Preferences.getBoolean(Preferences.isFinishOnBoardingKey)) == false) {
      Get.offAll(const IntroScreenView());
    } else {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin == true) {
        DriverUserModel? userModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid());
        if (userModel != null && userModel.isVerified == true) {
          debugPrint("=====>");
          debugPrint(Constant.isSubscriptionEnable.toString());
          if (Constant.isSubscriptionEnable == true) {
            if (userModel.subscriptionPlanId != null && userModel.subscriptionPlanId!.isNotEmpty) {
              if (userModel.subscriptionExpiryDate!.toDate().isAfter(DateTime.now())) {
                bool permissionGiven = await Constant.isPermissionApplied();
                if (permissionGiven) {
                  Get.offAll(const HomeView());
                } else {
                  Get.offAll(const PermissionView());
                }
              } else {
                Get.offAll(SubscriptionPlanView());
              }
            } else {
              Get.offAll(SubscriptionPlanView());
            }
          } else {
            Get.offAll(HomeView());
          }
        } else {
          Get.offAll(const VerifyDocumentsView(isFromDrawer: false));
        }
      } else {
        Get.offAll(const LoginView());
      }
    }
  }
}
