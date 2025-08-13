import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/place_picker/location_controller.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/google_places_flutter.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/model/prediction.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LocationController(),
        builder: (controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: GooglePlaceAutoCompleteTextField(
                textEditingController: controller.searchController,
                containerHorizontalPadding: 10,
                googleAPIKey: Constant.mapAPIKey,
                boxDecoration: BoxDecoration(
                  color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                  borderRadius: BorderRadius.circular(50),
                ),
                inputDecoration: InputDecoration(
                  filled: true,
                  fillColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                  hintText: 'Search place',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: GoogleFonts.inter(fontSize: 16),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  icon: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                    ),
                  ),
                ),
                debounceTime: 600,
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  if (prediction.description != null && prediction.description!.trim().isNotEmpty) {
                    final lat = double.tryParse(prediction.lat ?? '');
                    final lng = double.tryParse(prediction.lng ?? '');
                    if (lat != null && lng != null) {
                      controller.searchController.text = prediction.description!;
                      controller.moveCameraTo(LatLng(lat, lng));
                    }
                  }
                },
                itemClick: (Prediction prediction) async {
                  if (prediction.description != null && prediction.description!.trim().isNotEmpty) {
                    final lat = double.tryParse(prediction.lat ?? '');
                    final lng = double.tryParse(prediction.lng ?? '');
                    if (lat != null && lng != null) {
                      controller.searchController.text = prediction.description!;
                      LatLng selectedLatLng = LatLng(lat, lng);
                      controller.selectedLocation.value = selectedLatLng;
                      await controller.getAddressFromLatLng(selectedLatLng);
                    }
                  }
                },
              ),
            ),
            body: controller.selectedLocation.value == null
                ? Center(child: Constant.loader())
                : Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (controllers) {
                          controller.mapController = controllers;
                        },
                        initialCameraPosition: CameraPosition(
                          target: controller.selectedLocation.value!,
                          zoom: 15,
                        ),
                        onCameraMove: controller.onMapMoved,
                        onCameraIdle: () {
                          if (controller.selectedLocation.value != null) {
                            controller.getAddressFromLatLng(controller.selectedLocation.value!);
                          }
                        },
                      ),
                      Center(child: Icon(Icons.location_pin, size: 40, color: Colors.red)),
                      Positioned(
                        bottom: 50,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() => Text(
                                    controller.address.value,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: AppThemData.black),
                                  )),
                              SizedBox(height: 10),
                              RoundShapeButton(
                                  title: "Confirm Location",
                                  buttonColor: AppThemData.primary500,
                                  buttonTextColor: AppThemData.black,
                                  onTap: controller.confirmLocation,
                                  size: Size(190, 45))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
