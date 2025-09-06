import 'package:get/get.dart';

import '../controllers/email_signup_controller.dart';

class EmailSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailSignupController>(
      () => EmailSignupController(),
    );
  }
}