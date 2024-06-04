import 'package:dev_chat/core/api/firebase_apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RegisterParams {
  String? id;
  String? fullname;
  String? username;
  String? phonenumber;
  String? address;
  String? gender;
  String? email;
  String? password;
  String? confirmPassword;
  String? age;
  String? createdAt;
  String? image;
  String? about;
  String? lastActive;
  bool? isOnline;
  String? pushToken;
  List? followers;

  RegisterParams({
    this.id,
    this.fullname,
    this.username,
    this.phonenumber,
    this.address,
    this.gender,
    this.email,
    this.password,
    this.confirmPassword,
    this.age,
    this.createdAt,
    this.image,
    this.about,
    this.lastActive,
    this.isOnline,
    this.pushToken,
  });

  Map<String, dynamic> toJson() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    AuthHelper authHelper = AuthHelper();
    User user = authHelper.auth.currentUser!;
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = user.uid ?? '';
    data['name'] = fullname ?? '';
    data['username'] = username ?? '';
    data['phone_number'] = phonenumber ?? '';
    data['gender'] = gender?.toLowerCase();
    data['email'] = email ?? '';
    data["address"] = address ?? '';
    data["age"] = age ?? '';
    data["createdAt"] = formattedDate ?? '';
    data["image"] = image ?? '';
    data["about"] = 'Hey there I am using DevChat';
    data["last_active"] = lastActive ?? '';
    data["is_online"] = isOnline ?? true;
    data["push_token"] = pushToken ?? '';
    data["followers"] = followers ?? '';

    return data;
  }
}
