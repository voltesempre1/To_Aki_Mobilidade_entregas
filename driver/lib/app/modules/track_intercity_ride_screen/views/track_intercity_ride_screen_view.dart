import 'package:driver/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/track_intercity_ride_screen_controller.dart';

class TrackIntercityRideScreenView extends GetView<TrackInterCityRideScreenController> {
  const TrackIntercityRideScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
        init: TrackInterCityRideScreenController(),
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
            body: controller.isLoading.value
                ? Constant.loader()
                : SizedBox(
                    height: Responsive.height(100, context),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(controller.intercityModel.value.pickUpLocation!.latitude ?? 0.0, controller.intercityModel.value.pickUpLocation!.longitude ?? 0.0),
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
          );
        });
  }
}
