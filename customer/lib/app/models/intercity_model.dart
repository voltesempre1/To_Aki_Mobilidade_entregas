import 'dart:convert';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/admin_commission.dart';
import 'package:customer/app/models/coupon_model.dart';
import 'package:customer/app/models/distance_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/person_model.dart';
import 'package:customer/app/models/positions.dart';
import 'package:customer/app/models/vehicle_type_model.dart';
import 'tax_model.dart';

class IntercityModel {
  String? id;
  Timestamp? createAt;
  Timestamp? updateAt;
  String? driverId;
  LocationLatLng? pickUpLocation;
  LocationLatLng? dropLocation;
  String? pickUpLocationAddress;
  String? dropLocationAddress;
  String? bookingStatus;
  String? vehicleTypeID;
  String? customerId;
  String? paymentType;
  bool? paymentStatus;
  String? cancelledBy;
  String? discount;
  String? subTotal;
  Timestamp? bookingTime;
  Timestamp? pickupTime;
  Timestamp? dropTime;
  DriverVehicleDetails? driverVehicleDetails;
  VehicleTypeModel? vehicleType;
  List<dynamic>? rejectedDriverId;
  List<dynamic>? driverBidIdList;
  String? otp;
  Positions? position;
  CouponModel? coupon;
  List<TaxModel>? taxList;
  List<PersonModel>? sharingPersonList;
  List<BidModel>? bidList;
  AdminCommission? adminCommission;
  DistanceModel? distance;
  String? cancelledReason;
  String? startDate;
  String? setPrice;
  String? recommendedPrice;
  bool? isPersonalRide;
  bool? isAcceptDriver;
  String? persons;
  String? type;
  String? rideStartTime;

  IntercityModel(
      {this.createAt,
      this.updateAt,
      this.driverId,
      this.bookingStatus,
      this.vehicleTypeID,
      this.id,
      this.dropLocation,
      this.pickUpLocation,
      this.dropLocationAddress,
      this.pickUpLocationAddress,
      this.customerId,
      this.paymentType,
      this.paymentStatus,
      this.cancelledBy,
      this.discount,
      this.subTotal,
      this.bookingTime,
      this.pickupTime,
      this.dropTime,
      this.driverVehicleDetails,
      this.rejectedDriverId,
      this.driverBidIdList,
      this.otp,
      this.position,
      this.adminCommission,
      this.coupon,
      this.startDate,
      this.setPrice,
      this.recommendedPrice,
      this.isPersonalRide,
      this.taxList,
      this.sharingPersonList,
      this.vehicleType,
      this.bidList,
      this.persons,
      this.distance,
      this.isAcceptDriver,
      this.type,
      this.rideStartTime,
      this.cancelledReason});

  @override
  String toString() {
    return 'BookingModel{id: $id, createAt: $createAt, updateAt: $updateAt,cancelledReason:$cancelledReason, driverId: $driverId, pickUpLocation: $pickUpLocation, dropLocation: $dropLocation, pickUpLocationAddress: $pickUpLocationAddress, dropLocationAddress: $dropLocationAddress, bookingStatus: $bookingStatus, customerId: $customerId, paymentType: $paymentType, paymentStatus: $paymentStatus, cancelledBy: $cancelledBy, discount: $discount, subTotal: $subTotal, bookingTime: $bookingTime, pickupTime: $pickupTime, dropTime: $dropTime, driverVehicleDetails: $driverVehicleDetails, rejectedDriverId: $rejectedDriverId, otp: $otp, position: $position, coupon: $coupon, taxList: $taxList, adminCommission: $adminCommission, distance: $distance,recommendedPrice: $recommendedPrice}';
  }

