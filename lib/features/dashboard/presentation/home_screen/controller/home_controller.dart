import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/core/api/firebase_request.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:dev_chat/features/chats/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/api/firebase_apis.dart';
import '../model/chat_user_model._response.dart';

class HomeController extends GetxController {
  static FirebaseRequest firebaseRequest = FirebaseRequest();

  @override
  void onInit() {
    super.onInit();
    getUserDatafromfirebase();
    getFollowedUserData();
  }

  bool isSearching = false;
  List<ChatUserResponseModel> searchedUsers = [];
  List<ChatUserResponseModel> userList = [];
  List<ChatUserResponseModel> suggestedUser = [];

  final TextEditingController searchController = TextEditingController();

  var currentIndex = 0;
  changeIndex(int value) {
    currentIndex = value;
    update();
  }

  final AuthHelper authHelper = AuthHelper();
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserDatafromfirebase() {
    return firebaseRequest.getAllUserData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowedUserData() {
    return firebaseRequest.getFollowedUsersData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUserResponseModel user) {
    return firebaseRequest.getLastMessage(user);
  }

  void searchUser(String value, List<ChatUserResponseModel> userList) {
    searchedUsers.clear();
    searchedUsers = [];
    if (value.isEmpty) {
      searchedUsers = [];
      update();
    } else {
      for (var user in userList) {
        if (user.name!.toLowerCase().contains(value.toLowerCase()) ||
            user.email!.toLowerCase().contains(value.toLowerCase())) {
          searchedUsers.add(user);
        }
      }
    }
    update();
  }

  List<String> addedUserIds = [];
  void addUser(String userId) async {
    // if (!addedUserIds.contains(userId)) {
    // addedUserIds.add(userId);
    await firebaseRequest.addFollowedUserData(userId);
    showSuccessToast('User added successfully');
    update();
    // }
  }

  void removeUser(String userId) {
    addedUserIds.remove(userId);
    update();
  }
}
