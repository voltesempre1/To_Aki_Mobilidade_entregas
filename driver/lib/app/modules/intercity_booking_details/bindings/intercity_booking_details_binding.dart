import 'package:get/get.dart';

import '../controllers/intercity_booking_details_controller.dart';

class InterCityBookingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityBookingDetailsController>(
      () => InterCityBookingDetailsController(),
    );
  }
}
