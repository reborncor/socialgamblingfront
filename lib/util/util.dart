


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/model/CreditCardModel.dart';
import 'package:socialgamblingfront/response/SigninResponse.dart';


final SUCCESS = 0;
final ERROR = 1;
final BAN = 2;
final NOT_CONNECTED = 3;
final toolTipStatutMessage = "Le tableau de statut représente selon le nombre de dens la place que vous occupez dans la hiérarchie. Ainsi à titre indicatif, les couleurs renseignent sur votre statut actuel. Gagnez le plus de dens et fixez vous des objectifs!! ";
setOutlineBorder(borderSide, borderRadius)  {

  return OutlineInputBorder(
    borderSide: BorderSide(width: borderSide, color: Colors.red[700]),
    borderRadius: BorderRadius.circular(borderRadius),
  );

}
BorderRoundedColor(double size, color){
  return OutlineInputBorder(

    // width: 0.0 produces a thin "hairline" border
    borderSide: BorderSide(color: color, width: size),
    borderRadius: BorderRadius.circular(25.0),

  );
}

BaseButtonRoundedColor(double width, double height,color){
  return  ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(width,height)),

      backgroundColor: MaterialStateProperty.all(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: color)
          )
      ));
}
///////////////////////////////////



Future<String> getCurrentUserToken()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.get("token");
  return token;
}

Future<String> getCurrentUserMoney()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String money = sharedPreferences.get("money");
  return money;
}
Future<void> setCurrentUserMoney(int money)async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("money",money.toString());
}


Future<String> getCurrentUserDateOfban()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String dateOfBan = sharedPreferences.get("dateOfBan");
  return dateOfBan;
}


setUserData(String key, data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(key, data);
}

enum StatusPlayer {
  Ecumeur,
  Vicomte,
Comte,
Kid,
Lord,
}

String getUserStatus(int money){

  if(money < 400 ){
    return "Ecumeur";
  }
  else if(money < 800 ){
    return "Vicomte";
  }
  else if(money < 1200 ){
    return "Comte";
  }

  else if(money < 1600 ){
    return "Kid";
  }

  else{
    return "Lord";
  }

}

getUserStatusColors(String status, bool isDarkmode){


  var defaultColor = (isDarkmode) ? Colors.white: Colors.black;
  switch(status.replaceAll(" ", "")){
    case "Ecumeur" : return Colors.amber;
    case "Vicomte" : return Colors.greenAccent;
    case "Comte" : return Colors.blueAccent;
    case "Kid" : return Colors.redAccent;
    case "Lord" : return Colors.black26;
    default : return defaultColor;


  }



}

Future<void> saveUserData(SigninReponse data) async {

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  sharedPreferences.setString("token", data.token);
  sharedPreferences.setString("username", data.payload.username);
  sharedPreferences.setString("money", data.payload.money.toString());
  sharedPreferences.setString("dateOfBan", data.payload.dateOfBan.toString());

}
Future<void> saveNewGame(String gameId) async {

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("gameId",gameId);

}

Future<String> getGameId() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final gameId =sharedPreferences.get("gameId");
  return gameId;

}

Future<void> saveCard(String cardNumber, String expiryDate, String cardHolderName, String cvvCode) async {

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("cardNumber",cardNumber);
  sharedPreferences.setString("expiryDate",expiryDate);
  sharedPreferences.setString("cardHolderName",cardHolderName);
  sharedPreferences.setString("cvvCode",cvvCode);

}

Future<CreditCardModels> getCard() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final cardNumber = sharedPreferences.get("cardNumber");
  final expiryDate =sharedPreferences.get("expiryDate");
  final cardHolderName =sharedPreferences.get("cardHolderName");
  final cvvCode =sharedPreferences.get("cvvCode");

  return CreditCardModels(cvvCode :cvvCode, cardHolderName : cardHolderName, cardNumber : cardNumber, expiryDate : expiryDate);




}

Future<String> getCurrentUsername()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String type = sharedPreferences.get("username");
  return type;
}
deleteInfo() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}


