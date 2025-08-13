import 'dart:developer';

import 'package:customer/constant_widgets/place_picker/location_picker_screen.dart';
import 'package:customer/constant_widgets/place_picker/selected_location_model.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/services/recent_location_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/app/modules/select_location/controllers/select_location_controller.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class SelectLocationBottomSheet extends StatelessWidget {
  const SelectLocationBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: SelectLocationController(),
        builder: (controller) {
          log("===> ${Constant.mapAPIKey}");
          return Container(
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
              color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: ShapeDecoration(
                    color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Text(
                  'Select Location'.tr,
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Timeline.tileBuilder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  theme: TimelineThemeData(
                    nodePosition: 0,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  builder: TimelineTileBuilder.connected(
                    contentsAlign: ContentsAlign.basic,
                    indicatorBuilder: (context, index) {
                      return index == 0 ? SvgPicture.asset("assets/icon/ic_pick_up.svg") : SvgPicture.asset("assets/icon/ic_drop_in.svg");
                    },
                    connectorBuilder: (context, index, connectorType) {
                      return DashedLineConnector(
                        color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey300,
                      );
                    },
                    contentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: index == 0 ? controller.pickUpFocusNode : controller.dropFocusNode,
                        cursorColor: AppThemData.primary500,
                        readOnly: true,
                        controller: index == 0 ? controller.pickupLocationController : controller.dropLocationController,
                        onTap: () {
                          FocusNode tappedFocusNode = index == 0 ? controller.pickUpFocusNode : controller.dropFocusNode;

                          // Request focus before navigating (to ensure it's tracked)
                          tappedFocusNode.requestFocus();
                          Get.to(LocationPickerScreen())!.then(
                            (value) {
                              if (value != null) {
                                SelectedLocationModel selectedLocationModel = value;

                                String formattedAddress =
                                    "${selectedLocationModel.address?.street ?? ''}, ${selectedLocationModel.address?.subLocality}, ${selectedLocationModel.address?.locality ?? ''}, ${selectedLocationModel.address?.administrativeArea}, ${selectedLocationModel.address?.postalCode} ${selectedLocationModel.address?.country ?? ''}";

                                if (index == 0) {
                                  controller.sourceLocation = selectedLocationModel.latLng!;
                                  controller.pickupLocationController.text = formattedAddress;
                                  log("Pickup Address : ${controller.sourceLocation} ${formattedAddress.toString()}");
                                } else {
                                  controller.destination = selectedLocationModel.latLng;
                                  controller.dropLocationController.text = formattedAddress;
                                  log("Drop Address : ${controller.destination} ${formattedAddress.toString()}");
                                }
                                controller.updateData();
                                RecentSearchLocation.addLocationInHistory(selectedLocationModel);
                              } else {
                                Future.delayed(Duration(milliseconds: 100), () {
                                  tappedFocusNode.requestFocus();
                                });
                              }
                            },
                          );
                        },
                        decoration: InputDecoration(
                          hintText: index == 0 ? "Pick up Location".tr : "Destination Location".tr,
                          filled: true,
                          fillColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                          focusColor: AppThemData.primary500,
                          suffixIcon: (index == 0 ? controller.pickupLocationController.text.isNotEmpty : controller.dropLocationController.text.isNotEmpty)
                              ? InkWell(
                                  onTap: () {
                                    if (index == 0) {
                                      controller.pickupLocationController.clear();
                                    } else {
                                      controller.dropLocationController.clear();
                                      controller.destination = null;
                                    }
                                    controller.getRecentSearches();
                                    controller.polyLines.clear();
                                  },
                                  child: Icon(Icons.close))
                              : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: AppThemData.primary500)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                          hintStyle: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    itemCount: 2,
                  ),
                ),
                if (controller.recentSearches.isNotEmpty)
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Search",
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  RecentSearchLocation.clearLocationHistoryList().then((value) {
                                    controller.recentSearches.clear();
                                    controller.update();
                                  });
                                },
                                child: Text(
                                  "Clear",
                                  style: GoogleFonts.inter(
                                    color: AppThemData.danger500,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.recentSearches.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              SelectedLocationModel recentSearch = controller.recentSearches[index];
                              return InkWell(
                                onTap: () {
                                  if (controller.pickUpFocusNode.hasFocus) {
                                    controller.pickupLocationController.text = recentSearch.getFullAddress();
                                    controller.sourceLocation =
                                        LatLng(double.parse(recentSearch.latLng!.latitude.toString()), double.parse(recentSearch.latLng!.longitude.toString()));
                                  } else if (controller.dropFocusNode.hasFocus) {
                                    controller.dropLocationController.text = recentSearch.getFullAddress();
                                    controller.destination =
                                        LatLng(double.parse(recentSearch.latLng!.latitude.toString()), double.parse(recentSearch.latLng!.longitude.toString()));
                                  } else {
                                    ShowToastDialog.showToast("Please select a location field first.");
                                    return;
                                  }
                                  controller.updateData();
                                  FocusScope.of(context).unfocus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: themeChange.isDarkTheme() ? AppThemData.grey200 : AppThemData.grey800,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          recentSearch.getFullAddress(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey200 : AppThemData.grey800,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
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
