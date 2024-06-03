class UserModel {
  String? lastLogin;
  String? createdAt;
  String? password;
  String? address;
  String? gender;
  String? phone;
  String? name;
  String? age;
  String? email;
  String? username;

  UserModel(
      {this.lastLogin,
      this.createdAt,
      this.password,
      this.address,
      this.gender,
      this.phone,
      this.name,
      this.age,
      this.email,
      this.username});

  UserModel.fromJson(Map<String, dynamic> json) {
    lastLogin = json['lastLogin'] ?? "";
    createdAt = json['createdAt'] ?? "";
    password = json['password'] ?? "";
    address = json['address'] ?? "";
    gender = json['gender'];
    phone = json['phone'] ?? "";
    name = json['name'] ?? "";
    age = json['age'] ?? "";
    email = json['email'] ?? "";
    username = json['username'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastLogin'] = lastLogin;
    data['createdAt'] = createdAt;
    data['password'] = password;
    data['address'] = address;
    data['gender'] = gender;
    data['phone'] = phone;
    data['name'] = name;
    data['age'] = age;
    data['email'] = email;
    data['username'] = username;
    return data;
  }
}
