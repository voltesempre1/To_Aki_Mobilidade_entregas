import 'package:get/get.dart';
import 'package:admin/app/modules/support_reason/controllers/support_reason_controller.dart';

class SupportReasonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportReasonController>(() => SupportReasonController());
  }
}
