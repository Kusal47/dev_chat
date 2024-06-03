import 'dart:developer';
import 'dart:io';

import 'package:dev_chat/core/widgets/common/loading_dialog.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/firebase_request.dart';
import '../../../core/routes/app_pages.dart';
import '../model/update_params.dart';

class ProfileController extends GetxController {
  final FirebaseRequest _firebaseRequest = FirebaseRequest();
  var user = ChatUserResponseModel().obs;
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  loadUserData() async {
    ChatUserResponseModel? fetchedUser = await _firebaseRequest.getCurrentUserInfo();
    if (fetchedUser != null) {
      user.value = fetchedUser;
      // Future.delayed(const Duration(seconds: 1), () {
      //   loadUserData();
      // });
      print('User Data: ${user.value.toJson()}');
      update();
    }
  }

  Future<void> updateUserData(BuildContext context, UpdateParams updateParams) async {
    try {
      showLoadingDialog(context);
      bool isupdated = await _firebaseRequest.updateUserInfo(updateParams);
      if (isupdated == true) {
        loadUserData();
        hideLoadingDialog(context);
        showSuccessToast('User information updated successfully');
        hideLoadingDialog(context);
      } else {
        showErrorToast('User information update failed');
        hideLoadingDialog(context);
      }

      update();
    } catch (e) {}
  }

  Future<void> pickImage(BuildContext context) async {
    showLoadingDialog(context);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      await _firebaseRequest.updateProfileImage(File(pickedFile.path));
      await loadUserData();
      showSuccessToast('Profile image updated successfully');
      hideLoadingDialog(context);

      log('pickedImage: ${pickedImage?.path}');
      update();
    } else {
      showErrorToast('No image selected');
      hideLoadingDialog(context);
    }
  }
}
