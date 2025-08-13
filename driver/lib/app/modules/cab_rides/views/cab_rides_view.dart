// ignore_for_file: must_be_immutable

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/home/views/widgets/new_ride_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controllers/cab_rides_controller.dart';

class CabRidesView extends GetView<CabRidesController> {
  CabRidesView({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: CabRidesController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            body: Obx(
              () => SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                      child: Obx(
                        () => SizedBox(
                          height: 40,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(bottom: 2),
                            children: [
                              RoundShapeButton(
                                title: "New Ride".tr,
                                buttonColor: controller.selectedType.value == 0
                                    ? AppThemData.primary500
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.black
                                        : AppThemData.white,
                                buttonTextColor: controller.selectedType.value == 0
                                    ? AppThemData.black
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.white
                                        : AppThemData.black,
                                onTap: () {
                                  controller.selectedType.value = 0;
                                },
                                size: const Size(120, 38),
                                textSize: 12,
                              ),
                              const SizedBox(width: 10),
                              RoundShapeButton(
                                title: "Ongoing".tr,
                                buttonColor: controller.selectedType.value == 1
                                    ? AppThemData.primary500
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.black
                                        : AppThemData.white,
                                buttonTextColor: controller.selectedType.value == 1
                                    ? AppThemData.black
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.white
                                        : AppThemData.black,
                                onTap: () {
                                  controller.selectedType.value = 1;
                                },
                                size: const Size(120, 38),
                                textSize: 12,
                              ),
                              const SizedBox(width: 10),
                              RoundShapeButton(
                                title: "Completed".tr,
                                buttonColor: controller.selectedType.value == 2
                                    ? AppThemData.primary500
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.black
                                        : AppThemData.white,
                                buttonTextColor: controller.selectedType.value == 2
                                    ? AppThemData.black
                                    : (themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black),
                                onTap: () {
                                  controller.selectedType.value = 2;
                                },
                                size: const Size(120, 38),
                                textSize: 12,
                              ),
                              const SizedBox(width: 10),
                              RoundShapeButton(
                                title: "Cancelled".tr,
                                buttonColor: controller.selectedType.value == 3
                                    ? AppThemData.primary500
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.black
                                        : AppThemData.white,
                                buttonTextColor: controller.selectedType.value == 3
                                    ? AppThemData.black
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.white
                                        : AppThemData.black,
                                onTap: () {
                                  controller.selectedType.value = 3;
                                },
                                size: const Size(120, 38),
                                textSize: 12,
                              ),
                              const SizedBox(width: 10),
                              RoundShapeButton(
                                title: "Rejected".tr,
                                buttonColor: controller.selectedType.value == 4
                                    ? AppThemData.primary500
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.black
                                        : AppThemData.white,
                                buttonTextColor: controller.selectedType.value == 4
                                    ? AppThemData.black
                                    : themeChange.isDarkTheme()
                                        ? AppThemData.white
                                        : AppThemData.black,
                                onTap: () {
                                  controller.selectedType.value = 4;
                                },
                                size: const Size(120, 38),
                                textSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    if (controller.selectedType.value == 0) ...{
                      if (homeController.isOnline.value == true) ...{
                        homeController.bookingModel.value.id == null
                            ? SizedBox()
                            : NewRideView(
                                bookingModel: homeController.bookingModel.value,
                              )
                      } else ...{
                        Visibility(
                            visible: homeController.isOnline.value == false,
                            child: Column(
                              children: [
                                goOnlineDialog(
                                  title: "You're Now Offline".tr,
                                  descriptions:
                                      "Please change your status to online to access all features. When offline, you won't be able to access any functionalities."
                                          .tr,
                                  img: SvgPicture.asset(
                                    "assets/icon/ic_offline.svg",
                                    height: 58,
                                    width: 58,
                                  ),
                                  onClick: () async {
                                    await FireStoreUtils.updateDriverUserOnline(true);
                                    homeController.isOnline.value = true;
                                    homeController.updateCurrentLocation();
                                  },
                                  string: "Go Online".tr,
                                  themeChange: themeChange,
                                  context: context,
                                ),
                                const SizedBox(height: 20),
                              ],
                            )),
                      }
                    } else if (controller.selectedType.value == 1) ...{
                      Container(
                        height: Responsive.height(80, context),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: ListView.builder(
                          itemCount: controller.bookingsOnGoingList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            BookingModel bookingModel = controller.bookingsOnGoingList[index];
                            return NewRideView(
                              bookingModel: bookingModel,
                            );
                          },
                        ),
                      ),
                    } else if (controller.selectedType.value == 2) ...{
                      Container(
                        height: Responsive.height(80, context),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: ListView.builder(
                          itemCount: controller.bookingsCompletedList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            BookingModel bookingModel = controller.bookingsCompletedList[index];
                            return NewRideView(
                              bookingModel: bookingModel,
                            );
                          },
                        ),
                      ),
                    } else if (controller.selectedType.value == 3) ...{
                      Container(
                        height: Responsive.height(80, context),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: ListView.builder(
                          itemCount: controller.bookingsCancelledList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            BookingModel bookingModel = controller.bookingsCancelledList[index];
                            return NewRideView(
                              bookingModel: bookingModel,
                            );
                          },
                        ),
                      ),
                    } else if (controller.selectedType.value == 4) ...{
                      Container(
                        height: Responsive.height(80, context),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: ListView.builder(
                          itemCount: controller.bookingsRejectedList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            BookingModel bookingModel = controller.bookingsRejectedList[index];
                            return NewRideView(
                              bookingModel: bookingModel,
                            );
                          },
                        ),
                      )
                    }
                  ],
                ),
              ),
            ),
          );
        });
  }
}
