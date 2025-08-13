import 'dart:convert';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:admin/app/models/admin_commission_model.dart';
import 'package:admin/app/models/coupon_model.dart';
import 'package:admin/app/models/distance_model.dart';
import 'package:admin/app/models/location_lat_lng.dart';
import 'package:admin/app/models/positions.dart';
import 'package:admin/app/models/vehicle_type_model.dart';
import 'tax_model.dart';

class BookingModel {
  String? id;
  Timestamp? createAt;
  Timestamp? updateAt;
  Timestamp? assignedAt;
  String? driverId;
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
  String? taxTotal;
  Timestamp? bookingTime;
  Timestamp? pickupTime;
  Timestamp? dropTime;
  VehicleTypeModel? vehicleType;
  List<dynamic>? rejectedDriverId;
  String? otp;
  Positions? position;
  CouponModel? coupon;
  List<TaxModel>? taxList;
  AdminCommission? adminCommission;
  DistanceModel? distance;
  String? cancelledReason;

  BookingModel({this.createAt,
    this.updateAt,
    this.assignedAt,
    this.driverId,
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
    this.taxTotal,
    this.bookingTime,
    this.pickupTime,
    this.dropTime,
    this.vehicleType,
    this.rejectedDriverId,
    this.otp,
    this.position,
    this.adminCommission,
    this.coupon,
    this.taxList,
    this.distance,
    this.cancelledReason});

  @override
  String toString() {
    return 'BookingModel{id: $id, createAt: $createAt, updateAt: $updateAt,cancelledReason:$cancelledReason, driverId: $driverId, pickUpLocation: $pickUpLocation, dropLocation: $dropLocation, pickUpLocationAddress: $pickUpLocationAddress, dropLocationAddress: $dropLocationAddress, bookingStatus: $bookingStatus, customerId: $customerId, paymentType: $paymentType, paymentStatus: $paymentStatus, cancelledBy: $cancelledBy, discount: $discount, subTotal: $subTotal, taxTotal: $taxTotal, bookingTime: $bookingTime, pickupTime: $pickupTime, dropTime: $dropTime, vehicleType: $vehicleType, rejectedDriverId: $rejectedDriverId, otp: $otp, position: $position, coupon: $coupon, taxList: $taxList, adminCommission: $adminCommission, distance: $distance}';
  }

  factory BookingModel.fromRawJson(String str) => BookingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      BookingModel(
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        assignedAt: json["assignedAt"],
        driverId: json["driverId"],
        bookingStatus: json["bookingStatus"] ?? '',
        dropLocation: json['dropLocation'] != null ? LocationLatLng.fromJson(json['dropLocation']) : null,
        pickUpLocation: json['pickUpLocation'] != null ? LocationLatLng.fromJson(json['pickUpLocation']) : null,
        dropLocationAddress: json['dropLocationAddress'] ?? '',
        pickUpLocationAddress: json['pickUpLocationAddress'] ?? '',
        id: json["id"] ?? '',
        customerId: json["customerId"],
        paymentType: json["paymentType"] ?? '',
        paymentStatus: json["paymentStatus"] ?? false,
        cancelledBy: json["cancelledBy"] ?? '',
        cancelledReason: json["cancelledReason"] ?? '',
        discount: json["discount"],
        subTotal: json["subTotal"],
        taxTotal: json["taxTotal"],
        bookingTime: json["bookingTime"],
        pickupTime: json["pickupTime"],
        dropTime: json["dropTime"],
        otp: json["otp"] ?? '',
        vehicleType: json["vehicleType"] == null ? null : VehicleTypeModel.fromJson(json["vehicleType"]),
        rejectedDriverId: json["rejectedDriverId"] == null ? [] : List<dynamic>.from(json["rejectedDriverId"]!.map((x) => x)),
        taxList: json["taxList"] == null ? [] : List<TaxModel>.from(json["taxList"]!.map((x) => TaxModel.fromJson(x))),
        position: json["position"] == null ? null : Positions.fromJson(json["position"]),
        coupon: json["coupon"] == null ? null : CouponModel.fromJson(json["coupon"]),
        adminCommission: json["adminCommission"] == null ? null : AdminCommission.fromJson(json["adminCommission"]),
        distance: json["distance"] == null ? null : DistanceModel.fromJson(json["distance"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "createAt": createAt,
        "updateAt": updateAt,
        "assignedAt": assignedAt,
        "driverId": driverId,
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
        "taxTotal": taxTotal,
        "bookingTime": bookingTime,
        "pickupTime": pickupTime,
        "dropTime": dropTime,
        "vehicleType": vehicleType?.toJson(),
        "rejectedDriverId": rejectedDriverId == null ? [] : List<dynamic>.from(rejectedDriverId!.map((x) => x)),
        "taxList": taxList == null ? [] : (taxList!.map((x) => x.toJson()).toList()),
        "position": position?.toJson(),
        "coupon": coupon?.toJson(),
        "adminCommission": adminCommission?.toJson(),
        "distance": distance?.toJson(),
      };
}
