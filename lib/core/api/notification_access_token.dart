import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope = 'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "dev-chat-app-51b93",
          "private_key_id": "cbdcb302be4323340887d00c96358ea0513e209b",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD1SNrnLCZ7Bvf0\nYN3PsiVOir1AtERooJ1ej20nxHpabi/RljgIWgYQoPMhgxnPiqq72un6aF6WQrbZ\nkg3ucHtTnLBp7ZdWszY1okWJYhivimbjv5G6JjKwEp5bWehPxkuB7ovqQkctZF8V\ncAHsMwovurcIR4ZMY2iVKN8biOp+up5EUq+/Wi1xWfbR4Fx/N5tFL7FCqoMvp393\nmepRFhbqUne2XIAXQMBuiEbeWA7tU86XluCW7fpOLHfu/zt0dFEJaW0Xz3CrmBb2\nkaJlJ5/FD5PLCK29nvgrXJnj2Kbkj8spfT8crV8O2zywN0hietKGtjhjaaadrR9x\nKgdWhQTjAgMBAAECggEANsDwKJmI736jPBihexsby9gZngd/m9F6v6CJr85it6wQ\nHZuIX4jlALJFA86VpOgh67RW9bB1qNo0ogXB+V9/kC8SjFrepRp1N+zE1AGjXBAr\nnpxlZeXf+8D0O5Uq0CAGO/dpoT3xUJcuyITL0ROlqvjlocIBnyyzrFRG1YkvO2Fy\nUVNuUonW4st6SjPdLywkmWi25DZn+eotjABJQKH1sOerM2JHKNzKYqnzOTIdxRQG\nwjPOYIOYRUC1h88jTjRsbSEKDgf7Tw36KatXYbsPDi7fKE5G0+GiUOYDzTlXGDxT\nvV0S0KXe5WzZAcH1v0J1Ia+hKk0w3N6u8PGOY8nyhQKBgQD8GHPqoy82QptqvHX2\n8eO/M1cwlx42Us5xkH4j2If73TUpzLEuUxAYtkzRNvpyEJBFrGnRm51ORG69R9AQ\nnK0TCu3ePy/X/DsgaAt6DikFzIYoQbqlFKVi4Qf/nHePi8DZOKu4r8fVdums6cCU\nbn6aNjDsMo529YZcoFBqScy/hQKBgQD5FWWziG49ycutuxnlIIgAZ74Fg6L5uoVm\ny0MOS+lmhH6NdYVNY6HOsMNboWAHN5qmy0QBxe9s+8TEeDkYkWuE+japYcvshYSu\niZkZZzwLNe7UM+3L3bwY7Nh6wldq4GQh3efKED7Z3VBNQpe26lBCoujecGNwOge0\nKsJndAt7RwKBgQCvCkeKVy5T7aG+VgdOpRwuyXYz3enzbEG95sc/Gn0pK6pbUK6B\n7NjTX9kst5DkHI4gYpvDF9r82lVOBgv5TOB7xW3ukE8nGBLx6Gx3nldrmFxanXD8\naL6BTqDgIgN+X1pTOZ86iIsns/6CunemWKZ9az1C88Op48ccj4/mjUGmhQKBgE5R\n8xObn4ZgMGIlRcQtEXaHKFHVjWZWxuGGokQZjH9GxAA45rxpypQSMqtaN7atPjya\nB31DPsCW/c0FPHbEKvm6L3vdG2D4rrqu22wIcPHZeIpS9b+3rhBsULlw6Enb2sBn\nZR29M/YPR9OzT78dODVrwitHTY0ZQhjdpRkgfQe7AoGBAI2w9xNt/6++JMkR1vij\nws75il5MT+tcXdQryAB1u50l+wyCCnGgYcY+YMccs6hllKwcww6xwfd6JJQIy3g2\nOfMMoB2XO+oFuanzVC2KZSCP0jk6VvI1wXP/H0mhCncUfpvkXjC89VxIRhZENa9l\nyUYC/Ded0/UmVEwGiVSA8nEQ\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-iyfg0@dev-chat-app-51b93.iam.gserviceaccount.com",
          "client_id": "110301071305887812995",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-iyfg0%40dev-chat-app-51b93.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
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
