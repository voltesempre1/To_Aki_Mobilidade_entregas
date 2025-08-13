import 'package:get/get.dart';

import '../controllers/intercity_service_controller.dart';

class IntercityServiceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntercityServiceController>(
      () => IntercityServiceController(),
    );
  }
}
