import 'package:get/get.dart';

import '../controllers/track_parcel_ride_screen_controller.dart';

class ParcelRideScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelRideScreenController>(
      () => ParcelRideScreenController(),
    );
  }
}
