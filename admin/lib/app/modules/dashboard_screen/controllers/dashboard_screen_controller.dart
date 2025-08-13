// ignore_for_file: depend_on_referenced_packages

import 'package:admin/app/constant/booking_status.dart';
import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/admin_model.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/vehicle_type_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreenController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKeyDrawer = GlobalKey<ScaffoldState>();
  RxBool isDrawerOpen = false.obs;

  void toggleDrawer() {
    GlobalKey<ScaffoldState> scaffoldKey = scaffoldKeyDrawer;
    scaffoldKey.currentState?.openDrawer();
  }

  RxBool isLoading = true.obs;
  RxBool isUserData = true.obs;

  RxInt totalBookingPlaced = 0.obs;
  RxInt totalBookingActive = 0.obs;
  RxInt totalBookingCompleted = 0.obs;

  RxInt totalBookingCanceled = 0.obs;

  RxInt totalBookings = 0.obs;
  RxInt totalCab = 0.obs;
  RxDouble totalEarnings = 0.0.obs;

  RxDouble todayTotalEarnings = 0.0.obs;
  RxDouble monthlyEarning = 0.0.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<AdminModel> admin = AdminModel().obs;

  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  List<ChartData>? bookingChartData;
  List<ChartData>? usersChartData;
  List<ChartDataCircle>? usersCircleChartData;
  var monthlyUserCount = List<int>.filled(12, 0).obs;

  RxBool isLoadingBookingChart = true.obs;
  RxBool isLoadingUserChart = true.obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<BookingModel> recentBookingList = <BookingModel>[].obs;
  List<ChartDataCircle> chartDataCircle = [];
  List<SalesStatistic> salesStatistic = [];
  RxInt todayService = 0.obs;
  RxInt totalService = 0.obs;
  RxInt totalUser = 0.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isUserData.value = true;
    await FireStoreUtils.getAdmin().then((value) {
      if (value != null) {
        admin.value = value;
        Constant.adminModel = value;
        Constant.isDemoSet(value);
      }
    }).catchError((error) {
      log('error in getAdmin type ${error.toString()}');
    });
    Constant.getCurrencyData();
    Constant.getLanguageData();

    // Fetch bookings and users in parallel
    final results = await Future.wait([
      FireStoreUtils.getRecentBooking("All"),
      FireStoreUtils.getRecentUsers(),
      FireStoreUtils.countDrivers(),
      FireStoreUtils.countUsers(),
    ]);

    bookingList.value = results[0] as List<BookingModel>;
    userList.value = results[1] as List<UserModel>;
    totalCab.value = results[2] as int;
    totalUser.value = results[3] as int;

    // Recent Bookings
    if (bookingList.isNotEmpty) {
      recentBookingList.value = bookingList.take(5).toList();
    }

    bookingChartData = List.filled(12, ChartData("", 0));
    usersChartData = List.filled(12, ChartData("", 0));
    usersCircleChartData = List.filled(12, ChartDataCircle("", 0, Colors.amber));

    // Parallel chart and stats fetching
    await Future.wait([
      getAllStatisticData(),
      getTodayStatisticData(),
      getLanguage(),
      getBookingData(),
    ]);

    isUserData.value = false;
  }

  Future<void> getTodayStatisticData() async {
    for (var booking in bookingList) {
      if (Constant.timestampToDate(booking.createAt!) == Constant.timestampToDate(Timestamp.now())) {
        if (booking.bookingStatus == BookingStatus.bookingCompleted) {
          todayTotalEarnings.value += Constant.calculateFinalAmount(booking);
        }
      }
    }
  }

  Future<void> getAllStatisticData() async {
    totalBookings.value = bookingList.length;
    totalService.value = bookingList.where((element) => element.bookingStatus == BookingStatus.bookingCompleted).length;
    totalBookingPlaced.value = bookingList.where((element) => element.bookingStatus == BookingStatus.bookingPlaced).length;
    totalBookingActive.value = bookingList
        .where((element) =>
            element.bookingStatus == BookingStatus.bookingAccepted ||
            element.bookingStatus == BookingStatus.bookingOngoing ||
            element.bookingStatus == BookingStatus.bookingCompleted ||
            element.bookingStatus == BookingStatus.bookingCancelled ||
            element.bookingStatus == BookingStatus.bookingPlaced)
        .length;
    totalBookingCompleted.value = bookingList.where((element) => element.bookingStatus == BookingStatus.bookingCompleted).length;
    totalBookingCanceled.value = bookingList.where((element) => element.bookingStatus == BookingStatus.bookingCancelled).length;

    for (var booking in bookingList) {
      if (booking.bookingStatus == BookingStatus.bookingCompleted) {
        totalEarnings.value += Constant.calculateFinalAmount(booking);
      }
    }
    salesStatistic = [
      SalesStatistic("Total Earning", totalEarnings.value, Colors.green),
    ];

    chartDataCircle = [
      ChartDataCircle('Total Service', totalService.value, Colors.blue),
      ChartDataCircle('Total Booking', totalBookings.value, Colors.purple),
      ChartDataCircle('Total Users', totalCab.value, Colors.green),
      ChartDataCircle('Booking Placed', totalBookingPlaced.value, Colors.yellow),
      ChartDataCircle('Booking Active', totalBookingActive.value, Colors.brown),
      ChartDataCircle('Booking Completed', totalBookingCompleted.value, Colors.deepOrange),
      ChartDataCircle('Booking Canceled', totalBookingCanceled.value, Colors.red),
    ];
  }

  Future<void> getBookingData() async {
    List<Future<void>> monthDataFutures = [
      getBookingMonthWiseData("01", 0, "JAN"),
      getBookingMonthWiseData("02", 1, "FEB"),
      getBookingMonthWiseData("03", 2, "MAR"),
      getBookingMonthWiseData("04", 3, "APR"),
      getBookingMonthWiseData("05", 4, "MAY"),
      getBookingMonthWiseData("06", 5, "JUN"),
      getBookingMonthWiseData("07", 6, "JUL"),
      getBookingMonthWiseData("08", 7, "AUG"),
      getBookingMonthWiseData("09", 8, "SEP"),
      getBookingMonthWiseData("10", 9, "OCT"),
      getBookingMonthWiseData("11", 10, "NOV"),
      getBookingMonthWiseData("12", 11, "DEC"),
    ];

    await Future.wait(monthDataFutures);
    isLoadingBookingChart.value = false;
  }

  Future<void> getBookingMonthWiseData(String monthValue, int index, String monthName) async {
    int month = int.parse(monthValue);
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, month, 1);
    DateTime lastDayOfMonth = DateTime(DateTime.now().year, month + 1, 0, 23, 59, 59);

    List<BookingModel> bookingHistory = [];

    try {
      QuerySnapshot value = await FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where("createAt", isGreaterThanOrEqualTo: firstDayOfMonth, isLessThanOrEqualTo: lastDayOfMonth)
          .where("bookingStatus", isEqualTo: "booking_completed")
          .get();

      for (var element in value.docs) {
        Map<String, dynamic>? elementData = element.data() as Map<String, dynamic>?;
        // bookingChartData
        if (elementData != null) {
          BookingModel orderHistoryModel = BookingModel.fromJson(elementData);
          bookingHistory.add(orderHistoryModel);
        }
      }
      monthlyEarning.value = 0.0;
      for (var monthSubtotal in bookingHistory) {
        monthlyEarning.value += double.parse(monthSubtotal.subTotal.toString());
      }

      bookingChartData![index] = ChartData(monthName, monthlyEarning.value);
    } catch (e) {
      log('Error getting month-wise data: $e');
    }
  }

  Future<void> getLanguage() async {
    isLoading = true.obs;
    await FireStoreUtils.getLanguage().then((value) {
      languageList.value = value;
      for (var element in languageList) {
        if (element.code == "en") {
          selectedLanguage.value = element;
          continue;
        } else {
          selectedLanguage.value = languageList.first;
        }
      }
    }).catchError((error) {
      log('error in getLanguage type ${error.toString()}');
    });

    isLoading = false.obs;
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class ChartDataCircle {
  ChartDataCircle(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}

class SalesStatistic {
  SalesStatistic(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
