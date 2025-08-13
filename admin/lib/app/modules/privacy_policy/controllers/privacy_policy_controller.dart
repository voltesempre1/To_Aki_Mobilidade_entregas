import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  RxString title = "Privacy Policy".tr.obs;

  RxString result = ''.obs;
  RxString parsedString = ''.obs;

  Rx<ConstantModel> constantModel = ConstantModel().obs;

  Future<void> getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) {
      if (value != null) {
        constantModel.value = value;
      }
    });
  }

}
