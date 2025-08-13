import 'package:admin/app/modules/support_ticket_screen/controllers/support_ticket_screen_controller.dart';
import 'package:get/get.dart';

class SupportTicketScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportTicketScreenController>(() => SupportTicketScreenController());
  }
}
