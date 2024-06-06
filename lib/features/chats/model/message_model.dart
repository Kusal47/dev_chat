import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({
    this.receiver,
    this.msg,
    this.read,
    this.type,
    this.sender,
    this.sentTime,
    // this.callStatus
  });

  String? receiver;
  String? msg;
  String? read;
  String? sender;
  Timestamp? sentTime;
  Type? type;
  // bool? callStatus;

  MessageModel.fromJson(Map<String, dynamic> json) {
    receiver = json['receiver'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sender = json['sender'].toString();
    sentTime = json['sentTime'];
    // callStatus = json['callStatus'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['receiver'] = receiver;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type?.name;
    data['sender'] = sender;
    data['sentTime'] = sentTime;
    // data['callStatus'] = callStatus;
    return data;
  }
}

enum Type { text, image }
