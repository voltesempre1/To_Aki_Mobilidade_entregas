import 'package:customer/app/models/support_ticket_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  RxList<SupportTicketModel> supportTicketList = <SupportTicketModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    isLoading.value = true;
    final value = await FireStoreUtils.getSupportTicket(FirebaseAuth.instance.currentUser!.uid);
    supportTicketList.value = value;
    isLoading.value = false;
  }
}
