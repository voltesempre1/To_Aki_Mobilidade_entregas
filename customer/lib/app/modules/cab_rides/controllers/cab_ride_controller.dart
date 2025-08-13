// ignore_for_file: unnecessary_overrides

import 'package:customer/app/models/booking_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class CabRideController extends GetxController {
  var selectedType = 0.obs;

  @override
  void onInit() {
    getData(isOngoingDataFetch: true, isCompletedDataFetch: true, isRejectedDataFetch: true);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxBool isLoading = true.obs;
  RxList<BookingModel> ongoingRides = <BookingModel>[].obs;
  RxList<BookingModel> completedRides = <BookingModel>[].obs;
  RxList<BookingModel> rejectedRides = <BookingModel>[].obs;

  Future<void> getData({required bool isOngoingDataFetch, required bool isCompletedDataFetch, required bool isRejectedDataFetch}) async {
    isLoading.value = true;
    final List<Future<void>> fetchTasks = [];
    if (isOngoingDataFetch) {
      FireStoreUtils.getOngoingRides((List<BookingModel> updatedList) {
        ongoingRides.value = updatedList;
      });
    }
    if (isCompletedDataFetch) {
      FireStoreUtils.getCompletedRides((List<BookingModel> completeList) {
        completedRides.value = completeList;
      });
    }
    if (isRejectedDataFetch) {
      FireStoreUtils.getRejectedRides((List<BookingModel> rejectList) {
        rejectedRides.value = rejectList;
      });
    }
    await Future.wait(fetchTasks);
    isLoading.value = false;
  }
}
