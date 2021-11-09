import 'dart:convert';
import 'dart:core';


import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';



class FriendsResponse extends BasicResponse{

  List<FriendModel> friends;

  FriendsResponse({ this.friends});

  FriendsResponse.jsonData({this.friends, code, message}) :super(code: code, message: message);

  factory FriendsResponse.fromJsonData(Map<String,  dynamic> json){
    return FriendsResponse.jsonData(
      code: json['code'],
      message: json['message'],
      friends:  (json['payload']['friends'] as List).map((e) => FriendModel.fromJsonData(e)).toList(),
    );
  }

}


