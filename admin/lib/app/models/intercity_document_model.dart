import 'time_slots_charges_model.dart';

class IntercityDocumentModel {
  String id;
  bool isAvailable;
  bool isBidEnable;
  List<TimeSlotsChargesModel> timeSlots;

  IntercityDocumentModel({
    required this.id,
    required this.isAvailable,
    required this.timeSlots,
    required this.isBidEnable,
  });

  factory IntercityDocumentModel.fromJson(String id, Map<String, dynamic> json) {
    return IntercityDocumentModel(
      id: id,
      isBidEnable: json["isBidEnable"] ?? false,
      isAvailable: json["isAvailable"] ?? false,
      timeSlots: (json["timeSlots"] as List<dynamic>)
          .map((e) => TimeSlotsChargesModel.fromJson(e))
          .toList(),
    );
  }
}
