class   CabTimeSlotsChargesModel {
  String timeSlot;
  String fareMinimumChargesWithinKm;
  String farMinimumCharges;
  String farePerKm;

  CabTimeSlotsChargesModel({
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

  factory CabTimeSlotsChargesModel.fromJson(Map<String, dynamic> json) {
    return CabTimeSlotsChargesModel(
      timeSlot: json["timeSlot"] ?? "",
      fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"]?.toString() ?? "0",
      farMinimumCharges: json["farMinimumCharges"]?.toString() ?? "0",
      farePerKm: json["farePerKm"]?.toString() ?? "0",
    );
  }
}
