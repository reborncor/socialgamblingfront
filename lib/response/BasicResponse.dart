import 'dart:convert';
import 'dart:core';



class BasicResponse<T>{

  int code;
  String message;
  T payload ;
  BasicResponse({ this.code,this.message, this.payload});

  BasicResponse.jsonData({this.code,this.message, this.payload});

  factory BasicResponse.fromJsonData(Map<String,  dynamic> json){

    return BasicResponse.jsonData(
      code: json['code'],
      message: json['message'],
      payload: (json['payload']),
    );
  }


}


