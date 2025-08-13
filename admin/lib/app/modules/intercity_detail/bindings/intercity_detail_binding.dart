import 'package:get/get.dart';

import '../controllers/intercity_detail_controller.dart';

class InterCityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityDetailController>(
      () => InterCityDetailController(),
    );
  }
}
