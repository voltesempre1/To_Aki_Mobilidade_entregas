import 'package:get/get.dart';

import '../controllers/parcel_rides_controller.dart';

class ParcelRidesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelRidesController>(
      () => ParcelRidesController(),
    );
  }
}
