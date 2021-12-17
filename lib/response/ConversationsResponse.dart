import 'dart:convert';
import 'dart:core';


import 'package:socialgamblingfront/model/ConversationModel.dart';
import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';



class ConversationsResponse extends BasicResponse{

  List<ConversationModel> conversations;

  ConversationsResponse({ this.conversations, int code, String message}): super(code: code, message:message );

  ConversationsResponse.jsonData({this.conversations, int code, String message}) :super(code: code, message: message);

  factory ConversationsResponse.fromJsonData(Map<String,  dynamic> json){
    return ConversationsResponse.jsonData(
      code: json['code'],
      message: json['message'],
      conversations:  (json['payload']['conversations'] as List).map((e) => ConversationModel.fromJsonData(e)).toList(),
    );
  }



}


