import 'package:get/get.dart';

import '../controllers/verify_driver_screen_controller.dart';

class VerifyDocumentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyDriverScreenController>(
      () => VerifyDriverScreenController(),
    );
  }
}
