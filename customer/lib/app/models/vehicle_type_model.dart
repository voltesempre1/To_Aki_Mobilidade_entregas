// import 'dart:convert';
//
// class VehicleTypeModel {
//   final String id;
//   final String image;
//   final bool isActive;
//   final String title;
//   final String persons;
//   final Charges charges;
//
//   VehicleTypeModel({
//     required this.id,
//     required this.image,
//     required this.isActive,
//     required this.title,
//     required this.charges,
//     required this.persons,
//   });
//
//   factory VehicleTypeModel.fromRawJson(String str) => VehicleTypeModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
//         id: json["id"],
//         image: json["image"],
//         isActive: json["isActive"],
//         title: json["title"],
//         charges: json["charges"] == null
//             ? Charges(
//                 fareMinimumChargesWithinKm: "0",
//                 farMinimumCharges: "0",
//                 farePerKm: "0",
//               )
//             : Charges.fromJson(json["charges"]),
//         persons: json["persons"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "image": image,
//         "isActive": isActive,
//         "title": title,
//         "charges": charges.toJson(),
//         "persons": persons,
//       };
// }
//
// class Charges {
//   final String fareMinimumChargesWithinKm;
//   final String farMinimumCharges;
//   final String farePerKm;
//
//   Charges({
//     required this.fareMinimumChargesWithinKm,
//     required this.farMinimumCharges,
//     required this.farePerKm,
//   });
//
//   factory Charges.fromRawJson(String str) => Charges.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Charges.fromJson(Map<String, dynamic> json) => Charges(
//         fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"],
//         farMinimumCharges: json["far_minimum_charges"],
//         farePerKm: json["fare_per_km"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "fare_minimum_charges_within_km": fareMinimumChargesWithinKm,
//         "far_minimum_charges": farMinimumCharges,
//         "fare_per_km": farePerKm,
//       };
// }
import 'dart:convert';

import 'package:customer/app/models/cab_time_slots_charges_model.dart';


class VehicleTypeModel {
  final String id;
  final String image;
  bool? isActive;
  bool? isTimeSlotEnable;
  final String title;
  final String persons;
  final Charges charges;
  List<CabTimeSlotsChargesModel> timeSlots;

  VehicleTypeModel({
    required this.id,
    required this.image,
    required this.isActive,
    required this.title,
    this.isTimeSlotEnable,
    required this.charges,
    required this.persons,
    required this.timeSlots,
  });

  factory VehicleTypeModel.fromRawJson(String str) => VehicleTypeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
    id: json["id"],
    image: json["image"],
    isActive: json["isActive"],
    isTimeSlotEnable: json["isTimeSlotEnable"],
    title: json["title"],
    charges: json["charges"] == null
        ? Charges(
      fareMinimumChargesWithinKm: "0",
      farMinimumCharges: "0",
      farePerKm: "0",
    )
        : Charges.fromJson(json["charges"]),
    persons: json["persons"],
    timeSlots: json["timeSlots"] != null ? (json["timeSlots"] as List<dynamic>).map((e) => CabTimeSlotsChargesModel.fromJson(e)).toList() : [],
    // timeSlots: (json["timeSlots"] as List<dynamic>).map((e) => TimeSlotsChargesModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "isActive": isActive,
    "isTimeSlotEnable": isTimeSlotEnable,
    "title": title,
    "charges": charges.toJson(),
    "persons": persons,
    "timeSlots": timeSlots.map((slot) => slot.toJson()).toList(),
  };
}

class Charges {
  final String fareMinimumChargesWithinKm;
  final String farMinimumCharges;
  final String farePerKm;

  Charges({
    required this.fareMinimumChargesWithinKm,
    required this.farMinimumCharges,
    required this.farePerKm,
  });

  factory Charges.fromRawJson(String str) => Charges.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
    fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"],
    farMinimumCharges: json["far_minimum_charges"],
    farePerKm: json["fare_per_km"],
  );

  Map<String, dynamic> toJson() => {
    "fare_minimum_charges_within_km": fareMinimumChargesWithinKm,
    "far_minimum_charges": farMinimumCharges,
    "fare_per_km": farePerKm,
  };
}
