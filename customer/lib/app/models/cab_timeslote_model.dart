
class CabTimeSlotModel {
  String id;
  String vehicleTypeId;
  bool isAvailable;
  List<TimeSlotsChargesModelOfCab> timeSlots;

  CabTimeSlotModel({
    required this.id,
    required this.vehicleTypeId,
    required this.isAvailable,
    required this.timeSlots,
  });

  factory CabTimeSlotModel.fromJson(String id, Map<String, dynamic> json) {
    return CabTimeSlotModel(
      id: id,
      isAvailable: json["isAvailable"] ?? false,
      vehicleTypeId: json["vehicleTypeId"]?.toString() ?? "",
      timeSlots: (json["timeSlots"] as List<dynamic>)
          .map((e) => TimeSlotsChargesModelOfCab.fromJson(e))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vehicleTypeId": vehicleTypeId,
      "isAvailable": isAvailable,
      "timeSlots": timeSlots.map((slot) => slot.toJson()).toList(),
    };
  }
}
class TimeSlotsChargesModelOfCab {
  String timeSlot;
  String perKm;
  String minimumCharges;
  String minimumChargeWithKm;

  TimeSlotsChargesModelOfCab({
    required this.timeSlot,
    required this.perKm,
    required this.minimumCharges,
    required this.minimumChargeWithKm,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      "timeSlot": timeSlot,
      "perKm": perKm,
      "minimumCharges": minimumCharges,
      "minimumChargeWithKm": minimumChargeWithKm,
    };
  }

  // Create model from Firestore document
  factory TimeSlotsChargesModelOfCab.fromJson(Map<String, dynamic> json) {
    return TimeSlotsChargesModelOfCab(
      timeSlot: json["timeSlot"] ?? "",
      perKm: json["perKm"]?.toString() ?? "0",
      minimumCharges: json["minimumCharges"]?.toString() ?? "0",
      minimumChargeWithKm: json["minimumChargeWithKm"]?.toString() ?? "0",
    );
  }
}



