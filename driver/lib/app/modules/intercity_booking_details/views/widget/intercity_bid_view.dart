import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/intercity_booking_details/controllers/intercity_booking_details_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/custom_loader.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/extension/date_time_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class InterCityBidView extends StatelessWidget {
  const InterCityBidView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: InterCityBookingDetailsController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Obx( ()=>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: Responsive.width(100, context),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.interCityModel.value.bookingTime == null ? "" : controller.interCityModel.value.bookingTime!.toDate().dateMonthYear(),
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
                                controller.interCityModel.value.bookingTime == null ? "" : controller.interCityModel.value.bookingTime!.toDate().time(),
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Icon(
                            //   Icons.keyboard_arrow_right_sharp,
                            //   color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                            // )
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
                              FutureBuilder<UserModel?>(
                                  future: FireStoreUtils.getUserProfile(controller.interCityModel.value.customerId ?? ''),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      CustomLoader();
                                    }
                                    UserModel customerModel = snapshot.data ?? UserModel();
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      margin: const EdgeInsets.only(right: 10),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: (customerModel.profilePic != null && customerModel.profilePic!.isNotEmpty) ? customerModel.profilePic! : Constant.profileConstant,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CustomLoader(),
                                        ),
                                        errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder),
                                      ),
                                    );
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
                                    //       image: CachedNetworkImageProvider(
                                    //         (Constant.userModel?.profilePic == null || Constant.userModel!.profilePic!.isEmpty)
                                    //             ? Constant.profileConstant
                                    //             : Constant.userModel!.profilePic.toString(),
                                    //       ),
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // );
                                  }),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID: ${controller.interCityModel.value.id!.substring(0, 5)}',
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Ride Start Date: ${Constant.formatDate(Constant.parseDate(controller.interCityModel.value.startDate))}',
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
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
                                    Constant.amountToShow(amount: Constant.calculateInterCityFinalAmount(controller.interCityModel.value).toString()),
                                    // amount: Constant.calculateInterCityFinalAmount(bookingModel).toStringAsFixed(2)),
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
                                        '${controller.interCityModel.value.persons}',
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
                            PickDropPointView(pickUpAddress: controller.interCityModel.value.pickUpLocationAddress ?? '', dropAddress: controller.interCityModel.value.dropLocationAddress ?? ''),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
                    child: Obx(
                          () {
                            BidModel? driverBid = controller.interCityModel.value.bidList!.firstWhereOrNull((bid)=> bid.driverID == FireStoreUtils.getCurrentUid());
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Views'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.grey25
                                    : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            driverBid == null ? Center(
                                    child: Text(
                                      'No Available Any Bid'.tr,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme()
                                            ? AppThemData.grey25
                                            : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ): FutureBuilder<DriverUserModel?>(
                                    future: FireStoreUtils.getDriverUserProfile(
                                        driverBid.driverID ?? ''),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      }
                                      DriverUserModel driverUserModel =
                                          snapshot.data ?? DriverUserModel();
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width:
                                                Responsive.width(100, context),
                                            padding: const EdgeInsets.all(16),
                                            margin: const EdgeInsets.only(
                                                bottom: 14),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: themeChange
                                                            .isDarkTheme()
                                                        ? AppThemData.grey800
                                                        : AppThemData.grey100),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // const SizedBox(height: 12),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 48,
                                                      width: 48,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2000),
                                                        child:
                                                            CachedNetworkImage(
                                                          // imageUrl: (  Constant.userModel!.profilePic =='' || Constant.userModel!.profilePic == null) ? Constant.profileConstant : Constant.userModel!.profilePic.toString(),
                                                          imageUrl: (driverUserModel
                                                                          .profilePic !=
                                                                      null &&
                                                                  driverUserModel
                                                                      .profilePic!
                                                                      .isNotEmpty)
                                                              ? driverUserModel
                                                                  .profilePic!
                                                              : Constant
                                                                  .profileConstant,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Constant.loader(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(Constant
                                                                  .userPlaceHolder),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${driverUserModel.fullName}',
                                                            style: GoogleFonts
                                                                .inter(
                                                              color: themeChange
                                                                      .isDarkTheme()
                                                                  ? AppThemData
                                                                      .grey25
                                                                  : AppThemData
                                                                      .grey950,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                  Icons
                                                                      .star_rate_rounded,
                                                                  color: AppThemData
                                                                      .warning500),
                                                              Text(
                                                                Constant.calculateReview(
                                                                        reviewCount:
                                                                            driverUserModel
                                                                                .reviewsCount,
                                                                        reviewSum:
                                                                            driverUserModel.reviewsSum)
                                                                    .toString(),
                                                                // driverUserModel.reviewsSum ?? '0.0',
                                                                style:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  color: themeChange.isDarkTheme()
                                                                      ? AppThemData
                                                                          .white
                                                                      : AppThemData
                                                                          .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    driverBid.bidStatus ==
                                                            'close'
                                                        ? Container(
                                                            width: 77,
                                                            height: 32,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2000),
                                                                color: AppThemData
                                                                    .danger50),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Closed'.tr,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: AppThemData
                                                                    .danger500,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 77,
                                                            height: 32,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2000),
                                                                color: AppThemData
                                                                    .success50),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'Active'.tr,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: AppThemData
                                                                    .success500,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.start,
                                                //   children: [
                                                //     SvgPicture.asset(
                                                //       "assets/icon/ic_map.svg",
                                                //     ),
                                                //     const SizedBox(width: 8),
                                                //     // SvgPicture.asset(
                                                //     //   "assets/icon/ic_ride.svg",
                                                //     // ),
                                                //     Text(
                                                //       '2km away from your destination location'.tr,
                                                //       style: GoogleFonts.inter(
                                                //         color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                //         fontSize: 12,
                                                //         fontWeight: FontWeight.w400,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                // const SizedBox(height: 4),
                                                Divider(),
                                                const SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icon/ic_ride.svg",
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          '${driverUserModel.driverVehicleDetails!.brandName}'
                                                              .tr,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: themeChange
                                                                    .isDarkTheme()
                                                                ? AppThemData
                                                                    .grey25
                                                                : AppThemData
                                                                    .grey950,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        // SvgPicture.asset(
                                                        //   "assets/icon/ic_ride.svg",
                                                        // ),
                                                        // const SizedBox(width: 8),
                                                        Text(
                                                          Constant.amountToShow(
                                                              amount: driverBid
                                                                  .amount),
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: themeChange
                                                                    .isDarkTheme()
                                                                ? AppThemData
                                                                    .grey25
                                                                : AppThemData
                                                                    .grey950,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icon/ic_number.svg",
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          '${driverUserModel.driverVehicleDetails!.vehicleNumber}'
                                                              .tr,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: themeChange
                                                                    .isDarkTheme()
                                                                ? AppThemData
                                                                    .grey25
                                                                : AppThemData
                                                                    .grey950,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                            // controller.interCityModel.value.bidList!.isEmpty
                            //     ? Center(
                            //         child: Text(
                            //           'No Available Any Bid'.tr,
                            //           style: GoogleFonts.inter(
                            //             color: themeChange.isDarkTheme()
                            //                 ? AppThemData.grey25
                            //                 : AppThemData.grey950,
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w500,
                            //           ),
                            //         ),
                            //       )
                            //     : ListView.builder(
                            //         itemCount: controller
                            //             .interCityModel.value.bidList!.length,
                            //         shrinkWrap: true,
                            //         physics: NeverScrollableScrollPhysics(),
                            //         // scrollDirection: Axis.vertical,
                            //         itemBuilder: (contex, index) {
                            //           BidModel bidModel = controller
                            //               .interCityModel.value.bidList![index];
                            //           return FutureBuilder<DriverUserModel?>(
                            //               future: FireStoreUtils
                            //                   .getDriverUserProfile(
                            //                       bidModel.driverID ?? ''),
                            //               builder: (context, snapshot) {
                            //                 if (!snapshot.hasData) {
                            //                   return Container();
                            //                 }
                            //                 DriverUserModel driverUserModel =
                            //                     snapshot.data ??
                            //                         DriverUserModel();
                            //                 return Column(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                   children: [
                            //                     Container(
                            //                       width: Responsive.width(
                            //                           100, context),
                            //                       padding:
                            //                           const EdgeInsets.all(16),
                            //                       margin: const EdgeInsets.only(
                            //                           bottom: 14),
                            //                       decoration: ShapeDecoration(
                            //                         shape:
                            //                             RoundedRectangleBorder(
                            //                           side: BorderSide(
                            //                               width: 1,
                            //                               color: themeChange
                            //                                       .isDarkTheme()
                            //                                   ? AppThemData
                            //                                       .grey800
                            //                                   : AppThemData
                            //                                       .grey100),
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   12),
                            //                         ),
                            //                       ),
                            //                       child: Column(
                            //                         mainAxisSize:
                            //                             MainAxisSize.min,
                            //                         mainAxisAlignment:
                            //                             MainAxisAlignment.start,
                            //                         crossAxisAlignment:
                            //                             CrossAxisAlignment
                            //                                 .start,
                            //                         children: [
                            //                           // const SizedBox(height: 12),
                            //                           Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.min,
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .start,
                            //                             crossAxisAlignment:
                            //                                 CrossAxisAlignment
                            //                                     .center,
                            //                             children: [
                            //                               SizedBox(
                            //                                 height: 48,
                            //                                 width: 48,
                            //                                 child: ClipRRect(
                            //                                   borderRadius:
                            //                                       BorderRadius
                            //                                           .circular(
                            //                                               2000),
                            //                                   child:
                            //                                       CachedNetworkImage(
                            //                                     // imageUrl: (  Constant.userModel!.profilePic =='' || Constant.userModel!.profilePic == null) ? Constant.profileConstant : Constant.userModel!.profilePic.toString(),
                            //                                     imageUrl: (driverUserModel.profilePic !=
                            //                                                 null &&
                            //                                             driverUserModel
                            //                                                 .profilePic!
                            //                                                 .isNotEmpty)
                            //                                         ? driverUserModel
                            //                                             .profilePic!
                            //                                         : Constant
                            //                                             .profileConstant,
                            //                                     fit: BoxFit
                            //                                         .cover,
                            //                                     placeholder: (context,
                            //                                             url) =>
                            //                                         Constant
                            //                                             .loader(),
                            //                                     errorWidget: (context,
                            //                                             url,
                            //                                             error) =>
                            //                                         Image.asset(
                            //                                             Constant
                            //                                                 .userPlaceHolder),
                            //                                   ),
                            //                                 ),
                            //                               ),
                            //                               const SizedBox(
                            //                                   width: 12),
                            //                               Expanded(
                            //                                 child: Column(
                            //                                   mainAxisSize:
                            //                                       MainAxisSize
                            //                                           .min,
                            //                                   mainAxisAlignment:
                            //                                       MainAxisAlignment
                            //                                           .center,
                            //                                   crossAxisAlignment:
                            //                                       CrossAxisAlignment
                            //                                           .start,
                            //                                   children: [
                            //                                     Text(
                            //                                       '${driverUserModel.fullName}',
                            //                                       style:
                            //                                           GoogleFonts
                            //                                               .inter(
                            //                                         color: themeChange.isDarkTheme()
                            //                                             ? AppThemData
                            //                                                 .grey25
                            //                                             : AppThemData
                            //                                                 .grey950,
                            //                                         fontSize:
                            //                                             14,
                            //                                         fontWeight:
                            //                                             FontWeight
                            //                                                 .w600,
                            //                                       ),
                            //                                     ),
                            //                                     const SizedBox(
                            //                                         height: 2),
                            //                                     Row(
                            //                                       mainAxisAlignment:
                            //                                           MainAxisAlignment
                            //                                               .start,
                            //                                       crossAxisAlignment:
                            //                                           CrossAxisAlignment
                            //                                               .center,
                            //                                       children: [
                            //                                         const Icon(
                            //                                             Icons
                            //                                                 .star_rate_rounded,
                            //                                             color: AppThemData
                            //                                                 .warning500),
                            //                                         Text(
                            //                                           Constant.calculateReview(
                            //                                                   reviewCount: driverUserModel.reviewsCount,
                            //                                                   reviewSum: driverUserModel.reviewsSum)
                            //                                               .toString(),
                            //                                           // driverUserModel.reviewsSum ?? '0.0',
                            //                                           style: GoogleFonts
                            //                                               .inter(
                            //                                             color: themeChange.isDarkTheme()
                            //                                                 ? AppThemData.white
                            //                                                 : AppThemData.black,
                            //                                             fontSize:
                            //                                                 14,
                            //                                             fontWeight:
                            //                                                 FontWeight.w400,
                            //                                           ),
                            //                                         ),
                            //                                       ],
                            //                                     ),
                            //                                   ],
                            //                                 ),
                            //                               ),
                            //                               const SizedBox(
                            //                                   width: 16),
                            //                               bidModel.bidStatus ==
                            //                                       'close'
                            //                                   ? Container(
                            //                                       width: 77,
                            //                                       height: 32,
                            //                                       decoration: BoxDecoration(
                            //                                           borderRadius:
                            //                                               BorderRadius.circular(
                            //                                                   2000),
                            //                                           color: AppThemData
                            //                                               .danger50),
                            //                                       alignment:
                            //                                           Alignment
                            //                                               .center,
                            //                                       child: Text(
                            //                                         'Closed'.tr,
                            //                                         style: GoogleFonts
                            //                                             .inter(
                            //                                           color: AppThemData
                            //                                               .danger500,
                            //                                           fontSize:
                            //                                               16,
                            //                                           fontWeight:
                            //                                               FontWeight
                            //                                                   .w400,
                            //                                         ),
                            //                                       ),
                            //                                     )
                            //                                   : Container(
                            //                                       width: 77,
                            //                                       height: 32,
                            //                                       decoration: BoxDecoration(
                            //                                           borderRadius:
                            //                                               BorderRadius.circular(
                            //                                                   2000),
                            //                                           color: AppThemData
                            //                                               .success50),
                            //                                       alignment:
                            //                                           Alignment
                            //                                               .center,
                            //                                       child: Text(
                            //                                         'Active'.tr,
                            //                                         style: GoogleFonts
                            //                                             .inter(
                            //                                           color: AppThemData
                            //                                               .success500,
                            //                                           fontSize:
                            //                                               16,
                            //                                           fontWeight:
                            //                                               FontWeight
                            //                                                   .w400,
                            //                                         ),
                            //                                       ),
                            //                                     )
                            //                             ],
                            //                           ),
                            //                           const SizedBox(height: 8),
                            //                           // Row(
                            //                           //   mainAxisAlignment: MainAxisAlignment.start,
                            //                           //   children: [
                            //                           //     SvgPicture.asset(
                            //                           //       "assets/icon/ic_map.svg",
                            //                           //     ),
                            //                           //     const SizedBox(width: 8),
                            //                           //     // SvgPicture.asset(
                            //                           //     //   "assets/icon/ic_ride.svg",
                            //                           //     // ),
                            //                           //     Text(
                            //                           //       '2km away from your destination location'.tr,
                            //                           //       style: GoogleFonts.inter(
                            //                           //         color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            //                           //         fontSize: 12,
                            //                           //         fontWeight: FontWeight.w400,
                            //                           //       ),
                            //                           //     ),
                            //                           //   ],
                            //                           // ),
                            //                           // const SizedBox(height: 4),
                            //                           Divider(),
                            //                           const SizedBox(height: 6),
                            //                           Row(
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .spaceBetween,
                            //                             children: [
                            //                               Row(
                            //                                 children: [
                            //                                   SvgPicture.asset(
                            //                                     "assets/icon/ic_ride.svg",
                            //                                   ),
                            //                                   const SizedBox(
                            //                                       width: 8),
                            //                                   Text(
                            //                                     '${driverUserModel.driverVehicleDetails!.brandName}'
                            //                                         .tr,
                            //                                     style:
                            //                                         GoogleFonts
                            //                                             .inter(
                            //                                       color: themeChange.isDarkTheme()
                            //                                           ? AppThemData
                            //                                               .grey25
                            //                                           : AppThemData
                            //                                               .grey950,
                            //                                       fontSize: 12,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .w400,
                            //                                     ),
                            //                                   ),
                            //                                 ],
                            //                               ),
                            //                               Row(
                            //                                 children: [
                            //                                   // SvgPicture.asset(
                            //                                   //   "assets/icon/ic_ride.svg",
                            //                                   // ),
                            //                                   // const SizedBox(width: 8),
                            //                                   Text(
                            //                                     Constant.amountToShow(
                            //                                         amount: bidModel
                            //                                             .amount),
                            //                                     style:
                            //                                         GoogleFonts
                            //                                             .inter(
                            //                                       color: themeChange.isDarkTheme()
                            //                                           ? AppThemData
                            //                                               .grey25
                            //                                           : AppThemData
                            //                                               .grey950,
                            //                                       fontSize: 14,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .w500,
                            //                                     ),
                            //                                   ),
                            //                                 ],
                            //                               ),
                            //                               Row(
                            //                                 children: [
                            //                                   SvgPicture.asset(
                            //                                     "assets/icon/ic_number.svg",
                            //                                   ),
                            //                                   const SizedBox(
                            //                                       width: 8),
                            //                                   Text(
                            //                                     '${driverUserModel.driverVehicleDetails!.vehicleNumber}'
                            //                                         .tr,
                            //                                     style:
                            //                                         GoogleFonts
                            //                                             .inter(
                            //                                       color: themeChange.isDarkTheme()
                            //                                           ? AppThemData
                            //                                               .grey25
                            //                                           : AppThemData
                            //                                               .grey950,
                            //                                       fontSize: 12,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .w400,
                            //                                     ),
                            //                                   ),
                            //                                 ],
                            //                               )
                            //                             ],
                            //                           )
                            //                         ],
                            //                       ),
                            //                     )
                            //                   ],
                            //                 );
                            //               });
                            //         }),
                            // shouldShowButton != true ? SizedBox(height: 50,) : SizedBox(height: 50,),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              )
          ),
        );
      },
    );
  }
}
