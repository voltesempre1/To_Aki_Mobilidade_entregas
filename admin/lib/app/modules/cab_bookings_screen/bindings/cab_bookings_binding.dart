import 'package:get/get.dart';

import '../controllers/cab_booking_controller.dart';

class CabBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CabBookingController>(
      () => CabBookingController(),
    );
  }
}
