import 'package:get/get.dart';

import '../controllers/otp_intercity_screen_controller.dart';

class OtpInterCityScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpInterCityScreenController>(
      () => OtpInterCityScreenController(),
    );
  }
}
