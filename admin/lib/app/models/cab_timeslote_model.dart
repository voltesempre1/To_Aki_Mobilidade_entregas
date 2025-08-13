import 'time_slots_charges_model.dart';

class CabTimeSlotModel {
  String id;
  String vehicleTypeId;
  bool isAvailable;
  List<TimeSlotsChargesModel> timeSlots;

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
          .map((e) => TimeSlotsChargesModel.fromJson(e))
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


