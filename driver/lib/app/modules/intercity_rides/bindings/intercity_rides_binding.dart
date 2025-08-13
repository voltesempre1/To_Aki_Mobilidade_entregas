import 'package:get/get.dart';

import '../controllers/intercity_rides_controller.dart';

class InterCityRidesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityRidesController>(
      () => InterCityRidesController(),
    );
  }
}
