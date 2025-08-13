import 'package:get/get.dart';

import '../controllers/offers_screen_controller.dart';

class OffersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OffersScreenController>(
      () => OffersScreenController(),
    );
  }
}
