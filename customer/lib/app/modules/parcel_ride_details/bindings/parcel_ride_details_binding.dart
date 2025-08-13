import 'package:get/get.dart';

import '../controllers/parcel_ride_details_controller.dart';

class ParcelRideDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelRideDetailsController>(
      () => ParcelRideDetailsController(),
    );
  }
}
