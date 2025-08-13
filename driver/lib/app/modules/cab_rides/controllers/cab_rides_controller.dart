// ignore_for_file: unnecessary_overrides

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class CabRidesController extends GetxController {
  var selectedType = 0.obs;

  RxList<BookingModel> bookingsCancelledList = <BookingModel>[].obs;
  RxList<BookingModel> bookingsOnGoingList = <BookingModel>[].obs;
  RxList<BookingModel> bookingsCompletedList = <BookingModel>[].obs;
  RxList<BookingModel> bookingsRejectedList = <BookingModel>[].obs;

  @override
  void onInit() {
    getBookingData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getBookingData() {
    FireStoreUtils.fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingAccepted)
        .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createAt', descending: true)
        .snapshots()
        .listen((event) {
      for (var document in event.docs) {
        final data = document.data();
        BookingModel bookingModel = BookingModel.fromJson(data);
        bookingsOnGoingList.add(bookingModel);
      }
    });

    FireStoreUtils.fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingCancelled)
        .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
        .snapshots()
        .listen((event) {
      for (var document in event.docs) {
        final data = document.data();
        BookingModel bookingModel = BookingModel.fromJson(data);
        bookingsCancelledList.add(bookingModel);
      }
    });

    FireStoreUtils.fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingCompleted)
        .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createAt', descending: true)
        .snapshots()
        .listen((event) {
      for (var document in event.docs) {
        final data = document.data();
        BookingModel bookingModel = BookingModel.fromJson(data);
        bookingsCompletedList.add(bookingModel);
      }
    });

    FireStoreUtils.fireStore
        .collection(CollectionName.bookings)
        .where('rejectedDriverId', arrayContains: FireStoreUtils.getCurrentUid())
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((event) {
      for (var document in event.docs) {
        final data = document.data();
        BookingModel bookingModel = BookingModel.fromJson(data);
        bookingsRejectedList.add(bookingModel);
      }
    });
  }
}
