import 'package:get/get.dart';

import '../controllers/intercity_reason_for_cancel_controller.dart';

class ReasonForCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityReasonForCancelController>(
      () => InterCityReasonForCancelController(),
    );
  }
}
