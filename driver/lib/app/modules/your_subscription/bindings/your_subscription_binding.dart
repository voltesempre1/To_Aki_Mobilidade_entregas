import 'package:driver/app/modules/your_subscription/controllers/your_subscription_controller.dart';
import 'package:get/get.dart';

class YourSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourSubscriptionController>(() => YourSubscriptionController());
  }
}
