import 'dart:core';
import 'package:socialgamblingfront/model/PGameModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';



class PGameResponse extends BasicResponse{

  PGameModel game;

  PGameResponse({ this.game, int code, String message}) : super(code: code, message:message );

  PGameResponse.jsonData({this.game, code, message}) :super(code: code, message: message);

  factory PGameResponse.fromJsonData(Map<String,  dynamic> json){
    return PGameResponse.jsonData(
      code: json['code'],
      message: json['message'],
      game: PGameModel.fromJsonData( json['payload']['game']),
    );
  }


}


