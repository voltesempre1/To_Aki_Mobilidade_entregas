import 'package:driver/app/models/support_ticket_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  RxList<SupportTicketModel> supportTicketList = <SupportTicketModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    final tickets = await FireStoreUtils.getSupportTicket(FirebaseAuth.instance.currentUser!.uid);
    supportTicketList.value = tickets;
    isLoading.value = false;
  }
}
