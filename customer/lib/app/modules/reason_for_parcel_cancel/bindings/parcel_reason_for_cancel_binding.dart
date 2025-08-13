import 'package:get/get.dart';

import '../controllers/parcel_reason_for_cancel_controller.dart';

class ParcelReasonForCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelReasonForCancelController>(
      () => ParcelReasonForCancelController(),
    );
  }
}
