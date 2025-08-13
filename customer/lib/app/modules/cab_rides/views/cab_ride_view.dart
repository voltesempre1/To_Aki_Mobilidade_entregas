import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/modules/cab_ride_details/views/cab_ride_details_view.dart';
import 'package:customer/app/modules/select_location/views/select_location_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:customer/app/models/booking_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/no_rides_view.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/extension/date_time_extension.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/cab_ride_controller.dart';

class CabRideView extends StatelessWidget {
  const CabRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: CabRideController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTabButton(context, controller, themeChange, 0, "Ongoing"),
                        _buildTabButton(context, controller, themeChange, 1, "Completed"),
                        _buildTabButton(context, controller, themeChange, 2, "Rejected"),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.getData(
                        isOngoingDataFetch: controller.selectedType.value == 0,
                        isCompletedDataFetch: controller.selectedType.value == 1,
                        isRejectedDataFetch: controller.selectedType.value == 2,
                      );
                    },
                    child: Obx(
                      () {
                        final rides = controller.selectedType.value == 0
                            ? controller.ongoingRides
                            : controller.selectedType.value == 1
                                ? controller.completedRides
                                : controller.rejectedRides;
                        if (rides.isEmpty) {
                          return ListView(
                            children: [
                              NoRidesView(
                                themeChange: themeChange,
                                onTap: () {
                                  Get.to(const SelectLocationView());
                                },
                              )
                            ],
                          );
                        }
                        return ListView.builder(
                          itemCount: rides.length,
                          padding: EdgeInsets.only(bottom: 8),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _buildRideTile(context, controller, themeChange, rides[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTabButton(BuildContext context, CabRideController controller, DarkThemeProvider themeChange, int type, String title) {
    return RoundShapeButton(
      title: title.tr,
      buttonColor: controller.selectedType.value == type
          ? AppThemData.primary500
          : themeChange.isDarkTheme()
              ? AppThemData.black
              : AppThemData.white,
      buttonTextColor: controller.selectedType.value == type
          ? AppThemData.black
          : themeChange.isDarkTheme()
              ? AppThemData.white
              : AppThemData.black,
      onTap: () {
        controller.selectedType.value = type;
      },
      size: Size((Responsive.width(88, context) / 3), 38),
      textSize: 12,
    );
  }

  Widget _buildRideTile(BuildContext context, CabRideController controller, DarkThemeProvider themeChange, BookingModel bookingModel) {
    final RxBool isOpen = false.obs;
    return InkWell(
      onTap: () {
        Get.to(const CabRideDetailsView(), arguments: {"bookingModel": bookingModel});
      },
      child: Container(
        width: Responsive.width(100, context),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                isOpen.value = !isOpen.value;
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    bookingModel.bookingTime == null ? "" : bookingModel.bookingTime!.toDate().dateMonthYear(),
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
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
                          color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bookingModel.bookingTime == null ? "" : bookingModel.bookingTime!.toDate().time(),
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CachedNetworkImage(
                      imageUrl: bookingModel.vehicleType == null ? Constant.profileConstant : bookingModel.vehicleType!.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Constant.loader(),
                      errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookingModel.vehicleType == null ? "" : bookingModel.vehicleType!.title,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (bookingModel.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                        Constant.amountToShow(amount: Constant.calculateFinalAmount(bookingModel).toStringAsFixed(2)),
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
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
                            bookingModel.vehicleType == null ? "" : bookingModel.vehicleType!.persons,
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
            Obx(() => Visibility(
                  visible: isOpen.value,
                  child: PickDropPointView(
                    pickUpAddress: bookingModel.pickUpLocationAddress ?? '',
                    dropAddress: bookingModel.dropLocationAddress ?? '',
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
