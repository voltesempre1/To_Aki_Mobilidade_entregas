import 'dart:convert';


class PersonModel {
  String? name;
  String? mobileNumber;
  String? id;

  PersonModel({
    this.name,
    this.mobileNumber,
    this.id,
  });

  factory PersonModel.fromRawJson(String str) =>
      PersonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
        name: json["name"],
        mobileNumber: json["mobileNumber"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobileNumber": mobileNumber,
        "id": id,
      };
}
