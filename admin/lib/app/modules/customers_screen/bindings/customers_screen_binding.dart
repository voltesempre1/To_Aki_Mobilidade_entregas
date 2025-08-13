import 'package:get/get.dart';

import '../controllers/customers_screen_controller.dart';

class CustomersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomersScreenController>(
      () => CustomersScreenController(),
    );
  }
}
