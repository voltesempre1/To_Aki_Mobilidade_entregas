import 'dart:developer';

import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/currencies_model.dart';
import 'package:customer/app/models/language_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/extension/hax_color_extension.dart';
import 'package:customer/services/localization_service.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    notificationInit();
    getCurrentCurrency();
    getLanguage();
    getInterCityService();
    getVehicleTypeList();
    // getTax();
    super.onInit();
  }

  Future<void> getCurrentCurrency() async {
    await FireStoreUtils().getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "USD", decimalDigits: 2, active: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
    await FireStoreUtils().getSettings();
    await FireStoreUtils().getPayment();
    AppThemData.primary500 = HexColor.fromHex(Constant.appColor.toString());
  }

  Future<void> getVehicleTypeList() async {
    await FireStoreUtils.getVehicleType().then((value) {
      Constant.vehicleTypeList = value;
        });
  }

  Future<void> getInterCityService() async {
    await FireStoreUtils.fetchIntercityService();
    List<VehicleTypeModel> allCabs = await FireStoreUtils.fetchAllCabServices();
    Constant.cabTimeSlotList.clear();
    Constant.cabTimeSlotList.addAll(allCabs);
  }

  NotificationService notificationService = NotificationService();

  void notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {
        final uid = FireStoreUtils.getCurrentUid();
        final userModel = await FireStoreUtils.getUserProfile(uid);
        if (userModel != null) {
          if (userModel.fcmToken != token) {
            userModel.fcmToken = token;
            Constant.userModel = userModel;
            await FireStoreUtils.updateUser(userModel);
          } else {
            Constant.userModel = userModel;
          }
        }
      }
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
}
