import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/person_model.dart';
import 'package:customer/app/models/tax_model.dart';
import 'package:customer/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:customer/app/modules/intercity_ride_details/controllers/intercity_ride_details_controller.dart';
import 'package:customer/app/modules/payment_method/views/widgets/price_row_view.dart';
import 'package:customer/constant/booking_status.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/pick_drop_point_view.dart';
import 'package:customer/constant_widgets/title_view.dart';
import 'package:customer/theme/app_them_data.dart';
import 'package:customer/theme/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class InterCityDetailsView extends StatelessWidget {
  const InterCityDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: InterCityRideDetailsController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ride Status'.tr,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      BookingStatus.getBookingStatusTitle(controller.interCityModel.value.bookingStatus ?? ''),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        color: BookingStatus.getBookingStatusTitleColor(controller.interCityModel.value.bookingStatus ?? ''),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: controller.interCityModel.value.bookingStatus == BookingStatus.bookingAccepted,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Your OTP for Ride'.tr,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        controller.interCityModel.value.otp ?? '',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          color: AppThemData.primary500,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                TitleView(titleText: 'Cab Details'.tr, padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                Container(
                  width: Responsive.width(100, context),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Container(
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
                              imageUrl: controller.interCityModel.value.vehicleType == null ? Constant.profileConstant : controller.interCityModel.value.vehicleType!.image,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Constant.loader(),
                              errorWidget: (context, url, error) => Image.asset(
                                Constant.userPlaceHolder,
                                fit: BoxFit.cover,
                              )),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.interCityModel.value.vehicleType == null ? "" : controller.interCityModel.value.vehicleType!.title,
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                (controller.interCityModel.value.paymentStatus ?? false) ? 'Payment is Completed'.tr : 'Payment is Pending'.tr,
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
                              Constant.amountToShow(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toStringAsFixed(2)),
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
                                  controller.interCityModel.value.persons.toString(),
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
                ),
                if (controller.interCityModel.value.bookingStatus != BookingStatus.bookingPlaced) ...{
                  FutureBuilder<DriverUserModel?>(
                      future: FireStoreUtils.getDriverUserProfile(controller.interCityModel.value.driverId ?? ''),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        DriverUserModel driverUserModel = snapshot.data ?? DriverUserModel();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleView(titleText: 'Driver Details'.tr, padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                            Container(
                              width: Responsive.width(100, context),
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    margin: const EdgeInsets.only(right: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(driverUserModel.profilePic != null
                                            ? driverUserModel.profilePic!.isNotEmpty
                                            ? driverUserModel.profilePic ?? Constant.profileConstant
                                            : Constant.profileConstant
                                            : Constant.profileConstant),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          driverUserModel.fullName ?? '',
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rate_rounded, color: AppThemData.warning500),
                                            Text(
                                              Constant.calculateReview(reviewCount: driverUserModel.reviewsCount, reviewSum: driverUserModel.reviewsSum).toString(),
                                              // driverUserModel.reviewsSum ?? '0.0',
                                              style: GoogleFonts.inter(
                                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Get.to(ChatScreenView(
                                          receiverId: driverUserModel.id ?? '',
                                        ));
                                      },
                                      child: SvgPicture.asset("assets/icon/ic_message.svg")),
                                  const SizedBox(width: 12),
                                  InkWell(
                                      onTap: () {
                                        Constant().launchCall("${driverUserModel.countryCode}${driverUserModel.phoneNumber}");
                                      },
                                      child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            )
                          ],
                        );
                      })
                },
                PickDropPointView(
                  pickUpAddress: controller.interCityModel.value.pickUpLocationAddress ?? '',
                  dropAddress: controller.interCityModel.value.dropLocationAddress ?? '',
                ),
                TitleView(titleText: 'Ride Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                Container(
                  width: Responsive.width(100, context),
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icon/ic_calendar.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Date'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            // controller.interCityModel.value.bookingTime == null ? "" : controller.interCityModel.value.bookingTime!.toDate().dateMonthYear(),
                            controller.interCityModel.value.bookingTime == null ? "" : Constant.formatDate(Constant.parseDate(controller.interCityModel.value.startDate)),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 0.11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icon/ic_time.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Time'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            controller.interCityModel.value.rideStartTime.toString(),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 0.11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icon/ic_distance.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Distance'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '${double.parse(controller.interCityModel.value.distance!.distance!).toStringAsFixed(2)} ${controller.interCityModel.value.distance!.distanceType!}',
                            style: GoogleFonts.inter(
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: controller.interCityModel.value.isPersonalRide == false ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleView(titleText: 'Ride Sharing'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                      const SizedBox(height: 8),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: ListView.builder(
                            itemCount: controller.interCityModel.value.sharingPersonList!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                              PersonModel personModel = controller.interCityModel.value.sharingPersonList![index];
                              return   Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    personModel.name.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    personModel.mobileNumber.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (index != controller.interCityModel.value.sharingPersonList!.length - 1)
                                    const Divider(),
                                ],
                              );

                            }),
                      ),

                      // Container(
                      //   width: Responsive.width(100, context),
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: ShapeDecoration(
                      //     shape: RoundedRectangleBorder(
                      //       side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Umag Souvaratha',
                      //         style: GoogleFonts.inter(
                      //           color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 2,
                      //       ),
                      //       Text(
                      //         '9874563214',
                      //         style: GoogleFonts.inter(
                      //           color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       const Divider(),
                      //       // const SizedBox(width: 12),
                      //       // InkWell(
                      //       //     onTap: () {
                      //       //       Constant().launchCall("${customerModel.countryCode}${customerModel.phoneNumber}");
                      //       //     },
                      //       //     child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                      //     ],
                      //   ),
                      // ),

                    ],
                  ),
                ),
                TitleView(titleText: 'Price Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 0)),
                Container(
                  width: Responsive.width(100, context),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 12),
                  decoration: ShapeDecoration(
                    color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(
                        () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PriceRowView(
                          price: Constant.amountToShow(amount: controller.interCityModel.value.subTotal.toString()),
                          title: "Amount".tr,
                          priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        ),
                        const SizedBox(height: 16),
                        PriceRowView(
                            price: Constant.amountToShow(amount: controller.interCityModel.value.discount ?? '0.0'),
                            title: "Discount".tr,
                            priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                        const SizedBox(height: 16),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.interCityModel.value.taxList!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            TaxModel taxModel = controller.interCityModel.value.taxList![index];
                            return Column(
                              children: [
                                PriceRowView(
                                    price: Constant.amountToShow(amount: Constant.calculateTax(amount:((double.parse(controller.interCityModel.value.subTotal ?? '0.0')) - (double.parse(controller.interCityModel.value.discount ?? '0.0'))).toString(), taxModel: taxModel).toString()),
                                    title: "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                    priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Divider(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                        const SizedBox(height: 12),
                        PriceRowView(
                          price: Constant.amountToShow(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString()),
                          title: "Total Amount".tr,
                          priceColor: AppThemData.primary500,
                          titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
