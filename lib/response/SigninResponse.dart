import 'dart:core';





import 'package:socialgamblingfront/model/UserModel.dart';



class SigninReponse{

  int code;
  String message;
  UserModel payload ;
  String token;

  SigninReponse({ this.code,this.message, this.payload, this.token});


  SigninReponse.jsonData({this.code,this.message, this.payload, this.token});

  factory SigninReponse.fromJsonData(Map<String,  dynamic> json){
    return SigninReponse.jsonData(
      code: json['code'],
      message: json['message'],
      payload: UserModel.fromJsonData(json['payload']),
      token: json['token'],
    );
  }

}


