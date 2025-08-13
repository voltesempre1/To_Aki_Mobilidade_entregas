import 'package:get/get.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';

class LanguageController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    final data = await FireStoreUtils.getLanguage();
    languageList.assignAll(data);
    final temp = await Constant.getLanguage();
    final idx = languageList.indexWhere((element) => element.id == temp.id);
    if (idx != -1) {
      selectedLanguage.value = languageList[idx];
    } else if (languageList.isNotEmpty) {
      selectedLanguage.value = languageList.first;
    }
    isLoading(false);
  }
}
