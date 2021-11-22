import 'dart:core';



class FriendModel{

  String id;
  String username;
  bool confirmed;

  FriendModel({ this.id,  this.username, this.confirmed});

  FriendModel.jsonData({ this.id,  this.username, this.confirmed});

  factory FriendModel.fromJsonData(Map<String,  dynamic> json){
    return FriendModel.jsonData(
      id: json['id'],
      username: json['username'],
      confirmed: json['confirmed'],

    );
  }



}


