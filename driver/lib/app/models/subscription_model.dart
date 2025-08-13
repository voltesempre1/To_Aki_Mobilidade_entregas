// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  String? id;
  String? title;
  String? description;
  String? price;
  String? type;
  String? expireDays;
  Timestamp? createdAt;
  SubscriptionFeatures? features;
  bool? isEnable;

  SubscriptionModel({this.id, this.title, this.description, this.price, this.type, this.expireDays, this.createdAt, this.features, this.isEnable});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    type = json['type'];
    expireDays = json['expireDays'];
    createdAt = json['createdAt'];
    features = json['features'] != null ? SubscriptionFeatures.fromJson(json['features']) : SubscriptionFeatures();
    isEnable = json['isEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['type'] = type;
    data['expireDays'] = expireDays;
    data['createdAt'] = createdAt;
    if (features != null) {
      data['features'] = features!.toJson();
    }
    data['isEnable'] = isEnable;
    return data;
  }
}

class SubscriptionFeatures {
  String? bookings;

  SubscriptionFeatures({
    this.bookings,
  });

  SubscriptionFeatures.fromJson(Map<String, dynamic> json) {
    bookings = json['bookings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookings'] = bookings;
    return data;
  }
}
