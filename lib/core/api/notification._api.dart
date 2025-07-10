import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_access_token.dart';

class NotificationClass {
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  AuthHelper authHelper = AuthHelper();

  final String serverToken = "";

  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission(
      alert: true,
      sound: true,
    );

    await fMessaging.getToken().then((t) {
      if (t != null) {
        if (authHelper.user != null) {
          updatePushTokenInFirestore(authHelper.user!.uid, t);
        }
        log('Push Token: $t');
      }
    });
  }

  Future<void> updatePushTokenInFirestore(String userId, String pushToken) async {
    try {
      await authHelper.storage.collection('chatUsers').doc(userId).update({
        'push_token': pushToken,
      });
      log('Push token updated successfully for user: $userId');
    } catch (e) {
      log('Error updating push token: $e');
      // showErrorToast('Error updating push token');
    }
  }

  Future<void> sendPushNotification(String pushToken, String senderName, String message,
      {String? callId, ChatUserResponseModel? chatUser}) async {
    try {
      final body = {
        "message": {
          "token": pushToken,
          "notification": {
            "title": senderName,
            "body": message,
          },
          "data": {
            "call_id": callId ?? '',
            // 'user':chatUser?.toJson()
          },
        }
      };

      const projectID = 'dev-chat-app-51b93';

      final bearerToken = await NotificationAccessToken.getToken;

      log('bearerToken: $bearerToken');

      if (bearerToken == null) return;

      var response = await Dio().post(
        'https://fcm.googleapis.com/v1/projects/$projectID/messages:send',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
          },
        ),
        data: jsonEncode(body),
      );

      print('Response: ${response.statusCode} ${response.data}');

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.data}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

}
