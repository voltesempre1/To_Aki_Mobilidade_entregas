import 'package:admin/app/modules/subscription_history/controllers/subscription_history_controller.dart';
import 'package:get/get.dart';

class SubscriptionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionHistoryController>(() => SubscriptionHistoryController());
  }
}
