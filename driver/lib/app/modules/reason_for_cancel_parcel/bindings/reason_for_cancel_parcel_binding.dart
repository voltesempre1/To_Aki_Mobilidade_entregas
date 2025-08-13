import 'package:get/get.dart';

import '../controllers/reason_for_cancel_parcel_controller.dart';

class ReasonForCancelParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReasonForCancelParcelController>(
      () => ReasonForCancelParcelController(),
    );
  }
}
