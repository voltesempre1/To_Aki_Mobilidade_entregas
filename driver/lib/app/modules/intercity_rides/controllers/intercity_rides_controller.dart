// ignore_for_file: unnecessary_overrides

import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class InterCityRidesController extends GetxController {
  var selectedType = 0.obs;

  @override
  void onInit() {
    getData(isActiveDataFetch: true, isOngoingDataFetch: true, isCompletedDataFetch: true, isRejectedDataFetch: true);
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

  RxList<IntercityModel> activeRides = <IntercityModel>[].obs;
  RxList<IntercityModel> ongoingRides = <IntercityModel>[].obs;
  RxList<IntercityModel> completedRides = <IntercityModel>[].obs;
  RxList<IntercityModel> rejectedRides = <IntercityModel>[].obs;

  Future<void> getData({required bool isActiveDataFetch, required bool isOngoingDataFetch, required bool isCompletedDataFetch, required bool isRejectedDataFetch}) async {
    if (isActiveDataFetch) {
      FireStoreUtils.getInterCityActiveRides((List<IntercityModel> updatedList) {
        activeRides.value = updatedList;
      });
    }

    if (isOngoingDataFetch) {
      FireStoreUtils.getInterCityOngoingRides((List<IntercityModel> updatedList) {
        ongoingRides.value = updatedList;
      });
    }
    if (isCompletedDataFetch) {
      FireStoreUtils.getInterCityCompletedRides((List<IntercityModel> completeList) {
        completedRides.value = completeList;
      });
    }

    if (isRejectedDataFetch) {
      FireStoreUtils.getInterCityRejectedRides((List<IntercityModel> rejectList) {
        rejectedRides.value = rejectList;
      });
    }
    isLoading.value = false;
  }
}
