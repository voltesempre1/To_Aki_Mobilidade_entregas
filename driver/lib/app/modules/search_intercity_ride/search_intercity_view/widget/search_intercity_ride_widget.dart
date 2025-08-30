// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/intercity_booking_details/views/intercity_booking_details_view.dart';
import 'package:driver/app/modules/search_intercity_ride/controllers/search_ride_controller.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/custom_loader.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/dependency_packages/google_auto_complete_textfield/google_places_city_flutter.dart';
import 'package:driver/dependency_packages/google_auto_complete_textfield/model/prediction.dart';
import 'package:driver/extension/date_time_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class SearchInterCityRideWidget extends StatelessWidget {
  const SearchInterCityRideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<SearchRideController>(
        init: SearchRideController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Location'.tr,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
                        return index == 0
                            ? SvgPicture.asset("assets/icon/ic_pick_up.svg")
                            : SvgPicture.asset("assets/icon/ic_drop_in.svg");
                      },
                      connectorBuilder: (context, index, connectorType) {
                        return DashedLineConnector(
                          color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey300,
                        );
                      },
                      contentsBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GooglePlaceAutoCompleteTextFieldOnlyCity(
                          textEditingController:
                              index == 0 ? controller.pickupLocationController : controller.dropLocationController,
                          googleAPIKey: Constant.mapAPIKey,
                          boxDecoration: BoxDecoration(
                            color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          inputDecoration: InputDecoration(
                            hintText: index == 0 ? "Pick up Location".tr : "Destination Location".tr,
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintStyle: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          textStyle: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          clearData: () {
                            if (index == 0) {
                              controller.sourceLocation = null;
                              controller.intercityPickUpAddress.value = '';
                              controller.pickupLocationController.clear();
                              controller.searchIntercityList.clear();
                              log('==========> Pickup Location Cleared');
                            } else {
                              controller.destination = null;
                              controller.intercityDropAddress.value = '';
                              controller.dropLocationController.clear();
                              log('==========> Drop Location Cleared');
                              // controller.updateData();
                              // controller.polyLines.clear();
                            }
                          },
                          debounceTime: 800,
                          isLatLngRequired: true,
                          focusNode: index == 0 ? controller.pickUpFocusNode : controller.dropFocusNode,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            if (index == 0) {
                              controller.sourceLocation = LatLng(
                                  double.parse(prediction.lat ?? '0.00'), double.parse(prediction.lng ?? '0.00'));
                              controller.intercityPickUpAddress.value = prediction.description!;
                              log("Pickup Location :: ${controller.sourceLocation}");
                              // controller.updateData();
                            } else {
                              // controller.isFetchingDropLatLng.value = true;
                              controller.destination = LatLng(
                                  double.parse(prediction.lat ?? '0.00'), double.parse(prediction.lng ?? '0.00'));
                              controller.intercityDropAddress.value = prediction.description!;
                              log("Drop Location :: ${controller.destination}");
                              // controller.isFetchingDropLatLng.value = false;
                              // controller.updateData();
                            }
                          },
                          itemClick: (postalCodeResponse) {
                            if (index == 0) {
                              controller.pickupLocationController.text = postalCodeResponse.description ?? '';
                            } else {
                              controller.dropLocationController.text = postalCodeResponse.description ?? '';
                            }
                          },
                          itemBuilder: (context, index, Prediction prediction) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                      child: Text(
                                    prediction.description ?? "",
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ))
                                ],
                              ),
                            );
                          },
                          seperatedBuilder: Container(),
                          isCrossBtnShown: true,
                          containerHorizontalPadding: 10,
                        ),
                      ),
                      itemCount: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Select Date'.tr,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 1000)),
                          );

                          if (selectedDate != null) {
                            controller.selectedDate.value = selectedDate;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(top: 4),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            // color: Colors.white,
                            color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  controller.selectedDate.value == null
                                      ? "Select Date"
                                      : controller.selectedDate.value!.dateMonthYear(),
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: AppThemData.grey500,
                                size: 24,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RoundShapeButton(
                    title: "Search".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    textSize: 16,
                    onTap: () async {
                      controller.intercityPickUpAddress.value = controller.pickupLocationController.value.text;
                      log("Pickup address :: ${controller.intercityPickUpAddress.value}");

                      if (controller.intercityPickUpAddress.value == '') {
                        return ShowToastDialog.toast('Enter pick up location ');
                      }

                      if (controller.dropLocationController.value.text.isNotEmpty) {
                        if (controller.destination == null) {
                          controller.searchIntercityList.clear();
                          return ShowToastDialog.toast('Please Wait..');
                        }
                      }

                      controller.searchIntercityList.clear();
                      controller.isSearchInterCity.value = true;
                      await controller.fetchNearestIntercityRide();
                      controller.isSearchInterCity.value = false;

                      // controller.fetchNearestIntercityRide();
                      // controller.isSearchInterCity.value = true;
                      // controller.searchIntercityList.clear();
                      // String selectedDateStr = controller.selectedDate.value?.toIso8601String().split('T')[0] ?? '';
                      //
                      // controller.searchIntercityList.value = controller.intercityBookingList.where((booking) {
                      //   DateTime? bookingDate;
                      //   try {
                      //     bookingDate = DateTime.parse(booking.startDate ?? '');
                      //   } catch (e) {
                      //     log("Error parsing startDate: ${e.toString()}");
                      //     return false;
                      //   }
                      //   String bookingDateStr = bookingDate.toIso8601String().split('T')[0];
                      //
                      //   String pickUpAddress = controller.intercityPikUpAddress.value.trim();
                      //   String dropAddress = controller.intercityDropAddress.value.trim();
                      //
                      //   log('==================> add adress intercityDropAddress ${controller.intercityDropAddress.value}');
                      //   log('==================> add adress $dropAddress');
                      //
                      //   String normalizeAddress(String address) {
                      //     return address
                      //         .replaceAll(RegExp(r'\s+'), ' ')  // Convert multiple spaces to a single space
                      //         .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')  // Remove zero-width characters
                      //         .trim()
                      //         .toLowerCase();
                      //   }
                      //
                      //   bool dateMatches = selectedDateStr == bookingDateStr;
                      //
                      //   bool pickUpMatches = pickUpAddress.isNotEmpty
                      //       ? normalizeAddress(booking.pickUpLocationAddress ?? '') == normalizeAddress(pickUpAddress)
                      //       : false;
                      //
                      //   bool dropMatches = dropAddress.isNotEmpty
                      //       ? normalizeAddress(booking.dropLocationAddress ?? '') == normalizeAddress(dropAddress)
                      //       : false;
                      //
                      //   log('Stored Pickup Address: "${booking.pickUpLocationAddress ?? ''}"');
                      //   log('User Input Pickup Address: "$pickUpAddress"');
                      //   log('Pickup Matches Result: $pickUpMatches');
                      //
                      //   log('Stored Drop Address: "${booking.dropLocationAddress ?? ''}"');
                      //   log('User Input Drop Address: "$dropAddress"');
                      //   log('Drop Matches Result: $dropMatches');
                      //
                      //   log('======================. search screen that time match is address pickUpMatches $pickUpMatches');
                      //   log('======================. search screen that time match is address dropMatches $dropMatches');
                      //
                      //   controller.isSearchInterCity.value = false;
                      //
                      //   // 1. If both addresses are provided, both must match.
                      //   if (pickUpAddress.isNotEmpty && dropAddress.isNotEmpty) {
                      //     return dateMatches && pickUpMatches && dropMatches;
                      //   }
                      //
                      //   // 2. If either address is provided, return results that match at least one.
                      //   if (pickUpAddress.isNotEmpty || dropAddress.isNotEmpty) {
                      //     return dateMatches && (pickUpMatches || dropMatches);
                      //   }
                      //
                      //   // 3. If both addresses are empty, return results based only on the date.
                      //   return dateMatches;
                      // }).toList();
                      //
                      // controller.isSearchInterCity.value = false;
                      // log('Filtered Results Count: ${controller.searchIntercityList.length}');

                      // controller.isSearchInterCity.value = true;
                      // controller.searchIntercityList.clear();
                      // String selectedDateStr = controller.selectedDate.value?.toIso8601String().split('T')[0] ?? '';
                      // controller.searchIntercityList.value = controller.intercityBookingList.where((booking) {
                      //   DateTime? bookingDate;
                      //   try {
                      //     bookingDate = DateTime.parse(booking.startDate ?? '');
                      //   } catch (e) {
                      //     log("Error parsing startDate: ${e.toString()}");
                      //     return false;
                      //   }
                      //   String bookingDateStr = bookingDate.toIso8601String().split('T')[0];
                      //   String pickUpAddress = controller.intercityPikUpAddress.value.trim();
                      //   String dropAddress = controller.intercityDropAddress.value.trim();
                      //   log('======================. search screen that time match is address ${pickUpAddress}   drop location $dropAddress');
                      //   log('======================. search screen that time match is address controller  ${controller.intercityPikUpAddress.value}   drop location ${controller.intercityDropAddress.value}');
                      //   bool dateMatches = selectedDateStr == bookingDateStr;
                      //   // bool pickUpMatches = pickUpAddress.isNotEmpty ? booking.pickUpLocationAddress == pickUpAddress : true;
                      //   // bool dropMatches = dropAddress.isNotEmpty ? booking.dropLocationAddress == dropAddress : true;
                      //
                      //   String normalizeAddress(String address) {
                      //     return address
                      //         .replaceAll(RegExp(r'\s+'), ' ')  // Convert multiple spaces to single space
                      //         .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')  // Remove zero-width characters
                      //         .trim()
                      //         .toLowerCase();
                      //   }
                      //
                      //   bool pickUpMatches = pickUpAddress.isNotEmpty ?
                      //   normalizeAddress(booking.pickUpLocationAddress!) == normalizeAddress(pickUpAddress) : true;
                      //
                      //   bool dropMatches = dropAddress.isNotEmpty ?
                      //   normalizeAddress(booking.dropLocationAddress!) == normalizeAddress(dropAddress) : true;
                      //
                      //   log('Stored Drop Address: "${booking.dropLocationAddress!}"');
                      //   log('User Input Drop Address: "$dropAddress"');
                      //   log('Drop Matches Result: ${dropMatches}');
                      //
                      //   // bool pickUpMatches = pickUpAddress.isNotEmpty ?
                      //   // booking.pickUpLocationAddress!.trim().toLowerCase() == pickUpAddress.toLowerCase() : true;
                      //   //
                      //   // bool dropMatches = dropAddress.isNotEmpty ?
                      //   // booking.dropLocationAddress!.trim().toLowerCase() == dropAddress.toLowerCase() : true;
                      //
                      //   log('======================. search screen that time match is address pickUpMatches ${pickUpMatches}');
                      //   log('======================. search screen that time match is address dropMatches ${dropMatches}');
                      //
                      //   controller.isSearchInterCity.value = false;
                      //
                      //   // if(pickUpMatches == true && dropMatches == true){
                      //   //   return dateMatches && (pickUpMatches && dropMatches);
                      //   // }
                      //
                      //   return dateMatches && (pickUpMatches || dropMatches);
                      // }).toList();
                      // controller.isSearchInterCity.value = false;
                      // log('Filtered Results Count: ${controller.searchIntercityList.length}');
                    },
                    size: Size(Responsive.width(100, context), 52),
                  ),
                  const SizedBox(height: 20),
                  controller.searchIntercityList.isEmpty
                      ? controller.isSearchInterCity.value == true
                          ? Constant.loader()
                          : Center(
                              child: Text('No Search Data'.tr,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                      : ListView.builder(
                          itemCount: controller.searchIntercityList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            IntercityModel bookingModel = controller.searchIntercityList[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: Responsive.width(100, context),
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                margin: const EdgeInsets.only(top: 12, left: 0, right: 0),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          bookingModel.bookingTime == null
                                              ? ""
                                              : bookingModel.bookingTime!.toDate().dateMonthYear(),
                                          style: GoogleFonts.inter(
                                            color:
                                                themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          height: 15,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide.strokeAlignCenter,
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemData.grey800
                                                    : AppThemData.grey100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            bookingModel.bookingTime == null
                                                ? ""
                                                : bookingModel.bookingTime!.toDate().time(),
                                            style: GoogleFonts.inter(
                                              color:
                                                  themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              InterCityBookingDetailsView(),
                                              arguments: {
                                                "bookingId": bookingModel.id ?? '',
                                                "isSearch": true,
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_right_sharp,
                                            color:
                                                themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // SizedBox(
                                          //   height: 60,
                                          //   width: 60,
                                          //   child: CachedNetworkImage(
                                          //     imageUrl: bookingModel.vehicleType == null ? Constant.profileConstant : bookingModel.vehicleType!.image,
                                          //     fit: BoxFit.cover,
                                          //     placeholder: (context, url) => Constant.loader(),
                                          //     errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   width: 60,
                                          //   height: 60,
                                          //   margin: const EdgeInsets.only(right: 10),
                                          //   clipBehavior: Clip.antiAlias,
                                          //   decoration: ShapeDecoration(
                                          //     color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.circular(200),
                                          //     ),
                                          //     image: DecorationImage(
                                          //       image: NetworkImage(customerModel.profilePic != null
                                          //           ? customerModel.profilePic!.isNotEmpty
                                          //           ? customerModel.profilePic ?? Constant.profileConstant
                                          //           : Constant.profileConstant
                                          //           : Constant.profileConstant),
                                          //       fit: BoxFit.fill,
                                          //     ),
                                          //   ),
                                          // ),
                                          FutureBuilder<UserModel?>(
                                            future: FireStoreUtils.getUserProfile(bookingModel.customerId ?? ''),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Center(
                                                  child: CustomLoader(),
                                                );
                                              }

                                              if (!snapshot.hasData || snapshot.data == null) {
                                                return Container();
                                              }
                                              UserModel customerModel = snapshot.data ?? UserModel();
                                              return Container(
                                                width: 60,
                                                height: 60,
                                                margin: const EdgeInsets.only(right: 10),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: themeChange.isDarkTheme()
                                                      ? AppThemData.grey950
                                                      : AppThemData.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(200),
                                                  ),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: (customerModel.profilePic != null &&
                                                          customerModel.profilePic!.isNotEmpty)
                                                      ? customerModel.profilePic!
                                                      : Constant.profileConstant,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(
                                                    child: CustomLoader(),
                                                  ),
                                                  errorWidget: (context, url, error) =>
                                                      Image.asset(Constant.userPlaceHolder),
                                                ),
                                              );
                                            },
                                          ),

                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ID: ${bookingModel.id!.substring(0, 5)}',
                                                  style: GoogleFonts.inter(
                                                    color: themeChange.isDarkTheme()
                                                        ? AppThemData.grey25
                                                        : AppThemData.grey950,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Ride Start Date: ${Constant.formatDate(Constant.parseDate(bookingModel.startDate))}',
                                                  style: GoogleFonts.inter(
                                                    color: themeChange.isDarkTheme()
                                                        ? AppThemData.grey25
                                                        : AppThemData.grey950,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                // Text(
                                                //   (bookingModel.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
                                                //   style: GoogleFonts.inter(
                                                //     color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w400,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                Constant.amountToShow(
                                                    amount: Constant.calculateInterCityFinalAmount(bookingModel)
                                                        .toString()),
                                                // amount: Constant.calculateInterCityFinalAmount(bookingModel).toStringAsFixed(2)),
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme()
                                                      ? AppThemData.grey25
                                                      : AppThemData.grey950,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset("assets/icon/ic_multi_person.svg"),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '${bookingModel.persons}',
                                                    style: GoogleFonts.inter(
                                                      color: AppThemData.primary500,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 12),
                                        PickDropPointView(
                                            pickUpAddress: bookingModel.pickUpLocationAddress ?? '',
                                            dropAddress: bookingModel.dropLocationAddress ?? ''),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (bookingModel.isPersonalRide == true) ...{
                                              Constant.isInterCityBid == false
                                                  ? bookingModel.bookingStatus == BookingStatus.bookingPlaced
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            RoundShapeButton(
                                                              title: "Cancel Ride".tr,
                                                              buttonColor: AppThemData.danger500,
                                                              buttonTextColor: AppThemData.white,
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return CustomDialogBox(
                                                                          themeChange: themeChange,
                                                                          title: "Cancel Ride".tr,
                                                                          negativeButtonColor: themeChange.isDarkTheme()
                                                                              ? AppThemData.grey950
                                                                              : AppThemData.grey50,
                                                                          negativeButtonTextColor:
                                                                              themeChange.isDarkTheme()
                                                                                  ? AppThemData.grey50
                                                                                  : AppThemData.grey950,
                                                                          positiveButtonColor: AppThemData.danger500,
                                                                          positiveButtonTextColor: AppThemData.grey25,
                                                                          descriptions:
                                                                              "Are you sure you want cancel this ride?"
                                                                                  .tr,
                                                                          positiveString: "Cancel Ride".tr,
                                                                          negativeString: "Cancel".tr,
                                                                          positiveClick: () async {
                                                                            Navigator.pop(context);
                                                                            List rejectedId =
                                                                                bookingModel.rejectedDriverId ?? [];
                                                                            rejectedId
                                                                                .add(FireStoreUtils.getCurrentUid());
                                                                            bookingModel.bookingStatus =
                                                                                BookingStatus.bookingRejected;
                                                                            bookingModel.rejectedDriverId = rejectedId;
                                                                            bookingModel.updateAt = Timestamp.now();
                                                                            FireStoreUtils.setInterCityBooking(
                                                                                    bookingModel)
                                                                                .then((value) async {
                                                                              if (value == true) {
                                                                                ShowToastDialog.showToast(
                                                                                    "Ride cancelled successfully!");
                                                                                controller.searchIntercityList
                                                                                    .removeAt(index);
                                                                                // DriverUserModel? driverModel =
                                                                                //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                                                UserModel? receiverUserModel =
                                                                                    await FireStoreUtils.getUserProfile(
                                                                                        bookingModel.customerId
                                                                                            .toString());
                                                                                Map<String, dynamic> playLoad =
                                                                                    <String, dynamic>{
                                                                                  "bookingId": bookingModel.id
                                                                                };

                                                                                await SendNotification
                                                                                    .sendOneNotification(
                                                                                        type: "order",
                                                                                        token: receiverUserModel!
                                                                                            .fcmToken
                                                                                            .toString(),
                                                                                        title: 'Your Ride is Rejected',
                                                                                        customerId:
                                                                                            receiverUserModel.id,
                                                                                        senderId: FireStoreUtils
                                                                                            .getCurrentUid(),
                                                                                        bookingId:
                                                                                            bookingModel.id.toString(),
                                                                                        driverId: bookingModel.driverId
                                                                                            .toString(),
                                                                                        body:
                                                                                            'Your ride #${bookingModel.id.toString().substring(0, 5)} has been Rejected by Driver.',
                                                                                        // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                                                        payload: playLoad);

                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                ShowToastDialog.showToast(
                                                                                    "Something went wrong!");
                                                                                Navigator.pop(context);
                                                                              }
                                                                            });
                                                                          },
                                                                          negativeClick: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          img: Image.asset(
                                                                            "assets/icon/ic_close.png",
                                                                            height: 58,
                                                                            width: 58,
                                                                          ));
                                                                    });
                                                              },
                                                              size: Size(Responsive.width(40, context), 42),
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            RoundShapeButton(
                                                              title: "Accept".tr,
                                                              buttonColor: AppThemData.primary500,
                                                              buttonTextColor: AppThemData.black,
                                                              onTap: () {
                                                                if (double.parse(
                                                                        Constant.userModel!.walletAmount.toString()) >=
                                                                    double.parse(Constant.minimumAmountToAcceptRide
                                                                        .toString())) {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return CustomDialogBox(
                                                                          title: "Confirm Ride Request".tr,
                                                                          descriptions:
                                                                              "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride."
                                                                                  .tr,
                                                                          img: Image.asset(
                                                                            "assets/icon/ic_green_right.png",
                                                                            height: 58,
                                                                            width: 58,
                                                                          ),
                                                                          positiveClick: () async {
                                                                            if (Constant.isSubscriptionEnable == true) {
                                                                              if (Constant.userModel!
                                                                                          .subscriptionPlanId !=
                                                                                      null &&
                                                                                  Constant.userModel!
                                                                                      .subscriptionPlanId!.isNotEmpty) {
                                                                                if (Constant.userModel!
                                                                                        .subscriptionTotalBookings ==
                                                                                    '0') {
                                                                                  Navigator.pop(context);
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return SubscriptionAlertDialog(
                                                                                          title:
                                                                                              "You can't accept more Rides.Upgrade your Plan.",
                                                                                          cancelText: "Cancel",
                                                                                          confirmText: "Upgrade",
                                                                                          themeChange: themeChange,
                                                                                        );
                                                                                      });
                                                                                  // ShowToastDialog.showToast("You can't accept more Bookings.Upgrade your Plan.");
                                                                                  return;
                                                                                }
                                                                              }
                                                                              if (Constant.userModel!
                                                                                          .subscriptionExpiryDate !=
                                                                                      null &&
                                                                                  Constant.userModel!
                                                                                      .subscriptionExpiryDate!
                                                                                      .toDate()
                                                                                      .isBefore(DateTime.now())) {
                                                                                Navigator.pop(context);
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return SubscriptionAlertDialog(
                                                                                        title:
                                                                                            "Your subscription has expired. Please renew your plan.",
                                                                                        cancelText: "Cancel",
                                                                                        confirmText: "Upgrade",
                                                                                        themeChange: themeChange,
                                                                                      );
                                                                                    });
                                                                                // ShowToastDialog.showToast("Your subscription has expired. Please renew your plan.");
                                                                                return;
                                                                              }
                                                                            }

                                                                            bookingModel.driverId =
                                                                                FireStoreUtils.getCurrentUid();
                                                                            bookingModel.bookingStatus =
                                                                                BookingStatus.bookingAccepted;
                                                                            bookingModel.updateAt = Timestamp.now();

                                                                            if (Constant.isSubscriptionEnable == true &&
                                                                                Constant.userModel!
                                                                                        .subscriptionPlanId !=
                                                                                    null &&
                                                                                Constant.userModel!.subscriptionPlanId!
                                                                                    .isNotEmpty &&
                                                                                Constant.userModel!.subscriptionTotalBookings !=
                                                                                    '0' &&
                                                                                Constant.userModel!
                                                                                        .subscriptionTotalBookings !=
                                                                                    '-1' &&
                                                                                Constant.userModel!
                                                                                        .subscriptionTotalBookings !=
                                                                                    null) {
                                                                              int remainingBookings = int.parse(Constant
                                                                                      .userModel!
                                                                                      .subscriptionTotalBookings!) -
                                                                                  1;
                                                                              Constant.userModel!
                                                                                      .subscriptionTotalBookings =
                                                                                  remainingBookings.toString();
                                                                              await FireStoreUtils.updateDriverUser(
                                                                                  Constant.userModel!);
                                                                            }

                                                                            FireStoreUtils.setInterCityBooking(
                                                                                    bookingModel)
                                                                                .then((value) async {
                                                                              if (value == true) {
                                                                                ShowToastDialog.showToast(
                                                                                    "Ride accepted successfully!".tr);
                                                                                controller.searchIntercityList
                                                                                    .removeAt(index);

                                                                                UserModel? receiverUserModel =
                                                                                    await FireStoreUtils.getUserProfile(
                                                                                        bookingModel.customerId
                                                                                            .toString());
                                                                                Map<String, dynamic> playLoad =
                                                                                    <String, dynamic>{
                                                                                  "bookingId": bookingModel.id
                                                                                };

                                                                                await SendNotification.sendOneNotification(
                                                                                    type: "order",
                                                                                    token: receiverUserModel!.fcmToken
                                                                                        .toString(),
                                                                                    title: 'Your Ride is Accepted',
                                                                                    customerId: receiverUserModel.id,
                                                                                    senderId:
                                                                                        FireStoreUtils.getCurrentUid(),
                                                                                    bookingId:
                                                                                        bookingModel.id.toString(),
                                                                                    driverId: bookingModel.driverId
                                                                                        .toString(),
                                                                                    body:
                                                                                        'Your ride #${bookingModel.id.toString().substring(0, 5)} has been confirmed.',
                                                                                    payload: playLoad);
                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                ShowToastDialog.showToast(
                                                                                    "Something went wrong!".tr);
                                                                                Navigator.pop(context);
                                                                              }
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          negativeClick: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          positiveString: "Confirm",
                                                                          negativeString: "Cancel",
                                                                          themeChange: themeChange);
                                                                    },
                                                                  );
                                                                } else {
                                                                  ShowToastDialog.showToast(
                                                                      'insufficient_wallet_balance'.tr.replaceAll(
                                                                          '@amount',
                                                                          Constant.amountShow(
                                                                              amount:
                                                                                  Constant.minimumAmountToAcceptRide)));
                                                                }
                                                              },
                                                              size: Size(Responsive.width(40, context), 42),
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox()
                                                  : Expanded(
                                                      child: RoundShapeButton(
                                                        title: "Add Bid".tr,
                                                        buttonColor: AppThemData.primary500,
                                                        buttonTextColor: AppThemData.black,
                                                        onTap: () {
                                                          Get.to(
                                                            InterCityBookingDetailsView(),
                                                            arguments: {
                                                              "bookingId": bookingModel.id ?? '',
                                                              "isSearch": true,
                                                            },
                                                          );
                                                        },
                                                        size: const Size(double.infinity, 48),
                                                      ),
                                                    )
                                            } else ...{
                                              Constant.isInterCitySharingBid == false
                                                  ? bookingModel.bookingStatus == BookingStatus.bookingPlaced
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            RoundShapeButton(
                                                              title: "Cancel Ride".tr,
                                                              buttonColor: AppThemData.danger500,
                                                              buttonTextColor: AppThemData.white,
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return CustomDialogBox(
                                                                          themeChange: themeChange,
                                                                          title: "Cancel Ride".tr,
                                                                          negativeButtonColor: themeChange.isDarkTheme()
                                                                              ? AppThemData.grey950
                                                                              : AppThemData.grey50,
                                                                          negativeButtonTextColor:
                                                                              themeChange.isDarkTheme()
                                                                                  ? AppThemData.grey50
                                                                                  : AppThemData.grey950,
                                                                          positiveButtonColor: AppThemData.danger500,
                                                                          positiveButtonTextColor: AppThemData.grey25,
                                                                          descriptions:
                                                                              "Are you sure you want cancel this ride?"
                                                                                  .tr,
                                                                          positiveString: "Cancel Ride".tr,
                                                                          negativeString: "Cancel".tr,
                                                                          positiveClick: () async {
                                                                            Navigator.pop(context);
                                                                            List rejectedId =
                                                                                bookingModel.rejectedDriverId ?? [];
                                                                            rejectedId
                                                                                .add(FireStoreUtils.getCurrentUid());
                                                                            bookingModel.bookingStatus =
                                                                                BookingStatus.bookingRejected;
                                                                            bookingModel.rejectedDriverId = rejectedId;
                                                                            bookingModel.updateAt = Timestamp.now();
                                                                            FireStoreUtils.setInterCityBooking(
                                                                                    bookingModel)
                                                                                .then((value) async {
                                                                              if (value == true) {
                                                                                ShowToastDialog.showToast(
                                                                                    "Ride cancelled successfully!");
                                                                                controller.searchIntercityList
                                                                                    .removeAt(index);
                                                                                // DriverUserModel? driverModel =
                                                                                //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                                                                UserModel? receiverUserModel =
                                                                                    await FireStoreUtils.getUserProfile(
                                                                                        bookingModel.customerId
                                                                                            .toString());
                                                                                Map<String, dynamic> playLoad =
                                                                                    <String, dynamic>{
                                                                                  "bookingId": bookingModel.id
                                                                                };

                                                                                await SendNotification
                                                                                    .sendOneNotification(
                                                                                        type: "order",
                                                                                        token: receiverUserModel!
                                                                                            .fcmToken
                                                                                            .toString(),
                                                                                        title: 'Your Ride is Rejected',
                                                                                        customerId:
                                                                                            receiverUserModel.id,
                                                                                        senderId: FireStoreUtils
                                                                                            .getCurrentUid(),
                                                                                        bookingId:
                                                                                            bookingModel.id.toString(),
                                                                                        driverId: bookingModel.driverId
                                                                                            .toString(),
                                                                                        body:
                                                                                            'Your ride #${bookingModel.id.toString().substring(0, 5)} has been Rejected by Driver.',
                                                                                        // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                                                        payload: playLoad);

                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                ShowToastDialog.showToast(
                                                                                    "Something went wrong!");
                                                                                Navigator.pop(context);
                                                                              }
                                                                            });
                                                                          },
                                                                          negativeClick: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          img: Image.asset(
                                                                            "assets/icon/ic_close.png",
                                                                            height: 58,
                                                                            width: 58,
                                                                          ));
                                                                    });
                                                              },
                                                              size: Size(Responsive.width(40, context), 42),
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            RoundShapeButton(
                                                              title: "Accept".tr,
                                                              buttonColor: AppThemData.primary500,
                                                              buttonTextColor: AppThemData.black,
                                                              onTap: () {
                                                                if (double.parse(
                                                                        Constant.userModel!.walletAmount.toString()) >=
                                                                    double.parse(Constant.minimumAmountToAcceptRide
                                                                        .toString())) {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return CustomDialogBox(
                                                                          title: "Confirm Ride Request".tr,
                                                                          descriptions:
                                                                              "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride."
                                                                                  .tr,
                                                                          img: Image.asset(
                                                                            "assets/icon/ic_green_right.png",
                                                                            height: 58,
                                                                            width: 58,
                                                                          ),
                                                                          positiveClick: () {
                                                                            bookingModel.driverId =
                                                                                FireStoreUtils.getCurrentUid();
                                                                            bookingModel.bookingStatus =
                                                                                BookingStatus.bookingAccepted;
                                                                            bookingModel.updateAt = Timestamp.now();
                                                                            FireStoreUtils.setInterCityBooking(
                                                                                    bookingModel)
                                                                                .then((value) async {
                                                                              if (value == true) {
                                                                                ShowToastDialog.showToast(
                                                                                    "Ride accepted successfully!");
                                                                                controller.searchIntercityList
                                                                                    .removeAt(index);
                                                                                UserModel? receiverUserModel =
                                                                                    await FireStoreUtils.getUserProfile(
                                                                                        bookingModel.customerId
                                                                                            .toString());
                                                                                Map<String, dynamic> playLoad =
                                                                                    <String, dynamic>{
                                                                                  "bookingId": bookingModel.id
                                                                                };
                                                                                await SendNotification.sendOneNotification(
                                                                                    type: "order",
                                                                                    token: receiverUserModel!.fcmToken
                                                                                        .toString(),
                                                                                    title: 'Your Ride is Accepted',
                                                                                    customerId: receiverUserModel.id,
                                                                                    senderId:
                                                                                        FireStoreUtils.getCurrentUid(),
                                                                                    bookingId:
                                                                                        bookingModel.id.toString(),
                                                                                    driverId: bookingModel.driverId
                                                                                        .toString(),
                                                                                    body:
                                                                                        'Your ride #${bookingModel.id.toString().substring(0, 5)} has been confirmed.',
                                                                                    payload: playLoad);
                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                ShowToastDialog.showToast(
                                                                                    "Something went wrong!".tr);
                                                                                Navigator.pop(context);
                                                                              }
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          negativeClick: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          positiveString: "Confirm",
                                                                          negativeString: "Cancel",
                                                                          themeChange: themeChange);
                                                                    },
                                                                  );
                                                                } else {
                                                                  ShowToastDialog.showToast(
                                                                      'insufficient_wallet_balance'.tr.replaceAll(
                                                                          '@amount',
                                                                          Constant.amountShow(
                                                                              amount:
                                                                                  Constant.minimumAmountToAcceptRide)));
                                                                }
                                                              },
                                                              size: Size(Responsive.width(40, context), 42),
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox()
                                                  : Expanded(
                                                      child: RoundShapeButton(
                                                        title: "Add Bid".tr,
                                                        buttonColor: AppThemData.primary500,
                                                        buttonTextColor: AppThemData.black,
                                                        onTap: () {
                                                          Get.to(
                                                            InterCityBookingDetailsView(),
                                                            arguments: {
                                                              "bookingId": bookingModel.id ?? '',
                                                              "isSearch": true,
                                                            },
                                                          );
                                                        },
                                                        size: const Size(double.infinity, 48),
                                                      ),
                                                    )
                                            }

                                            // Constant.isInterCityBid == false
                                            //     ? bookingModel.bookingStatus == BookingStatus.bookingPlaced
                                            //         ? Row(
                                            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //             crossAxisAlignment: CrossAxisAlignment.center,
                                            //             children: [
                                            //               RoundShapeButton(
                                            //                 title: "Cancel Ride",
                                            //                 buttonColor: AppThemData.danger500,
                                            //                 buttonTextColor: AppThemData.white,
                                            //                 onTap: () {
                                            //                   showDialog(
                                            //                       context: context,
                                            //                       builder: (BuildContext context) {
                                            //                         return CustomDialogBox(
                                            //                             themeChange: themeChange,
                                            //                             title: "Cancel Ride".tr,
                                            //                             negativeButtonColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                                            //                             negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                            //                             positiveButtonColor: AppThemData.danger500,
                                            //                             positiveButtonTextColor: AppThemData.grey25,
                                            //                             descriptions: "Are you sure you want cancel this ride?".tr,
                                            //                             positiveString: "Cancel Ride".tr,
                                            //                             negativeString: "Cancel".tr,
                                            //                             positiveClick: () async {
                                            //                               Navigator.pop(context);
                                            //                               List rejectedId = bookingModel.rejectedDriverId ?? [];
                                            //                               rejectedId.add(FireStoreUtils.getCurrentUid());
                                            //                               bookingModel.bookingStatus = BookingStatus.bookingRejected;
                                            //                               bookingModel.rejectedDriverId = rejectedId;
                                            //                               bookingModel.updateAt = Timestamp.now();
                                            //                               FireStoreUtils.setInterCityBooking(bookingModel!).then((value) async {
                                            //                                 if (value == true) {
                                            //                                   ShowToastDialog.showToast("Ride cancelled successfully!");
                                            //                                   controller.searchIntercityList.removeAt(index);
                                            //                                   // DriverUserModel? driverModel =
                                            //                                   //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                            //                                   UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
                                            //                                   Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};
                                            //
                                            //                                   await SendNotification.sendOneNotification(
                                            //                                       type: "order",
                                            //                                       token: receiverUserModel!.fcmToken.toString(),
                                            //                                       title: 'Your Ride is Rejected',
                                            //                                       customerId: receiverUserModel.id,
                                            //                                       senderId: FireStoreUtils.getCurrentUid(),
                                            //                                       bookingId: bookingModel!.id.toString(),
                                            //                                       driverId: bookingModel!.driverId.toString(),
                                            //                                       body: 'Your ride #${bookingModel!.id.toString().substring(0, 4)} has been Rejected by Driver.',
                                            //                                       // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                            //                                       payload: playLoad);
                                            //
                                            //                                   Navigator.pop(context);
                                            //                                 } else {
                                            //                                   ShowToastDialog.showToast("Something went wrong!");
                                            //                                   Navigator.pop(context);
                                            //                                 }
                                            //                               });
                                            //                             },
                                            //                             negativeClick: () {
                                            //                               Navigator.pop(context);
                                            //                             },
                                            //                             img: Image.asset(
                                            //                               "assets/icon/ic_close.png",
                                            //                               height: 58,
                                            //                               width: 58,
                                            //                             ));
                                            //                       });
                                            //                 },
                                            //                 size: Size(Responsive.width(40, context), 42),
                                            //               ),
                                            //               SizedBox(
                                            //                 width: 4,
                                            //               ),
                                            //               RoundShapeButton(
                                            //                 title: "Accept".tr,
                                            //                 buttonColor: AppThemData.primary500,
                                            //                 buttonTextColor: AppThemData.black,
                                            //                 onTap: () {
                                            //                   if (double.parse(Constant.userModel!.walletAmount.toString()) > double.parse(Constant.minimumAmountToAcceptRide.toString())) {
                                            //                     showDialog(
                                            //                       context: context,
                                            //                       builder: (context) {
                                            //                         return CustomDialogBox(
                                            //                             title: "Confirm Ride Request",
                                            //                             descriptions: "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.",
                                            //                             img: Image.asset(
                                            //                               "assets/icon/ic_green_right.png",
                                            //                               height: 58,
                                            //                               width: 58,
                                            //                             ),
                                            //                             positiveClick: () {
                                            //                               bookingModel.driverId = FireStoreUtils.getCurrentUid();
                                            //                               bookingModel.bookingStatus = BookingStatus.bookingAccepted;
                                            //                               bookingModel.updateAt = Timestamp.now();
                                            //                               FireStoreUtils.setInterCityBooking(bookingModel).then((value) async {
                                            //                                 if (value == true) {
                                            //                                   ShowToastDialog.showToast("Ride accepted successfully!");
                                            //                                   controller.searchIntercityList.removeAt(index);
                                            //
                                            //                                   UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel!.customerId.toString());
                                            //                                   Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel!.id};
                                            //
                                            //                                   await SendNotification.sendOneNotification(
                                            //                                       type: "order",
                                            //                                       token: receiverUserModel!.fcmToken.toString(),
                                            //                                       title: 'Your Ride is Accepted',
                                            //                                       customerId: receiverUserModel.id,
                                            //                                       senderId: FireStoreUtils.getCurrentUid(),
                                            //                                       bookingId: bookingModel!.id.toString(),
                                            //                                       driverId: bookingModel!.driverId.toString(),
                                            //                                       body: 'Your ride #${bookingModel!.id.toString().substring(0, 4)} has been confirmed.',
                                            //                                       payload: playLoad);
                                            //                                   Navigator.pop(context);
                                            //                                 } else {
                                            //                                   ShowToastDialog.showToast("Something went wrong!");
                                            //                                   Navigator.pop(context);
                                            //                                 }
                                            //                               });
                                            //                               Navigator.pop(context);
                                            //                             },
                                            //                             negativeClick: () {
                                            //                               Navigator.pop(context);
                                            //                             },
                                            //                             positiveString: "Confirm",
                                            //                             negativeString: "Cancel",
                                            //                             themeChange: themeChange);
                                            //                       },
                                            //                     );
                                            //                   } else {
                                            //                     ShowToastDialog.showToast("You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
                                            //                   }
                                            //                 },
                                            //                 size: Size(Responsive.width(40, context), 42),
                                            //               )
                                            //             ],
                                            //           )
                                            //         : SizedBox()
                                            //     : bookingModel.bookingStatus == BookingStatus.bookingPlaced
                                            //         ? Expanded(
                                            //             child: RoundShapeButton(
                                            //               title: "Add Bid".tr,
                                            //               buttonColor: AppThemData.primary500,
                                            //               buttonTextColor: AppThemData.black,
                                            //               onTap: () {
                                            //                 Get.to(
                                            //                   InterCityBookingDetailsView(),
                                            //                   arguments: {
                                            //                     "bookingId": bookingModel.id ?? '',
                                            //                   },
                                            //                 );
                                            //               },
                                            //               size: const Size(double.infinity, 48),
                                            //             ),
                                            //           )
                                            //         : bookingModel.bookingStatus == BookingStatus.bookingAccepted
                                            //             ?
                                            //             // RoundShapeButton(
                                            //             //   title: "Add Bid".tr,
                                            //             //   buttonColor: AppThemData.primary500,
                                            //             //   buttonTextColor: AppThemData.black,
                                            //             //   onTap: () {
                                            //             //     Get.to(
                                            //             //       InterCityBookingDetailsView(),
                                            //             //       arguments: {
                                            //             //         "bookingId": bookingModel.id ?? '',
                                            //             //       },
                                            //             //     );
                                            //             //   },
                                            //             //   size:  Size(Responsive.width(80, context), 48),
                                            //             // )
                                            //             RoundShapeButton(
                                            //                 title: "Cancel Ride",
                                            //                 buttonColor: AppThemData.danger500,
                                            //                 buttonTextColor: AppThemData.white,
                                            //                 onTap: () {
                                            //                   showDialog(
                                            //                       context: context,
                                            //                       builder: (BuildContext context) {
                                            //                         return CustomDialogBox(
                                            //                             themeChange: themeChange,
                                            //                             title: "Cancel Ride".tr,
                                            //                             negativeButtonColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                                            //                             negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey950,
                                            //                             positiveButtonColor: AppThemData.danger500,
                                            //                             positiveButtonTextColor: AppThemData.grey25,
                                            //                             descriptions: "Are you sure you want cancel this ride?".tr,
                                            //                             positiveString: "Cancel Ride".tr,
                                            //                             negativeString: "Cancel".tr,
                                            //                             positiveClick: () async {
                                            //                               Navigator.pop(context);
                                            //                               List rejectedId = bookingModel!.rejectedDriverId ?? [];
                                            //                               rejectedId.add(FireStoreUtils.getCurrentUid());
                                            //                               bookingModel.bookingStatus = BookingStatus.bookingRejected;
                                            //                               bookingModel.rejectedDriverId = rejectedId;
                                            //                               bookingModel.updateAt = Timestamp.now();
                                            //                               FireStoreUtils.setInterCityBooking(bookingModel).then((value) async {
                                            //                                 if (value == true) {
                                            //                                   ShowToastDialog.showToast("Ride cancelled successfully!");
                                            //                                   // DriverUserModel? driverModel =
                                            //                                   //     await FireStoreUtils.getDriverUserProfile(bookingModel!.driverId.toString());
                                            //                                   UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
                                            //                                   Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel!.id};
                                            //                                   await SendNotification.sendOneNotification(
                                            //                                       type: "order",
                                            //                                       token: receiverUserModel!.fcmToken.toString(),
                                            //                                       title: 'Your Ride is Rejected',
                                            //                                       customerId: receiverUserModel.id,
                                            //                                       senderId: FireStoreUtils.getCurrentUid(),
                                            //                                       bookingId: bookingModel.id.toString(),
                                            //                                       driverId: bookingModel.driverId.toString(),
                                            //                                       body: 'Your ride #${bookingModel.id.toString().substring(0, 4)} has been Rejected by Driver.',
                                            //                                       // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                            //                                       payload: playLoad);
                                            //
                                            //                                   Navigator.pop(context);
                                            //                                 } else {
                                            //                                   ShowToastDialog.showToast("Something went wrong!");
                                            //                                   Navigator.pop(context);
                                            //                                 }
                                            //                               });
                                            //                             },
                                            //                             negativeClick: () {
                                            //                               Navigator.pop(context);
                                            //                             },
                                            //                             img: Image.asset(
                                            //                               "assets/icon/ic_close.png",
                                            //                               height: 58,
                                            //                               width: 58,
                                            //                             ));
                                            //                       });
                                            //                 },
                                            //                 size: Size(Responsive.width(79, context), 42),
                                            //               )
                                            //             : SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                ],
              ),
            ),
          );
        });
  }
}
