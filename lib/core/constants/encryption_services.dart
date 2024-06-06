import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;

class EncryptionHelper {
  final key = enc.Key.fromUtf8('devchatD5esh1345');
  final iv = enc.IV.fromUtf8('devchatD5esh1345');

  String encryptData(String text) {
    try {
      final encrypter = enc.Encrypter(enc.AES(key));
      final encrypted = encrypter.encrypt(text, iv: iv);
      return encrypted.base64;
    } catch (e) {
      return e.toString();
    }
  }

  String decryptData(String chipherText) {
    try {
      final decrypter = enc.Encrypter(enc.AES(key));
      final decrypted = decrypter.decryptBytes(enc.Encrypted.from64(chipherText), iv: iv);
      return utf8.decode(decrypted);
    } catch (e) {
      return e.toString();
    }
  }
}

Uint8List stringToUint8List(String str) {
  return Uint8List.fromList(utf8.encode(str));
}

String uint8ListToString(Uint8List uint8list) {
  return utf8.decode(uint8list);
}
