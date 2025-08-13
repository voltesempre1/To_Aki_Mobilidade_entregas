import 'package:get/get.dart';

import '../controllers/track_intercity_ride_screen_controller.dart';

class TrackInterCityRideScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackInterCityRideScreenController>(
      () => TrackInterCityRideScreenController(),
    );
  }
}
