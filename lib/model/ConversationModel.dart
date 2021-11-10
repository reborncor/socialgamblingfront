import 'dart:convert';
import 'dart:core';

import 'MessageModel.dart';
import 'MessageModel.dart';



class Conversation{

  String id;
  List<String> members;
  List<MessageModel> chat;

  Conversation({ this.id,  this.members, this.chat});


  Conversation.jsonData({this.id,  this.members, this.chat});

  factory Conversation.fromJsonData(Map<String,  dynamic> json){
    return Conversation.jsonData(
      id: json['id'],
      members: json['members'] as List,
      chat:  (json['chat'] as List).map((e) => MessageModel.fromJsonData(e)).toList(),


    );
  }

}


