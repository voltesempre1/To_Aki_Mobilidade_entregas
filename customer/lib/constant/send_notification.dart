import 'dart:convert';
import 'dart:developer';

// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/app/models/notification_model.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:googleapis_auth/auth_io.dart'; // For OAuth 2.0
import 'package:http/http.dart' as http;

class SendNotification {
  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future getCharacters() {
    return http.get(Uri.parse(Constant.jsonFileURL.toString()));
  }

  static Future<String> getAccessToken() async {
    Map<String, dynamic> jsonData = {};

    await getCharacters().then((response) {
      jsonData = json.decode(response.body);
    });
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonData);

    final client = await clientViaServiceAccount(serviceAccountCredentials, _scopes);
    return client.credentials.accessToken.data;
  }

  static Future<void> sendOneNotification({
    required String token,
    required String title,
    required String body,
    required String type,
    required Map<String, dynamic> payload,
    String? bookingId,
    String? driverId,
    String? customerId,
    String? senderId,
    bool isBooking = false,
  }) async {
    NotificationModel notificationModel = NotificationModel();
    if (driverId != null) {
      notificationModel.id = Constant.getUuid();
      notificationModel.type = type;
      notificationModel.title = title;
      notificationModel.description = body;
      notificationModel.bookingId = bookingId;
      notificationModel.customerId = customerId;
      notificationModel.driverId = driverId;
      notificationModel.senderId = senderId;
      notificationModel.createdAt = Timestamp.now();
      await FireStoreUtils.setNotification(notificationModel);
    }

    final String accessToken = await getAccessToken();

    log("_____________________________________________________________________");
    log("token--->$token");
    log("jsonFileURL--->${Constant.jsonFileURL.toString()}");
    log("AccessToken--->$accessToken");
    log("_____________________________________________________________________");

    Map<String, dynamic> mergedPayload = {
      ...bookingId != null ? notificationModel.toNotificationJson() : payload,
      'isBooking': isBooking == true ? 'true' : 'false',
    };

    Map<String, dynamic> message = {
      'token': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': mergedPayload,
    };

    if (isBooking == true) {
      message['android'] = {
        'notification': {
          'sound': 'booking_notification',
          'channel_id': '0',
        },
      };
      message['apns'] = {
        'payload': {
          'aps': {
            'sound': 'booking_notification.caf',
          },
        },
      };
    }

    final response = await http.post(Uri.parse('https://fcm.googleapis.com/v1/projects/${Constant.senderId}/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': message,
        }));
    log("====================>");
    log(response.body);
  }
}
