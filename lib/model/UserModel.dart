import 'dart:core';



class UserModel{

  String id;
  String username;
  String firstName;
  String lastName;
  String email ;
  bool admin;

  UserModel({ this.id,  this.username,  this.firstName, this.lastName,  this.email,this.admin});

  UserModel.jsonData({ this.id,  this.username,  this.firstName, this.lastName,  this.email, this.admin});

  factory UserModel.fromJsonData(Map<String,  dynamic> json){
    return UserModel.jsonData(
      id: json['id'],
      username: json['message'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      admin: json['admin'],
      email: json['email'],


    );
  }



}


