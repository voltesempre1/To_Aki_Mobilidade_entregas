import 'package:driver/app/models/parcel_model.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../controllers/otp_parcel_screen_controller.dart';

class OtpParcelScreenView extends StatelessWidget {
  final ParcelModel interCityBookingModel;

  const OtpParcelScreenView({
    super.key,
    required this.interCityBookingModel,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: OtpParcelScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              title: const Text(''),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Enter OTP to Start Parcel Ride'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please enter the OTP which provided by customer to confirm your acceptance of the ride request.'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 86),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 52,
                      height: 52,
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // no fill color
                        border: Border.all(color: AppThemData.grey100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 52,
                      height: 52,
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // no fill color
                        border: Border.all(color: AppThemData.primary500),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onCompleted: (pin) async {
                      controller.otp.value = pin;
                    },
                  ),
                  const SizedBox(height: 83),
                  RoundShapeButton(
                      size: const Size(200, 45),
                      title: "Submit".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () async {
                        if (controller.otp.value == interCityBookingModel.otp) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                    themeChange: themeChange,
                                    title: "Confirm Parcel Ride Request".tr,
                                    descriptions:
                                        "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.".tr,
                                    positiveString: "Confirm".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      controller.startBooking(interCityBookingModel);
                                      Navigator.pop(context);
                                      // Get.offAll(const HomeView());
                                      Get.back();
                                      Get.back();
                                      // Get.to(const HomeView());
                                    },
                                    negativeClick: () {
                                      Navigator.pop(context);
                                    },
                                    img: Image.asset(
                                      "assets/icon/ic_green_right.png",
                                      height: 58,
                                      width: 58,
                                    ));
                              });
                        } else {
                          ShowToastDialog.showToast("Please enter a valid OTP.".tr);
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}
