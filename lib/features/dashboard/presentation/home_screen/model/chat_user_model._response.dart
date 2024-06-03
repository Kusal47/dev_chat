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

  ChatUserResponseModel({
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
  });

  ChatUserResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'].toString() ?? '';
    isOnline = json['is_online'] ?? true;
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    username = json['username'] ?? '';
    phonenumber = json['phonenumber'] ?? '';
    address = json['address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    data['username'] = this.username;
    data['phonenumber'] = this.phonenumber;
    data['address'] = this.address;
    return data;
  }
}
