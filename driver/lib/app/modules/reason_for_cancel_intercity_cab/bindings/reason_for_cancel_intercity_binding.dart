import 'package:get/get.dart';

import '../controllers/reason_for_cancel_intercity_controller.dart';

class ReasonForCancelInterCityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReasonForCancelInterCityController>(
      () => ReasonForCancelInterCityController(),
    );
  }
}
