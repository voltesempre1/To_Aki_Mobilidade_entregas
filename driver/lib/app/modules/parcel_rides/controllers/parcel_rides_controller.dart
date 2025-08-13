// ignore_for_file: unnecessary_overrides


import 'package:driver/app/models/parcel_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class ParcelRidesController extends GetxController {
  var selectedType = 0.obs;

  @override
  void onInit() {
    getData( isActiveDataFetch: true, isOngoingDataFetch: true, isCompletedDataFetch: true, isRejectedDataFetch: true);
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
  RxList<ParcelModel> activeRides = <ParcelModel>[].obs;
  RxList<ParcelModel> ongoingRides = <ParcelModel>[].obs;
  RxList<ParcelModel> completedRides = <ParcelModel>[].obs;
  RxList<ParcelModel> rejectedRides = <ParcelModel>[].obs;

  Future<void> getData({ required bool isActiveDataFetch  , required bool isOngoingDataFetch, required bool isCompletedDataFetch, required bool isRejectedDataFetch}) async {
    if(isActiveDataFetch){
      FireStoreUtils.getParcelActiveRides((List<ParcelModel> updatedList) {
        activeRides.value = updatedList;
      });
    }

    if (isOngoingDataFetch) {
      FireStoreUtils.getParcelOngoingRides((List<ParcelModel> updatedList) {
        ongoingRides.value = updatedList;

      });
    }
    if (isCompletedDataFetch) {
      FireStoreUtils.getParcelCompletedRides((List<ParcelModel> completeList) {
        completedRides.value = completeList;

      });
    }

    if (isRejectedDataFetch) {
      FireStoreUtils.getParcelRejectedRides((List<ParcelModel> rejectList) {
        rejectedRides.value = rejectList;
      });
    }
    isLoading.value = false;
  }
}
