import 'package:get/get.dart';

import '../controllers/cab_detail_controller.dart';

class CabDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CabDetailController>(
      () => CabDetailController(),
    );
  }
}
