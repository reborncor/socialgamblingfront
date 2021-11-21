import 'dart:core';



class MessageModel{

  String id;
  String senderUsername;
  String receiverUsername;
  String content;
  String time ;

  MessageModel({ this.id,  this.senderUsername, this.receiverUsername, this.content,  this.time});


  MessageModel.jsonData({this.id,  this.senderUsername, this.receiverUsername, this.content,  this.time});

  factory MessageModel.fromJsonData(Map<String,  dynamic> json){
    return MessageModel.jsonData(
      id: json['id'],
      senderUsername: json['senderUsername'],
      receiverUsername: json['receiverUsername'],
      content: json['content'],
      time: json['time'],


    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id ,
      'senderUsername': senderUsername ,
      'receiverUsername': receiverUsername ,
      'content': content ,
      'time': time ,
    };
  }

}


