import 'dart:core';


import 'package:socialgamblingfront/model/ConversationModel.dart';
import 'package:socialgamblingfront/model/UserModel.dart';

import 'package:socialgamblingfront/response/BasicResponse.dart';



class UserResponse extends BasicResponse{

  UserModel user;

  UserResponse({ this.user, code, message}): super(code: code, message:message );

  UserResponse.jsonData({this.user, code, message}) :super(code: code, message: message);

  factory UserResponse.fromJsonData(Map<String,  dynamic> json){
    return UserResponse.jsonData(
      code: json['code'],
      message: json['message'],
      user: UserModel.fromJsonData( json['payload']['currentuser']),
    );
  }



}


