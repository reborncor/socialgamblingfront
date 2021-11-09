import 'dart:core';



class UserModel{

  String id;
  String username;
  String firstName;
  String lastName;
  String password;
  String email ;
  bool admin;
  String phoneNumber;

  UserModel({ this.id,  this.username,  this.firstName, this.lastName,  this.email,this.admin, this.phoneNumber});

  UserModel.forJson({this.username, this.password, this.firstName, this.lastName, this.email, this.phoneNumber});

  UserModel.jsonData({ this.id,  this.username,  this.firstName, this.lastName,  this.email, this.admin,this.phoneNumber});

  factory UserModel.fromJsonData(Map<String,  dynamic> json){
    return UserModel.jsonData(
      id: json['id'],
      username: json['message'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      admin: json['admin'],
      email: json['email'],
      phoneNumber : json['phoneNumber'],


    );
  }

  Map<String, dynamic> toJson() => {
    "username" : username,
    "password" : password,
    "firstName" : firstName,
    "lastName" : lastName,
    "phoneNumber" :phoneNumber,
    "email":email,
  };



}


