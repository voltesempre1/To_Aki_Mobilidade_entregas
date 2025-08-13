import 'package:get/get.dart';

import '../controllers/otp_parcel_screen_controller.dart';

class OtpInterCityScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpParcelScreenController>(
      () => OtpParcelScreenController(),
    );
  }
}
