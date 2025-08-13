// ignore_for_file: depend_on_referenced_packages
import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/support_ticket_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/modules/support_ticket_screen/controllers/support_ticket_screen_controller.dart';
import 'package:admin/app/modules/verify_driver_screen/views/verify_driver_screen_view.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/app/utils/toast.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../routes/app_pages.dart';

class SupportTicketScreenView extends GetView<SupportTicketScreenController> {
  const SupportTicketScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SupportTicketScreenController>(
        init: SupportTicketScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
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
              // key: scaffoldKey,
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                    child: Padding(
                  padding: paddingEdgeInsets(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContainerCustom(
                            child: Column(children: [
                          ResponsiveWidget.isDesktop(context)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
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
                                            title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        TextCustom(
                                            title: ' ${controller.title.value} '.tr,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.medium,
                                            color: AppThemData.primary500)
                                      ])
                                    ]),
                                    NumberOfRowsDropDown(
                                      controller: controller,
                                    )
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: AppThemeData.bold),
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
                                            title: ' / ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemData.greyShade500),
                                        TextCustom(
                                            title: ' ${controller.title.value} '.tr,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.medium,
                                            color: AppThemData.primary500)
                                      ])
                                    ]),
                                    spaceH(),
                                    NumberOfRowsDropDown(
                                      controller: controller,
                                    ),
                                  ],
                                ),
                          spaceH(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: controller.isLoading.value
                                    ? Padding(
                                        padding: paddingEdgeInsets(),
                                        child: Constant.loader(),
                                      )
                                    : controller.currentPageSupportTicketList.isEmpty
                                        ? TextCustom(title: "No Data available".tr)
                                        : DataTable(
                                            horizontalMargin: 20,
                                            columnSpacing: 30,
                                            dataRowMaxHeight: 65,
                                            headingRowHeight: 65,
                                            border: TableBorder.all(
                                              color: themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            headingRowColor: WidgetStateColor.resolveWith(
                                                (states) => themeChange.isDarkTheme() ? AppThemData.greyShade800 : AppThemData.greyShade100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Id".tr, width: MediaQuery.of(context).size.width * 0.15),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Name".tr, width: MediaQuery.of(context).size.width * 0.1),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Reason".tr, width: MediaQuery.of(context).size.width * 0.2),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Type".tr, width: MediaQuery.of(context).size.width * 0.1),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Status".tr, width: MediaQuery.of(context).size.width * 0.05),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Actions".tr, width: MediaQuery.of(context).size.width * 0.05),
                                            ],
                                            rows: controller.currentPageSupportTicketList
                                                .map((supportTicketModel) => DataRow(cells: [
                                                      DataCell(TextCustom(
                                                          title: supportTicketModel.id!.isEmpty ? "N/A" : supportTicketModel.id.toString())),
                                                      DataCell(FutureBuilder(
                                                        future: supportTicketModel.type == "customer"
                                                            ? FireStoreUtils.getCustomerByCustomerID(supportTicketModel.userId.toString())
                                                            : FireStoreUtils.getDriverByDriverID(supportTicketModel.userId.toString()),
                                                        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.waiting:
                                                              return const SizedBox();
                                                            default:
                                                              if (snapshot.hasError) {
                                                                return Text("Error ; ${snapshot.error}");
                                                              } else {
                                                                var userName = (supportTicketModel.type == "customer"
                                                                    ? (snapshot.data as UserModel).fullName
                                                                    : (snapshot.data as DriverUserModel).fullName);
                                                                return TextCustom(title: userName!.isEmpty ? "N/A" : userName.toString());
                                                              }
                                                          }
                                                        },
                                                      )),
                                                      DataCell(TextCustom(
                                                          title: supportTicketModel.title!.isEmpty ? "N/A" : supportTicketModel.title.toString())),
                                                      DataCell(
                                                          TextCustom(title: supportTicketModel.type == "customer" ? "Customer".tr : "Driver".tr)),
                                                      DataCell(Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4),
                                                          color: supportTicketModel.status == "pending"
                                                              ? AppThemData.primary500.withOpacity(0.2)
                                                              : supportTicketModel.status == "accepted"
                                                                  ? AppThemData.green500.withOpacity(0.2)
                                                                  : AppThemData.red500.withOpacity(0.2),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(6.0),
                                                          child: TextCustom(
                                                            title: supportTicketModel.status == "pending"
                                                                ? "Pending"
                                                                : supportTicketModel.status == "accepted"
                                                                    ? "Accepted"
                                                                    : "Rejected",
                                                            color: supportTicketModel.status == "pending"
                                                                ? AppThemData.primary600
                                                                : supportTicketModel.status == "accepted"
                                                                    ? AppThemData.green600
                                                                    : AppThemData.red600,
                                                          ),
                                                        ),
                                                      )),
                                                      DataCell(IconButton(
                                                        onPressed: () {
                                                          controller.notesController.value.clear();
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) => supportTicketDetail(context, supportTicketModel, controller));
                                                        },
                                                        icon: const Icon(
                                                          Icons.info_outline,
                                                          color: AppThemData.greyShade500,
                                                        ),
                                                      ))
                                                    ]))
                                                .toList())),
                          ),
                          spaceH(),
                          ResponsiveWidget.isMobile(context)
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: controller.totalPage.value > 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: WebPagination(
                                            currentPage: controller.currentPage.value,
                                            totalPage: controller.totalPage.value,
                                            displayItemCount: controller.pageValue("5"),
                                            onPageChanged: (page) {
                                              controller.currentPage.value = page;
                                              controller.setPagination(controller.totalItemPerPage.value);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                        ]))
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        });
  }

  Dialog supportTicketDetail(BuildContext context, SupportTicketModel ticketModel, SupportTicketScreenController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade50,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                        color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(title: '${controller.title}'.tr, fontSize: 18),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 25,
                              color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack,
                            ),
                          )
                        ],
                      )).expand(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: themeChange.isDarkTheme() ? AppThemData.greyShade700 : AppThemData.greyShade200)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                          child: Row(
                            children: [
                              Text(
                                "Id".tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade300 : AppThemData.greyShade600,
                                    fontFamily: AppThemeData.medium),
                              ).expand(),
                              TextCustom(
                                title: "# ${ticketModel.id}",
                                color: themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade700 : AppThemData.greyShade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                "User Name".tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade300 : AppThemData.greyShade600,
                                    fontFamily: AppThemeData.medium),
                              ).expand(),
                              FutureBuilder(
                                future: ticketModel.type == "customer"
                                    ? FireStoreUtils.getCustomerByCustomerID(ticketModel.userId.toString())
                                    : FireStoreUtils.getDriverByDriverID(ticketModel.userId.toString()),
                                builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const SizedBox();
                                    default:
                                      if (snapshot.hasError) {
                                        return Text("Error ; ${snapshot.error}");
                                      } else {
                                        var userName = ticketModel.type == "customer"
                                            ? (snapshot.data as UserModel).fullName
                                            : (snapshot.data as DriverUserModel).fullName;
                                        return TextCustom(
                                          title: userName!.isEmpty ? "N/A" : userName.toString(),
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                          fontSize: 16,
                                          fontFamily: AppThemeData.medium,
                                        );
                                      }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade700 : AppThemData.greyShade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                "Type".tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade300 : AppThemData.greyShade600,
                                    fontFamily: AppThemeData.medium),
                              ).expand(),
                              TextCustom(
                                title: ticketModel.type == "customer" ? "Customer" : "Driver",
                                color: themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: themeChange.isDarkTheme() ? AppThemData.greyShade700 : AppThemData.greyShade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                "Date".tr,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.isDarkTheme() ? AppThemData.greyShade300 : AppThemData.greyShade600,
                                    fontFamily: AppThemeData.medium),
                              ).expand(),
                              TextCustom(
                                title: Constant.timestampToDate(ticketModel.createAt!),
                                color: themeChange.isDarkTheme() ? AppThemData.greyShade25 : AppThemData.greyShade950,
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  ),
                  12.height,
                  Container(
                    decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextCustom(
                                title: ticketModel.title.toString(),
                                fontSize: 16,
                                fontFamily: AppThemeData.bold,
                                color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack,
                              ).expand(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: ticketModel.status == "pending"
                                      ? AppThemData.primary500.withOpacity(0.2)
                                      : ticketModel.status == "accepted"
                                          ? AppThemData.green500.withOpacity(0.2)
                                          : AppThemData.red500.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: TextCustom(
                                    title: ticketModel.status == "pending"
                                        ? "Pending"
                                        : ticketModel.status == "accepted"
                                            ? "Accepted"
                                            : "Rejected",
                                    color: ticketModel.status == "pending"
                                        ? AppThemData.primary600
                                        : ticketModel.status == "accepted"
                                            ? AppThemData.green600
                                            : AppThemData.red600,
                                  ),
                                ),
                              )
                            ],
                          ),
                          4.height,
                          TextCustom(
                              title: ticketModel.subject.toString(),
                              fontSize: 14,
                              fontFamily: AppThemeData.medium,
                              color: themeChange.isDarkTheme() ? AppThemData.primaryWhite : AppThemData.primaryBlack),
                          8.height,
                          TextCustom(
                              title: ticketModel.description.toString(),
                              maxLine: 2,
                              fontSize: 14,
                              fontFamily: AppThemeData.regular,
                              color: themeChange.isDarkTheme() ? AppThemData.greyShade200 : AppThemData.greyShade900),
                          12.height,
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: ticketModel.attachments!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: GestureDetector(
                                          onTap: () {
                                            viewURLImage(ticketModel.attachments![index].toString());
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: ticketModel.attachments![index],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                            progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                                              child: CircularProgressIndicator(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  12.height,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: "Notes :".tr,
                            fontSize: 16,
                            fontFamily: AppThemeData.bold,
                          ),
                          10.height,
                          ticketModel.status == "pending"
                              ? TextFormField(
                                  validator: (value) => value != null && value.isNotEmpty ? null : 'required',
                                  cursorColor: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: controller.notesController.value,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,

                                  // inputFormatters: inputFormatters,

                                  style: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950,
                                      fontFamily: AppThemeData.medium),
                                  decoration: InputDecoration(
                                      errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                      isDense: true,
                                      filled: true,
                                      enabled: true,
                                      fillColor: themeChange.isDarkTheme() ? AppThemData.primaryBlack : AppThemData.greyShade200,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade200,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade200,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade200,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade200,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade950 : AppThemData.greyShade200,
                                        ),
                                      ),
                                      hintText: "Enter Note".tr,
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.isDarkTheme() ? AppThemData.greyShade400 : AppThemData.greyShade950,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppThemeData.medium)),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ticketModel.notes.toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: AppThemeData.medium,
                                            fontSize: 16,
                                            color: themeChange.isDarkTheme() ? AppThemData.greyShade200 : AppThemData.greyShade900)),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  if (ticketModel.status == "pending")
                    Column(
                      children: [
                        20.height,
                        Row(
                          children: [
                            const Spacer(),
                            CustomButtonWidget(
                                buttonTitle: "Approved".tr,
                                buttonColor: AppThemData.green500,
                                height: 45,
                                onPress: () async {
                                  if (Constant.isDemo) {
                                    DialogBox.demoDialogBox();
                                  } else {
                                    // Constant.waitingLoader();
                                    if (controller.notesController.value.text.isNotEmpty) {
                                      controller.isLoading.value = true;
                                      try {
                                        await FirebaseFirestore.instance.collection(CollectionName.supportTicket).doc(ticketModel.id).update(
                                            {'notes': controller.notesController.value.text, 'status': "accepted", 'updateAt': Timestamp.now()});
                                        ShowToast.successToast("Support Ticket Accepted".tr);
                                        Get.back();
                                        controller.getData();
                                        // ticketController.isLoading.value = false;
                                      } catch (e) {
                                        ShowToast.errorToast("Something went Wrong, Please try later!".tr);
                                        log("Error : $e");
                                      }
                                    } else {
                                      ShowToast.errorToast("Please enter a note!".tr);
                                      controller.isLoading.value = false;
                                    }
                                  }
                                }),
                            const SizedBox(width: 16),
                            CustomButtonWidget(
                                buttonTitle: "Rejected".tr,
                                buttonColor: AppThemData.red500,
                                height: 45,
                                onPress: () async {
                                  if (Constant.isDemo) {
                                    DialogBox.demoDialogBox();
                                  } else {
                                    if (controller.notesController.value.text.isNotEmpty) {
                                      controller.isLoading.value = true;
                                      await FirebaseFirestore.instance.collection(CollectionName.supportTicket).doc(ticketModel.id).update(
                                          {'notes': controller.notesController.value.text, 'status': "rejected", 'updateAt': Timestamp.now()});

                                      await FirebaseFirestore.instance
                                          .collection(ticketModel.type == "customer" ? CollectionName.users : CollectionName.drivers)
                                          .doc(ticketModel.userId)
                                          .update({'isActive': false});

                                      ShowToast.successToast("Support Ticket Rejected".tr);
                                      Get.back();
                                      controller.getData();
                                    } else {
                                      ShowToast.errorToast("Please enter a note!".tr);
                                      controller.isLoading.value = false;
                                    }
                                  }
                                }),
                          ],
                        ),
                      ],
                    ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
