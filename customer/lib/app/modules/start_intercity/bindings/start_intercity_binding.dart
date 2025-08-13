import 'package:get/get.dart';

import '../controllers/start_intercity_controller.dart';

class StartIntercityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartIntercityController>(
      () => StartIntercityController(),
    );
  }
}
