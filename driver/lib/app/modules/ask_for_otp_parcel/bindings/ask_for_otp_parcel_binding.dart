import 'package:get/get.dart';

import '../controllers/ask_for_otp_parcel_controller.dart';

class AskForOtpParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AskForOtpParcelController>(
      () => AskForOtpParcelController(),
    );
  }
}
