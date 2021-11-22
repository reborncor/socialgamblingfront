import 'dart:core';


import 'package:socialgamblingfront/model/MessageModel.dart';

import 'package:socialgamblingfront/response/BasicResponse.dart';



class OldMessageResponse extends BasicResponse{

  List<MessageModel> oldmessages;

  OldMessageResponse({ this.oldmessages, code, message}): super(code: null, message:null );

  OldMessageResponse.jsonData({this.oldmessages, code, message}) :super(code: code, message: message);

  factory OldMessageResponse.fromJsonData(Map<String,  dynamic> json){
    return OldMessageResponse.jsonData(
      code: json['code'],
      message: json['message'],
      oldmessages: (json['payload']['oldmessages'] as List).map((e) => MessageModel.fromJsonData(e)).toList(),
    );
  }



}


