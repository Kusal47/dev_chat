// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../core/widgets/custom/image_picker_function.dart';

// class ChatController extends GetxController {
//   final TextEditingController messageController = TextEditingController();

//   final List<Map<String, dynamic>> messages = [
//     {'isUserMessage': true, 'message': 'Hello!'},
//     {'isUserMessage': false, 'message': 'Hi there!'}
//   ];

//   void chatUpdate(String message) {
//     messages.add({'isUserMessage': true, 'message': message});
//     messageController.clear();
//     update();
//   }

//   void reset() {
//     messageController.clear();
//   }

//   File pickedImage = File('');
//   String? trimmedImage;
//   ImagePicker imagePicker = ImagePicker();
//   Future<void> pickImage(BuildContext context) async {
//     File? pickedImageFile = await uploadImageFromGallery(context, ImageSource.gallery);
//     if (pickedImageFile != null) {
//       trimmedImage = await imageFileToBase64(pickedImageFile);
//       pickedImage = File('');
//       pickedImage = File(pickedImageFile.path);
//       update();
//     } else {
//       pickedImage = File('');
//       // Get.back();
//       return;
//     }
//   }

//   @override
//   void dispose() {
//     messageController.dispose();
//     super.dispose();
//   }
// }
// Future<String?> imageFileToBase64(File imageFile) async {
//   if (imageFile == null) return null;

//   // Read the file as bytes
//   List<int> imageBytes = await imageFile.readAsBytes();

//   // Convert bytes to base64 string
//   String base64Image = base64Encode(imageBytes);

//   return base64Image;
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/message_model.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  List<File> multiImage = [];
  bool isUserMessage = false;
  bool focus = false;

  // final List<Map<String, dynamic>> messages = [
  //   {'isUserMessage': true, 'message': 'Hello!', 'isImage': false},
  //   {'isUserMessage': false, 'message': 'Hi there!', 'isImage': false},
  // ];

  // void chatUpdate(String message) {
  //   if (message.isNotEmpty) {
  //     messages.add({'isUserMessage': true, 'message': message, 'isImage': false});
  //     messageController.clear();
  //     update();
  //   }
  // }

  Future<void> pickGallaryImage(ChatUserResponseModel user) async {
    final multiImage = await _picker.pickMultiImage(imageQuality: 100, limit: 5);
    if (multiImage.isNotEmpty) {
      for (var element in multiImage) {
        _firebaseRequest.sendChatImage(
          user,
          File(element.path),
        );
      }
      // messages.add({
      //   'isUserMessage': true,
      //   'message': pickedImage,
      //   'isImage': true,
      // });

      focus = true;
      update();
    }
  }

  Future<void> clickImage(ChatUserResponseModel user) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      _firebaseRequest.sendChatImage(
        user,
        File(pickedFile.path),
      );
      // messages.add({
      //   'isUserMessage': true,
      //   'message': pickedImage,
      //   'isImage': true,
      // });
      focus = true;
      update();
    }
  }

  List<MessageModel> messagesList = [];
  @override
  FirebaseRequest _firebaseRequest = FirebaseRequest();

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(ChatUserResponseModel user) {
    return _firebaseRequest.getAllMessages(user);
  }

  Future<void> sendMessage(ChatUserResponseModel user, String message, Type type) async {
    await _firebaseRequest.sendMessage(user, message, type);
    focus = true;
    messageController.clear();
    update();
  }

  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
