import 'dart:convert';
import 'dart:developer';

import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/GameResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:http/http.dart'as http;

Future<PGameResponse> getResultGame(String gameId) async{

  String token = await getCurrentUserToken();
  var response;
  final String path = "/game/result";
  final data = {
    'gameId' :gameId,
  };
  final uri = Uri.http(URL.replaceAll("https://", ""),path, data);
  try {
    response = await http.get(uri,
      headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token},);
  }
  catch (e) {
    print(e.toString());
    return PGameResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    PGameResponse data = PGameResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{
    return PGameResponse(code: 1, message: json.decode(response.body)['message']);
  }


}
Future<BasicResponse> handleUserLevel(bool win) async{
    var response;

  final String path = "/user/handlelevel";
  String token = await getCurrentUserToken();
  Map data = {
    "win":win,
  };
  BasicResponse result;
  try {
    response = await http.put(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    result = BasicResponse.fromJsonData(json.decode(response.body));
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1, message: result.message);
  }



}
