// ignore_for_file: deprecated_member_use

import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/extension/date_time_extension.dart';
import 'package:admin/app/models/tax_model.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/screen_size.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/cab_detail_controller.dart';
import 'widget/pick_drop_point_view.dart';
import 'widget/price_row_view.dart';

class CabDetailView extends GetView<CabDetailController> {
  const CabDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CabDetailController>(
      init: CabDetailController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
          // appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKey),
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            leadingWidth: 200,
            // title: title,
            leading: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    if (!ResponsiveWidget.isDesktop(context)) {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: !ResponsiveWidget.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.menu,
                              size: 30,
                              color: themeChange.isDarkTheme() ? AppThemData.primary500 : AppThemData.primary500,
                            ),
                          )
                        : SizedBox(
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/image/logo.png",
                                  height: 45,
                                  color: AppThemData.primary500,
                                ),
                                spaceW(),
                                const TextCustom(
                                  title: 'My Taxi',
                                  color: AppThemData.primary500,
                                  fontSize: 30,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w700,
                                )
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (themeChange.darkTheme == 1) {
                    themeChange.darkTheme = 0;
                  } else if (themeChange.darkTheme == 0) {
                    themeChange.darkTheme = 1;
                  } else if (themeChange.darkTheme == 2) {
                    themeChange.darkTheme = 0;
                  } else {
                    themeChange.darkTheme = 2;
                  }
                },
                child: themeChange.isDarkTheme()
                    ? SvgPicture.asset(
                        "assets/icons/ic_sun.svg",
                        color: AppThemData.yellow600,
                        height: 20,
                        width: 20,
                      )
                    : SvgPicture.asset(
                        "assets/icons/ic_moon.svg",
                        color: AppThemData.blue400,
                        height: 20,
                        width: 20,
                      ),
              ),
              spaceW(),
              const LanguagePopUp(),
              spaceW(),
              ProfilePopUp()
            ],
          ),
          drawer: Drawer(
            width: 270,
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            child: const MenuWidget(),
          ),
          // drawer: CommonUI.drawerCustom(scaffoldKey: controller.scaffoldKey, themeChange: themeChange),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
              Expanded(
                  child: controller.isLoading.value
                      ?Constant.loader()
                        
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: ContainerCustom(
                                    child: Column(children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          10.width,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                TextCustom(title: controller.title.value, fontSize: 20, fontFamily: AppThemeData.bold),
                                                spaceH(height: 2),
                                                Row(children: [
                                                  GestureDetector(
                                                      onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                      child: TextCustom(
                                                          title: 'Dashboard'.tr,
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.medium,
                                                          color: AppThemData.greyShade500)),
                                                  const TextCustom(
                                                      title: ' / ',
                                                      fontSize: 14,
                                                      fontFamily: AppThemeData.medium,
                                                      color: AppThemData.greyShade500),
                                                  GestureDetector(
                                                      onTap: () => Get.offAllNamed(Routes.CAB_BOOKING_SCREEN),
                                                      child: TextCustom(
                                                          title: 'Cab Booking'.tr,
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.medium,
                                                          color: AppThemData.greyShade500)),
                                                  const TextCustom(
                                                      title: ' / ',
                                                      fontSize: 14,
                                                      fontFamily: AppThemeData.medium,
                                                      color: AppThemData.greyShade500),
                                                  TextCustom(
                                                      title: ' ${controller.title.value} ',
                                                      fontSize: 14,
                                                      fontFamily: AppThemeData.medium,
                                                      color: AppThemData.primary500)
                                                ])
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                      spaceH(height: 20),
                                      ResponsiveWidget(
                                        mobile: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextCustom(
                                                            title: "Order ID # ${controller.bookingModel.value.id!.substring(0, 8)}",
                                                            fontSize: 18,
                                                            fontFamily: AppThemeData.bold),
                                                        spaceH(height: 2),
                                                        TextCustom(
                                                            title:
                                                                "${Constant.timestampToDate(controller.bookingModel.value.createAt!)} at ${Constant.timestampToTime(controller.bookingModel.value.createAt!)}",
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.medium),
                                                      ],
                                                    ),
                                                    spaceH(),
                                                    Container(
                                                      child: Constant.bookingStatusText(
                                                          context, controller.bookingModel.value.bookingStatus.toString()),
                                                    ),
                                                    spaceH(height: 40),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextCustom(
                                                          title: "Customer Details".tr,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.bold,
                                                        ),
                                                        spaceH(height: 16),
                                                        rowDataWidget(
                                                            name: "Name",
                                                            value: controller.userModel.value.fullName.toString(),
                                                            themeChange: themeChange),
                                                        rowDataWidget(
                                                            name: "Phone No.",
                                                            value: Constant.maskMobileNumber(
                                                                mobileNumber: controller.userModel.value.phoneNumber.toString(),
                                                                countryCode: controller.userModel.value.countryCode.toString()),
                                                            themeChange: themeChange),
                                                      ],
                                                    ),
                                                    spaceH(height: 24),
                                                    if (controller.driverModel.value.id != null)
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextCustom(
                                                            title: "Driver Details".tr,
                                                            fontSize: 16,
                                                            fontFamily: AppThemeData.bold,
                                                          ),
                                                          spaceH(height: 16),
                                                          rowDataWidget(
                                                              name: "ID",
                                                              value: "# ${controller.driverModel.value.id.toString().substring(0, 6)}",
                                                              themeChange: themeChange),
                                                          rowDataWidget(
                                                              name: "Name",
                                                              value: controller.driverModel.value.fullName.toString(),
                                                              themeChange: themeChange),
                                                          rowDataWidget(
                                                              name: "Phone No.",
                                                              value: Constant.maskMobileNumber(
                                                                  mobileNumber: controller.driverModel.value.phoneNumber.toString(),
                                                                  countryCode: controller.driverModel.value.countryCode.toString()),
                                                              themeChange: themeChange),
                                                        ],
                                                      ),
                                                    controller.bookingModel.value.cancelledReason != null &&
                                                        controller.bookingModel.value.cancelledReason
                                                            .toString()
                                                            .isNotEmpty ?
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        spaceH(height: 20),
                                                        TextCustom(
                                                          title: "Cancelled Reason".tr,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.bold,
                                                        ),
                                                        spaceH(height: 8),
                                                        TextCustom(title: controller.bookingModel.value.cancelledReason.toString())
                                                      ],
                                                    ) : const SizedBox(),
                                                    spaceH(height: 20),
                                                    TextCustom(
                                                      title: "Payment Method".tr,
                                                      fontSize: 16,
                                                      fontFamily: AppThemeData.bold,
                                                    ),
                                                    spaceH(height: 20),
                                                    Row(
                                                      children: [
                                                        (controller.bookingModel.value.paymentType == "Cash")
                                                            ? SvgPicture.asset("assets/icons/ic_cash.svg")
                                                            : (controller.bookingModel.value.paymentType == "Wallet")
                                                            ? SvgPicture.asset(
                                                          "assets/icons/ic_wallet.svg",
                                                          height: 24,
                                                          color: themeChange.isDarkTheme()
                                                              ? AppThemData.lightGrey08
                                                              : AppThemData.black08,
                                                        )
                                                            : (controller.bookingModel.value.paymentType == "Razorpay")
                                                            ? Image.asset("assets/image/ig_razorpay.png", height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType == "Paypal")
                                                            ? Image.asset("assets/image/ig_paypal.png", height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType == "Strip")
                                                            ? Image.asset("assets/image/ig_stripe.png",
                                                            height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType == "PayStack")
                                                            ? Image.asset("assets/image/ig_paystack.png",
                                                            height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType ==
                                                            "Mercado Pago")
                                                            ? Image.asset("assets/image/ig_marcadopago.png",
                                                            height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType ==
                                                            "payfast")
                                                            ? Image.asset("assets/image/ig_payfast.png",
                                                            height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType ==
                                                            "Flutter Wave")
                                                            ? Image.asset("assets/image/ig_flutterwave.png",
                                                            height: 24, width: 24)
                                                            : SvgPicture.asset("assets/icons/ic_cash.svg"),
                                                        spaceW(width: 8),
                                                        TextCustom(
                                                          title: "${controller.bookingModel.value.paymentType}",
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.regular,
                                                        ),

                                                      ],
                                                    ),
                                                    spaceH(height: 20),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextCustom(
                                                          title: "Ride Details".tr,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.bold,
                                                        ),
                                                        spaceH(height: 16),
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/ic_calendar.svg",
                                                              width: 18,
                                                              height: 18,
                                                              color: themeChange.isDarkTheme()
                                                                  ? AppThemData.primaryWhite
                                                                  : AppThemData.primaryBlack,
                                                            ),
                                                            const SizedBox(width: 6),
                                                            Expanded(
                                                                child: rowDataWidget(
                                                                    name: "Date",
                                                                    value: controller.bookingModel.value.bookingTime == null
                                                                        ? ""
                                                                        : controller.bookingModel.value.bookingTime!
                                                                        .toDate()
                                                                        .dateMonthYear(),
                                                                    themeChange: themeChange)),
                                                          ],
                                                        ),
                                                        Row(children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_time.svg", height: 18, width: 18, color: themeChange.isDarkTheme()
                                                              ? AppThemData.primaryWhite
                                                              : AppThemData.primaryBlack,),
                                                          const SizedBox(width: 6),
                                                          Expanded(
                                                              child: rowDataWidget(
                                                                  name: "Time",
                                                                  value: controller.bookingModel.value.bookingTime == null
                                                                      ? ""
                                                                      : controller.bookingModel.value.bookingTime!
                                                                      .toDate()
                                                                      .time(),
                                                                  themeChange: themeChange)),
                                                        ]),
                                                        Row(children: [
                                                          SvgPicture.asset("assets/icons/ic_distance.svg",
                                                            height: 18, width: 18,
                                                            color: themeChange.isDarkTheme()
                                                                ? AppThemData.primaryWhite
                                                                : AppThemData.primaryBlack,),
                                                          const SizedBox(width: 6),
                                                          // TextCustom(title: "Distance"),
                                                          // FutureBuilder<String>(
                                                          //     future: controller.getDistanceInKm(),
                                                          //     builder: (context, snapshot) {
                                                          //       if (!snapshot.hasData) {
                                                          //         return Container();
                                                          //       }
                                                          //       return TextCustom(title: snapshot.data ?? "");
                                                          //     })
                                                          Expanded(
                                                              child: rowDataWidget(
                                                                  name: "Distance",
                                                                  value:
                                                                  ("${controller.bookingModel.value.distance!.distance} ${controller.bookingModel
                                                                      .value.distance!.distanceType}"),
                                                                  themeChange: themeChange)),
                                                        ]),
                                                      ],
                                                    ),
                                                    spaceH(height: 20),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextCustom(
                                                          title: "Cab Details".tr,
                                                          fontSize: 16,
                                                          fontFamily: AppThemeData.bold,),
                                                        spaceH(height: 16),
                                                        Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height:50,
                                                                width: 50,
                                                                child: CachedNetworkImage(
                                                                    imageUrl: controller.bookingModel.value.vehicleType == null
                                                                        ? Constant.userPlaceHolder
                                                                        : controller.bookingModel.value.vehicleType!.image,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Constant.loader(),
                                                                    errorWidget: (context, url, error) =>
                                                                        Image.asset(
                                                                          Constant.userPlaceHolder,
                                                                          fit: BoxFit.fill,
                                                                        )),
                                                              ),
                                                              spaceW(width: 12),
                                                              Expanded(
                                                                  child: TextCustom(
                                                                      title: (controller.bookingModel.value.vehicleType == null
                                                                          ? ""
                                                                          : controller.bookingModel.value.vehicleType!.title),
                                                                      fontSize: 16,
                                                                      fontFamily: AppThemeData.medium)
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SvgPicture.asset("assets/icons/ic_multi_person.svg"),
                                                                  spaceW(width: 6),
                                                                  TextCustom(
                                                                      title: (controller.bookingModel.value.vehicleType == null
                                                                          ? ""
                                                                          : controller.bookingModel.value.vehicleType!.persons),
                                                                      fontSize: 16,
                                                                      fontFamily: AppThemeData.regular)
                                                                ],
                                                              )

                                                            ]

                                                        )
                                                      ],
                                                    ),
                                                    spaceH(height: 24),
                                                    TextCustom(
                                                      title: "Address Details".tr,
                                                      fontSize: 16,
                                                      fontFamily: AppThemeData.bold,
                                                    ),
                                                    spaceH(height: 16),
                                                    PickDropPointView(
                                                      dropAddress: controller.bookingModel.value.dropLocationAddress.toString(),
                                                      pickUpAddress: controller.bookingModel.value.pickUpLocationAddress.toString(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            spaceH(height: 16),
                                            Container(
                                              // width: Responsive.width(100, context),
                                              padding: const EdgeInsets.all(20),
                                              margin: const EdgeInsets.only(top: 12),
                                              decoration: ShapeDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50,
                                                // themeChange.getTheme() ? AppColors.primaryBlack : AppColors.primaryWhite,
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
                                                      price: controller.bookingModel.value.subTotal.toString(),
                                                      title: "Amount".tr,
                                                      priceColor:
                                                          themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                                      titleColor:
                                                          themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    PriceRowView(
                                                        price:
                                                            Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                                        title: (controller.bookingModel.value.coupon?.code ?? '').isEmpty
                                                            ? "Discount".tr
                                                            : "Discount (${controller.bookingModel.value.coupon?.code ?? ""})".tr,
                                                        priceColor:
                                                            themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                                        titleColor:
                                                            themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950),
                                                    const SizedBox(height: 16),
                                                    ListView.builder(
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: controller.bookingModel.value.taxList!.length,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) {
                                                        TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                                        return Column(
                                                          children: [
                                                            PriceRowView(
                                                                price: Constant.amountToShow(
                                                                    amount: Constant.calculateTax(
                                                                            amount: Constant.amountBeforeTax(controller.bookingModel.value)
                                                                                .toString(),
                                                                            taxModel: taxModel)
                                                                        .toString()),
                                                                title:
                                                                    "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                                priceColor: themeChange.isDarkTheme()
                                                                    ? AppThemData.greyShade25
                                                                    : AppThemData.greyShade950,
                                                                titleColor: themeChange.isDarkTheme()
                                                                    ? AppThemData.greyShade25
                                                                    : AppThemData.greyShade950),
                                                            const SizedBox(height: 16),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Divider(
                                                        color: themeChange.isDarkTheme()
                                                            ? AppThemData.greyShade800
                                                            : AppThemData.greyShade100),
                                                    const SizedBox(height: 12),
                                                    PriceRowView(
                                                      price: Constant.amountShow(
                                                          amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                                      title: "Total Amount".tr,
                                                      priceColor: AppThemData.primary500,
                                                      titleColor:
                                                          themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        tablet: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Padding(
                                                    padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                    title:
                                                                        "Order ID # ${controller.bookingModel.value.id!.substring(0, 8)}",
                                                                    fontSize: 18,
                                                                    fontFamily: AppThemeData.bold),
                                                                spaceH(height: 2),
                                                                TextCustom(
                                                                    title:
                                                                        "${Constant.timestampToDate(controller.bookingModel.value.createAt!)} at ${Constant.timestampToTime(controller.bookingModel.value.createAt!)}",
                                                                    fontSize: 14,
                                                                    fontFamily: AppThemeData.medium),
                                                              ],
                                                            ),
                                                            Container(
                                                              child: Constant.bookingStatusText(
                                                                  context, controller.bookingModel.value.bookingStatus.toString()),
                                                            )
                                                          ],
                                                        ),
                                                        spaceH(height: 40),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: ScreenSize.width(20, context),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Customer Details".tr,
                                                                    fontSize: 16,
                                                                    fontFamily: AppThemeData.bold,
                                                                  ),
                                                                  spaceH(height: 16),
                                                                  rowDataWidget(
                                                                      name: "Name",
                                                                      value: controller.userModel.value.fullName.toString(),
                                                                      themeChange: themeChange),
                                                                  rowDataWidget(
                                                                      name: "Phone No.",
                                                                      value: Constant.maskMobileNumber(
                                                                          mobileNumber: controller.userModel.value.phoneNumber.toString(),
                                                                          countryCode: controller.userModel.value.countryCode.toString()),
                                                                      themeChange: themeChange),
                                                                ],
                                                              ),
                                                            ),
                                                            if (controller.driverModel.value.id != null)
                                                              SizedBox(
                                                                width: ScreenSize.width(20, context),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Driver Details".tr,
                                                                      fontSize: 16,
                                                                      fontFamily: AppThemeData.bold,
                                                                    ),
                                                                    spaceH(height: 16),
                                                                    rowDataWidget(
                                                                        name: "ID",
                                                                        value: "# ${controller.driverModel.value.id!.substring(0, 6)}",
                                                                        themeChange: themeChange),
                                                                    rowDataWidget(
                                                                        name: "Name",
                                                                        value: controller.driverModel.value.fullName.toString(),
                                                                        themeChange: themeChange),
                                                                    rowDataWidget(
                                                                        name: "Phone No.",
                                                                        value: Constant.maskMobileNumber(
                                                                            mobileNumber:
                                                                                controller.driverModel.value.phoneNumber.toString(),
                                                                            countryCode:
                                                                                controller.driverModel.value.countryCode.toString()),
                                                                        themeChange: themeChange),
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        controller.bookingModel.value.cancelledReason != null &&
                                                            controller.bookingModel.value.cancelledReason
                                                                .toString()
                                                                .isNotEmpty ?
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            spaceH(height: 20),
                                                            TextCustom(
                                                              title: "Cancelled Reason".tr,
                                                              fontSize: 16,
                                                              fontFamily: AppThemeData.bold,
                                                            ),
                                                            spaceH(height: 8),
                                                            TextCustom(title: controller.bookingModel.value.cancelledReason.toString())
                                                          ],
                                                        ) : const SizedBox(),
                                                        spaceH(height: 24),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: ScreenSize.width(20, context),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextCustom(
                                                                        title: "Payment Method".tr,
                                                                        fontSize: 16,
                                                                        fontFamily: AppThemeData.bold,
                                                                      ),
                                                                      spaceH(height: 16),
                                                                      Row(
                                                                        children: [
                                                                          (controller.bookingModel.value.paymentType == "Cash")
                                                                              ? SvgPicture.asset("assets/icons/ic_cash.svg")
                                                                              : (controller.bookingModel.value.paymentType == "Wallet")
                                                                                  ? SvgPicture.asset(
                                                                                      "assets/icons/ic_wallet.svg",
                                                                                      height: 24,
                                                                                      color: themeChange.isDarkTheme()
                                                                                          ? AppThemData.lightGrey08
                                                                                          : AppThemData.black08,
                                                                                    )
                                                                                  : (controller.bookingModel.value.paymentType ==
                                                                                          "Razorpay")
                                                                                      ? Image.asset("assets/image/ig_razorpay.png",
                                                                                          height: 24, width: 24)
                                                                                      : (controller.bookingModel.value.paymentType ==
                                                                                              "Paypal")
                                                                                          ? Image.asset("assets/image/ig_paypal.png",
                                                                                              height: 24, width: 24)
                                                                                          : (controller.bookingModel.value.paymentType ==
                                                                                                  "Strip")
                                                                                              ? Image.asset("assets/image/ig_stripe.png",
                                                                                                  height: 24, width: 24)
                                                                                              : (controller.bookingModel.value.paymentType ==
                                                                                                      "PayStack")
                                                                                                  ? Image.asset("assets/image/ig_paystack.png",
                                                                                                      height: 24, width: 24)
                                                                                                  : (controller.bookingModel.value.paymentType ==
                                                                                                          "Mercado Pago")
                                                                                                      ? Image.asset(
                                                                                                          "assets/image/ig_marcadopago.png",
                                                                                                          height: 24,
                                                                                                          width: 24)
                                                                                                      : (controller.bookingModel.value
                                                                                                                  .paymentType ==
                                                                                                              "payfast")
                                                                                                          ? Image.asset(
                                                                                                              "assets/image/ig_payfast.png",
                                                                                                              height: 24,
                                                                                                              width: 24)
                                                                                                          : (controller.bookingModel.value
                                                                                                                      .paymentType ==
                                                                                                                  "Flutter Wave")
                                                                                                              ? Image.asset(
                                                                                                                  "assets/image/ig_flutterwave.png",
                                                                                                                  height: 24,
                                                                                                                  width: 24)
                                                                                                              : SvgPicture.asset(
                                                                                                                  "assets/icons/ic_cash.svg"),
                                                                          spaceW(width: 8),
                                                                          TextCustom(
                                                                            title: "${controller.bookingModel.value.paymentType}",
                                                                            fontSize: 14,
                                                                            fontFamily: AppThemeData.regular,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                width: ScreenSize.width(20, context),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Ride Details".tr,
                                                                      fontSize: 16,
                                                                      fontFamily: AppThemeData.bold,
                                                                    ),
                                                                    spaceH(height: 16),
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/ic_calendar.svg",
                                                                          width: 18,
                                                                          height: 18,
                                                                          color: themeChange.isDarkTheme()
                                                                              ? AppThemData.primaryWhite
                                                                              : AppThemData.primaryBlack,
                                                                        ),
                                                                        const SizedBox(width: 6),
                                                                        Expanded(
                                                                            child: rowDataWidget(
                                                                                name: "Date",
                                                                                value: controller.bookingModel.value.bookingTime == null
                                                                                    ? ""
                                                                                    : controller.bookingModel.value.bookingTime!
                                                                                        .toDate()
                                                                                        .dateMonthYear(),
                                                                                themeChange: themeChange)),
                                                                      ],
                                                                    ),
                                                                    Row(children: [
                                                                      SvgPicture.asset(
                                                                        "assets/icons/ic_time.svg",
                                                                        height: 18,
                                                                        width: 18,
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemData.primaryWhite
                                                                            : AppThemData.primaryBlack,
                                                                      ),
                                                                      const SizedBox(width: 6),
                                                                      Expanded(
                                                                          child: rowDataWidget(
                                                                              name: "Time",
                                                                              value: controller.bookingModel.value.bookingTime == null
                                                                                  ? ""
                                                                                  : controller.bookingModel.value.bookingTime!
                                                                                      .toDate()
                                                                                      .time(),
                                                                              themeChange: themeChange)),
                                                                    ]),
                                                                    Row(children: [
                                                                      SvgPicture.asset(
                                                                        "assets/icons/ic_distance.svg",
                                                                        height: 18,
                                                                        width: 18,
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemData.primaryWhite
                                                                            : AppThemData.primaryBlack,
                                                                      ),
                                                                      const SizedBox(width: 6),
                                                                      Expanded(
                                                                          child: rowDataWidget(
                                                                              name: "Distance",
                                                                              value:
                                                                                  ("${controller.bookingModel.value.distance!.distance} ${controller.bookingModel.value.distance!.distanceType}"),
                                                                              themeChange: themeChange)),
                                                                    ]),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                        spaceH(height: 40),
                                                        PickDropPointView(
                                                          dropAddress: controller.bookingModel.value.dropLocationAddress.toString(),
                                                          pickUpAddress: controller.bookingModel.value.pickUpLocationAddress.toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ).expand(flex: 2),
                                                spaceW(width: 20),
                                                Container(
                                                  // width: Responsive.width(100, context),
                                                  padding: const EdgeInsets.all(20),
                                                  margin: const EdgeInsets.only(top: 12),
                                                  decoration: ShapeDecoration(
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50,
                                                    // themeChange.getTheme() ? AppColors.primaryBlack : AppColors.primaryWhite,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: Obx(
                                                    () => Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            padding: const EdgeInsets.all(16),
                                                            decoration: ShapeDecoration(
                                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData
                                                                  .greyShade25,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(width: 1,
                                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData
                                                                        .greyShade100),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                  title: "Cab Details".tr,
                                                                  fontSize: 16,
                                                                  fontFamily: AppThemeData.bold,),
                                                                spaceH(height: 16),
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 60,
                                                                        width: 60,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: controller.bookingModel.value.vehicleType == null
                                                                                ? Constant.userPlaceHolder
                                                                                : controller.bookingModel.value.vehicleType!.image,
                                                                            fit: BoxFit.fill,
                                                                            placeholder: (context, url) => Constant.loader(),
                                                                            errorWidget: (context, url, error) =>
                                                                                Image.asset(
                                                                                  Constant.userPlaceHolder,
                                                                                  fit: BoxFit.fill,
                                                                                )),
                                                                      ),
                                                                      spaceW(width: 12),
                                                                      Expanded(
                                                                          child: TextCustom(
                                                                              title: (controller.bookingModel.value.vehicleType == null
                                                                                  ? ""
                                                                                  : controller.bookingModel.value.vehicleType!.title),
                                                                              fontSize: 16,
                                                                              fontFamily: AppThemeData.medium)
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SvgPicture.asset("assets/icons/ic_multi_person.svg"),
                                                                          spaceW(width: 6),
                                                                          TextCustom(
                                                                              title: (controller.bookingModel.value.vehicleType == null
                                                                                  ? ""
                                                                                  : controller.bookingModel.value.vehicleType!.persons),
                                                                              fontSize: 16,
                                                                              fontFamily: AppThemeData.regular)
                                                                        ],
                                                                      )

                                                                    ]

                                                                )
                                                              ],
                                                            )
                                                        ),
                                                        spaceH(height: 24),
                                                        PriceRowView(
                                                          price: controller.bookingModel.value.subTotal.toString(),
                                                          title: "Amount".tr,
                                                          priceColor: themeChange.isDarkTheme()
                                                              ? AppThemData.greyShade25
                                                              : AppThemData.greyShade950,
                                                          titleColor: themeChange.isDarkTheme()
                                                              ? AppThemData.greyShade25
                                                              : AppThemData.greyShade950,
                                                        ),
                                                        const SizedBox(height: 16),
                                                        PriceRowView(
                                                            price: Constant.amountToShow(
                                                                amount: controller.bookingModel.value.discount ?? '0.0'),
                                                            title: (controller.bookingModel.value.coupon?.code ?? '').isEmpty
                                                                ? "Discount".tr
                                                                : "Discount (${controller.bookingModel.value.coupon?.code ?? ""})".tr,
                                                            priceColor: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade25
                                                                : AppThemData.greyShade950,
                                                            titleColor: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade25
                                                                : AppThemData.greyShade950),
                                                        const SizedBox(height: 16),
                                                        ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: controller.bookingModel.value.taxList!.length,
                                                          shrinkWrap: true,
                                                          itemBuilder: (context, index) {
                                                            TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                                            return Column(
                                                              children: [
                                                                PriceRowView(
                                                                    price: Constant.amountToShow(
                                                                        amount: Constant.calculateTax(
                                                                                amount:
                                                                                    Constant.amountBeforeTax(controller.bookingModel.value)
                                                                                        .toString(),
                                                                                taxModel: taxModel)
                                                                            .toString()),
                                                                    title:
                                                                        "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                                    priceColor: themeChange.isDarkTheme()
                                                                        ? AppThemData.greyShade25
                                                                        : AppThemData.greyShade950,
                                                                    titleColor: themeChange.isDarkTheme()
                                                                        ? AppThemData.greyShade25
                                                                        : AppThemData.greyShade950),
                                                                const SizedBox(height: 16),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Divider(
                                                            color: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade800
                                                                : AppThemData.greyShade100),
                                                        const SizedBox(height: 12),
                                                        PriceRowView(
                                                          price: Constant.amountShow(
                                                              amount:
                                                                  Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                                          title: "Total Amount".tr,
                                                          priceColor: AppThemData.primary500,
                                                          titleColor: themeChange.isDarkTheme()
                                                              ? AppThemData.greyShade25
                                                              : AppThemData.greyShade950,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ).expand(flex: 1),
                                              ],
                                            ),
                                          ],
                                        ),
                                        desktop: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Padding(
                                                    padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                    title:
                                                                        "Order ID # ${controller.bookingModel.value.id!.substring(0, 8)}",
                                                                    fontSize: 18,
                                                                    fontFamily: AppThemeData.bold),
                                                                spaceH(height: 2),
                                                                TextCustom(
                                                                    title:
                                                                        "${Constant.timestampToDate(controller.bookingModel.value.createAt!)} at ${Constant.timestampToTime(controller.bookingModel.value.createAt!)}",
                                                                    fontSize: 14,
                                                                    fontFamily: AppThemeData.medium),
                                                              ],
                                                            ),
                                                            Container(
                                                              child: Constant.bookingStatusText(
                                                                  context, controller.bookingModel.value.bookingStatus.toString()),
                                                            )
                                                          ],
                                                        ),
                                                        spaceH(height: 40),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 250,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Customer Details".tr,
                                                                    fontSize: 16,
                                                                    fontFamily: AppThemeData.bold,
                                                                  ),
                                                                  spaceH(height: 16),
                                                                  rowDataWidget(
                                                                      name: "Name",
                                                                      value: controller.userModel.value.fullName.toString(),
                                                                      themeChange: themeChange),
                                                                  rowDataWidget(
                                                                      name: "Phone Number",
                                                                      value: Constant.maskMobileNumber(
                                                                          mobileNumber: controller.userModel.value.phoneNumber.toString(),
                                                                          countryCode: controller.userModel.value.countryCode.toString()),
                                                                      themeChange: themeChange),
                                                                ],
                                                              ),
                                                            ),
                                                            if (controller.driverModel.value.id != null)
                                                              SizedBox(
                                                                width: 250,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Driver Details".tr,
                                                                      fontSize: 16,
                                                                      fontFamily: AppThemeData.bold,
                                                                    ),
                                                                    spaceH(height: 16),
                                                                    rowDataWidget(
                                                                        name: "ID",
                                                                        value: "# ${controller.driverModel.value.id!.substring(0, 6)}",
                                                                        themeChange: themeChange),
                                                                    rowDataWidget(
                                                                        name: "Name",
                                                                        value: controller.driverModel.value.fullName.toString(),
                                                                        themeChange: themeChange),
                                                                    rowDataWidget(
                                                                        name: "Phone Number",
                                                                        value: Constant.maskMobileNumber(
                                                                            mobileNumber:
                                                                                controller.driverModel.value.phoneNumber.toString(),
                                                                            countryCode:
                                                                                controller.driverModel.value.countryCode.toString()),
                                                                        themeChange: themeChange),
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        controller.bookingModel.value.cancelledReason != null &&
                                                            controller.bookingModel.value.cancelledReason
                                                                .toString()
                                                                .isNotEmpty ?
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            spaceH(height: 20),
                                                            TextCustom(
                                                              title: "Cancelled Reason".tr,
                                                              fontSize: 16,
                                                              fontFamily: AppThemeData.bold,
                                                            ),
                                                            spaceH(height: 8),
                                                            TextCustom(title: controller.bookingModel.value.cancelledReason.toString())
                                                          ],
                                                        ) : const SizedBox(),
                                                        spaceH(height: 24),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 250,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Payment Method".tr,
                                                                    fontSize: 16,
                                                                    fontFamily: AppThemeData.bold,
                                                                  ),
                                                                  spaceH(height: 16),
                                                                  Row(
                                                                    children: [
                                                                      (controller.bookingModel.value.paymentType == "Cash")
                                                                          ? SvgPicture.asset("assets/icons/ic_cash.svg")
                                                                          : (controller.bookingModel.value.paymentType == "Wallet")
                                                                          ? SvgPicture.asset(
                                                                        "assets/icons/ic_wallet.svg",
                                                                        height: 24,
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemData.lightGrey08
                                                                            : AppThemData.black08,
                                                                      )
                                                                          : (controller.bookingModel.value.paymentType == "Razorpay")
                                                                          ? Image.asset("assets/image/ig_razorpay.png", height: 24, width: 24)
                                                                          : (controller.bookingModel.value.paymentType == "Paypal")
                                                                          ? Image.asset("assets/image/ig_paypal.png",
                                                                          height: 24, width: 24)
                                                                          : (controller.bookingModel.value.paymentType == "Strip")
                                                                          ? Image.asset("assets/image/ig_stripe.png",
                                                                          height: 24, width: 24)
                                                                          : (controller.bookingModel.value.paymentType == "PayStack")
                                                                          ? Image.asset("assets/image/ig_paystack.png",
                                                                          height: 24, width: 24)
                                                                          : (controller.bookingModel.value.paymentType ==
                                                                          "Mercado Pago")
                                                                          ? Image.asset("assets/image/ig_marcadopago.png",
                                                                          height: 24, width: 24)
                                                                          : (controller.bookingModel.value.paymentType ==
                                                                          "payfast")
                                                                          ? Image.asset("assets/image/ig_payfast.png",
                                                                          height: 24, width: 24)
                                                                          : (controller.bookingModel.value.paymentType ==
                                                                          "Flutter Wave")
                                                                          ? Image.asset(
                                                                          "assets/image/ig_flutterwave.png",
                                                                          height: 24,
                                                                          width: 24)
                                                                          : SvgPicture.asset(
                                                                          "assets/icons/ic_cash.svg"),
                                                                      spaceW(width: 8),
                                                                      TextCustom(
                                                                        title: "${controller.bookingModel.value.paymentType}",
                                                                        fontSize: 14,
                                                                        fontFamily: AppThemeData.regular,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 250,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Ride Details".tr,
                                                                      fontSize: 16,
                                                                      fontFamily: AppThemeData.bold,
                                                                    ),
                                                                    spaceH(height: 16),
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/ic_calendar.svg",
                                                                          width: 18,
                                                                          height: 18,
                                                                          color: themeChange.isDarkTheme()
                                                                              ? AppThemData.primaryWhite
                                                                              : AppThemData.primaryBlack,
                                                                        ),
                                                                        const SizedBox(width: 6),
                                                                        Expanded(
                                                                            child: rowDataWidget(
                                                                                name: "Date",
                                                                                value: controller.bookingModel.value.bookingTime == null
                                                                                    ? ""
                                                                                    : controller.bookingModel.value.bookingTime!
                                                                                    .toDate()
                                                                                    .dateMonthYear(),
                                                                                themeChange: themeChange)),
                                                                      ],
                                                                    ),
                                                                    Row(children: [
                                                                      SvgPicture.asset("assets/icons/ic_time.svg", height: 18,
                                                                        width: 18,
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemData.primaryWhite
                                                                            : AppThemData.primaryBlack,),
                                                                      const SizedBox(width: 6),
                                                                      Expanded(
                                                                          child: rowDataWidget(
                                                                              name: "Time",
                                                                              value: controller.bookingModel.value.bookingTime == null
                                                                                  ? ""
                                                                                  : controller.bookingModel.value.bookingTime!
                                                                                  .toDate()
                                                                                  .time(),
                                                                              themeChange: themeChange)),
                                                                    ]),
                                                                    Row(children: [
                                                                      SvgPicture.asset("assets/icons/ic_distance.svg",
                                                                        height: 18, width: 18,
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemData.primaryWhite
                                                                            : AppThemData.primaryBlack,),
                                                                      const SizedBox(width: 6),
                                                                      // TextCustom(title: "Distance"),
                                                                      // FutureBuilder<String>(
                                                                      //     future: controller.getDistanceInKm(),
                                                                      //     builder: (context, snapshot) {
                                                                      //       if (!snapshot.hasData) {
                                                                      //         return Container();
                                                                      //       }
                                                                      //       return TextCustom(title: snapshot.data ?? "");
                                                                      //     })
                                                                      Expanded(
                                                                          child: rowDataWidget(
                                                                              name: "Distance",
                                                                              value:
                                                                              ("${controller.bookingModel.value.distance!.distance} ${controller
                                                                                  .bookingModel.value.distance!.distanceType}"),
                                                                              themeChange: themeChange)),
                                                                    ]),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                        spaceH(height: 20),
                                                        PickDropPointView(
                                                          dropAddress: controller.bookingModel.value.dropLocationAddress.toString(),
                                                          pickUpAddress: controller.bookingModel.value.pickUpLocationAddress.toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ).expand(flex: 2),
                                                spaceW(width: 20),
                                                Container(
                                                  // width: Responsive.width(100, context),
                                                  padding: const EdgeInsets.all(20),
                                                  margin: const EdgeInsets.only(top: 12),
                                                  decoration: ShapeDecoration(
                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50,
                                                    // themeChange.getTheme() ? AppColors.primaryBlack : AppColors.primaryWhite,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: Obx(
                                                    () => Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            padding: const EdgeInsets.all(16),
                                                            decoration: ShapeDecoration(
                                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData
                                                                  .greyShade25,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(width: 1,
                                                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData
                                                                        .greyShade100),
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                  title: "Cab Details".tr,
                                                                  fontSize: 16,
                                                                  fontFamily: AppThemeData.bold,),
                                                                spaceH(height: 16),
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 60,
                                                                        width: 80,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl: controller.bookingModel.value.vehicleType == null
                                                                                ? Constant.userPlaceHolder
                                                                                : controller.bookingModel.value.vehicleType!.image,
                                                                            fit: BoxFit.cover,
                                                                            placeholder: (context, url) => Constant.loader(),
                                                                            errorWidget: (context, url, error) =>
                                                                                Image.asset(
                                                                                  Constant.userPlaceHolder,
                                                                                  fit: BoxFit.cover,
                                                                                )),
                                                                      ),
                                                                      spaceW(width: 12),
                                                                      Expanded(
                                                                          child: TextCustom(
                                                                              title: (controller.bookingModel.value.vehicleType == null
                                                                                  ? ""
                                                                                  : controller.bookingModel.value.vehicleType!.title),
                                                                              fontSize: 16,
                                                                              fontFamily: AppThemeData.medium)
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SvgPicture.asset("assets/icons/ic_multi_person.svg"),
                                                                          spaceW(width: 6),
                                                                          TextCustom(
                                                                              title: (controller.bookingModel.value.vehicleType == null
                                                                                  ? ""
                                                                                  : controller.bookingModel.value.vehicleType!.persons),
                                                                              fontSize: 16,
                                                                              fontFamily: AppThemeData.regular)
                                                                        ],
                                                                      )

                                                                    ]

                                                                )
                                                              ],
                                                            )
                                                        ),
                                                        spaceH(height: 24),
                                                        PriceRowView(
                                                          price: controller.bookingModel.value.subTotal.toString(),
                                                          title: "Amount".tr,
                                                          priceColor: themeChange.isDarkTheme()
                                                              ? AppThemData.greyShade25
                                                              : AppThemData.greyShade950,
                                                          titleColor: themeChange.isDarkTheme()
                                                              ? AppThemData.greyShade25
                                                              : AppThemData.greyShade950,
                                                        ),
                                                        const SizedBox(height: 16),
                                                        PriceRowView(
                                                            price: Constant.amountToShow(
                                                                amount: controller.bookingModel.value.discount ?? '0.0'),
                                                            title: (controller.bookingModel.value.coupon?.code ?? '').isEmpty
                                                                ? "Discount".tr
                                                                : "Discount (${controller.bookingModel.value.coupon?.code ?? ""})".tr,
                                                            priceColor: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade25
                                                                : AppThemData.greyShade950,
                                                            titleColor: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade25
                                                                : AppThemData.greyShade950),
                                                        const SizedBox(height: 16),
                                                        ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: controller.bookingModel.value.taxList!.length,
                                                          shrinkWrap: true,
                                                          itemBuilder: (context, index) {
                                                            TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                                            return Column(
                                                              children: [
                                                                PriceRowView(
                                                                    price: Constant.amountToShow(
                                                                        amount: Constant.calculateTax(
                                                                                amount:
                                                                                    Constant.amountBeforeTax(controller.bookingModel.value)
                                                                                        .toString(),
                                                                                taxModel: taxModel)
                                                                            .toString()),
                                                                    title:
                                                                        "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                                    priceColor: themeChange.isDarkTheme()
                                                                        ? AppThemData.greyShade25
                                                                        : AppThemData.greyShade950,
                                                                    titleColor: themeChange.isDarkTheme()
                                                                        ? AppThemData.greyShade25
                                                                        : AppThemData.greyShade950),
                                                                const SizedBox(height: 16),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Divider(
                                                            color: themeChange.isDarkTheme()
                                                                ? AppThemData.greyShade800
                                                                : AppThemData.greyShade100),
                                                        const SizedBox(height: 12),
                                                        PriceRowView(
                                                          price: Constant.amountShow(
                                                              amount:
                                                                  Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                                          title: "Total Amount".tr,
                                                          priceColor: AppThemData.primary500,
                                                          titleColor: themeChange.isDarkTheme()
                                                              ? AppThemData.greyShade25
                                                              : AppThemData.greyShade950,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ).expand(flex: 1),
                                              ],
                                            ),
                                            20.height,
                                          ],
                                        ),
                                      )
                                    ]),
                                  ),
                                )
                              ]),
                        )),
            ],
          ),
        );
      },
    );
  }
}

Padding priceDetailWidget({required String name, required String value}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: TextCustom(title: name.tr, fontSize: 14, fontFamily: AppThemeData.medium),
        ),
        TextCustom(
          title: (value.length > 35) ? value.substring(0, 30) : value,
          fontSize: 14,
          fontFamily: AppThemeData.bold,
        ),
      ],
    ),
  );
}

Row rowDataWidget({required String name, required String value, required themeChange}) {
  return Row(
    children: [
      TextCustom(title: name.tr, fontSize: 14, fontFamily: AppThemeData.medium).expand(flex: 1),
      const TextCustom(title: ":   ", fontSize: 14, fontFamily: AppThemeData.medium),
      TextCustom(
        title: value,
        fontSize: 14,
        fontFamily: AppThemeData.regular,
      ).expand(flex: 1),
    ],
  );
}
