class ChatUserResponseModel {
  String? id;
  String? image;
  String? name;
  String? about;
  String? createdAt;
  String? lastActive;
  bool? isOnline;
  String? email;
  String? pushToken;
  String? username;
  String? phonenumber;
  String? address;
  List<String>? followers;

  ChatUserResponseModel({
    this.id,
    this.image,
    this.name,
    this.about,
    this.createdAt,
    this.lastActive,
    this.isOnline,
    this.email,
    this.pushToken,
    this.username,
    this.phonenumber,
    this.address,
    this.followers,
  });

  factory ChatUserResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatUserResponseModel(
      id: json['id'],
      image: json['image'],
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      createdAt: json['created_at'] ?? '',
      lastActive: json['last_active']?.toString() ?? '',
      isOnline: json['is_online'] ?? true,
      email: json['email'] ?? '',
      pushToken: json['push_token'] ?? '',
      username: json['username'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      address: json['address'] ?? '',
      followers: (json['followers'] != null)
          ? List<String>.from(json['followers'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['username'] = username;
    data['phonenumber'] = phonenumber;
    data['address'] = address;
    data['followers'] = followers;
    return data;
  }
}
