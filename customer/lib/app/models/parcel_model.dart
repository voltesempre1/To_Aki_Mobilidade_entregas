import 'dart:convert';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/admin_commission.dart';
import 'package:customer/app/models/coupon_model.dart';
import 'package:customer/app/models/distance_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/intercity_model.dart';
import 'package:customer/app/models/location_lat_lng.dart';
import 'package:customer/app/models/positions.dart';
import 'package:customer/app/models/vehicle_type_model.dart';

import 'tax_model.dart';

class ParcelModel {
  String? id;
  Timestamp? createAt;
  Timestamp? updateAt;
  String? driverId;
  String? vehicleTypeID;
  LocationLatLng? pickUpLocation;
  LocationLatLng? dropLocation;
  String? pickUpLocationAddress;
  String? dropLocationAddress;
  String? bookingStatus;
  String? customerId;
  String? paymentType;
  bool? paymentStatus;
  String? cancelledBy;
  String? discount;
  String? subTotal;
  Timestamp? bookingTime;
  Timestamp? pickupTime;
  Timestamp? dropTime;
  VehicleTypeModel? vehicleType;
  List<dynamic>? rejectedDriverId;
  List<dynamic>? driverBidIdList;
  String? otp;
  Positions? position;
  CouponModel? coupon;
  List<TaxModel>? taxList;
  AdminCommission? adminCommission;
  DistanceModel? distance;
  String? cancelledReason;
  String? parcelImage;
  String? dimension;
  String? weight;
  String? startDate;
  String? setPrice;
  String? recommendedPrice;
  String? rideStartTime;
  List<BidModel>? bidList;
  DriverVehicleDetails? driverVehicleDetails;

  ParcelModel({
    this.createAt,
    this.updateAt,
    this.driverId,
    this.vehicleTypeID,
    this.bookingStatus,
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
    this.vehicleType,
    this.rejectedDriverId,
    this.driverBidIdList,
    this.otp,
    this.position,
    this.adminCommission,
    this.coupon,
    this.taxList,
    this.distance,
    this.cancelledReason,
    this.parcelImage,
    this.dimension,
    this.weight,
    this.startDate,
    this.setPrice,
    this.recommendedPrice,
    this.rideStartTime,
    this.bidList,
    this.driverVehicleDetails,
  });

  @override
  String toString() {
    return 'BookingModel{id: $id, createAt: $createAt, updateAt: $updateAt,cancelledReason:$cancelledReason, driverId: $driverId, pickUpLocation: $pickUpLocation, dropLocation: $dropLocation, pickUpLocationAddress: $pickUpLocationAddress, dropLocationAddress: $dropLocationAddress, bookingStatus: $bookingStatus, customerId: $customerId, paymentType: $paymentType, paymentStatus: $paymentStatus, cancelledBy: $cancelledBy, discount: $discount, subTotal: $subTotal, bookingTime: $bookingTime, pickupTime: $pickupTime, dropTime: $dropTime, vehicleType: $vehicleType, rejectedDriverId: $rejectedDriverId, otp: $otp, position: $position, coupon: $coupon, taxList: $taxList, adminCommission: $adminCommission, distance: $distance, recommendedPrice: $recommendedPrice}';
  }

  factory ParcelModel.fromRawJson(String str) => ParcelModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParcelModel.fromJson(Map<String, dynamic> json) => ParcelModel(
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        driverId: json["driverId"],
        vehicleTypeID: json["vehicleTypeID"],
        bookingStatus: json["bookingStatus"],
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
        parcelImage: json["parcelImage"],
        dimension: json["dimension"],
        weight: json["weight"],
        startDate: json["startDate"],
        setPrice: json["setPrice"],
        recommendedPrice: json["recommendedPrice"],
        otp: json["otp"],
        rideStartTime: json["rideStartTime"],
        vehicleType: json["vehicleType"] == null ? null : VehicleTypeModel.fromJson(json["vehicleType"]),
        rejectedDriverId: json["rejectedDriverId"] == null ? [] : List<dynamic>.from(json["rejectedDriverId"]!.map((x) => x)),
        driverBidIdList: json["driverBidIdList"] == null ? [] : List<dynamic>.from(json["driverBidIdList"]!.map((x) => x)),
        taxList: json["taxList"] == null ? [] : List<TaxModel>.from(json["taxList"]!.map((x) => TaxModel.fromJson(x))),
        position: json["position"] == null ? null : Positions.fromJson(json["position"]),
        coupon: json["coupon"] == null ? null : CouponModel.fromJson(json["coupon"]),
        driverVehicleDetails: json["driverVehicleDetails"] == null ? null : DriverVehicleDetails.fromJson(json["driverVehicleDetails"]),
        adminCommission: json["adminCommission"] == null ? null : AdminCommission.fromJson(json["adminCommission"]),
        distance: json["distance"] == null ? null : DistanceModel.fromJson(json["distance"]),
        bidList: json["bidList"] == null ? [] : List<BidModel>.from(json["bidList"]!.map((x) => BidModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createAt": createAt,
        "updateAt": updateAt,
        "driverId": driverId,
        "vehicleTypeID": vehicleTypeID,
        "bookingStatus": bookingStatus,
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
        "parcelImage": parcelImage,
        "setPrice": setPrice,
        "recommendedPrice": recommendedPrice,
        "dimension": dimension,
        "startDate": startDate,
        "weight": weight,
        "pickupTime": pickupTime,
        "rideStartTime": rideStartTime,
        "dropTime": dropTime,
        "vehicleType": vehicleType?.toJson(),
        "rejectedDriverId": rejectedDriverId == null ? [] : List<dynamic>.from(rejectedDriverId!.map((x) => x)),
        "driverBidIdList": driverBidIdList == null ? [] : List<dynamic>.from(driverBidIdList!.map((x) => x)),
        "taxList": taxList == null ? [] : (taxList!.map((x) => x.toJson()).toList()),
        "bidList": bidList == null ? [] : (bidList!.map((x) => x.toJson()).toList()),
        "position": position?.toJson(),
        "driverVehicleDetails": driverVehicleDetails?.toJson(),
        "coupon": coupon?.toJson(),
        "adminCommission": adminCommission?.toJson(),
        "distance": distance?.toJson(),
        "otp": otp
      };
}
