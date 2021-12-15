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

  int level;
  double xp ;
  int money ;
  bool isBanned ;
  int dateOfBan ;
  int games ;
  int wins ;

  UserModel({ this.id,  this.username,  this.firstName, this.lastName,  this.email,this.admin, this.phoneNumber});

  UserModel.forJson({this.username, this.password, this.firstName, this.lastName, this.email, this.phoneNumber});

  UserModel.jsonData({ this.id,  this.username,  this.firstName, this.lastName,  this.email, this.admin,this.phoneNumber, this.level,
  this.xp ,
  this.money ,
  this.isBanned ,
  this.dateOfBan ,
  this.games ,
  this.wins ,});

  factory UserModel.fromJsonData(Map<String,  dynamic> json){
    return UserModel.jsonData(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      admin: json['admin'],
      email: json['email'],
      phoneNumber : json['phoneNumber'],
         level: json['level'],
         xp : json['xp'],
         money : json['money'],
         isBanned : json['isBanned'],
         dateOfBan : json['dateOfBan'],
         games : json['games'],
         wins : json['wins'],


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


