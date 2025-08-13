import 'package:get/get.dart';

import '../controllers/reason_for_cancel_cab_controller.dart';

class ReasonForCancelCabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReasonForCancelCabController>(
      () => ReasonForCancelCabController(),
    );
  }
}
