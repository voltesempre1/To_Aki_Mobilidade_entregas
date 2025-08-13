import 'dart:developer';
import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;

class AboutAppController extends GetxController {
  final RxString title = 'About App'.tr.obs;
  final RxString result = ''.obs;
  final Rx<ConstantModel> constantModel = ConstantModel().obs;

  @override
  void onInit() {
    super.onInit();
    getSettingData();
  }

  Future<void> getSettingData() async {
    try {
      final value = await FireStoreUtils.getGeneralSetting();
      if (value != null && value.aboutApp != null) {
        final document = html_parser.parse(value.aboutApp!);
        // Extract only the text content, stripping all HTML tags
        result.value = document.body?.text.trim() ?? '';
        constantModel.value = value;
        log(result.value);
      } else {
        result.value = '';
      }
    } catch (e, stack) {
      log('Error fetching About App settings: $e\n$stack');
      result.value = '';
    }
  }
}
