import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/constants/encryption_services.dart';
import 'package:dev_chat/core/widgets/common/loading_dialog.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:dev_chat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../core/api/token_services.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/widgets/common/toast.dart';
import '../model/message_model.dart';

class ChatController extends GetxController {
  final user=FirebaseAuth.instance.currentUser!;
  @override
  void onInit() {
    super.onInit();
  }

  String token = '';
  String callId = '';

  void generatetoken( String userId) {
    token = generateJwtToken(userId);
    log("Generated values token: $token");
  }

  void generateCallId(String userId) {
    callId = generateUserCallId(userId);
    log("Generated values callId: $callId");
  }

  final TextEditingController messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  List<File> multiImage = [];
  bool isUserMessage = false;
  bool focus = false;

  Future<void> pickGallaryImage(BuildContext context, ChatUserResponseModel user) async {
    final multiImage = await _picker.pickMultiImage(imageQuality: 100, limit: 5);
    if (multiImage.isNotEmpty) {
      for (var element in multiImage) {
        _firebaseRequest.sendChatImage(
          context,
          user,
          File(element.path),
        );
      }

      focus = true;
      update();
    }
  }

  Future<File> pick() async {
    final multiImage = await _picker.pickMultiImage(imageQuality: 100, limit: 5);
    if (multiImage.isNotEmpty) {
      for (var element in multiImage) {
        return File(element.path);
      }

      focus = true;
      update();
    }
    return File('');
  }

  Future<void> clickImage(BuildContext context, ChatUserResponseModel user) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      _firebaseRequest.sendChatImage(
        context,
        user,
        File(pickedFile.path),
      );

      focus = true;
      update();
    }
  }

  List<MessageModel> messagesList = [];
  final FirebaseRequest _firebaseRequest = FirebaseRequest();

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(ChatUserResponseModel user) {
    return _firebaseRequest.getAllMessages(user);
  }

  startACall(ChatUserResponseModel user, String callId) {
    return _firebaseRequest.startCall(user, callId);
  }

  Future<void> sendMessage(ChatUserResponseModel user, String message, Type type) async {
    await _firebaseRequest.sendMessage(user, message, type);
    focus = true;
    messageController.clear();
    update();
  }

  Future<void> deleteMessage(
    BuildContext context,
    MessageModel message,
  ) async {
    showLoadingDialog(context);
    try {
      await _firebaseRequest.deleteMessage(message).then((value) {});
      hideLoadingDialog(context);
    } catch (e) {
      log(e.toString());
      hideLoadingDialog(context);
    }

    update();
  }

  Future<void> editMessage(
    BuildContext context,
    MessageModel message,
    String updateMsg,
  ) async {
    showLoadingDialog(context);
    try {
      final decryptedUpdatedMessage = EncryptionHelper().encryptData(updateMsg);
      await _firebaseRequest.updateMessage(message, decryptedUpdatedMessage);
      hideLoadingDialog(context);
    } catch (e) {
      log(e.toString());
      hideLoadingDialog(context);
    }

    update();
  }

  bool isBlocked = false;

  // void removeUser(BuildContext context, String userId) async {
  //   showLoadingDialog(context);
  //   try {
  //     await _firebaseRequest.removeFromFollowerList(userId);
  //     hideLoadingDialog(context);
  //     Get.offAllNamed(Routes.dashboard);
  //     isBlocked = true;
  //     update();
  //   } catch (e) {}
  // }

  blockedUser(BuildContext context, String userId, bool unblock) async {
    showLoadingDialog(context);
    try {
      if (unblock == false) {
        await _firebaseRequest.removeFromFollowerList(userId);
        await _firebaseRequest.addBlockedUserData(userId);
        showSuccessToast('User has been Blocked');
        hideLoadingDialog(context);
        Get.offAllNamed(Routes.dashboard);
        isBlocked = true;
        update();
      } else {
        await _firebaseRequest.addFollowedUserData(userId);
        await _firebaseRequest.removeFromBlockedList(userId);
        showSuccessToast('User has been Unblocked');
        hideLoadingDialog(context);
        Get.offAllNamed(Routes.blockedUser);
        isBlocked = false;
        update();
      }
    } catch (e) {}
  }

  List<ChatUserResponseModel> blockedList = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedUser() {
    return _firebaseRequest.getBlockedUsersData();
  }

  bool isBlockedUser = false;
  Future<bool> getChatUserBlockedList(String userId) async {
    isBlockedUser = await _firebaseRequest.getChatUserBlockedList(userId);
    update();
    return isBlockedUser;
  }

  // Future<String> getCallId(String userId) async {
  //   return await _firebaseRequest.getCallIdIfUseridExists(userId);
  // }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
