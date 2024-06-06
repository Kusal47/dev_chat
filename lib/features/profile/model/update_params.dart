class UpdateParams {
  String? name;
  String? about;
  String? email;
  String? username;

  UpdateParams({this.name, this.about, this.email,this.username});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['about'] = this.about;
    data['email'] = this.email;
    data['username'] = this.username;
    return data;
  }
}
