import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/admin_commission_model.dart';
import 'package:admin/app/models/constant_model.dart';
import 'package:admin/app/models/global_value_model.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/toast.dart';

class AppSettingsController extends GetxController {
  Rx<TextEditingController> adminCommissionController = TextEditingController().obs;
  Rx<TextEditingController> minimumDepositController = TextEditingController().obs;
  Rx<TextEditingController> minimumAmountAcceptRideController = TextEditingController().obs;
  Rx<TextEditingController> minimumWithdrawalController = TextEditingController().obs;
  Rx<TextEditingController> referralAmountController = TextEditingController().obs;
  Rx<TextEditingController> mapRadiusController = TextEditingController().obs;
  Rx<TextEditingController> appNameController = TextEditingController().obs;
  Rx<TextEditingController> colourCodeController = TextEditingController().obs;
  Rx<TextEditingController> globalDistanceTypeController = TextEditingController().obs;
  Rx<TextEditingController> globalDriverLocationUpdateController = TextEditingController().obs;
  Rx<TextEditingController> globalRadiusController = TextEditingController().obs;
  Rx<TextEditingController> globalInterCityRadiusController = TextEditingController().obs;
  Rx<TextEditingController> secondsForRideCancelController = TextEditingController().obs;

  Rx<Color> selectedColor = AppThemData.primary500.obs;

  Rx<AdminCommission> adminCommissionModel = AdminCommission().obs;
  Rx<ConstantModel> currencyModel = ConstantModel().obs;
  Rx<ConstantModel> constantModel = ConstantModel().obs;
  Rx<GlobalValueModel> globalValueModel = GlobalValueModel().obs;

  Rx<Status> isActive = Status.active.obs;
  Rx<Status> isGstActive = Status.active.obs;
  Rx<Status> isSubscriptionActive = Status.active.obs;
  Rx<Status> isDocumentVerificationActive = Status.active.obs;

  List<String> adminCommissionType = ["Fix", "Percentage"];
  RxString selectedAdminCommissionType = "Fix".obs;

  List<String> distanceType = ["Km", "Miles "];
  RxString selectedDistanceType = "Km".obs;

