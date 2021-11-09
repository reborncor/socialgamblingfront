import 'dart:core';



class MessageModel{

  String id;
  String senderId;
  String receiverId;
  String content;
  String time ;

  MessageModel({ this.id,  this.senderId,  this.receiverId, this.content,  this.time});


  MessageModel.jsonData({this.id,  this.senderId,  this.receiverId, this.content,  this.time});

  factory MessageModel.fromJsonData(Map<String,  dynamic> json){
    return MessageModel.jsonData(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      time: json['id'],


    );
  }

}


