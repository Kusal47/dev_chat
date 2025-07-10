import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;
  final projectId = dotenv.env['PROJECT_ID'];
  final privateKey = dotenv.env['PRIVATE_KEY'];
  final clientEmail = dotenv.env['CLIENT_EMAIL'];

  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope = 'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": dotenv.env['PROJECT_ID'],
          "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
          "private_key": dotenv.env['PRIVATE_KEY'],
          "client_email": dotenv.env['CLIENT_EMAIL'],
          "client_id": dotenv.env['CLIENT_ID'],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/${Uri.encodeComponent(dotenv.env['CLIENT_EMAIL']!)}",
          "universe_domain": "googleapis.com",
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
