import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

class EncryptionService {
   final key = Key.fromSecureRandom(32);
  final iv = IV.fromSecureRandom(16);

  String encryptMessage(String message) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted.base64;
  }

  String decryptMessage(String encryptedMessage) {
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(encryptedMessage, iv: iv);
    return decrypted;
  }
}
