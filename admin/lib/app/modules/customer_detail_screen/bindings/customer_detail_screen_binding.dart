import 'package:get/get.dart';

import '../controllers/customer_detail_screen_controller.dart';

class CustomerDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDetailScreenController>(
      () => CustomerDetailScreenController(),
    );
  }
}
