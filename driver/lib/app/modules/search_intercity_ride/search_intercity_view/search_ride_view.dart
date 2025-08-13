import 'package:driver/app/modules/search_intercity_ride/controllers/search_ride_controller.dart';
import 'package:driver/app/modules/search_intercity_ride/search_intercity_view/widget/search_parcel_ride_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widget/search_intercity_ride_widget.dart';

class SearchRideView extends StatelessWidget {
  const SearchRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    bool isParcelAvailable = Constant.parcelDocuments.isNotEmpty && Constant.parcelDocuments.first.isAvailable;
    bool isInterCityAvailable =
        (Constant.intercitySharingDocuments.isNotEmpty && Constant.intercitySharingDocuments.first.isAvailable) ||
            (Constant.intercityPersonalDocuments.isNotEmpty && Constant.intercityPersonalDocuments.first.isAvailable);

    List<Tab> tabs = [];
    List<Widget> tabViews = [];

    if (isInterCityAvailable) {
      tabs.add(const Tab(text: 'Intercity'));
      tabViews.add(SearchInterCityRideWidget());
    }

    if (isParcelAvailable) {
      tabs.add(const Tab(text: 'Parcel'));
      tabViews.add(SearchParcelRideWidget());
    }

    if (tabs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Search Ride'.tr)),
        body: Center(child: Text('No rides available')),
      );
    }

    return GetBuilder<SearchRideController>(
      init: SearchRideController(),
      builder: (controller) {
        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              shape: Border(
                bottom: BorderSide(
                  color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                  width: 1,
                ),
              ),
              title: Text(
                'Search Ride'.tr,
                style: GoogleFonts.inter(
                  color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              bottom: TabBar(
                dividerHeight: 2,
                labelColor: AppThemData.primary600,
                indicatorColor: AppThemData.primary600,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                tabs: tabs,
              ),
            ),
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.grey50,
            body: Obx(() => controller.isLoading.value
                ? Constant.loader()
                : TabBarView(children: tabViews)),
          ),
        );
      },
    );
  }
}


// class SearchRideView extends StatelessWidget {
//   const SearchRideView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     return GetBuilder(
//         init: SearchRideController(),
//         builder: (controller) {
//           return DefaultTabController(
//             length: 2,
//             child: Scaffold(
//               // Constant.parcelDocuments.first.isAvailable == true
//               // Constant.intercitySharingDocuments.first.isAvailable == true  || Constant.intercityPersonalDocuments.first.isAvailable == true
//               appBar: AppBar(
//                 shape: Border(bottom: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1)),
//                 title: Text(
//                   'Search Ride'.tr,
//                   style: GoogleFonts.inter(
//                     color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 centerTitle: false,
//                 bottom: const TabBar(
//                   // isScrollable: true+,
//                   dividerHeight: 2,
//                   automaticIndicatorColorAdjustment: true,
//                   labelColor: AppThemData.primary600,
//                   // unselectedLabelColor: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey600,
//                   indicatorColor: AppThemData.primary600,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   // labelPadding: EdgeInsets.zero,
//                   labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
//                   // Add padding around the text
//                   tabs: <Widget>[
//                     Tab(
//                       text: 'InterCity',
//                     ),
//                     Tab(
//                       text: 'Parcel',
//                     ),
//                   ],
//                 ),
//               ),
//               backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.grey50,
//               body: Obx(() =>
//               controller.isLoading.value == true ? Constant.loader() :
//               TabBarView(
//                 children: <Widget>[SearchInterCityRideWidget(), SearchParcelRideWidget()],
//               ),
//               ),
//             ),
//           );
//         });
//   }
// }
