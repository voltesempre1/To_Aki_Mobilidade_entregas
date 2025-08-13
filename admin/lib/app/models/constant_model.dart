// ignore_for_file: non_constant_identifier_names

class ConstantModel {
  String? googleMapKey;
  String? jsonFileURL;
  String? minimumAmountDeposit;
  String? minimumAmountWithdraw;
  String? notificationServerKey;
  String? privacyPolicy;
  String? termsAndConditions;
  String? aboutApp;
  String? appColor;
  String? appName;
  String? interCityRadius;
  bool? isSubscriptionEnable;
  bool? isDocumentVerificationEnable;
  String? secondsForRideCancel;


  ConstantModel({
    this.googleMapKey,
    this.jsonFileURL,
    this.minimumAmountDeposit,
    this.minimumAmountWithdraw,
    this.notificationServerKey,
    this.privacyPolicy,
    this.termsAndConditions,
    this.aboutApp,
    this.appColor,
    this.appName,
    this.interCityRadius,
    this.isSubscriptionEnable,
    this.isDocumentVerificationEnable,
    this.secondsForRideCancel,
  });

  ConstantModel.fromJson(Map<String, dynamic> json) {
    googleMapKey = json['googleMapKey'];
    jsonFileURL = json['jsonFileURL'];
    minimumAmountDeposit = json['minimum_amount_deposit'];
    minimumAmountWithdraw = json['minimum_amount_withdraw'];
    notificationServerKey = json['notification_senderId'];
    privacyPolicy = json['privacyPolicy'];
    termsAndConditions = json['termsAndConditions'];
    aboutApp = json['aboutApp'];
    appColor = json['appColor'];
    appName = json['appName'];
    interCityRadius = json['interCityRadius'];
    isSubscriptionEnable = json['isSubscriptionEnable'];
    isDocumentVerificationEnable = json['isDocumentVerificationEnable'];
    secondsForRideCancel = json['secondsForRideCancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['googleMapKey'] = googleMapKey ?? "";
    data['jsonFileURL'] = jsonFileURL ?? "";
    data['minimum_amount_deposit'] = minimumAmountDeposit ?? "";
    data['minimum_amount_withdraw'] = minimumAmountWithdraw ?? "";
    data['notification_senderId'] = notificationServerKey ?? "";
    data['privacyPolicy'] = privacyPolicy ?? "";
    data['termsAndConditions'] = termsAndConditions ?? "";
    data['aboutApp'] = aboutApp ?? "";
    data['appColor'] = appColor ?? "";
    data['appName'] = appName ?? "";
    data['interCityRadius'] = interCityRadius ?? "";
    data['isSubscriptionEnable'] = isSubscriptionEnable ?? false;
    data['isDocumentVerificationEnable'] = isDocumentVerificationEnable ?? true;
    data['secondsForRideCancel'] = secondsForRideCancel ;
    return data;
  }
}
