class LoginParams {
  String? email;
  String? password;
  String? phoneNumber;

  LoginParams({this.email, this.password, this.phoneNumber});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (email != null) {
      data['email'] = email;
    } else {
      data['number'] = phoneNumber;
    }
    data['password'] = password;
    return data;
  }


  // Create a LoginParams object from a JSON map
  factory LoginParams.fromJson(Map<String, dynamic> json) {
    return LoginParams(
      email: json['email'],
      password: json['password'],
    );
  }
}
