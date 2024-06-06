import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:dev_chat/core/api/notification._api.dart';
import 'package:dev_chat/core/constants/capitalize_first_letters.dart';
import 'package:dev_chat/core/constants/date_formatter.dart';
import 'package:dev_chat/core/widgets/common/toast.dart';
import 'package:dev_chat/features/auth/register/model/register_param.dart';
import 'package:dev_chat/features/chats/model/message_model.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../features/auth/login/model/login_params.dart';
import '../../features/profile/model/update_params.dart';
import '../constants/encryption_services.dart';
import '../constants/storage_constants.dart';
import '../resources/secure_storage_functions.dart';
import '../widgets/common/loading_dialog.dart';
import 'network_info.dart';

class FirebaseRequest {
  final networkInfo = Get.find<NetworkInfo>();
  final authHelper = Get.find<AuthHelper>();

 Future<User?> loginWithEmailAndPassword(LoginParams loginParams) async {
    if (await networkInfo.isConnected) {
      try {
        UserCredential userCredential = await authHelper.loginUser(
          email: loginParams.email.toString(),
          password: loginParams.password.toString(),
        );
        return userCredential.user;
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code}');
      }
    } else {
      showErrorToast("Network Error");
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(RegisterParams registerParams) async {
    String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    if (await networkInfo.isConnected) {
      try {
        // Create new user
        UserCredential userCredential = await authHelper.auth.createUserWithEmailAndPassword(
          email: registerParams.email!,
          password: registerParams.password!,
        );

        // Store user data in Firestore
        await authHelper.storage
            .collection('chatUsers')
            .doc(userCredential.user?.uid)
            .set(registerParams.toJson());

        return userCredential.user;
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code}');
        switch (e.code) {
          case 'email-already-in-use':
            showErrorToast('The email address is already in use.');
            break;
          // case 'invalid-email':
          //   showErrorToast('The email address is not valid.');
          //   break;
          // case 'operation-not-allowed':
          //   showErrorToast('Email/password accounts are not enabled.');
          //   break;

          default:
            showErrorToast('An unknown error occurred.');
        }
        return null;
      } catch (e) {
        print('Exception: $e');
        showErrorToast('An error occurred during registration.');
        return null;
      }
    } else {
      showErrorToast("Network Error");
      return null;
    }
  }

  Future<GoogleSignInAccount?> signInWithGoogle(BuildContext context) async {
    if (await networkInfo.isConnected) {
      showLoadingDialog(context);

      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          showErrorToast('Google Login Error');
          return null;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await authHelper.auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          final userDoc = await authHelper.storage.collection('chatUsers').doc(user.uid).get();

          if (!userDoc.exists) {
            await authHelper.storage.collection('chatUsers').doc(user.uid).set({
              'name': capitalizeFirstLetters(googleUser.displayName ?? ''),
              'email': googleUser.email,
              'image': googleUser.photoUrl ?? '',
              'about': 'Hey there I am using DevChat',
              'id': user.uid,
              'createdAt': DateTime.now().toString(),
              'last_active': DateTime.now().toString(),
              'is_online': true,
              'push_token': '',
              'username': googleUser.email.split('@').first,
              'gender': '',
              'age': '',
              'address': '',
              'phone_number': '',
              'followers': FieldValue.arrayUnion([]),
            });
          }

          hideLoadingDialog(context);
          return googleUser;
        } else {
          showErrorToast('User is null after sign-in');
        }
      } catch (e) {
        print('Error during Google Sign-In: $e');
        showErrorToast('An error occurred during Google Sign-In. Please try again.');
      } finally {
        hideLoadingDialog(context);
      }
    } else {
      showErrorToast("Network Error");
    }
    return null;
  }

  Future<User?> signInWithFacebook() async {
    if (await networkInfo.isConnected) {
      try {
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final userData = await FacebookAuth.instance.getUserData();
          final AccessToken accessToken = result.accessToken!;
          final AuthCredential credential =
              FacebookAuthProvider.credential(accessToken.tokenString);
          UserCredential userCredential = await authHelper.auth.signInWithCredential(credential);
          return userCredential.user;
        } else if (result.status == LoginStatus.cancelled) {
          showErrorToast('Facebook sign-in cancelled by user.');
        } else if (result.status == LoginStatus.failed) {
          showErrorToast('Facebook sign-in failed.');
        }
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    } else {
      showErrorToast("Network Error");
    }
    return null;
  }
//  Future<UserCredential?> signInWithFacebook() async {
//     if (await networkInfo.isConnected) {
//       try {
//         // Trigger the sign-in flow
//         final LoginResult loginResult = await FacebookAuth.instance.login();

