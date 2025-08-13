import 'package:admin/app/models/time_slots_charges_model.dart';

class InterCityTimeModel {
  final String title;
  final List<TimeSlotsChargesModel>? timeZone;

  InterCityTimeModel({this.title = "Intercity", this.timeZone});


  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "timeZone": timeZone?.map((service) => service.toJson()).toList(),
    };
  }

  factory InterCityTimeModel.fromJson(Map<String, dynamic> json) {
    return InterCityTimeModel(
      title: json["title"] ?? "Intercity",
      timeZone: (json["timeZone"] as List<dynamic>?)
          ?.map((service) => TimeSlotsChargesModel.fromJson(service))
          .toList(),
    );
  }
}
