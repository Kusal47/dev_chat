import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String generateJwtToken(String userId) {
  const secretKey = 'm9dmf3myjgs468h9raeduek4h99arh9nmydnr8tcsgnk2fu8sdsphgsuuq2jzmtq';

  // Create a json web token
  final jwt = JWT(
    {
      'user_id': userId,
      'iat': DateTime.now().millisecondsSinceEpoch,
      'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch
    },
  );

  // Sign it with a secret key
  final token = jwt.sign(SecretKey(secretKey));
  return token;
}

String generateUserCallId(String userId) {
  final random = Random();
  final randomString = String.fromCharCodes(
    List.generate(10, (_) => random.nextInt(26) + 65),
  );
  final callId = '$userId$randomString';
  return callId;
}
