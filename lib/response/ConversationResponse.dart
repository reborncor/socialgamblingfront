import 'dart:core';


import 'package:socialgamblingfront/model/ConversationModel.dart';

import 'package:socialgamblingfront/response/BasicResponse.dart';



class ConversationResponse extends BasicResponse{

  ConversationModel conversation;

  ConversationResponse({ this.conversation, code, message}): super(code: code, message:code );

  ConversationResponse.jsonData({this.conversation, code, message}) :super(code: code, message: message);

  factory ConversationResponse.fromJsonData(Map<String,  dynamic> json){
    return ConversationResponse.jsonData(
      code: json['code'],
      message: json['message'],
      conversation: ConversationModel.fromJsonData( json['payload']['conversation']),
    );
  }



}


