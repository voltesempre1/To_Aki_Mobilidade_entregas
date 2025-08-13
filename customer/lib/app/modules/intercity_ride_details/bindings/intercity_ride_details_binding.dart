import 'package:get/get.dart';

import '../controllers/intercity_ride_details_controller.dart';

class MyRideDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityRideDetailsController>(
      () => InterCityRideDetailsController(),
    );
  }
}
