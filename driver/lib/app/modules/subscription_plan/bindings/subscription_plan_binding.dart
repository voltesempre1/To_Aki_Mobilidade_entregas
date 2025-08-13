import 'package:driver/app/modules/subscription_plan/controllers/subscription_plan_controller.dart';
import 'package:get/get.dart';

class SubscriptionPlanBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionPlanController>(()=>SubscriptionPlanController());
  }
}