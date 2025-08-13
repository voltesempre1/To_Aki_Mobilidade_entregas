import 'package:get/get.dart';

import '../controllers/cab_ride_details_controller.dart';

class CabRideDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CabRideDetailsController>(
      () => CabRideDetailsController(),
    );
  }
}
