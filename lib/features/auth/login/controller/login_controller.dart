import 'dart:math';

import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/loading_dialog.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:dev_chat/features/auth/login/model/login_params.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/storage_constants.dart';
import '../../../../core/resources/secure_storage_functions.dart';
import '../model/login_response_model.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  FirebaseRequest request = FirebaseRequest();
  UserResponseModel userResponseModel = UserResponseModel();
  SecureStorageService secureStorageService = SecureStorageService();

  void userLogin(BuildContext context, LoginParams loginParams) async {
    try {
      showLoadingDialog(context);
      var user = await request.loginWithEmailAndPassword(loginParams);

      if (user != null) {
        showSuccessToast('Login Successfull');
        Get.offAllNamed(Routes.dashboard);
      } else {
        hideLoadingDialog(context);
        showErrorToast('Invalid email or password');
      }
    } catch (e) {
      hideLoadingDialog(context);
      showErrorToast('An error occurred during login');
    }
  }

  void googleLogin(BuildContext context) async {
    try {
      showLoadingDialog(context);
      var user = await request.signInWithGoogle(context);

      if (user != null) {
        showSuccessToast('Login Successfull');
        Get.offAllNamed(Routes.dashboard);
      } else {
        showErrorToast(
          'Google sign-in failed',
        );
        hideLoadingDialog(context);
      }
    } catch (e) {
      hideLoadingDialog(context);
      print(
        'An error occurred during Google sign-in',
      );
    }
  }

  void facebookLogin(BuildContext context) async {
    try {
      showLoadingDialog(context);
      var user = await request.signInWithFacebook();

      if (user != null) {
        showSuccessToast('Login Successfull');
        Get.offAllNamed(Routes.dashboard);
      } else {
        hideLoadingDialog(context);
        showErrorToast(
          'Facebook sign-in failed',
        );
      }
    } catch (e) {
      hideLoadingDialog(context);
      showErrorToast(
        'An error occurred during Facebook sign-in',
      );
    }
  }
}
