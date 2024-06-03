import 'dart:math';

import 'package:dev_chat/features/auth/login/model/login_params.dart';
import 'package:dev_chat/features/auth/register/model/register_param.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/api/firebase_request.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/resources/secure_storage_functions.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../core/widgets/common/loading_dialog.dart';
import '../../../../core/widgets/common/toast.dart';

class RegisterController extends GetxController {
  FirebaseRequest request = FirebaseRequest();
  SecureStorageService secureStorageService = SecureStorageService();

  void userRegistration(BuildContext context, RegisterParams registerParams) async {
    try {
      showLoadingDialog(context);
      var user = await request.createUserWithEmailAndPassword(registerParams);

      if (user != null) {
        showSuccessToast('Signup Successfull');

        Get.offAllNamed(Routes.dashboard);
      } else {
        hideLoadingDialog(context);
        showErrorToast('An error occurred during registration');
        return;
      }
    } catch (e) {
      hideLoadingDialog(context);
      showErrorToast('An error occurred during registration');
      return;
    }
  }
}
