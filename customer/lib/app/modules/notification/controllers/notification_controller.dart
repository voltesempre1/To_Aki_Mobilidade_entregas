// ignore_for_file: unnecessary_overrides

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/notification_model.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  Future<void> getNotification() async {
    final value = await FireStoreUtils.getNotificationList();
    if (value != null) {
      notificationList.assignAll(value);
    }
  }

  Future<void> removeNotification(String id) async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.notification).doc(id).delete();
      ShowToastDialog.showToast("Notification deleted successfully");
    } catch (error) {
      ShowToastDialog.showToast("Failed to delete notification, Try again after some time.");
    }
  }
}
