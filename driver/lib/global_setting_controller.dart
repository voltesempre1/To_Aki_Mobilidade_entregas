import 'dart:developer';

import 'package:driver/app/models/currencies_model.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/extension/hax_color_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:driver/utils/preferences.dart';
import 'package:get/get.dart';

import 'services/localization_service.dart';

class GlobalSettingController extends GetxController {
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    notificationInit();
    await getInterCityService();
    await getCurrentCurrency();
    await getVehicleTypeList();
    await getLanguage();
    isLoading.value = false;
    update();
  }

  Future<void> getInterCityService() async {
    await FireStoreUtils.fetchIntercityService();
  }

  Future<void> getCurrentCurrency() async {
    await FireStoreUtils().getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(
          id: "",
          code: "USD",
          decimalDigits: 2,
          active: true,
          name: "US Dollar",
          symbol: "\$",
          symbolAtRight: false,
        );
      }
    });
    await FireStoreUtils().getAdminCommission();
    await FireStoreUtils().getPayment();
    await FireStoreUtils().getSettings();

    AppThemData.primary500 = HexColor.fromHex(Constant.appColor.toString());
  }

  Future<void> getVehicleTypeList() async {
    await FireStoreUtils.getVehicleType().then((value) {
      Constant.vehicleTypeList = value;
    });
  }

  Future<void> getLanguage() async {
    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = await Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.code.toString());
    } else {
      LanguageModel languageModel = LanguageModel(
        id: "CcrGiUvJbPTXaU31s5l8",
        name: "English",
        code: "en",
      );
      LocalizationService().changeLocale(languageModel.code.toString());
    }
  }

  NotificationService notificationService = NotificationService();

  void notificationInit() {
    notificationService.initInfo().then((_) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      // final currentUser = FirebaseAuth.instance.currentUser;
      // if (currentUser != null) {
      //   final userModel = await FireStoreUtils.getDriverUserProfile(currentUser.uid);
      //   if (userModel != null) {
      //     userModel.fcmToken = token;
      //     Constant.userModel = userModel;
      //     await FireStoreUtils.updateDriverUser(userModel);
      //   }
      // }
    });
  }
}
