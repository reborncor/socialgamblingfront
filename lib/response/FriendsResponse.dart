import 'dart:core';

import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';



class FriendsResponse extends BasicResponse{

  List<FriendModel> friends;

  FriendsResponse({ this.friends, int code, String message}) : super(code: code, message:message );

  FriendsResponse.jsonData({this.friends, code, message}) :super(code: code, message: message);

  factory FriendsResponse.fromJsonData(Map<String,  dynamic> json){
    return FriendsResponse.jsonData(
      code: json['code'],
      message: json['message'],
      friends:  (json['payload']['friends'] as List).map((e) => FriendModel.fromJsonData(e)).toList(),
    );
  }

  factory FriendsResponse.fromJsonDataInvitaions(Map<String,  dynamic> json){
    return FriendsResponse.jsonData(
      code: json['code'],
      message: json['message'],
      friends:  (json['payload']['invitations'] as List).map((e) => FriendModel.fromJsonData(e)).toList(),
    );
  }


}


