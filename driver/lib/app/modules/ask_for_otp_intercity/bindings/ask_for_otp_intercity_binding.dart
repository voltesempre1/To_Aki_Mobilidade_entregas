import 'package:get/get.dart';

import '../controllers/ask_for_otp_intercity_controller.dart';

class AskForOtpIntercityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AskForOtpInterCityController>(
      () => AskForOtpInterCityController(),
    );
  }
}
