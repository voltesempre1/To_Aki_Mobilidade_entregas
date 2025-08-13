// ignore_for_file: unnecessary_overrides

import 'dart:developer';
import 'dart:io';

import 'package:customer/constant/constant.dart';
import 'package:get/get.dart';
import 'package:customer/app/modules/home/views/home_view.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;

class PermissionController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> forceRequestPermissions() async {
    log("---> Requesting permissions");

    loc.Location location = loc.Location();

    loc.PermissionStatus permissionStatus = await location.requestPermission();

    if (permissionStatus == loc.PermissionStatus.granted) {
      bool isBackgroundPermissionGranted = await requestBackgroundLocationPermission();

      if (isBackgroundPermissionGranted) {
        if (Platform.isAndroid) {
          location.enableBackgroundMode(enable: true).then((value) {
            if (value) {
              Get.to(const HomeView());
            } else {
              ShowToastDialog.showToast("Please enable background mode");
            }
          });
        } else {
          Get.to(const HomeView());
        }
      } else {
        ShowToastDialog.showToast("Background location permission denied. Please allow access for all the time.");
        await Constant.showDialogToOpenSettings();
      }
    } else {
      ShowToastDialog.showToast("Location permission denied. Please allow access.");
      await Constant.showDialogToOpenSettings();
    }
  }

  Future<bool> requestBackgroundLocationPermission() async {
    if (Platform.isAndroid) {
      var backgroundPermissionStatus = await perm.Permission.locationAlways.status;
      if (backgroundPermissionStatus != perm.PermissionStatus.granted) {
        backgroundPermissionStatus = await perm.Permission.locationAlways.request();
      }
      return backgroundPermissionStatus == perm.PermissionStatus.granted;
    }
    return true;
  }
}
