// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionLogModel {
  String? id;
  Timestamp? createdAt;
  String? type;
  String? transactionId;
  bool? isCredit;
  String? userId;
  String? paymentType;
  String? amount;
  dynamic transactionLog;

  TransactionLogModel(
      {this.createdAt, this.type, this.transactionId, this.paymentType, this.isCredit, this.userId, this.transactionLog, this.id, this.amount});

  TransactionLogModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    type = json['type'];
    transactionId = json['transactionId'];
    isCredit = json['isCredit'];
    userId = json['userId'];
    transactionLog = json['transactionLog'];
    id = json['id'];
    amount = json['amount'];
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['type'] = type;
    data['transactionId'] = transactionId;
    data['isCredit'] = isCredit;
    data['userId'] = userId;
    data['transactionLog'] = transactionLog;
    data['id'] = id;
    data['amount'] = amount;
    data['paymentType'] = paymentType;
    return data;
  }
}
