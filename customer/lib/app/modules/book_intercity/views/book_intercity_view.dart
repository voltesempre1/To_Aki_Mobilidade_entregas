import 'dart:developer';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/app/modules/book_intercity/views/widget/select_payment_type.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/google_places_city_flutter.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/model/prediction.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../controllers/book_intercity_controller.dart';

class BookIntercityView extends StatelessWidget {
  const BookIntercityView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: BookIntercityController(),
        builder: (controller) {
          bool isPersonalAvailable = Constant.intercityPersonalDocuments.first.isAvailable;
          bool isSharingAvailable = Constant.intercitySharingDocuments.first.isAvailable;

          return Scaffold(
            appBar: AppBarWithBorder(
              title: "",
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.grey50,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: SingleChildScrollView(
                child: Obx(
                  () => controller.isLoading.value
                      ? Constant.loader()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if(Constant.intercityPersonalDocuments.first.isAvailable || Constant.intercitySharingDocuments.first.isAvailable)
                            if (isPersonalAvailable ^ isSharingAvailable)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ride Type'.tr,
                                  // style: GoogleFonts.inter(
                                  //   color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                  //   fontSize: 16,
                                  //   fontWeight: FontWeight.w500,
                                  // ),
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  Constant.intercityPersonalDocuments.first.isAvailable ?'Personal Ride'.tr : 'Ride Sharing'.tr,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],),
                            // if(Constant.intercityPersonalDocuments.first.isAvailable && Constant.intercitySharingDocuments.first.isAvailable)
                            if (isPersonalAvailable && isSharingAvailable)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Ride Type'.tr,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: Constant.intercityPersonalDocuments.first.isAvailable,
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: 1,
                                            groupValue: controller.selectedRideType.value,
                                            activeColor: AppThemData.primary500,
                                            onChanged: (value) {
                                              controller.selectedRideType.value = value ?? 1;
                                              controller.updateCalculation();
                                              // _radioVal = 'male';
                                            },
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.selectedRideType.value = 1;
                                              controller.updateCalculation();
                                              log('------------------------> personal ride selected ');
                                            },
                                            child: Text(
                                              'Personal Ride'.tr,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: controller.selectedRideType.value == 1
                                                      ? themeChange.isDarkTheme()
                                                          ? AppThemData.white
                                                          : AppThemData.grey950
                                                      : AppThemData.grey500,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: Constant.intercitySharingDocuments.first.isAvailable,
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: 2,
                                            groupValue: controller.selectedRideType.value,
                                            activeColor: AppThemData.primary500,
                                            onChanged: (value) {
                                              controller.selectedRideType.value = value ?? 2;
                                              controller.updateCalculation();
                                              // _radioVal = 'female';
                                            },
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.selectedRideType.value = 2;
                                              controller.updateCalculation();
                                            },
                                            child: Text(
                                              'Ride Sharing'.tr,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: controller.selectedRideType.value == 2
                                                      ? themeChange.isDarkTheme()
                                                          ? AppThemData.white
                                                          : AppThemData.grey950
                                                      : AppThemData.grey500,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
                                  child: GooglePlaceAutoCompleteTextFieldOnlyCity(
                                    textEditingController: index == 0 ? controller.pickupLocationController : controller.dropLocationController,
                                    googleAPIKey: Constant.mapAPIKey,
                                    boxDecoration: BoxDecoration(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
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
                                        controller.updateData();
                                        // controller.polyLines.clear();
                                      } else {
                                        controller.destination = null;
                                        controller.updateData();
                                        // controller.polyLines.clear();
                                      }
                                    },
                                    debounceTime: 800,
                                    isLatLngRequired: true,
                                    focusNode: index == 0 ? controller.pickUpFocusNode : controller.dropFocusNode,
                                    getPlaceDetailWithLatLng: (Prediction prediction) {
                                      if (index == 0) {
                                        controller.sourceLocation = LatLng(double.parse(prediction.lat ?? '0.00'), double.parse(prediction.lng ?? '0.00'));
                                        controller.pikUpAddress.value = prediction.description!;
                                        controller.updateData();
                                      } else {
                                        controller.destination = LatLng(double.parse(prediction.lat ?? '0.00'), double.parse(prediction.lng ?? '0.00'));
                                        controller.dropAddress.value = prediction.description!;
                                        controller.updateData();
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
                                        color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
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
                            const SizedBox(height: 20),
                            if (controller.selectedRideType.value == 1) ...{
                              Text(
                                'Select Date'.tr,
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(top: 4),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
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
                                          controller.selectedDate.value == null ? "Select Date".tr : controller.selectedDate.value!.dateMonthYear(),
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey500,
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
                            },
                            if (controller.selectedRideType.value == 2) ...{
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select Date'.tr,
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
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
                                            padding: const EdgeInsets.all(16),
                                            margin: const EdgeInsets.only(top: 4),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
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
                                                    controller.selectedDate.value == null ? "Select Date".tr : controller.selectedDate.value!.dateMonthYear(),
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey500,
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
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Persons'.tr,
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: 116,
                                          height: 56,
                                          padding: const EdgeInsets.all(16),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    if (controller.selectedPersons.value != 1) {
                                                      controller.selectedPersons.value = controller.selectedPersons.value - 1;
                                                    }
                                                  },
                                                  child: const Icon(Icons.remove)),
                                              Expanded(
                                                child: Text(
                                                  controller.selectedPersons.value.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                    color: themeChange.isDarkTheme() ? AppThemData.grey50 : AppThemData.grey500,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    controller.selectedPersons.value = controller.selectedPersons.value + 1;
                                                  },
                                                  child: const Icon(Icons.add)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            },
                            const SizedBox(height: 20),
                            Text(
                              'Select Time'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => controller.pickTime(context),
                              child: Obx(() => Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.watch_later_outlined, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950),
                                        SizedBox(width: 10), // Spacing between icon and text
                                        Text(
                                          controller.selectedTime.value,
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Set Price'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: controller.addPriceController.value,
                              decoration: InputDecoration(
                                hintText: "Add your price".tr,
                                fillColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                focusColor: Colors.white,
                                filled: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    "assets/icon/ic_currency_usd.svg",
                                  ),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                hintStyle: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Visibility(
                              visible: controller.isEstimatePriceVisible.value,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: themeChange.isDarkTheme() ? AppThemData.secondary900 : AppThemData.secondary100
                                ),
                                child: Text(
                                  'Recommended Price For this Ride ${Constant.amountToShow(amount: double.parse(controller.estimatePrice.value.toString()).toString())}',
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: AppThemData.secondary500,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Select Vehicle'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 0),
                            Container(
                              height: 58.0,
                              width: Responsive.width(100, context),
                              margin: const EdgeInsets.only(top: 6, bottom: 0),
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                                // ),
                                color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                borderRadius: BorderRadius.circular(2000.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Obx(
                                  () => DropdownButton<VehicleTypeModel>(
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                    ),
                                    hint: Text(
                                      "Select Vehicle Type".tr,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                        fontSize: 16,
                                      ),
                                    ),
                                    itemHeight: 70,
                                    dropdownColor: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey25,
                                    padding: const EdgeInsets.only(right: 12),
                                    selectedItemBuilder: (context) {
                                      return controller.vehicleTypeList.map((VehicleTypeModel value) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 12, right: 12),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                value.image,
                                                height: 42,
                                                width: 42,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(value.title),
                                            ],
                                          ),
                                        );
                                      }).toList();
                                    },
                                    items: controller.vehicleTypeList.map<DropdownMenuItem<VehicleTypeModel>>((VehicleTypeModel value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.network(
                                                  value.image,
                                                  height: 42,
                                                  width: 42,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(value.title),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Visibility(visible: controller.vehicleTypeList.indexOf(value) != (controller.vehicleTypeList.length - 1), child: const Divider())
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    borderRadius: BorderRadius.circular(12),
                                    isExpanded: false,
                                    isDense: false,
                                    onChanged:
                                        // isUploaded
                                        //     ? null
                                        //     :
                                        (VehicleTypeModel? newSelectedBank) {
                                      controller.vehicleTypeModel.value = newSelectedBank!;
                                    },
                                    value: controller.vehicleTypeModel.value,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (controller.selectedRideType.value == 2) ...{
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add person'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                                          ),
                                          // backgroundColor: AppThemData.grey50,
                                          context: context,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          builder: (BuildContext context) {
                                            return AddPersonPopup(
                                              themeChange: themeChange,
                                              controller: controller,
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: Responsive.width(100, context),
                                      height: 60,
                                      padding: const EdgeInsets.all(8),
                                      decoration: ShapeDecoration(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: ShapeDecoration(
                                                color: AppThemData.primary50,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(200),
                                                ),
                                              ),
                                              child: SvgPicture.asset("assets/icon/ic_user_add.svg")),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Add Person'.tr,
                                            style: GoogleFonts.inter(
                                              color: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            },
                            const SizedBox(height: 20),
                            Center(
                              child: RoundShapeButton(
                                  size: const Size(200, 45),
                                  title: "Next".tr,
                                  buttonColor: AppThemData.primary500,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () {
                                    if (controller.pickupLocationController.value.text.isEmpty || controller.pickupLocationController.value.text == '') {
                                      return ShowToastDialog.toast('Please Enter pickUp Location'.tr);
                                    }
                                    if (controller.dropLocationController.value.text.isEmpty || controller.dropLocationController.value.text == '') {
                                      return ShowToastDialog.toast('Please Enter Destination Location'.tr);
                                    } else if (controller.addPriceController.value.text.isEmpty || controller.addPriceController.value.text == '') {
                                      controller.addPriceController.value.text = controller.estimatePrice.value.toString();
                                    } else if (controller.selectedRideType.value == 2) {
                                      log('=-------------------->');
                                      if (controller.selectedPersons.value != controller.addInSharing.length + 1) {
                                        log('=--------------------> 2222222');
                                        return ShowToastDialog.toast('Please Add person'.tr);
                                      } else if (controller.selectedTime.value == 'Select Time') {
                                        return ShowToastDialog.toast('Please Select Start Time'.tr);
                                      } else {
                                        Get.to(() => SelectPaymentType());
                                      }
                                    } else if (controller.selectedTime.value == 'Select Time') {
                                      return ShowToastDialog.toast('Please Select Start Time'.tr);
                                    } else {
                                      Get.to(() => SelectPaymentType());
                                    }
                                  }),
                            ),
                            SizedBox(height: 16,)
                          ],
                        ),
                ),
              ),
            ),
          );
        });
  }
}

class AddPersonPopup extends StatelessWidget {
  const AddPersonPopup({
    super.key,
    required this.themeChange,
    required this.controller,
  });

