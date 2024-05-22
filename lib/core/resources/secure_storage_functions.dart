import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  // Future<void> saveUserData(User user) async {
  //   try {
  //     String userDataJson = json.encode(user.toJson());

  //     await deleteSecureData(StorageConstants.saveUserData);

  //     await writeSecureData(StorageConstants.saveUserData, userDataJson);
  //   } catch (e) {
  //     print("Error while saving user data: $e");
  //   }
  // }

  // Future<User>? getUserData() async {
  //   try {
  //     String? userData = await readSecureData(StorageConstants.saveUserData);
  //     if (userData != null) {
  //       Map<String, dynamic> userDataMap = json.decode(userData);
  //       return User.fromJson(userDataMap);
  //     } else {
  //       return User();
  //     }
  //   } catch (e) {
  //     print("Error while decoding user data: $e");
  //     return User();
  //   }
  // }
}
