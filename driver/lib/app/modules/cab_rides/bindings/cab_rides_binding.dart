import 'package:get/get.dart';

import '../controllers/cab_rides_controller.dart';

class CabRidesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CabRidesController>(
      () => CabRidesController(),
    );
  }
}
