import 'package:get/get.dart';

import '../controllers/book_parcel_controller.dart';

class BookParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookParcelController>(
      () => BookParcelController(),
    );
  }
}
