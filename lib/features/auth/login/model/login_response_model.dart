import 'dart:math';

class UserResponseModel {
  UserModel? user;
  String? token;

  UserResponseModel({this.user, this.token});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    token = Random().nextInt(1000000).toString();
  }
}

class UserModel {
  int? id;
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

  UserModel({
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
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    phonenumber = json['phone_number'];
    address = json['address'];
    gender = json['gender'];
    email = json['email'];
    password = json['password'];
    age = json['age'];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']).toString() : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fullname;
    data['username'] = username;
    data['phone_number'] = phonenumber;
    data['address'] = address;
    data['gender'] = gender?.toLowerCase();
    data['email'] = email;
    data['password'] = password;
    data["address"] = address;
    data["age"] = age;
    data["createdAt"] = createdAt;
    return data;
  }
}
