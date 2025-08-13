import 'package:driver/app/modules/otp_parcel_screen/views/otp_parcel_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/ask_for_otp_parcel_controller.dart';

class AskForOtpParcelView extends StatelessWidget {
  const AskForOtpParcelView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AskForOtpParcelController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white, shape: BoxShape.circle),
                  margin: EdgeInsets.only(left: 16),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back,
                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                SizedBox(
                  height: Responsive.height(80, context),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(controller.interCityModel.value.pickUpLocation!.latitude ?? 0.0, controller.interCityModel.value.pickUpLocation!.longitude ?? 0.0),
                      zoom: 5,
                    ),
                    padding: const EdgeInsets.only(
                      top: 22.0,
                    ),
                    polylines: Set<Polyline>.of(controller.polyLines.values),
                    markers: Set<Marker>.of(controller.markers.values),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.38,
                  snapSizes: const [0.31, 0.32, 0.34, 0.36, 0.38, 0.40,],
                  maxChildSize: 0.40,
                  minChildSize: 0.31,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 00),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 29),
                              decoration: ShapeDecoration(
                                color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            Center(
                              child: Image.asset(
                                "assets/icon/gif_ask_otp.gif",
                                height: 76.0,
                                width: 76.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                'Do you want to start this Ride?'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey50: AppThemData.grey950,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Ask the customer for an OTP so that you can start this ride'.tr,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey50: AppThemData.grey950,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RoundShapeButton(
                                  title: "Cancel".tr,
                                  buttonColor: AppThemData.grey50,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () {
                                    Get.back();
                                  },
                                  size: Size(Responsive.width(43, context), 42),
                                ),
                                RoundShapeButton(
                                  title: "Ask for OTP".tr,
                                  buttonColor: AppThemData.primary500,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () {
                                    Get.to(OtpParcelScreenView(
                                      interCityBookingModel: controller.interCityModel.value,
                                    ));
                                  },
                                  size: Size(Responsive.width(43, context), 42),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
