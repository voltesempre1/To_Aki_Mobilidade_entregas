// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/subscription_model.dart';

class SubscriptionHistoryModel {
  String? id;
  String? driverId;
  SubscriptionModel? subscriptionPlan;
  String? paymentType;
  Timestamp? expiryDate;
  Timestamp? createdAt;

  SubscriptionHistoryModel({this.id, this.driverId, this.expiryDate, this.createdAt, this.subscriptionPlan, this.paymentType});

  SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    expiryDate = json['expiryDate'];
    createdAt = json['createdAt'];
    subscriptionPlan = json['subscriptionPlan'] != null ? SubscriptionModel.fromJson(json['subscriptionPlan']) : SubscriptionModel();
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverId'] = driverId;
    data['expiryDate'] = expiryDate;
    data['createdAt'] = createdAt;
    if (subscriptionPlan != null) {
      data['subscriptionPlan'] = subscriptionPlan!.toJson();
    }
    data['paymentType'] = paymentType;
    return data;
  }
}
