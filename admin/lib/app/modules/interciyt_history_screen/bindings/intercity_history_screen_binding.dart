import 'package:get/get.dart';

import '../controllers/intercity_history_screen_controller.dart';

class InterCityHistoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityHistoryScreenController>(
      () => InterCityHistoryScreenController(),
    );
  }
}
