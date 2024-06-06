import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/loading_dialog.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  FirebaseRequest request = FirebaseRequest();
  Future<void> resetEmail(BuildContext context, String email) async {
    showLoadingDialog(context);
    bool isSent = await request.resetPassword(email);
    if (isSent == true) {
      showSuccessToast('Check your email to reset your password');
      hideLoadingDialog(context);
      Get.offAllNamed(Routes.login);
    } else {
      showErrorToast('Reset password failed');
      hideLoadingDialog(context);
    }
  }
}
