import 'package:customer/app/models/vehicle_type_model.dart';
import 'package:customer/app/modules/book_parcel/views/widgets/parcel_payment_type.dart';
import 'package:customer/constant_widgets/app_bar_with_border.dart';
import 'package:customer/constant_widgets/show_toast_dialog.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/google_places_city_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/dependency_packages/google_auto_complete_textfield/model/prediction.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../controllers/book_parcel_controller.dart';

class BookParcelView extends StatelessWidget {
  const BookParcelView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: BookParcelController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBarWithBorder(
              title: "",
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.grey50,
            body: Obx(
              () => controller.isLoading.value == true
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                        // controller.updateData();
                                        // controller.polyLines.clear();
                                      } else {
                                        controller.destination = null;
                                        controller.updateData();
                                        // controller.updateData();
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
                                        'Weight'.tr,
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: controller.weightController.value,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          filled: true,
                                          // hintStyle: TextStyle(color: Colors.grey[800]),
                                          hintStyle: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          hintText: "Enter Weight".tr,
                                          fillColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dimension'.tr,
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: controller.dimensionController.value,
                                        decoration: InputDecoration(
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                          filled: true,
                                          hintStyle: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          hintText: "Enter Dimension".tr,
                                          fillColor: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
                                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
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
                                border:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                disabledBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                enabledBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                errorBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                focusedBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
                                focusedErrorBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25)),
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: themeChange.isDarkTheme() ? AppThemData.secondary900 : AppThemData.secondary100),
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
                                )),
                            const SizedBox(height: 20),
                            Text(
                              'Select Vehicle'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 58.0,
                              width: Responsive.width(100, context),
                              margin: const EdgeInsets.only(top: 6, bottom: 0, left: 0),
                              // padding: EdgeInsets.only(left:- 20,right: - 20),
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
                                    dropdownColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
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
                            Text(
                              'Upload Image'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  if (controller.selectedImage.value == null) {
                                    buildBottomSheet(context, controller);
                                  }
                                },
                                child: Container(
                                  width: Responsive.width(100, context),
                                  height: 181,
                                  padding: const EdgeInsets.all(16),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey25,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: controller.selectedImage.value == null ? buildUploadView() : buildImagePreview(controller),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: RoundShapeButton(
                                  size: const Size(200, 45),
                                  title: "Next".tr,
                                  buttonColor: AppThemData.primary500,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () {
                                    if (controller.dropLocationController.value.text.isEmpty || controller.dropLocationController.value.text == '') {
                                      return ShowToastDialog.toast('Please Enter Destination Location'.tr);
                                    } else if (controller.weightController.value.text.isEmpty || controller.weightController.value.text == '') {
                                      return ShowToastDialog.toast('Please Enter Your Weight'.tr);
                                    } else if (controller.dimensionController.value.text.isEmpty || controller.dimensionController.value.text == '') {
                                      return ShowToastDialog.toast('Please Enter Your Dimension'.tr);
                                    } else if (controller.addPriceController.value.text.isEmpty || controller.addPriceController.value.text == '') {
                                      // return ShowToastDialog.toast('Please Enter Your Price');
                                      controller.addPriceController.value.text = controller.estimatePrice.value.toString();
                                    } else if (controller.selectedImage.value == null) {
                                      return ShowToastDialog.toast('Please Add Parcel Image'.tr);
                                    } else if (controller.selectedTime.value == 'Select Time') {
                                      return ShowToastDialog.toast('Please Select Ride Time'.tr);
                                    } else {
                                      // controller.saveParcelData();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        isDismissible: true,
                                        enableDrag: true,
                                        constraints: BoxConstraints(maxHeight: Responsive.height(90, context), maxWidth: Responsive.width(100, context)),
                                        builder: (BuildContext context) {
                                          return const ParcelPaymentDialogView();
                                        },
                                      );
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 16,
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }

  Widget buildUploadView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: AppThemData.primary50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200),
            ),
          ),
          child: SvgPicture.asset("assets/icon/ic_upload.svg"),
        ),
        Text(
          'Upload Image'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppThemData.grey500,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          'Image size should be a max 2MB'.tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppThemData.info500,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildImagePreview(BookParcelController controller) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            controller.selectedImage.value!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => controller.removeImage(),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future buildBottomSheet(BuildContext context, BookParcelController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("Please Select".tr,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "Camera".tr,
                                style: GoogleFonts.inter(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "Gallery".tr,
                                style: GoogleFonts.inter(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
