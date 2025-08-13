import 'package:get/get.dart';

import '../controllers/parcel_booking_details_controller.dart';

class ParcelBookingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelBookingDetailsController>(
      () => ParcelBookingDetailsController(),
    );
  }
}
