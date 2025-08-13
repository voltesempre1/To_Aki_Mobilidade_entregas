import 'package:driver/app/modules/search_intercity_ride/controllers/search_ride_controller.dart';
import 'package:get/get.dart';


class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchRideController>(
      () => SearchRideController(),
    );
  }
}
