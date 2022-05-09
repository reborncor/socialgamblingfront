


import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/model/CreditCardModel.dart';
import 'package:socialgamblingfront/response/SigninResponse.dart';
import 'package:socialgamblingfront/socketService/SocketService.dart';
import 'package:store_redirect/store_redirect.dart';


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

  writeToken(data.token);


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
deleteInfo(String username) async{
  socketService.onDisconnect(username);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}



Future<String> createFolderInAppDocDir(String folderName) async {

  //Get this App Document Directory
  // final Directory _appDocDir = await getApplicationDocumentsDirectory();
  final Directory _appDocDirExtern = await getExternalStorageDirectory();
  // print(_appDocDir);
  print(_appDocDirExtern);


  //App Document Directory + folder name
  final Directory _appDocDirFolder =  Directory('${_appDocDirExtern.path}/$folderName');

  if(await _appDocDirFolder.exists()){ //if folder already exists return path
    return _appDocDirFolder.path;
  }else{//if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}
Future<File> get _localFile async {
  final path = await createFolderInAppDocDir("bloden");
  return File('$path/data.txt');
}

Future<File> get createFileToken async {
  final path = await createFolderInAppDocDir("bloden");
  return File('$path/token.txt');
}

Future<File> get createFileGameId async {
  final path = await createFolderInAppDocDir("bloden");
  return File('$path/game.txt');
}

Future<File> writeData(String data) async {
  final file = await _localFile;
  try{
    file.delete();
  }catch(e){
  }
  final newFile = await _localFile;
  // Write the file

  return newFile.writeAsString(data, mode: FileMode.write);
}

Future<File> writeToken(String data) async {
  final file = await createFileToken;
  try{
    file.delete();
  }catch(e){
  }
  final newFile = await createFileToken;
  // Write the file

  return newFile.writeAsString(data, mode: FileMode.write);
}
Future<File> writeGame(String data) async {
  final file = await createFileGameId;
  try{
    file.delete();
  }catch(e){
  }
  final newFile = await createFileGameId;
  // Write the file

  return newFile.writeAsString(data, mode: FileMode.write);
}


showSnackBar(context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message),duration:  Duration(milliseconds: 1500)),
  );
}


showSnackBarButton(context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), action: SnackBarAction(onPressed: () {
      Scaffold.of(context).hideCurrentSnackBar();

    },label: "OK",)),
  );
}

SocketService socketService = new SocketService();
createSocket(){
  return socketService;
}

navigateTo(context,view){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => view),
  );
}

launchGame(String gameName) async {

  String packageName = "";
  switch(gameName){
    case "Quiz" : packageName = 'com.DefaultCompagny.Quiz';break;
    case "LightUp" : packageName = 'com.UniWave.JeuBallon';break;
  }
  final result = await LaunchApp.isAppInstalled(
      androidPackageName: packageName,
      iosUrlScheme: 'pulsesecure://'
  );
  log(packageName);
  log("GAME :"+result.toString());
  if(result){
    await LaunchApp.openApp(
      androidPackageName: packageName,
      iosUrlScheme: 'pulsesecure://',
      appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
      // openStore: false
    );
  }
}

redirectTo(String gameName, context) async {

  String packageName = "";
  String gamePath = "";
  log(gameName);

  switch(gameName){
    case "Quiz" :
      packageName = 'com.DefaultCompagny.Quiz';
      gamePath = "com.DefaultCompagny.Quiz";
      break;
    case "LightUp" :
      packageName = 'com.UniWave.JeuBallon';
      gamePath = "com.UniWave.JeuBallon";
      break;
  }
  final result = await LaunchApp.isAppInstalled(
      androidPackageName: packageName,
      iosUrlScheme: 'pulsesecure://'
  );
  log(result.toString());
  // StoreRedirect.redirect(
  //   androidAppId: "com.DefaultCompagny.Quiz&gl",
  //   iOSAppId: "585027354",
  // );

  if(!result){
    await LaunchApp.openApp(
        androidPackageName: gamePath,
        openStore: !result);
  }
  else{
   showSnackBar(context, "Vous avez dejà installé cette application");
  }


  // final Uri _url = Uri.parse(gamePath);
  // log(_url.toString());
  // await launchUrl(_url);

}