import 'package:customer/app/modules/cab_rides/controllers/cab_ride_controller.dart';
import 'package:get/get.dart';

class CabRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CabRideController>(
      () => CabRideController(),
    );
  }
}
