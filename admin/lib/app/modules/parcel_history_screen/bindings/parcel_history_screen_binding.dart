import 'package:get/get.dart';

import '../controllers/parcel_history_screen_controller.dart';

class ParcelHistoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParcelHistoryScreenController>(
      () => ParcelHistoryScreenController(),
    );
  }
}
