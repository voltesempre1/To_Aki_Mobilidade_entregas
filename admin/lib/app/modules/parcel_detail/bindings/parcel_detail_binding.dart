import 'package:get/get.dart';

import '../controllers/parcel_detail_controller.dart';

class ParcelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelDetailController>(
      () => ParcelDetailController(),
    );
  }
}
