import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'utils/fire_store_utils.dart';

class GlobalController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    await getData();
    Constant.getLanguageData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = false;

    bool isLogin = await FireStoreUtils.isLogin();
    if (Get.currentRoute != Routes.ERROR_SCREEN) {
      if (!isLogin) {
        Get.offAllNamed(Routes.LOGIN_PAGE);
      } else {
        FireStoreUtils.getAdmin().then(
          (value) {
            if (value != null) {
              Constant.isDemoSet(value);
            }
          },
        );
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      }
    }
  }
}
