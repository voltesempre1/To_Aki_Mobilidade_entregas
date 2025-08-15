// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/modules/setting_screen/controllers/setting_screen_controller.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SettingScreenController settingScreenController = Get.put(SettingScreenController());
    return Container(
      color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
      width: 270,
      height: 1.sh,
      child: Column(
        children: [
          if (!ResponsiveWidget.isDesktop(context)) ...{
            GestureDetector(
              onTap: () {
                Get.offAllNamed(Routes.DASHBOARD_SCREEN);
              },
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
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
                  ],
                ),
              ),
            ),
            14.height,
            Divider(color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100),
          },
          Expanded(
            child: SingleChildScrollView(
              child: MouseRegion(
                cursor: SystemMouseCursors.text,
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: TextCustom(
                      title: "MAIN".tr,
                      color: AppThemData.greyShade400,
                      fontSize: 12,
                    )),
                    ListItem(
                      buttonTitle: "Dashboard".tr,
                      icon: "assets/icons/ic_vertical_line.svg",
                      onPress: () {
                        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.DASHBOARD_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "BOOKING MANAGEMENT".tr,
                      color: AppThemData.greyShade400,
                      fontSize: 12,
                    )),
                    ListItem(
                      buttonTitle: 'Cab Bookings'.tr,
                      icon: 'assets/icons/my_ride.svg',
                      onPress: () {
                        if (Get.currentRoute == Routes.CAB_DETAIL) {
                          Get.back();
                        }
                        Get.toNamed(Routes.CAB_BOOKING_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.CAB_BOOKING_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "INTERCITY SERVICE".tr,
                      color: AppThemData.greyShade400,
                      fontSize: 12,
                    )),
                    ListItem(
                      buttonTitle: 'Intercity Service'.tr,
                      icon: "assets/icons/my_ride.svg",
                      onPress: () {
                        if (Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN) {
                          Get.back();
                        }
                        Get.toNamed(Routes.INTERCITY_SERVICE_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN,
                      themeChange: themeChange,
                    ),
                    ExpansionTileItem(
                      title: 'Bookings'.tr,
                      titleColor: ( Get.currentRoute == Routes.PARCEL_DETAIL || Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN || Get.currentRoute == Routes.INTERCITY_DETAIL || Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN)
                          ? AppThemData.primary500
                          : AppThemData.primary500,
                      isSelected: ( Get.currentRoute == Routes.PARCEL_DETAIL || Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN || Get.currentRoute == Routes.INTERCITY_DETAIL || Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN),
                      icon: 'assets/icons/my_ride.svg',
                      iconColor: ( Get.currentRoute == Routes.PARCEL_DETAIL || Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN || Get.currentRoute == Routes.INTERCITY_DETAIL || Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN)
                          ? AppThemData.primary500
                          : AppThemData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          buttonTitle: 'Intercity History'.tr,
                          // icon: "assets/icons/ic_shopping_cart.svg",
                          onPress: () {
                            if (Get.currentRoute == Routes.INTERCITY_DETAIL) {
                              Get.back();
                            }
                            Get.toNamed(Routes.INTERCITY_HISTORY_SCREEN);
                          },
                          isSelected: Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          buttonTitle: 'Parcel History'.tr,
                          // icon: "assets/icons/ic_shopping_cart.svg",
                          onPress: () {
                            if (Get.currentRoute == Routes.PARCEL_DETAIL) {
                              Get.back();
                            }
                            Get.toNamed(Routes.PARCEL_HISTORY_SCREEN);
                          },
                          isSelected: Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN,
                          themeChange: themeChange,
                        ),
                      ],
                    ),
                    // ListItem(
                    //   buttonTitle: 'Cab Service'.tr,
                    //   icon: "assets/icons/my_ride.svg",
                    //   onPress: () {
                    //     if (Get.currentRoute == Routes.CAB_SERVICE) {
                    //       Get.back();
                    //     }
                    //     Get.toNamed(Routes.CAB_SERVICE);
                    //   },
                    //   isSelected: Get.currentRoute == Routes.CAB_SERVICE,
                    //   themeChange: themeChange,
                    // ),
                    // ExpansionTileItem(
                    //   title: 'InterCity',
                    //   titleColor: (Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN || Get.currentRoute == Routes.BOOKING_HISTORY_SCREEN
                    //       || Get.currentRoute == Routes.PARCEL_DETAIL || Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN
                    //       || Get.currentRoute == Routes.INTERCITY_DETAIL || Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN  )
                    //       ? AppThemData.primary500
                    //       : AppThemData.primary500,
                    //    isSelected: (Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN || Get.currentRoute == Routes.BOOKING_HISTORY_SCREEN
                    //        || Get.currentRoute == Routes.PARCEL_DETAIL || Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN
                    //        || Get.currentRoute == Routes.INTERCITY_DETAIL || Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN  ) ,
                    //   icon: 'assets/icons/my_ride.svg',
                    //   iconColor: (Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN || Get.currentRoute == Routes.BOOKING_HISTORY_SCREEN
                    //       || Get.currentRoute == Routes.PARCEL_DETAIL || Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN
                    //       || Get.currentRoute == Routes.INTERCITY_DETAIL || Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN)
                    //       ? AppThemData.primary500
                    //       : AppThemData.primary500,
                    //   themeChange: themeChange,
                    //   children: [
                    //     ListItem(
                    //       buttonTitle: 'Intercity Service'.tr,
                    //       // icon: "assets/icons/ic_shopping_cart.svg",
                    //       onPress: () {
                    //         if (Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN) {
                    //           Get.back();
                    //         }
                    //         Get.toNamed(Routes.INTERCITY_SERVICE_SCREEN);
                    //       },
                    //       isSelected: Get.currentRoute == Routes.INTERCITY_SERVICE_SCREEN,
                    //       themeChange: themeChange,
                    //     ),
                    //     ListItem(
                    //       buttonTitle: 'Intercity Booking'.tr,
                    //       // icon: "assets/icons/ic_shopping_cart.svg",
                    //       onPress: () {
                    //         if (Get.currentRoute == Routes.PARCEL_DETAIL) {
                    //           Get.back();
                    //         }
                    //         Get.toNamed(Routes.PARCEL_HISTORY_SCREEN);
                    //       },
                    //       isSelected: Get.currentRoute == Routes.PARCEL_HISTORY_SCREEN,
                    //       themeChange: themeChange,
                    //     ),
                    //     ListItem(
                    //       buttonTitle: 'Parcel Booking'.tr,
                    //       // icon: "assets/icons/ic_shopping_cart.svg",
                    //       onPress: () {
                    //         if (Get.currentRoute == Routes.INTERCITY_DETAIL) {
                    //           Get.back();
                    //         }
                    //         Get.toNamed(Routes.INTERCITY_HISTORY_SCREEN);
                    //       },
                    //       isSelected: Get.currentRoute == Routes.INTERCITY_HISTORY_SCREEN,
                    //       themeChange: themeChange,
                    //     ),
                    //   ],
                    // ),
                    ListTile(
                        title: TextCustom(
                      title: "CUSTOMER MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      buttonTitle: "Customers".tr,
                      icon: "assets/icons/ic_user.svg",
                      onPress: () {
                        if (Get.currentRoute == Routes.CUSTOMER_DETAIL_SCREEN) {
                          Get.back();
                        }
                        if (Get.currentRoute == Routes.CAB_DETAIL) {
                          Get.back();
                        }
                        Get.toNamed(Routes.CUSTOMERS_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.CUSTOMERS_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "DRIVER MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),

                    ExpansionTileItem(
                      title: 'Driver'.tr,
                      titleColor: (Get.currentRoute == Routes.DRIVER_SCREEN || Get.currentRoute == Routes.VERIFY_DRIVER_SCREEN || Get.currentRoute == Routes.DRIVER_DETAIL_SCREEN) ? AppThemData.primary500 : AppThemData.primary500,
                      isSelected: (Get.currentRoute == Routes.DRIVER_SCREEN || Get.currentRoute == Routes.VERIFY_DRIVER_SCREEN || Get.currentRoute == Routes.DRIVER_DETAIL_SCREEN),
                      icon: 'assets/icons/my_ride.svg',
                      iconColor: (Get.currentRoute == Routes.DRIVER_SCREEN || Get.currentRoute == Routes.VERIFY_DRIVER_SCREEN || Get.currentRoute == Routes.DRIVER_DETAIL_SCREEN) ? AppThemData.primary500 : AppThemData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          onPress: () async {
                            if (Get.currentRoute == Routes.CUSTOMER_DETAIL_SCREEN) {
                              Get.back();
                            }
                            if (Get.currentRoute == Routes.CAB_DETAIL) {
                              Get.back();
                            }
                            Get.toNamed(Routes.DRIVER_SCREEN);
                          },
                          buttonTitle: 'All Drivers'.tr,
                          // icon: "assets/icons/ic_driver.svg",
                          isSelected: Get.currentRoute == Routes.DRIVER_SCREEN,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          buttonTitle: 'Verify Driver'.tr,
                          // icon: "assets/icons/ic_check_circle.svg",
                          onPress: () {
                            Get.toNamed(Routes.VERIFY_DRIVER_SCREEN);
                          },
                          isSelected: Get.currentRoute == Routes.VERIFY_DRIVER_SCREEN,
                          themeChange: themeChange,
                        ),
                      ],
                    ),

                    ListTile(
                        title: TextCustom(
                      title: "VEHICLE MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ExpansionTileItem(
                      title: 'Vehicle Details'.tr,
                      titleColor: (Get.currentRoute == Routes.VEHICLE_BRAND_SCREEN || Get.currentRoute == Routes.VEHICLE_MODEL_SCREEN || Get.currentRoute == Routes.VEHICLE_TYPE_SCREEN) ? AppThemData.primary500 : AppThemData.primary500,
                      isSelected: (Get.currentRoute == Routes.VEHICLE_BRAND_SCREEN || Get.currentRoute == Routes.VEHICLE_MODEL_SCREEN || Get.currentRoute == Routes.VEHICLE_TYPE_SCREEN),
                      icon: 'assets/icons/my_ride.svg',
                      iconColor: (Get.currentRoute == Routes.VEHICLE_BRAND_SCREEN || Get.currentRoute == Routes.VEHICLE_MODEL_SCREEN || Get.currentRoute == Routes.VEHICLE_TYPE_SCREEN) ? AppThemData.primary500 : AppThemData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.VEHICLE_BRAND_SCREEN);
                          },
                          buttonTitle: 'Vehicle Brand'.tr,
                          // icon: "assets/icons/ic_car_2.svg",
                          isSelected: Get.currentRoute == Routes.VEHICLE_BRAND_SCREEN,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.VEHICLE_MODEL_SCREEN);
                          },
                          buttonTitle: 'Vehicle Model'.tr,
                          // icon: "assets/icons/ic_car_2.svg",
                          isSelected: Get.currentRoute == Routes.VEHICLE_MODEL_SCREEN,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.VEHICLE_TYPE_SCREEN);
                          },
                          buttonTitle: 'Vehicle Type'.tr,
                          // icon: "assets/icons/ic_car_2.svg",
                          isSelected: Get.currentRoute == Routes.VEHICLE_TYPE_SCREEN,
                          themeChange: themeChange,
                        ),
                      ],
                    ),

                    ListTile(
                        title: TextCustom(
                      title: "SUBSCRIPTION MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),

                    ExpansionTileItem(
                      title: 'Subscriptions'.tr,
                      titleColor: (Get.currentRoute == Routes.SUBSCRIPTION_PLAN || Get.currentRoute == Routes.SUBSCRIPTION_HISTORY) ? AppThemData.primary500 : AppThemData.primary500,
                      isSelected: (Get.currentRoute == Routes.SUBSCRIPTION_PLAN || Get.currentRoute == Routes.SUBSCRIPTION_HISTORY),
                      icon: "assets/icons/ic_subscription_history.svg",
                      iconColor: (Get.currentRoute == Routes.SUBSCRIPTION_PLAN || Get.currentRoute == Routes.SUBSCRIPTION_HISTORY) ? AppThemData.primary500 : AppThemData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          buttonTitle: 'Subscription Plans'.tr,
                          // icon: "assets/icons/ic_subscription.svg",
                          onPress: () {
                            Get.toNamed(Routes.SUBSCRIPTION_PLAN);
                          },
                          isSelected: Get.currentRoute == Routes.SUBSCRIPTION_PLAN,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          buttonTitle: 'Subscription History'.tr,
                          // icon: "assets/icons/ic_subscription_history.svg",
                          onPress: () {
                            Get.toNamed(Routes.SUBSCRIPTION_HISTORY);
                          },
                          isSelected: Get.currentRoute == Routes.SUBSCRIPTION_HISTORY,
                          themeChange: themeChange,
                        ),
                      ],
                    ),

                    ListTile(
                        title: TextCustom(
                      title: "SUPPORT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      buttonTitle: 'Support Ticket'.tr,
                      icon: "assets/icons/ic_support_ticket.svg",
                      onPress: () {
                        Get.toNamed(Routes.SUPPORT_TICKET_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.SUPPORT_TICKET_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Payout Request'.tr,
                      icon: "assets/icons/ic_payout.svg",
                      onPress: () {
                        Get.toNamed(Routes.PAYOUT_REQUEST);
                      },
                      isSelected: Get.currentRoute == Routes.PAYOUT_REQUEST,
                      themeChange: themeChange,
                    ),

                    ListTile(
                        title: TextCustom(
                      title: "SERVICE MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),
                    ListItem(
                      buttonTitle: 'Banner'.tr,
                      icon: "assets/icons/ic_album.svg",
                      onPress: () {
                        Get.toNamed(Routes.BANNER_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.BANNER_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Offers'.tr,
                      icon: "assets/icons/ic_payout.svg",
                      onPress: () {
                        Get.toNamed(Routes.OFFERS_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.OFFERS_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Documents'.tr,
                      icon: "assets/icons/ic_document.svg",
                      onPress: () {
                        Get.toNamed(Routes.DOCUMENT_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.DOCUMENT_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "SYSTEM MANAGEMENT".tr,
                      fontSize: 12,
                      color: AppThemData.greyShade400,
                    )),

                    ExpansionTileItem(
                      title: 'Settings'.tr,
                      titleColor: (Get.currentRoute == Routes.SETTING_SCREEN) ? AppThemData.primary500 : AppThemData.primary500,
                      isSelected: (Get.currentRoute == Routes.SETTING_SCREEN),
                      icon: "assets/icons/ic_settings.svg",
                      iconColor: (Get.currentRoute == Routes.SETTING_SCREEN) ? AppThemData.primary500 : AppThemData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: settingScreenController.settingsAllPage.length,
                          itemBuilder: (context, index) {
                            final currentRoute = Get.currentRoute;
                            final item = settingScreenController.settingsAllPage[index];

                            return Obx(() {
                              final selectedTitle = settingScreenController.selectSettingWidget.value.title;
                              bool isSelected = currentRoute == Routes.SETTING_SCREEN &&
                                  selectedTitle != null &&
                                  selectedTitle.isNotEmpty &&
                                  selectedTitle[0] == item.title![0];

                              log('=======================> is selected menu of setting: $isSelected');

                              return InkWell(
                                onTap: () {
                                  settingScreenController.settingsAllPage[index].selectIndex = 0;
                                  settingScreenController.selectSettingWidget.value = item;
                                  settingScreenController.update();
                                  Get.toNamed(Routes.SETTING_SCREEN);
                                },
                                child: ContainerCustom(
                                  radius: 12,
                                  color: isSelected
                                      ? (themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100)
                                      : null,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextCustom(
                                          title: item.title?[0].tr ?? '',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),



                  ],
                ),
              ),
            ),
          ),
          LogoutListItem(
            buttonTitle: 'Log out'.tr,
            icon: "assets/icons/ic_exit.svg",
            onPress: () {
              showDialog<bool>(
                context: Get.context!,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Logout?'.tr,
                    style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 18, color: AppThemData.greyShade950, fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Are you sure you want to logout?'.tr,
                    style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 16, color: AppThemData.textGrey, fontWeight: FontWeight.w400),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: AppThemData.textBlack, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.offAllNamed(Routes.LOGIN_PAGE);
                      },
                      child: Text(
                        'Log out'.tr,
                        style: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: AppThemData.red800, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
            textColor: AppThemData.red600,
            iconColor: AppThemData.red600,
            buttonColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
          ),
        ],
      ),
    );
  }
}

class LogoutListItem extends StatelessWidget {
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final String? buttonTitle;
  final String? icon;
  final VoidCallback? onPress;

  const LogoutListItem({
    super.key,
    this.buttonColor,
    this.iconColor,
    this.textColor,
    this.buttonTitle,
    this.icon,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
        color: buttonColor,
        boxShadow: [
          BoxShadow(color: AppThemData.black07, offset: textColor == AppThemData.black07 ? const Offset(4, 0) : const Offset(0, 0)),
        ],
      ),
      child: ListTile(
        minLeadingWidth: 20,
        onTap: onPress,
        title: Text(
          buttonTitle!,
          style: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        leading: (icon != null)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon!,
                  color: iconColor,
                  height: 16,
                  width: 16,
                ),
              )
            : null,
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String? buttonTitle;
  final String? icon;
  final VoidCallback? onPress;
  final bool? isSelected;
  final DarkThemeProvider themeChange;

  const ListItem({super.key, this.buttonTitle, this.icon, this.onPress, this.isSelected, required this.themeChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      decoration: isSelected == true
          ? BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              boxShadow: const [
                BoxShadow(color: AppThemData.primary500, offset: Offset(4, 0)),
              ],
            )
          : BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            ),
      child: ListTile(
        minLeadingWidth: 20,
        onTap: onPress,
        title: Text(
          buttonTitle!,
          style: TextStyle(
            fontFamily: AppThemeData.bold,
            fontSize: 15,
            color: isSelected == true
                ? AppThemData.primary500
                : themeChange.isDarkTheme()
                    ? AppThemData.greyShade25
                    : AppThemData.greyShade950,
          ),
        ),
        leading: (icon != null)
            ? Padding(
                // padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon!,
                  colorFilter: ColorFilter.mode(
                      isSelected == true
                          ? AppThemData.primary500
                          : themeChange.isDarkTheme()
                              ? AppThemData.greyShade25
                              : AppThemData.greyShade950,
                      BlendMode.srcIn),
                  height: 18,
                  width: 18,
                ),
              )
            : null,
      ),
    );
  }
}

class ExpansionTileItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final List<Widget>? children;
  final bool? isSelected;
  final DarkThemeProvider themeChange;

  const ExpansionTileItem({super.key, this.title, this.icon, this.children, this.isSelected, required this.themeChange, required titleColor, required iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isSelected == true
          ? BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              boxShadow: const [
                BoxShadow(color: AppThemData.primary500, offset: Offset(4, 0)),
              ],
            )
          : BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
            ),
      child: ListTileTheme(
        minLeadingWidth: 20,
        child: ExpansionTile(
          shape: const Border(),
          title: Text(
            title!,
            style: TextStyle(
              fontFamily: AppThemeData.bold,
              fontSize: 15,
              color: isSelected == true
                  ? themeChange.isDarkTheme()
                      ? AppThemData.greyShade25
                      : AppThemData.primary500
                  : themeChange.isDarkTheme()
                      ? AppThemData.greyShade25
                      : AppThemData.greyShade950,
            ),
          ),
          initiallyExpanded: false,
          childrenPadding: const EdgeInsets.only(left: 60, top: 0, bottom: 0, right: 0),
          backgroundColor: Colors.transparent,
          // collapsedIconColor: AppColors.darkGrey04,
          iconColor: AppThemData.greyShade400,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon!,
              color: isSelected == true
                  ? AppThemData.primary500
                  : themeChange.isDarkTheme()
                      ? AppThemData.greyShade25
                      : AppThemData.greyShade950,
              height: 18,
              width: 18,
            ),
          ),
          children: children!.toList(),
        ),
      ),
    );
  }
}