  factory IntercityModel.fromRawJson(String str) => IntercityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IntercityModel.fromJson(Map<String, dynamic> json) => IntercityModel(
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        driverId: json["driverId"],
        bookingStatus: json["bookingStatus"],
        vehicleTypeID: json["vehicleTypeID"],
        dropLocation: json['dropLocation'] != null ? LocationLatLng.fromJson(json['dropLocation']) : null,
        pickUpLocation: json['pickUpLocation'] != null ? LocationLatLng.fromJson(json['pickUpLocation']) : null,
        dropLocationAddress: json['dropLocationAddress'],
        pickUpLocationAddress: json['pickUpLocationAddress'],
        id: json["id"],
        customerId: json["customerId"],
        paymentType: json["paymentType"],
        paymentStatus: json["paymentStatus"],
        cancelledBy: json["cancelledBy"],
        cancelledReason: json["cancelledReason"],
        discount: json["discount"],
        subTotal: json["subTotal"],
        bookingTime: json["bookingTime"],
        pickupTime: json["pickupTime"],
        dropTime: json["dropTime"],
        otp: json["otp"],
        startDate: json["startDate"],
        setPrice: json["setPrice"],
        recommendedPrice: json["recommendedPrice"],
        isAcceptDriver: json["isAcceptDriver"],
        isPersonalRide: json["isPersonalRide"],
        persons: json["persons"],
        type: json["type"],
        rideStartTime: json["rideStartTime"],
        driverVehicleDetails: json["driverVehicleDetails"] == null ? null : DriverVehicleDetails.fromJson(json["driverVehicleDetails"]),
        vehicleType: json["vehicleType"] == null ? null : VehicleTypeModel.fromJson(json["vehicleType"]),
        rejectedDriverId: json["rejectedDriverId"] == null ? [] : List<dynamic>.from(json["rejectedDriverId"]!.map((x) => x)),
        driverBidIdList: json["driverBidIdList"] == null ? [] : List<dynamic>.from(json["driverBidIdList"]!.map((x) => x)),
        taxList: json["taxList"] == null ? [] : List<TaxModel>.from(json["taxList"]!.map((x) => TaxModel.fromJson(x))),
        sharingPersonList: json["sharingPersonList"] == null ? [] : List<PersonModel>.from(json["sharingPersonList"]!.map((x) => PersonModel.fromJson(x))),
        bidList: json["bidList"] == null ? [] : List<BidModel>.from(json["bidList"]!.map((x) => BidModel.fromJson(x))),
        position: json["position"] == null ? null : Positions.fromJson(json["position"]),
        coupon: json["coupon"] == null ? null : CouponModel.fromJson(json["coupon"]),
        adminCommission: json["adminCommission"] == null ? AdminCommission() : AdminCommission.fromJson(json["adminCommission"]),
        distance: json["distance"] == null ? null : DistanceModel.fromJson(json["distance"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createAt": createAt,
        "updateAt": updateAt,
        "driverId": driverId,
        "bookingStatus": bookingStatus,
        "vehicleTypeID": vehicleTypeID,
        "dropLocation": dropLocation?.toJson(),
        "pickUpLocation": pickUpLocation?.toJson(),
        "dropLocationAddress": dropLocationAddress,
        "pickUpLocationAddress": pickUpLocationAddress,
        "customerId": customerId,
        "paymentType": paymentType,
        "paymentStatus": paymentStatus,
        "cancelledBy": cancelledBy,
        "cancelledReason": cancelledReason,
        "discount": discount,
        "subTotal": subTotal,
        "bookingTime": bookingTime,
        "pickupTime": pickupTime,
        "dropTime": dropTime,
        "isAcceptDriver": isAcceptDriver,
        "persons": persons,
        "isPersonalRide": isPersonalRide,
        "setPrice": setPrice,
        "recommendedPrice": recommendedPrice,
        "type": type,
        "rideStartTime": rideStartTime,
        "startDate": startDate,
        "driverVehicleDetails": driverVehicleDetails?.toJson(),
        "rejectedDriverId": rejectedDriverId == null ? [] : List<dynamic>.from(rejectedDriverId!.map((x) => x)),
        "driverBidIdList": driverBidIdList == null ? [] : List<dynamic>.from(driverBidIdList!.map((x) => x)),
        "taxList": taxList == null ? [] : (taxList!.map((x) => x.toJson()).toList()),
        "sharingPersonList": sharingPersonList == null ? [] : (sharingPersonList!.map((x) => x.toJson()).toList()),
        "bidList": bidList == null ? [] : (bidList!.map((x) => x.toJson()).toList()),
        "position": position?.toJson(),
        "coupon": coupon?.toJson(),
        "vehicleType": vehicleType?.toJson(),
        "adminCommission": adminCommission?.toJson(),
        "distance": distance?.toJson(),
        "otp": otp
      };
}

class BidModel {
  String? id;
  String? driverID;
  String? bidStatus;
  String? amount;

  // DriverVehicleDetails? driverVehicleDetails;

  BidModel({
    this.id,
    this.amount,
    this.bidStatus,
    this.driverID,
    // this.driverVehicleDetails,
  });

  BidModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    amount = json["amount"];
    bidStatus = json["bidStatus"];
    driverID = json["driverID"];
    // driverVehicleDetails = json['driverVehicleDetails'] != null ? DriverVehicleDetails.fromJson(json["driverVehicleDetails"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // if (driverVehicleDetails != null) {
    data["id"] = id;
    data["amount"] = amount;
    data["bidStatus"] = bidStatus;
    data["driverID"] = driverID;
    // data["driverVehicleDetails"] = driverVehicleDetails!.toJson();
    // }

    return data;
  }
}
