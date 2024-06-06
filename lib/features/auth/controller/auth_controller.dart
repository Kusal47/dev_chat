import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/storage_constants.dart';
import '../../../core/resources/secure_storage_functions.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/widgets/common/loading_dialog.dart';
import '../../../core/widgets/common/toast.dart';

class AuthController extends GetxController {
  final FirebaseRequest firebaseRequest = FirebaseRequest();

  SecureStorageService secureStorageService = SecureStorageService();
// Check if user is logged in
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<bool> isLogin() async {
    if (isLoggedIn()) {
      return true;
    } else {
      return false;
    }
  }

  // void logout() async {
  //   await secureStorageService.deleteSecureData(StorageConstants.accessToken);

  //   Get.offNamedUntil(Routes.login, (route) => false);
  // }




  void logout(BuildContext context) async {
    showLoadingDialog(context);
    await firebaseRequest.signOut();
    await firebaseRequest.googleSignOut();

    hideLoadingDialog(context);

    await secureStorageService.deleteSecureData(StorageConstants.accessToken);
    await secureStorageService.deleteSecureData(StorageConstants.saveUserData);
    await secureStorageService.deleteSecureData(StorageConstants.userEmail);

    Get.offAllNamed(Routes.login);

    showSuccessToast("Logout Successfull !!");
  }
}
