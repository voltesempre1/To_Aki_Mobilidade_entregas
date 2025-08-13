import 'package:get/get.dart';

import '../controllers/book_intercity_controller.dart';

class BookIntercityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookIntercityController>(
      () => BookIntercityController(),
    );
  }
}
