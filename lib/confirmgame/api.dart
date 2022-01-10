import 'dart:convert';
import 'dart:developer';

import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/GameResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<PGameResponse> createGame(String username,int player1Gamble, int player2Gamble) async{
  var response;

  final String PATH = "/game/create";
  String token = await getCurrentUserToken();

  Map data = {
    "username" : username,
    "player1Gamble" : player1Gamble,
    "player2Gamble" : player2Gamble,
  };
  try {
    response = await http.post(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    PGameResponse result = PGameResponse.fromJsonData(json.decode(response.body));
    await saveNewGame(result.game.id);
    return result ;
  }
  catch (e) {
    print(e.toString());
    return PGameResponse(code: 1,message: json.decode(response.body)['message']);
  }



}
