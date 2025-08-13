
import 'package:driver/app/models/support_ticket_model.dart';
import 'package:get/get.dart';

class SupportTicketDetailsController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<SupportTicketModel> supportTicketModel = SupportTicketModel().obs;

  @override
  void onInit() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null && argumentData["supportTicket"] != null) {
      supportTicketModel.value = argumentData["supportTicket"];
    }
    isLoading.value = false;
    super.onInit();
  }
}
