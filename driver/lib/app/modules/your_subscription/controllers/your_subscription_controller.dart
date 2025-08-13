import 'package:driver/app/models/subscription_plan_history.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourSubscriptionController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<SubscriptionHistoryModel> subscriptionHistory = <SubscriptionHistoryModel>[].obs;

  @override
  void onInit() {
    getSubscription();
    super.onInit();
  }

  Future<void> getSubscription() async {
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection(CollectionName.subscriptionHistory)
        .where("driverId", isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((event) {
      subscriptionHistory.value = event.docs.map((doc) => SubscriptionHistoryModel.fromJson(doc.data())).toList();
      isLoading.value = false;
    });
  }
}
