import 'dart:async';
import 'dart:developer';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/admin_commission.dart';
import 'package:driver/app/models/bank_detail_model.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/currencies_model.dart';
import 'package:driver/app/models/documents_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/intercity_model.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/app/models/parcel_model.dart';
import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/app/models/subscription_model.dart';
import 'package:driver/app/models/subscription_plan_history.dart';
import 'package:driver/app/models/support_reason_model.dart';
import 'package:driver/app/models/support_ticket_model.dart';
import 'package:driver/app/models/time_slots_charge_model.dart';
import 'package:driver/app/models/transaction_log_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/models/vehicle_brand_model.dart';
import 'package:driver/app/models/vehicle_model_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/models/withdraw_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireStoreUtils {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() => firebaseAuth.currentUser!.uid;

  static Future<bool> setTransactionLog(TransactionLogModel transactionLogModel) async {
    try {
      await fireStore
          .collection(CollectionName.transactionLog)
          .doc(transactionLogModel.id)
          .set(transactionLogModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update transaction log: $error");
      return false;
    }
  }

  static Future<bool> isLogin() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return false;
    return await userExistOrNot(user.uid);
  }

  static Future<bool> userExistOrNot(String uid) async {
    try {
      final doc = await fireStore.collection(CollectionName.drivers).doc(uid).get();
      return doc.exists;
    } catch (error) {
      log("Failed to check user exist: $error");
      return false;
    }
  }

  static Future<bool> updateDriverUserLocation(DriverUserModel userModel) async {
    try {
      await fireStore.collection(CollectionName.drivers).doc(userModel.id).update(userModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update user: $error");
      return false;
    }
  }

  static Future<bool> updateDriverUser(DriverUserModel userModel) async {
    try {
      await fireStore.collection(CollectionName.drivers).doc(userModel.id).set(userModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update user: $error");
      return false;
    }
  }

  static Future<List<LanguageModel>> getLanguage() async {
    try {
      final snap = await FirebaseFirestore.instance.collection(CollectionName.languages).get();
      return snap.docs.map((doc) => LanguageModel.fromJson(doc.data())).toList();
    } catch (e) {
      log("Failed to fetch languages: $e");
      return [];
    }
  }

  static Future<bool> updateDriverUserOnline(bool isOnline) async {
    try {
      final userModel = Constant.userModel ?? await getDriverUserProfile(getCurrentUid());
      if (userModel == null) return false;
      userModel.isOnline = isOnline;
      await fireStore.collection(CollectionName.drivers).doc(userModel.id).set(userModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update user: $error");
      return false;
    }
  }

  static Future<void> fetchIntercityService() async {
    try {
      final documentLists = {
        "parcel": Constant.parcelDocuments,
        "intercity_sharing": Constant.intercitySharingDocuments,
        "intercity": Constant.intercityPersonalDocuments,
      };

      for (final docName in documentLists.keys) {
        final doc = await fireStore.collection("intercity_service").doc(docName).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final model = TimeSlotsChargesModel.fromJson(docName, data);

          if (docName == 'parcel') {
            Constant.isParcelBid = model.isBidEnable;
          } else if (docName == 'intercity_sharing') {
            Constant.isInterCitySharingBid = model.isBidEnable;
          } else {
            Constant.isInterCityBid = model.isBidEnable;
          }
          documentLists[docName]?.add(model);
        }
      }
    } catch (e) {
      log("Error fetching intercity services: $e");
    }
  }

  static Future<DriverUserModel?> getDriverUserProfile(String uuid) async {
    try {
      final doc = await fireStore.collection(CollectionName.drivers).doc(uuid).get();
      if (doc.exists && doc.data() != null) {
        final user = DriverUserModel.fromJson(doc.data()!);
        if (uuid == getCurrentUid()) {
          Constant.userModel = user;
        }
        return user;
      }
      return null;
    } catch (error) {
      log("Failed to get user: $error");
      return null;
    }
  }

  static Future<UserModel?> getUserProfileByUserId(String uuid) async {
    try {
      final doc = await fireStore.collection(CollectionName.drivers).doc(uuid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (error) {
      log("Failed to get user: $error");
      return null;
    }
  }

  static Future<UserModel?> getUserProfile(String uuid) async {
    try {
      final doc = await fireStore.collection(CollectionName.users).doc(uuid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (error) {
      log("Failed to get user: $error");
      return null;
    }
  }

  static Future<bool> deleteDriverUser() async {
    try {
      await fireStore.collection(CollectionName.drivers).doc(FireStoreUtils.getCurrentUid()).delete();
      await firebaseAuth.currentUser!.delete();
      return true;
    } catch (e, s) {
      log('FireStoreUtils.deleteDriverUser $e $s');
      return false;
    }
  }

  static Future<bool> updateDriverUserWallet({required String amount}) async {
    try {
      final userModel = Constant.userModel ?? await getDriverUserProfile(FireStoreUtils.getCurrentUid());
      if (userModel == null) return false;
      userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
      return await FireStoreUtils.updateDriverUser(userModel);
    } catch (error) {
      log("Failed to update wallet: $error");
      return false;
    }
  }

  static Future<bool> updateTotalEarning({required String amount}) async {
    try {
      final userModel = Constant.userModel ?? await getDriverUserProfile(FireStoreUtils.getCurrentUid());
      if (userModel == null) return false;
      userModel.totalEarning = (double.parse(userModel.totalEarning.toString()) + double.parse(amount)).toString();
      return await FireStoreUtils.updateDriverUser(userModel);
    } catch (error) {
      log("Failed to update total earning: $error");
      return false;
    }
  }

  static Future<bool> updateOtherUserWallet({required String amount, required String id}) async {
    try {
      final userModel = await getDriverUserProfile(id);
      if (userModel == null) return false;
      userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
      return await FireStoreUtils.updateDriverUser(userModel);
    } catch (error) {
      log("Failed to update other user wallet: $error");
      return false;
    }
  }

  static Stream<IntercityModel?> getInterCityRideDetails(String bookingId) {
    return fireStore
        .collection(CollectionName.interCityRide)
        .where("id", isEqualTo: bookingId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? IntercityModel.fromJson(snapshot.docs.first.data()) : null);
  }

  static Stream<ParcelModel?> getParcelRideDetails(String bookingId) {
    return fireStore
        .collection(CollectionName.parcelRide)
        .where("id", isEqualTo: bookingId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? ParcelModel.fromJson(snapshot.docs.first.data()) : null);
  }

  static Future<VehicleTypeModel?> getVehicleTypeById(String vehicleId) async {
    try {
      final querySnapshot =
          await fireStore.collection(CollectionName.vehicleType).where("id", isEqualTo: vehicleId).get();
      if (querySnapshot.docs.isNotEmpty) {
        return VehicleTypeModel.fromJson(querySnapshot.docs.first.data());
      }
    } catch (error) {
      log("Failed to fetch vehicle type: $error");
    }
    return null;
  }

  static Future<List<VehicleTypeModel>> getVehicleType() async {
    try {
      final snapshot = await fireStore.collection(CollectionName.vehicleType).where("isActive", isEqualTo: true).get();
      return snapshot.docs.map((doc) => VehicleTypeModel.fromJson(doc.data())).toList();
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  static Future<List<DocumentsModel>> getDocumentList() async {
    try {
      final snapshot = await fireStore.collection(CollectionName.documents).where("isEnable", isEqualTo: true).get();
      return snapshot.docs.map((doc) => DocumentsModel.fromJson(doc.data())).toList();
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  static Future<List<VehicleBrandModel>> getVehicleBrand() async {
    try {
      final snapshot = await fireStore.collection(CollectionName.vehicleBrand).where("isEnable", isEqualTo: true).get();
      return snapshot.docs.map((doc) => VehicleBrandModel.fromJson(doc.data())).toList();
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  static Future<List<VehicleModelModel>> getVehicleModel(String brandId) async {
    try {
      final snapshot = await fireStore
          .collection(CollectionName.vehicleModel)
          .where("isEnable", isEqualTo: true)
          .where("brandId", isEqualTo: brandId)
          .get();
      return snapshot.docs.map((doc) => VehicleModelModel.fromJson(doc.data())).toList();
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  static Future<bool> addDocument(VerifyDriverModel verifyDriver) async {
    try {
      await fireStore.collection(CollectionName.verifyDriver).doc(verifyDriver.driverId).set(verifyDriver.toJson());
      return true;
    } catch (error) {
      log("Failed to update data: $error");
      return false;
    }
  }

  static Future<VerifyDriverModel?> getVerifyDriver(String uuid) async {
    try {
      final snapshot = await fireStore.collection(CollectionName.verifyDriver).where('driverId', isEqualTo: uuid).get();
      if (snapshot.docs.isNotEmpty) {
        return VerifyDriverModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (error) {
      log("Failed to update data: $error");
      return null;
    }
  }

  Future<CurrencyModel?> getCurrency() async {
    try {
      final snapshot = await fireStore.collection(CollectionName.currency).where("active", isEqualTo: true).get();
      if (snapshot.docs.isNotEmpty) {
        return CurrencyModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (error) {
      log("Failed to get currency: $error");
      return null;
    }
  }

  Future<void> getAdminCommission() async {
    try {
      final doc = await fireStore.collection(CollectionName.settings).doc("admin_commission").get();
      log('========================> get admin commission');
      if (doc.data() != null) {
        final adminCommission = AdminCommission.fromJson(doc.data()!);
        if (adminCommission.active == true) {
          Constant.adminCommission = adminCommission;
        }
      }
    } catch (error) {
      log("Failed to get admin commission: $error");
    }
  }

  Future<void> getSettings() async {
    try {
      final constantDoc = await fireStore.collection(CollectionName.settings).doc("constant").get();
      if (constantDoc.exists) {
        final data = constantDoc.data()!;
        Constant.mapAPIKey = data["googleMapKey"];
        Constant.senderId = data["notification_senderId"];
        Constant.jsonFileURL = data["jsonFileURL"];
        Constant.minimumAmountToWithdrawal = data["minimum_amount_withdraw"];
        Constant.minimumAmountToDeposit = data["minimum_amount_deposit"];
        Constant.appName = data["appName"];
        Constant.appColor = data["appColor"];
        Constant.termsAndConditions = data["termsAndConditions"];
        Constant.privacyPolicy = data["privacyPolicy"];
        Constant.aboutApp = data["aboutApp"];
        Constant.interCityRadius = double.parse(data["interCityRadius"]);
        Constant.isSubscriptionEnable = data["isSubscriptionEnable"] ?? false;
        Constant.isDocumentVerificationEnable = data["isDocumentVerificationEnable"] ?? true;
      }

      final globalValueDoc = await fireStore.collection(CollectionName.settings).doc("globalValue").get();
      if (globalValueDoc.exists) {
        final data = globalValueDoc.data()!;
        Constant.distanceType = data["distanceType"];
        Constant.driverLocationUpdate = data["driverLocationUpdate"];
        Constant.radius = data["radius"];
        Constant.minimumAmountToAcceptRide = data["minimum_amount_accept_ride"];
      }

      final cancelReasonDoc = await fireStore.collection(CollectionName.settings).doc("canceling_reason").get();
      if (cancelReasonDoc.exists) {
        Constant.cancellationReason = cancelReasonDoc.data()!["reasons"];
      }
    } catch (error) {
      log("Failed to get settings: $error");
    }
  }

  Future<PaymentModel?> getPayment() async {
    try {
      final doc = await fireStore.collection(CollectionName.settings).doc("payment").get();
      if (doc.exists && doc.data() != null) {
        final payment = PaymentModel.fromJson(doc.data()!);
        Constant.paymentModel = payment;
        return payment;
      }
      return null;
    } catch (error) {
      log("Failed to get payment: $error");
      return null;
    }
  }

  static Future<List<WalletTransactionModel>> getWalletTransaction() async {
    try {
      final snapshot = await fireStore
          .collection(CollectionName.walletTransaction)
          .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
          .where('type', isEqualTo: "driver")
          .orderBy('createdDate', descending: true)
          .get();
      return snapshot.docs.map((doc) => WalletTransactionModel.fromJson(doc.data())).toList();
    } catch (error) {
      log("Failed to get wallet transactions: $error");
      return [];
    }
  }

  static Future<bool> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    try {
      await fireStore
          .collection(CollectionName.walletTransaction)
          .doc(walletTransactionModel.id)
          .set(walletTransactionModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update user: $error");
      return false;
    }
  }

  static Future<bool> setBooking(BookingModel bookingModel) async {
    try {
      await fireStore.collection(CollectionName.bookings).doc(bookingModel.id).set(bookingModel.toJson());
      return true;
    } catch (error) {
      log("Failed to add ride: $error");
      return false;
    }
  }

  static Future<bool> setInterCityBooking(IntercityModel bookingModel) async {
    try {
      await fireStore.collection(CollectionName.interCityRide).doc(bookingModel.id).set(bookingModel.toJson());
      return true;
    } catch (error) {
      log("Failed to add ride: $error");
      return false;
    }
  }

  static Future<bool> setParcelBooking(ParcelModel bookingModel) async {
    try {
      await fireStore.collection(CollectionName.parcelRide).doc(bookingModel.id).set(bookingModel.toJson());
      return true;
    } catch (error) {
      log("Failed to add ride: $error");
      return false;
    }
  }

  // StreamController<List<BookingModel>>? getNearestBookingController;
  //
  // Stream<List<BookingModel>> getBookings(double? latitude, double? longLatitude) async* {
  //   getNearestBookingController = StreamController<List<BookingModel>>.broadcast();
  //   List<BookingModel> bookingsList = [];
  //   Query query = fireStore
  //       .collection(CollectionName.bookings)
  //       .where('bookingStatus', isEqualTo: BookingStatus.driverAssigned)
  //       .where('vehicleType.id', isEqualTo: Constant.userModel!.driverVehicleDetails!.vehicleTypeId);
  //   GeoFirePoint center = GeoFlutterFire().point(latitude: latitude ?? 0.0, longitude: longLatitude ?? 0.0);
  //   Stream<List<DocumentSnapshot>> stream =
  //       GeoFlutterFire().collection(collectionRef: query).within(center: center, radius: double.parse(Constant.radius), field: 'position', strictMode: true);
  //
  //   stream.listen((List<DocumentSnapshot> documentList) {
  //     log("Length= : ${documentList.length}");
  //     bookingsList.clear();
  //     for (var document in documentList) {
  //       final data = document.data() as Map<String, dynamic>;
  //       BookingModel bookingModel = BookingModel.fromJson(data);
  //       if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
  //         if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
  //           bookingsList.add(bookingModel);
  //         }
  //       } else if (bookingModel.rejectedDriverId != null && bookingModel.rejectedDriverId!.isNotEmpty) {
  //         if (!(bookingModel.rejectedDriverId ?? []).contains(FireStoreUtils.getCurrentUid())) {
  //           bookingsList.add(bookingModel);
  //         }
  //       } else {
  //         bookingsList.add(bookingModel);
  //       }
  //     }
  //     getNearestBookingController!.sink.add(bookingsList);
  //   });
  //
  //   yield* getNearestBookingController!.stream;
  // }

  // void closeStream() {
  //   getNearestBookingController?.close();
  // }

  static Future<List<IntercityModel>> getNearestIntercityRide(LatLng? sourceLocation, String? selectedDate) async {
    if (sourceLocation == null) {
      log('Source location is null');
      return [];
    }
    try {
      log('==> get nearest ride location ${sourceLocation.longitude} and latitude ${sourceLocation.latitude}');
      log('==> get nearest ride selectedDate $selectedDate');

      Query query = fireStore
          .collection(CollectionName.interCityRide)
          .where('bookingStatus', isEqualTo: BookingStatus.bookingPlaced)
          .where('vehicleTypeID', isEqualTo: Constant.userModel?.driverVehicleDetails?.vehicleTypeId.toString());

      if (selectedDate != null) {
        query = query.where('startDate', isEqualTo: selectedDate);
      }

      QuerySnapshot querySnapshot = await query.get();

      String currentUserId = FireStoreUtils.getCurrentUid();
      log('==> get data ${querySnapshot.docs.length}');

      List<IntercityModel> intercityList = querySnapshot.docs
          .map((doc) => IntercityModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((ride) => !(ride.driverBidIdList?.contains(currentUserId) ?? false))
          .toList();

      log('--> Intercity Call Firebase, Total Available: ${intercityList.length}');
      return intercityList;
    } catch (e) {
      log('Error fetching nearest intercity rides: $e');
      return [];
    }
  }

  static Future<List<ParcelModel>> getNearestParcelRide(LatLng? sourceLocation, String? selectedDate) async {
    if (Constant.userModel?.driverVehicleDetails?.vehicleTypeId == null) {
      log('User or vehicle type is null');
      return [];
    }
    try {
      Query query = fireStore
          .collection(CollectionName.parcelRide)
          .where('bookingStatus', isEqualTo: BookingStatus.bookingPlaced)
          .where('vehicleTypeID', isEqualTo: Constant.userModel!.driverVehicleDetails!.vehicleTypeId.toString());

      if (selectedDate != null) {
        query = query.where('startDate', isEqualTo: selectedDate);
      }

      QuerySnapshot querySnapshot = await query.get();

      String currentUserId = FireStoreUtils.getCurrentUid();
      log('==> get data ${querySnapshot.docs.length}');

      List<ParcelModel> parcelList = querySnapshot.docs
          .map((doc) => ParcelModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((ride) => !(ride.driverBidIdList?.contains(currentUserId) ?? false))
          .toList();

      log('--> Parcel Booking Call Firebase, Total Available: ${parcelList.length}');
      return parcelList;
    } catch (e) {
      log('Error fetching nearest parcel rides: $e');
      return [];
    }
  }

  StreamController<List<BookingModel>>? getHomeOngoingBookingController;

  Stream<List<BookingModel>> getHomeOngoingBookings() async* {
    getHomeOngoingBookingController = StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];
    try {
      if (Constant.userModel?.id == null) {
        log('User id is null');
        yield [];
        return;
      }
      Stream<QuerySnapshot> stream1 = fireStore
          .collection(CollectionName.bookings)
          .where('bookingStatus',
              whereIn: [BookingStatus.bookingAccepted, BookingStatus.bookingPlaced, BookingStatus.bookingOngoing])
          .where('driverId', isEqualTo: Constant.userModel!.id)
          .snapshots();
      stream1.listen((QuerySnapshot querySnapshot) {
        log("Length= : ${querySnapshot.docs.length}");
        bookingsList.clear();
        for (var document in querySnapshot.docs) {
          final data = document.data() as Map<String, dynamic>;
          BookingModel bookingModel = BookingModel.fromJson(data);
          if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
            if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
              bookingsList.add(bookingModel);
            }
          }
        }
        getHomeOngoingBookingController?.sink.add(bookingsList);
      });
      yield* getHomeOngoingBookingController!.stream;
    } catch (e) {
      log('Error in getHomeOngoingBookings: $e');
      yield [];
    }
  }

  void closeHomeOngoingStream() {
    getHomeOngoingBookingController?.close();
    getHomeOngoingBookingController = null;
  }

  // StreamController<List<BookingModel>>? getOngoingBookingController;
  //
  // Stream<List<BookingModel>> getOngoingBookings() async* {
  //   getOngoingBookingController = StreamController<List<BookingModel>>.broadcast();
  //   List<BookingModel> bookingsList = [];
  //   try {
  //     if (Constant.userModel?.id == null) {
  //       log('User id is null');
  //       yield [];
  //       return;
  //     }
  //     Stream<QuerySnapshot> stream = fireStore
  //         .collection(CollectionName.bookings)
  //         .where('bookingStatus', isEqualTo: BookingStatus.bookingAccepted)
  //         .where('driverId', isEqualTo: Constant.userModel!.id)
  //         .orderBy('createAt', descending: true)
  //         .snapshots();
  //     stream.listen((QuerySnapshot querySnapshot) {
  //       log("Length= : ${querySnapshot.docs.length}");
  //       bookingsList.clear();
  //       for (var document in querySnapshot.docs) {
  //         final data = document.data() as Map<String, dynamic>;
  //         BookingModel bookingModel = BookingModel.fromJson(data);
  //         if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
  //           if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
  //             bookingsList.add(bookingModel);
  //           }
  //         }
  //       }
  //       getOngoingBookingController?.sink.add(bookingsList);
  //     });
  //     Stream<QuerySnapshot> stream1 = fireStore
  //         .collection(CollectionName.bookings)
  //         .where('bookingStatus', isEqualTo: BookingStatus.bookingOngoing)
  //         .where('driverId', isEqualTo: Constant.userModel!.id)
  //         .snapshots();
  //     stream1.listen((QuerySnapshot querySnapshot) {
  //       log("Length= : ${querySnapshot.docs.length}");
  //       for (var document in querySnapshot.docs) {
  //         final data = document.data() as Map<String, dynamic>;
  //         BookingModel bookingModel = BookingModel.fromJson(data);
  //         if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
  //           if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
  //             bookingsList.add(bookingModel);
  //           }
  //         }
  //       }
  //       getOngoingBookingController?.sink.add(bookingsList);
  //     });
  //     yield* getOngoingBookingController!.stream;
  //   } catch (e) {
  //     log('Error in getOngoingBookings: $e');
  //     yield [];
  //   }
  // }
  //
  // void closeOngoingStream() {
  //   getOngoingBookingController?.close();
  //   getOngoingBookingController = null;
  // }

  // StreamController<List<BookingModel>>? getCompletedBookingController;
  //
  // Stream<List<BookingModel>> getCompletedBookings() async* {
  //   getCompletedBookingController = StreamController<List<BookingModel>>.broadcast();
  //   List<BookingModel> bookingsList = [];
  //   try {
  //     final userId = Constant.userModel?.id;
  //     if (userId == null) {
  //       log('User id is null');
  //       yield [];
  //       return;
  //     }
  //     Stream<QuerySnapshot> stream = fireStore
  //         .collection(CollectionName.bookings)
  //         .where('bookingStatus', isEqualTo: BookingStatus.bookingCompleted)
  //         .where('driverId', isEqualTo: userId)
  //         .orderBy('createAt', descending: true)
  //         .snapshots();
  //     stream.listen((QuerySnapshot querySnapshot) {
  //       log("Length= : ${querySnapshot.docs.length}");
  //       bookingsList.clear();
  //       for (var document in querySnapshot.docs) {
  //         final data = document.data() as Map<String, dynamic>;
  //         BookingModel bookingModel = BookingModel.fromJson(data);
  //         if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
  //           if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
  //             bookingsList.add(bookingModel);
  //           }
  //         }
  //       }
  //       getCompletedBookingController?.sink.add(bookingsList);
  //     });
  //     yield* getCompletedBookingController!.stream;
  //   } catch (e) {
  //     log('Error in getCompletedBookings: $e');
  //     yield [];
  //   }
  // }
  //
  // void closeCompletedStream() {
  //   getCompletedBookingController?.close();
  //   getCompletedBookingController = null;
  // }

  // StreamController<List<BookingModel>>? getCancelledBookingController;
  //
  // Stream<List<BookingModel>> getCancelledBookings() async* {
  //   getCancelledBookingController = StreamController<List<BookingModel>>.broadcast();
  //   List<BookingModel> bookingsList = [];
  //   try {
  //     final userId = Constant.userModel?.id;
  //     if (userId == null) {
  //       log('User id is null');
  //       yield [];
  //       return;
  //     }
  //     Stream<QuerySnapshot> stream = fireStore
  //         .collection(CollectionName.bookings)
  //         .where('bookingStatus', isEqualTo: BookingStatus.bookingCancelled)
  //         .where('driverId', isEqualTo: userId)
  //         .orderBy('createAt', descending: true)
  //         .snapshots();
  //     stream.listen((QuerySnapshot querySnapshot) {
  //       log("Length= : ${querySnapshot.docs.length}");
  //       bookingsList.clear();
  //       for (var document in querySnapshot.docs) {
  //         final data = document.data() as Map<String, dynamic>;
  //         BookingModel bookingModel = BookingModel.fromJson(data);
  //         if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
  //           if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
  //             bookingsList.add(bookingModel);
  //           }
  //         }
  //       }
  //       getCancelledBookingController?.sink.add(bookingsList);
  //     });
  //     yield* getCancelledBookingController!.stream;
  //   } catch (e) {
  //     log('Error in getCancelledBookings: $e');
  //     yield [];
  //   }
  // }
  //
  // void closeCancelledStream() {
  //   getCancelledBookingController?.close();
  //   getCancelledBookingController = null;
  // }

  // StreamController<List<BookingModel>>? getRejectedBookingController;
  //
  // Stream<List<BookingModel>> getRejectedBookings() async* {
  //   getRejectedBookingController = StreamController<List<BookingModel>>.broadcast();
  //   List<BookingModel> bookingsList = [];
  //   try {
  //     final userId = Constant.userModel?.id;
  //     if (userId == null) {
  //       log('User id is null');
  //       yield [];
  //       return;
  //     }
  //     Stream<QuerySnapshot> stream = fireStore
  //         .collection(CollectionName.bookings)
  //         .where('rejectedDriverId', arrayContains: userId)
  //         .orderBy("createAt", descending: true)
  //         .snapshots();
  //     stream.listen((QuerySnapshot querySnapshot) {
  //       log("Length= : ${querySnapshot.docs.length}");
  //       bookingsList.clear();
  //       for (var document in querySnapshot.docs) {
  //         final data = document.data() as Map<String, dynamic>;
  //         BookingModel bookingModel = BookingModel.fromJson(data);
  //         if (bookingModel.rejectedDriverId != null && bookingModel.rejectedDriverId!.isNotEmpty) {
  //           if ((bookingModel.rejectedDriverId ?? []).contains(FireStoreUtils.getCurrentUid())) {
  //             bookingsList.add(bookingModel);
  //           }
  //         }
  //       }
  //       getRejectedBookingController?.sink.add(bookingsList);
  //     });
  //     yield* getRejectedBookingController!.stream;
  //   } catch (e) {
  //     log('Error in getRejectedBookings: $e');
  //     yield [];
  //   }
  // }
  //
  // void closeRejectedStream() {
  //   getRejectedBookingController?.close();
  //   getRejectedBookingController = null;
  // }

  static Future<List<NotificationModel>?> getNotificationList() async {
    List<NotificationModel> notificationModelList = [];
    try {
      final query = await fireStore
          .collection(CollectionName.notification)
          .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
          .orderBy('createdAt', descending: true)
          .get();
      for (var element in query.docs) {
        NotificationModel notificationModel = NotificationModel.fromJson(element.data());
        notificationModelList.add(notificationModel);
      }
    } catch (error) {
      log("Failed to fetch notifications: $error");
    }
    return notificationModelList;
  }

  static Future<bool?> setNotification(NotificationModel notificationModel) async {
    try {
      await fireStore.collection(CollectionName.notification).doc(notificationModel.id).set(notificationModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update user: $error");
      return false;
    }
  }

  static Future<List<ReviewModel>?> getReviewList(DriverUserModel driverUserModel) async {
    List<ReviewModel> reviewModelList = [];
    try {
      final query =
          await fireStore.collection(CollectionName.review).where("driverId", isEqualTo: driverUserModel.id).get();
      for (var element in query.docs) {
        ReviewModel reviewModel = ReviewModel.fromJson(element.data());
        reviewModelList.add(reviewModel);
      }
    } catch (error) {
      log("Failed to fetch reviews: $error");
    }
    return reviewModelList;
  }

  static Future<List<BankDetailsModel>> getBankDetailList(String? driverId) async {
    List<BankDetailsModel> bankDetailsList = [];
    try {
      final query = await fireStore.collection(CollectionName.bankDetails).where("driverID", isEqualTo: driverId).get();
      for (var element in query.docs) {
        bankDetailsList.add(BankDetailsModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Failed to fetch bank details: $error");
    }
    return bankDetailsList;
  }

  static Future<bool> addBankDetail(BankDetailsModel bankDetailsModel) async {
    try {
      await fireStore.collection(CollectionName.bankDetails).doc(bankDetailsModel.id).set(bankDetailsModel.toJson());
      return true;
    } catch (error) {
      log("Failed to add bank detail: $error");
      return false;
    }
  }

  static Future<bool> updateBankDetail(BankDetailsModel bankDetailsModel) async {
    try {
      await fireStore.collection(CollectionName.bankDetails).doc(bankDetailsModel.id).update(bankDetailsModel.toJson());
      return true;
    } catch (error) {
      log("Failed to update bank detail: $error");
      return false;
    }
  }

  static Future<bool> setWithdrawRequest(WithdrawModel withdrawModel) async {
    try {
      await fireStore.collection(CollectionName.withdrawalHistory).doc(withdrawModel.id).set(withdrawModel.toJson());
      return true;
    } catch (error) {
      log("Failed to set withdraw request: $error");
      return false;
    }
  }

  static Future<List<WithdrawModel>> getWithDrawRequest() async {
    List<WithdrawModel> withdrawalList = [];
    try {
      final query = await fireStore
          .collection(CollectionName.withdrawalHistory)
          .where('driverId', isEqualTo: getCurrentUid())
          .orderBy('createdDate', descending: true)
          .get();
      for (var element in query.docs) {
        withdrawalList.add(WithdrawModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Failed to fetch withdraw requests: $error");
    }
    return withdrawalList;
  }

  static Future<int> getTotalRide() async {
    try {
      final productList =
          FirebaseFirestore.instance.collection(CollectionName.bookings).where("driverId", isEqualTo: getCurrentUid());
      final query = await productList.count().get();
      log('The number of products: ${query.count}');
      return query.count ?? 0;
    } catch (e) {
      log('Error in getTotalRide: $e');
      return 0;
    }
  }

  static Future<int> getCompletedRide() async {
    try {
      final productList = FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where("driverId", isEqualTo: getCurrentUid())
          .where("bookingStatus", isEqualTo: BookingStatus.bookingCompleted);
      final query = await productList.count().get();
      log('The number of products: ${query.count}');
      return query.count ?? 0;
    } catch (e) {
      log('Error in getCompletedRide: $e');
      return 0;
    }
  }

  static Future<int> getOngoingRide() async {
    try {
      final productList = FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where("driverId", isEqualTo: getCurrentUid())
          .where("bookingStatus", isEqualTo: BookingStatus.bookingOngoing);
      final query = await productList.count().get();
      log('The number of products: ${query.count}');
      return query.count ?? 0;
    } catch (e) {
      log('Error in getOngoingRide: $e');
      return 0;
    }
  }

  static Future<BookingModel?> getBookingBuBookingId(String bookingId) async {
    BookingModel? referralModel;
    try {
      await fireStore.collection(CollectionName.bookings).doc(bookingId).get().then((value) {
        if (value.exists) {
          referralModel = BookingModel.fromJson(value.data()!);
        }
      });
    } catch (e, s) {
      debugPrint('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return referralModel;
  }

  static Future<int> getNewRide() async {
    try {
      final productList = FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where("driverId", isEqualTo: getCurrentUid())
          .where("bookingStatus", isEqualTo: BookingStatus.bookingAccepted);
      final query = await productList.count().get();
      log('The number of products: ${query.count}');
      return query.count ?? 0;
    } catch (e) {
      log('Error in getNewRide: $e');
      return 0;
    }
  }

  static Future<int> getRejectedRide() async {
    try {
      final productList = FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where("rejectedDriverId", arrayContains: getCurrentUid());
      final query = await productList.count().get();
      log('The number of products: ${query.count}');
      return query.count ?? 0;
    } catch (e) {
      log('Error in getRejectedRide: $e');
      return 0;
    }
  }

  static Future<int> getCancelledRide() async {
    try {
      final productList = FirebaseFirestore.instance
          .collection(CollectionName.bookings)
          .where("driverId", isEqualTo: getCurrentUid())
          .where("bookingStatus", isEqualTo: BookingStatus.bookingCancelled);
      final query = await productList.count().get();
      log('The number of products: ${query.count}');
      return query.count ?? 0;
    } catch (e) {
      log('Error in getCancelledRide: $e');
      return 0;
    }
  }

  static Future<List<SupportReasonModel>> getSupportReason() async {
    List<SupportReasonModel> supportReasonList = [];
    try {
      final value = await fireStore.collection(CollectionName.supportReason).where("type", isEqualTo: "driver").get();
      for (var element in value.docs) {
        supportReasonList.add(SupportReasonModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Failed to fetch support reasons: $error");
    }
    return supportReasonList;
  }

  static Future<bool> addSupportTicket(SupportTicketModel supportTicketModel) async {
    try {
      await fireStore
          .collection(CollectionName.supportTicket)
          .doc(supportTicketModel.id)
          .set(supportTicketModel.toJson());
      return true;
    } catch (error) {
      log("Failed to add Support Ticket : $error");
      return false;
    }
  }

  static Future<List<SupportTicketModel>> getSupportTicket(String id) async {
    List<SupportTicketModel> supportTicketList = [];
    try {
      final value = await fireStore
          .collection(CollectionName.supportTicket)
          .where("userId", isEqualTo: id)
          .orderBy("createAt", descending: true)
          .get();
      for (var element in value.docs) {
        supportTicketList.add(SupportTicketModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Failed to fetch support tickets: $error");
    }
    return supportTicketList;
  }

  static void getInterCityOngoingRides(Function(List<IntercityModel>) onUpdate) {
    fireStore
        .collection(CollectionName.interCityRide)
        .where("driverId", isEqualTo: getCurrentUid())
        .where('bookingStatus', whereIn: [BookingStatus.bookingOngoing, BookingStatus.bookingAccepted])
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          List<IntercityModel> bookingList =
              querySnapshot.docs.map((doc) => IntercityModel.fromJson(doc.data())).toList();
          onUpdate(bookingList);
        }, onError: (error) {
          log("Error fetching ongoing rides: $error");
          onUpdate([]);
        });
  }

  static void getInterCityCompletedRides(Function(List<IntercityModel>) onUpdate) {
    fireStore
        .collection(CollectionName.interCityRide)
        .where("driverId", isEqualTo: getCurrentUid())
        .where('bookingStatus', whereIn: [BookingStatus.bookingCompleted])
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          List<IntercityModel> updatedList =
              querySnapshot.docs.map((doc) => IntercityModel.fromJson(doc.data())).toList();
          onUpdate(updatedList);
        }, onError: (error) {
          log("Error fetching completed rides: $error");
          onUpdate([]);
        });
  }

  static void getInterCityActiveRides(Function(List<IntercityModel>) onUpdate) {
    String customerId = getCurrentUid();
    fireStore
        .collection(CollectionName.interCityRide)
        .where('bookingStatus', whereIn: [BookingStatus.bookingPlaced])
        .where('driverBidIdList', arrayContains: customerId)
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          List<IntercityModel> bookingList =
              querySnapshot.docs.map((doc) => IntercityModel.fromJson(doc.data())).toList();
          onUpdate(bookingList);
        }, onError: (error) {
          log("Error fetching ongoing rides: $error");
          onUpdate([]);
        });
  }

  static void getInterCityRejectedRides(Function(List<IntercityModel>) onUpdate) {
    fireStore
        .collection(CollectionName.interCityRide)
        .where("driverId", isEqualTo: getCurrentUid())
        .where('bookingStatus', whereIn: [BookingStatus.bookingCancelled, BookingStatus.bookingRejected])
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          final updatedList = querySnapshot.docs.map((doc) => IntercityModel.fromJson(doc.data())).toList();
          onUpdate(updatedList);
        }, onError: (error) {
          log("Error fetching rejected rides: $error");
          onUpdate([]);
        });
  }

  static void getParcelActiveRides(Function(List<ParcelModel>) onUpdate) {
    final customerId = getCurrentUid();
    fireStore
        .collection(CollectionName.parcelRide)
        .where('bookingStatus', whereIn: [BookingStatus.bookingPlaced])
        .where('driverBidIdList', arrayContains: customerId)
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          final bookingList = querySnapshot.docs.map((doc) => ParcelModel.fromJson(doc.data())).toList();
          onUpdate(bookingList);
        }, onError: (error) {
          log("Error fetching ongoing rides: $error");
          onUpdate([]);
        });
  }

  static void getParcelOngoingRides(Function(List<ParcelModel>) onUpdate) {
    fireStore
        .collection(CollectionName.parcelRide)
        .where("driverId", isEqualTo: getCurrentUid())
        .where('bookingStatus', whereIn: [BookingStatus.bookingOngoing, BookingStatus.bookingAccepted])
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          final bookingList = querySnapshot.docs.map((doc) => ParcelModel.fromJson(doc.data())).toList();
          onUpdate(bookingList);
        }, onError: (error) {
          log("Error fetching ongoing rides: $error");
          onUpdate([]);
        });
  }

  static void getParcelCompletedRides(Function(List<ParcelModel>) onUpdate) {
    fireStore
        .collection(CollectionName.parcelRide)
        .where("driverId", isEqualTo: getCurrentUid())
        .where('bookingStatus', whereIn: [BookingStatus.bookingCompleted])
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          final updatedList = querySnapshot.docs.map((doc) => ParcelModel.fromJson(doc.data())).toList();
          onUpdate(updatedList);
        }, onError: (error) {
          log("Error fetching completed rides: $error");
          onUpdate([]);
        });
  }

  static void getParcelRejectedRides(Function(List<ParcelModel>) onUpdate) {
    fireStore
        .collection(CollectionName.parcelRide)
        .where("driverId", isEqualTo: getCurrentUid())
        .where('bookingStatus', whereIn: [BookingStatus.bookingCancelled, BookingStatus.bookingRejected])
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
          final updatedList = querySnapshot.docs.map((doc) => ParcelModel.fromJson(doc.data())).toList();
          onUpdate(updatedList);
        }, onError: (error) {
          log("Error fetching rejected rides: $error");
          onUpdate([]);
        });
  }

  static Future<List<IntercityModel>> getDataForPdfInterCity(DateTimeRange? dateTimeRange) async {
    final interCityModelList = <IntercityModel>[];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.interCityRide)
          .where("driverId", isEqualTo: getCurrentUid())
          .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        interCityModelList.add(IntercityModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Error $error");
    }
    return interCityModelList;
  }

  static Future<List<BookingModel>> getDataForPdfCab(DateTimeRange? dateTimeRange) async {
    final cabModelList = <BookingModel>[];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.bookings)
          .where("driverId", isEqualTo: getCurrentUid())
          .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        cabModelList.add(BookingModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Error $error");
    }
    return cabModelList;
  }

  static Future<List<ParcelModel>> getDataForPdfParcel(DateTimeRange? dateTimeRange) async {
    List<ParcelModel> parcelList = [];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.parcelRide)
          .where("driverId", isEqualTo: getCurrentUid())
          .where('createAt', isGreaterThanOrEqualTo: dateTimeRange!.start, isLessThanOrEqualTo: dateTimeRange.end)
          .orderBy('createAt', descending: true)
          .get();
      for (var element in querySnapshot.docs) {
        parcelList.add(ParcelModel.fromJson(element.data()));
      }
    } catch (error) {
      log("Error $error");
    }
    return parcelList;
  }

  static Future<List<SubscriptionModel>> getSubscription() async {
    List<SubscriptionModel> subscriptionList = [];
    try {
      final value = await fireStore
          .collection(CollectionName.subscriptionPlans)
          .where("isEnable", isEqualTo: true)
          .orderBy("createdAt", descending: false)
          .get();
      for (var element in value.docs) {
        subscriptionList.add(SubscriptionModel.fromJson(element.data()));
      }
    } catch (error) {
      log(error.toString());
    }
    log("Subscription list length: ${subscriptionList.length}");
    return subscriptionList;
  }

  static Future<bool> setSubscriptionHistory(SubscriptionHistoryModel subscriptionHistoryModel) async {
    try {
      await fireStore
          .collection(CollectionName.subscriptionHistory)
          .doc(subscriptionHistoryModel.id)
          .set(subscriptionHistoryModel.toJson());
      return true;
    } catch (error, stackTrace) {
      log("Failed to update subscription history: $error\n$stackTrace");
      return false;
    }
  }

  Stream<List<SubscriptionHistoryModel>> getPurchasedSubscription(String driverId) {
    return fireStore
        .collection(CollectionName.subscriptionHistory)
        .where("driverId", isEqualTo: driverId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                return SubscriptionHistoryModel.fromJson(doc.data());
              } catch (e, st) {
                log("Failed to parse subscription history: $e\n$st");
                return null;
              }
            })
            .whereType<SubscriptionHistoryModel>()
            .toList());
  }
}
