// ignore_for_file: unnecessary_overrides
import 'package:get/get.dart';
import 'package:customer/app/models/coupon_model.dart';
import 'package:customer/utils/fire_store_utils.dart';

class CouponScreenController extends GetxController {
  RxList<CouponModel> couponList = <CouponModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getCouponList();
    super.onInit();
  }

  Future<void> getCouponList() async {
    final value = await FireStoreUtils.getCoupon();
    if (value != null) {
      couponList.value = value;
    }
    isLoading.value = false;
  }
}
