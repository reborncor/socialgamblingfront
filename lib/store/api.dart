import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:http/http.dart'as http;

Future<BasicResponse> buyDens(int amount, bool isCredit) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response;

  final String PATH = "/user/givemoney";
  String token = await getCurrentUserToken();
  Map data = {
    "amount":amount,
    "isCredit":isCredit,
  };
  try {
    response = await http.put(URL+PATH,
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

  final String PATH = "/user/createpayment";
  String token = await getCurrentUserToken();
  Map data = {
    "amount":amount,
    "currency":"eur",
  };
  try {
    response = await http.post(URL+PATH,
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

  final String PATH = "/user/refundmoney";
  String token = await getCurrentUserToken();
  Map data = {
    "amount":amount,
  };
  try {
    response = await http.put(URL+PATH,
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