//         // Create a credential from the access token
//         final OAuthCredential facebookAuthCredential =
//             FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

//         // Once signed in, return the UserCredential
//         return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//       } on FirebaseAuthException catch (e) {
//         print(e.message);
//       }
//     } else {
//       showErrorToast("Network Error");
//     }
//     return null;
//   }

  Future<bool> resetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await authHelper.sendPasswordResetLink(email: email);
        return true;
      } on FirebaseAuthException catch (e) {
        print(e.message ?? 'An error occurred');
        return false;
      }
    } else {
      showErrorToast("Network Error");
      return false;
    }
  }

  Future signOut() async {
    if (await networkInfo.isConnected) {
      await authHelper.signOut();
    } else {
      showErrorToast("Network Error");
      return null;
    }
  }

  Future googleSignOut() async {
    if (await networkInfo.isConnected) {
      await authHelper.googleSignOut();
    } else {
      showErrorToast("Network Error");
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserData() async* {
    List<String> followers = await getCurrentUserFollowers();
    User? currentUser = authHelper.auth.currentUser;
    List<String> excludeIds = List.from(followers)..add(currentUser?.uid ?? '');
    if (excludeIds.isNotEmpty) {
      yield* authHelper.storage
          .collection('chatUsers')
          .where(FieldPath.documentId, whereNotIn: excludeIds)
          .snapshots();
    } else {
      yield* const Stream.empty();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowedUsersData() async* {
    if (await networkInfo.isConnected) {
      try {
        List<String> followers = await getCurrentUserFollowers();
        if (followers.isNotEmpty) {
          yield* authHelper.storage
              .collection('chatUsers')
              .where(FieldPath.documentId, whereIn: followers)
              .snapshots();
        } else {
          yield* const Stream.empty();
        }
      } catch (e) {
        print('Error getting followed users: $e');
        yield* const Stream.empty();
      }
    } else {
      showErrorToast("Network Error");
      yield* const Stream.empty();
    }
  }

  Future<List<String>> getCurrentUserFollowers() async {
    User? currentUser = authHelper.auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot =
          await authHelper.storage.collection('chatUsers').doc(currentUser.uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        List<String> followers = List<String>.from(userData['followers'] ?? []);
        return followers;
      }
    }
    return [];
  }

//   Future<List<String>> getCurrentUserFollowers() async {
//   String currentUserId =authHelper.user!.uid;
//   if (currentUserId != null) {
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//         .collection('chatUsers')
//         .doc(currentUserId)
//         .get();
//     if (userSnapshot.exists) {
//       Map<String, dynamic> userData = userSnapshot.data()!;
//       List<String> followers = List<String>.from(userData['followers'] ?? []);
//       return followers;
//     }
//   }
//   return [];
// }

  Future<bool> addFollowedUserData(String userId) async {
    User? currentUser = authHelper.auth.currentUser;
    if (currentUser == null) return false;

    try {
      await authHelper.storage.collection('chatUsers').doc(currentUser.uid).update({
        'followers': FieldValue.arrayUnion([userId])
      });
      return true;
    } catch (e) {
      print('Error adding follower: $e');
      return false;
    }
  }

  // Fetch current user information
  Future<ChatUserResponseModel?> getCurrentUserInfo() async {
    try {
      User? currentUser = authHelper.auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await authHelper.storage.collection('chatUsers').doc(currentUser.uid).get();
        if (userDoc.exists) {
          // await NotificationClass().getFirebaseMessagingToken();
          updateActiveStatus(true);
          return ChatUserResponseModel.fromJson(userDoc.data()!);
        } else {
          showErrorToast('User document does not exist for UID: ${currentUser.uid}');
        }
      } else {
        showErrorToast('No user is currently signed in.');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
    return null;
  }

  // Update current user information
  Future<bool> updateUserInfo(UpdateParams updatedUser) async {
    if (await networkInfo.isConnected) {
      try {
        User? currentUser = authHelper.auth.currentUser;
        if (currentUser != null) {
          await authHelper.storage
              .collection('chatUsers')
              .doc(currentUser.uid)
              .update(updatedUser.toJson());
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print('Error updating user info: $e');
        return false;
      }
    } else {
      showErrorToast("Network Error");
      return false;
    }
  }

  Future<void> updateProfileImage(File file) async {
    if (await networkInfo.isConnected) {
      User? currentUser = authHelper.auth.currentUser;
      final ext = file.path.split('.').last;
      final ref =
          authHelper.firebaseStorage.ref().child("profile_images/${authHelper.user!.uid}.$ext");
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((data) {
        log("Data Transferred: ${data.bytesTransferred / 1000}kb");
      });
      final imageUrl = await ref.getDownloadURL();
      final encryptedImage = EncryptionHelper().encryptData(imageUrl);
      if (currentUser != null) {
        await authHelper.storage
            .collection('chatUsers')
            .doc(currentUser.uid)
            .update({'image': encryptedImage});
      }
    } else {
      showErrorToast('Network Error');
      return;
    }
  }

  // User get user => authHelper.auth.currentUser!;
  String chatId(String id) => authHelper.user!.uid.hashCode <= id.hashCode
      ? '${authHelper.user!.uid}_$id'
      : '${id}_${authHelper.user!.uid}';
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUserResponseModel chatuser) {
    return authHelper.storage
        .collection('chat/${chatId(chatuser.id.toString())}/messages')
        .orderBy('sentTime', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(ChatUserResponseModel chatUser, String msg, Type type) async {
    if (await networkInfo.isConnected) {
      final encryptedMessage = EncryptionHelper().encryptData(msg);

      final time = Timestamp.now();
      final MessageModel message = MessageModel(
          receiver: chatUser.id,
          msg: encryptedMessage,
          read: '',
          type: type,
          sender: authHelper.user!.uid,
          sentTime: time
          );

      final ref = authHelper.storage.collection('chat/${chatId(chatUser.id.toString())}/messages');
      await ref.doc(time.toString()).set(message.toJson()).then((value) async {
        bool? isLogin = chatUser.isOnline;
        if (isLogin == true) {
          ChatUserResponseModel? fetchedUser = await getCurrentUserInfo();

          await NotificationClass().sendPushNotification(
              chatUser.pushToken.toString(), fetchedUser!.name.toString(), msg);
        }
      });
    } else {
      showErrorToast("Network Error");
      return;
    }
  }

  Future<void> updateMessageReadStatus(MessageModel message) async {
    final time = Timestamp.now();

    authHelper.storage
        .collection('chat/${chatId(message.receiver.toString())}/messages')
        .doc(message.sentTime.toString())
        .update({'read': time});
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    authHelper.storage.collection('chatUsers').doc(authHelper.user!.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'push_token': user?.pushToken,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUserResponseModel chatUser) {
    return authHelper.storage
        .collection('chatUsers')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUserResponseModel user) {
    return authHelper.storage
        .collection('chat/${chatId(user.id.toString())}/messages')
        .orderBy('sentTime', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> sendChatImage(
      BuildContext context, ChatUserResponseModel chatUser, File file) async {
    if (await networkInfo.isConnected) {
      showLoadingDialog(context);
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final ext = file.path.split('.').last;

      final ref = authHelper.firebaseStorage
          .ref()
          .child('images/${chatId(chatUser.id.toString())}/$time.$ext');

      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      });
      final imageUrl = await ref.getDownloadURL();
      await sendMessage(chatUser, imageUrl, Type.image);
      hideLoadingDialog(context);
    } else {
      showErrorToast('Network Error');
      hideLoadingDialog(context);
    }
  }

  //delete message
  Future<void> deleteMessage(MessageModel message) async {
    await authHelper.storage
        .collection('chat/${chatId(message.receiver.toString())}/messages')
        .doc(message.sentTime.toString())
        .delete();

    if (message.type == Type.image) {
      final imageUrldecrypt = EncryptionHelper().decryptData(message.msg.toString());
      await authHelper.firebaseStorage.refFromURL(imageUrldecrypt).delete();
    }
  }

  //update message
  Future<void> updateMessage(MessageModel message, String updatedMsg) async {
    await authHelper.storage
        .collection('chat/${chatId(message.receiver.toString())}/messages')
        .doc(message.sentTime.toString())
        .update({'msg': updatedMsg});
  }

//   FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//   Future<void> getFirebaseMessagingToken() async {
//     await fMessaging.requestPermission();

//     await fMessaging.getToken().then((t) {
//       if (t != null) {
//     updatePushTokenInFirestore(authHelper.user!.uid, t);
//         log('Push Token: $t');
//       }
//     });
//   }
//   Future<void> updatePushTokenInFirestore(String userId, String pushToken) async {
//   try {
//     await authHelper.storage.collection('chatUsers').doc(userId).update({
//       'push_token': pushToken,
//     });
//     log('Push token updated successfully for user: $userId');
//   } catch (e) {
//     log('Error updating push token: $e');
//     // showErrorToast('Error updating push token');
//   }
// }
}
