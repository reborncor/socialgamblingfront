import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:http/http.dart'as http;

Future<BasicResponse> buyDens(int amount, bool isCredit) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response;

  final String path = "/user/givemoney";
  String token = await getCurrentUserToken();
  Map data = {
    "amount":amount,
    "isCredit":isCredit,
  };
  try {
    response = await http.put(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    sharedPreferences.setString("money", result.payload['money'].toString());
    sharedPreferences.setString("dateOfBan", result.payload['dateOfBan'].toString());
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1, message: "Erreur : $e");
  }



}

Future<BasicResponse> buyDensStripe(int amount) async{
  var response;

  final String path = "/user/createpayment";
  String token = await getCurrentUserToken();
  Map data = {
    "amount":amount,
    "currency":"eur",
  };
  try {
    response = await http.post(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1, message: "Erreur : $e");
  }



}


Future<BasicResponse> refundMoney(int amount) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response;

  final String path = "/user/refundmoney";
  String token = await getCurrentUserToken();
  Map data = {
    "amount":amount,
  };
  try {
    response = await http.put(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    sharedPreferences.setString("money", result.payload['money'].toString());
    sharedPreferences.setString("dateOfBan", result.payload['dateOfBan'].toString());
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1, message: "Erreur : $e");
  }


}

Future<BasicResponse> getUserMoney() async{

  String token = await getCurrentUserToken();
  var response;
  final String path = "/user/money";

  try {
    response = await http.get(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token});
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
//    log("DATA :"+ json.decode(response.body).toString());
    BasicResponse data = BasicResponse.fromJsonData(json.decode(response.body));
    setUserData("money", data.payload['money'].toString());
    log("DATA"+data.payload.toString());
    return data ;
  }
  else{
    return BasicResponse(code: json.decode(response.body)['code'], message: json.decode(response.body)['message']);
  }


}