  RxString title = "App Setting".tr.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    adminCommissionController.value.dispose();
    minimumDepositController.value.dispose();
    minimumAmountAcceptRideController.value.dispose();
    minimumWithdrawalController.value.dispose();
    referralAmountController.value.dispose();
    mapRadiusController.value.dispose();
    appNameController.value.dispose();
    colourCodeController.value.dispose();
    globalDistanceTypeController.value.dispose();
    globalDriverLocationUpdateController.value.dispose();
    globalRadiusController.value.dispose();
    globalInterCityRadiusController.value.dispose();
    secondsForRideCancelController.value.dispose();
    super.onClose();
  }

  Future<void> getData() async {
    isLoading(true);
    await getAdminCommissionData();
    await getSettingData();
    await getGlobalValueSetting();
    isLoading(false);
  }

  Future<void> getAdminCommissionData() async {
    await FireStoreUtils.getAdminCommission().then((value) {
      if (value != null) {
        adminCommissionModel.value = value;
        adminCommissionController.value.text = adminCommissionModel.value.value!;
        selectedAdminCommissionType.value = adminCommissionModel.value.isFix == true ? "Fix" : "Percentage";
        isActive.value = adminCommissionModel.value.active == true ? Status.active : Status.inactive;
      }
    });
  }

  Future<void> getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) {
      if (value != null) {
        constantModel.value = value;
        minimumDepositController.value.text = constantModel.value.minimumAmountDeposit!;
        minimumWithdrawalController.value.text = constantModel.value.minimumAmountWithdraw!;
        colourCodeController.value.text = constantModel.value.appColor!;
        globalInterCityRadiusController.value.text = constantModel.value.interCityRadius!;
        appNameController.value.text = constantModel.value.appName!;
        selectedColor.value = HexColor.fromHex(colourCodeController.value.text);
        isSubscriptionActive.value = constantModel.value.isSubscriptionEnable == true ? Status.active : Status.inactive;
        isDocumentVerificationActive.value = constantModel.value.isDocumentVerificationEnable == true ? Status.active : Status.inactive;
        secondsForRideCancelController.value.text = constantModel.value.secondsForRideCancel!;
      }
    });
  }

  Future<void> getGlobalValueSetting() async {
    await FireStoreUtils.getGlobalValueSetting().then((value) {
      if (value != null) {
        globalValueModel.value = value;
        globalDistanceTypeController.value.text = globalValueModel.value.distanceType!;
        globalDriverLocationUpdateController.value.text = globalValueModel.value.driverLocationUpdate!;
        minimumAmountAcceptRideController.value.text = globalValueModel.value.minimumAmountAcceptRide!;

        globalRadiusController.value.text = globalValueModel.value.radius!;
      }
    });
  }

  dynamic saveSettingData() {
    if (selectedAdminCommissionType.isEmpty) {
      return ShowToast.errorToast(" Please Add Information".tr);
    } else if (adminCommissionController.value.text.isEmpty || adminCommissionController.value.text == "") {
      return ShowToast.errorToast(" Please Add Admin Commission".tr);
    } else if (minimumDepositController.value.text.isEmpty || minimumDepositController.value.text == "") {
      return ShowToast.errorToast(" Please Add Deposit".tr);
    } else if (minimumWithdrawalController.value.text.isEmpty || minimumWithdrawalController.value.text == "") {
      return ShowToast.errorToast(" Please Add Withdrawal Amount".tr);
    } else if (appNameController.value.text.isEmpty || appNameController.value.text == "") {
      return ShowToast.errorToast(" Please Add App Name".tr);
    } else if (colourCodeController.value.text.isEmpty || colourCodeController.value.text == "") {
      return ShowToast.errorToast(" Please Add App Colors".tr);
    } else if (globalDistanceTypeController.value.text.isEmpty || globalDistanceTypeController.value.text == "") {
      return ShowToast.errorToast(" Please Add App Global Distance type".tr);
    } else if (minimumAmountAcceptRideController.value.text.isEmpty || minimumAmountAcceptRideController.value.text == "") {
      return ShowToast.errorToast(" Please Add Amount Accept Ride".tr);
    } else if (globalDriverLocationUpdateController.value.text.isEmpty || globalDriverLocationUpdateController.value.text == "") {
      return ShowToast.errorToast(" Please Add App Global Location".tr);
    } else if (globalRadiusController.value.text.isEmpty || globalRadiusController.value.text == "") {
      return ShowToast.errorToast(" Please Add App Global Radius".tr);
    } else if (globalInterCityRadiusController.value.text.isEmpty || globalInterCityRadiusController.value.text == "") {
      return ShowToast.errorToast(" Please Add App interCity Radius".tr);
    } else if (secondsForRideCancelController.value.text.isEmpty || secondsForRideCancelController.value.text == "") {
      return ShowToast.errorToast(" Please Add Seconds for ride Cancellation  ".tr);
    } else {
      adminCommissionModel.value.active = isActive.value == Status.inactive ? false : true;
      adminCommissionModel.value.isFix = selectedAdminCommissionType.value == "Fix" ? true : false;
      adminCommissionModel.value.value = adminCommissionController.value.text;
      constantModel.value.minimumAmountDeposit = minimumDepositController.value.text;
      constantModel.value.isSubscriptionEnable = isSubscriptionActive.value == Status.inactive ? false : true;
      constantModel.value.isDocumentVerificationEnable = isDocumentVerificationActive.value == Status.inactive ? false : true;
      constantModel.value.secondsForRideCancel = secondsForRideCancelController.value.text;

      constantModel.value.minimumAmountWithdraw = minimumWithdrawalController.value.text;
      constantModel.value.appName = appNameController.value.text;
      constantModel.value.appColor = colourCodeController.value.text;
      constantModel.value.interCityRadius = globalInterCityRadiusController.value.text;
      globalValueModel.value.driverLocationUpdate = globalDriverLocationUpdateController.value.text;
      globalValueModel.value.distanceType = selectedDistanceType.value.toString();
      globalValueModel.value.radius = globalRadiusController.value.text;
      globalValueModel.value.minimumAmountAcceptRide = minimumAmountAcceptRideController.value.text;

      FireStoreUtils.setAdminCommission(adminCommissionModel.value);
      FireStoreUtils.setGeneralSetting(constantModel.value);
      FireStoreUtils.setGlobalValueSetting(globalValueModel.value);
      ShowToast.successToast('Information Saved'.tr);
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
