
class TimeSlotsChargesModel {
  String id;
  bool isAvailable;
  bool isBidEnable;
  List<ChargesModel> timeSlots;

  TimeSlotsChargesModel({
    required this.id,
    required this.isAvailable,
    required this.timeSlots,
    required this.isBidEnable,
  });

  factory TimeSlotsChargesModel.fromJson(String id, Map<String, dynamic> json) {
    return TimeSlotsChargesModel(
      id: id,
      isAvailable: json["isAvailable"] ?? false,
      isBidEnable: json["isBidEnable"] ?? false,
      timeSlots: (json["timeSlots"] as List<dynamic>)
          .map((e) => ChargesModel.fromJson(e))
          .toList(),
    );
  }
}

class ChargesModel {
  String timeSlot;
  String fareMinimumChargesWithinKm;
  String farMinimumCharges;
  String farePerKm;

  ChargesModel({
    required this.timeSlot,
    required this.fareMinimumChargesWithinKm,
    required this.farMinimumCharges,
    required this.farePerKm,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      "timeSlot": timeSlot,
      "fare_minimum_charges_within_km": fareMinimumChargesWithinKm,
      "farMinimumCharges": farMinimumCharges,
      "farePerKm": farePerKm,
    };
  }

  factory ChargesModel.fromJson(Map<String, dynamic> json) {
    return ChargesModel(
      timeSlot: json["timeSlot"] ?? "",
      fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"]?.toString() ?? "0",
      farMinimumCharges: json["farMinimumCharges"]?.toString() ?? "0",
      farePerKm: json["farePerKm"]?.toString() ?? "0",
    );
  }
}
