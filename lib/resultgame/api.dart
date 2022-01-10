import 'dart:convert';
import 'dart:developer';

import 'package:socialgamblingfront/response/GameResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:http/http.dart'as http;

Future<PGameResponse> getResultGame(String gameId) async{

  String token = await getCurrentUserToken();
  var response;
  final String PATH = "/game/result";
  final data = {
    'gameId' :gameId,
  };
  final uri = Uri.http(URL.replaceAll("https://", ""),PATH, data);
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