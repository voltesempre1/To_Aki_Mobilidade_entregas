import 'package:get/get.dart';

import '../controllers/statement_controller.dart';

class StatementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatementController>(
      () => StatementController(),
    );
  }
}
