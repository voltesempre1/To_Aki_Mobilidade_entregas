import 'dart:developer';

import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/wallet_transaction_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';

class CustomerDetailScreenController extends GetxController {
  RxString title = "Customer Detail".tr.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  Rx<TextEditingController> topupController = TextEditingController().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  RxList<WalletTransactionModel> currentPageWalletTransaction = <WalletTransactionModel>[].obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<BookingModel> currentPageBooking = <BookingModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  RxString selectedPayoutStatus = "All".obs;
  RxString selectedPayoutStatusForData = "All".obs;
  List<String> payoutStatus = [
    "All",
    "Place",
    "Complete",
    "Rejected",
    "Cancelled",
    "Accepted",
    "OnGoing",
  ];

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    await getArgument();
    log("==============>${userModel.value.id}");
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    await getBookings();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    await getWalletTransactions();
    isLoading.value = false;
  }

  Future<void> getArgument() async {
    String userId = Get.parameters['userId']!;
    log("====> user ID :$userId");
    await FireStoreUtils.getUserByUserID(userId).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
    isLoading.value = false;
  }

  // dynamic argumentData = Get.arguments;
  // if (argumentData != null) {
  // userModel.value = argumentData['userModel'];
  // } else {
  // Get.offAllNamed(Routes.ERROR_SCREEN);
  // }

  Future<void> getBookingDataForConverter() async {
    if (selectedPayoutStatus.value == "Rejected") {
      selectedPayoutStatusForData.value = "booking_rejected";
      await getBookings();
    } else if (selectedPayoutStatus.value == "Place") {
      selectedPayoutStatusForData.value = "booking_placed";
      await getBookings();
    } else if (selectedPayoutStatus.value == "Complete") {
      selectedPayoutStatusForData.value = "booking_completed";
      await getBookings();
    } else if (selectedPayoutStatus.value == "Cancelled") {
      selectedPayoutStatusForData.value = 'booking_cancelled';
      await getBookings();
    } else if (selectedPayoutStatus.value == "Accepted") {
      selectedPayoutStatusForData.value = 'booking_accepted';
      await getBookings();
    } else if (selectedPayoutStatus.value == "OnGoing") {
      selectedPayoutStatusForData.value = 'booking_ongoing';
      await getBookings();
    } else {
      // booking_accepted
      selectedPayoutStatusForData.value = "All";
      await getBookings();
    }
  }

  Future<void> removeBooking(BookingModel bookingModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.bookings).doc(bookingModel.id).delete().then((value) {
      ShowToastDialog.toast("Booking deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading = false.obs;
  }

  Future<void> getBookings() async {
    isLoading.value = true;
    bookingList.value = await FireStoreUtils.getBookingByUserId(selectedPayoutStatusForData.value, userModel.value.id);
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  void setPagination(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (bookingList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > bookingList.length ? bookingList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPageBooking.value = bookingList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return bookingList.length;
    } else {
      return int.parse(data);
    }
  }

  Future<void> completeOrder(String transactionId) async {
    final amount = topupController.value.text;
    if (amount.isEmpty || double.tryParse(amount) == null || double.parse(amount) <= 0) {
      ShowToastDialog.toast("Please enter a valid amount.");
      return;
    }
    final userId = userModel.value.id;
    if (userId == null || userId.isEmpty) {
      ShowToastDialog.toast("User not found.");
      return;
    }
    final transactionModel = WalletTransactionModel(
      id: Constant.getUuid(),
      amount: amount,
      createdDate: Timestamp.now(),
      paymentType: "admin",
      transactionId: transactionId,
      userId: userId,
      isCredit: true,
      type: "customer",
      note: "Wallet Top up by admin",
    );
    ShowToastDialog.showLoader("Please wait".tr);
    try {
      final result = await FireStoreUtils.setWalletTransaction(transactionModel);
      if (result == true) {
        await FireStoreUtils.updateUserWallet(amount: amount, userId: userId);
        userModel.value = (await FireStoreUtils.getUserByUserID(userId))!;
        ShowToastDialog.toast("Amount added in your wallet.");
        Get.back();
      } else {
        ShowToastDialog.toast("Failed to add amount to wallet.");
      }
    } catch (e) {
      ShowToastDialog.toast("An error occurred. Please try again.");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> getWalletTransactions() async {
    await FireStoreUtils.getWalletTransactionOfUser(userModel.value.id!).then((value) {
      walletTransactionList.value = value;
      setPaginationForTransactionHistory(totalItemPerPage.value);
    });
  }

  void setDefaultData() {
    currentPage = 1.obs;
    startIndex = 1.obs;
    endIndex = 1.obs;
    totalPage = 1.obs;
  }

  void setPaginationForTransactionHistory(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (walletTransactionList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > walletTransactionList.length ? walletTransactionList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPageWalletTransaction.value = walletTransactionList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }
}
