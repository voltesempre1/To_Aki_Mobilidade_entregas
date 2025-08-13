import 'package:get/get.dart';

import '../controllers/track_parcel_ride_screen_controller.dart';

class TrackParcelRideScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackParcelRideScreenController>(
      () => TrackParcelRideScreenController(),
    );
  }
}