  final DarkThemeProvider themeChange;
  final BookIntercityController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.height(80, context),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      decoration: ShapeDecoration(
        color: themeChange.isDarkTheme() ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Sharing Persons',
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 12),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Column(
                          children: [
                            ...controller.totalAddPersonShare.map((person) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                margin: const EdgeInsets.only(top: 0),
                                decoration: ShapeDecoration(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                person.name ?? '',
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                person.mobileNumber ?? '',
                                                style: GoogleFonts.inter(
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          value: controller.addInSharing.any((p) => p.id == person.id),
                                          activeColor: AppThemData.warning06,
                                          onChanged: (value) {
                                            controller.toggleSelection(person);
                                          },
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              controller.deletePerson(person.id!);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: AppThemData.error07,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                    Container(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      height: 1,
                                      width: Responsive.width(100, context),
                                      margin: const EdgeInsets.only(bottom: 8),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Name'.tr,
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller.enterNameController.value,
                  decoration: InputDecoration(
                    hintText: "Enter Name".tr,
                    fillColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                    focusColor: Colors.white,
                    filled: true,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "assets/icon/ic_user_round.svg",
                      ),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
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
                const SizedBox(height: 12),
                Text(
                  'Number'.tr,
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: controller.enterNumberController.value,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Number".tr,
                    fillColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                    focusColor: Colors.white,
                    filled: true,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "assets/icon/ic_phone_ring.svg",
                      ),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50)),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (controller.enterNameController.value.text.isEmpty || controller.enterNameController.value.text == '') {
                          return ShowToastDialog.toast('Please Enter Name');
                        } else if (controller.enterNumberController.value.text.isEmpty || controller.enterNumberController.value.text == '') {
                          return ShowToastDialog.toast('Please Enter Mobile Number');
                        } else {
                          controller.addPerson();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                            child: SvgPicture.asset("assets/icon/ic_user_add.svg"),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add Person',
                            style: GoogleFonts.inter(
                              color: AppThemData.primary500,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: RoundShapeButton(
                  size: const Size(200, 45),
                  title: "Save".tr,
                  buttonColor: AppThemData.primary500,
                  buttonTextColor: AppThemData.black,
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
