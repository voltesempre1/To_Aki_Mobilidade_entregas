import 'package:admin/app/utils/app_colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToastDialog {
  static void showLoader(String message) {
    EasyLoading.show(status: message, dismissOnTap: false);
  }

  static void closeLoader() {
    EasyLoading.dismiss();
  }

  static void toast(
    String? value, {
    ToastGravity? gravity,
    length = Toast.LENGTH_SHORT,
    bool log = false,
  }) {
    if (value!.isEmpty) {
    } else {
      Fluttertoast.showToast(
          msg: value,
          toastLength: length,
          gravity: gravity,
          timeInSecForIosWeb: 4,
          webPosition: "right",
          webShowClose: true,
          webBgColor: "linear-gradient(to right, #626C78, #626C78)",
          backgroundColor: AppThemData.greyShade500.withOpacity(0.8),
          fontSize: 16.0);
    }
  }
}
