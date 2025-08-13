import 'package:customer/app/modules/intercity_rides/controllers/intercityl_rides_controller.dart';
import 'package:get/get.dart';

class ParcelRidesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterCityRidesController>(
      () => InterCityRidesController(),
    );
  }
}
