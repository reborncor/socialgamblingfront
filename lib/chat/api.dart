import 'dart:convert';
import 'dart:developer';


import 'package:socialgamblingfront/response/ConversationResponse.dart';
import 'package:socialgamblingfront/response/OldMessageResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<ConversationResponse> getUserConversation(String username) async{

  String token = await getCurrentUserToken();
  var response;
  final String path = "/conversation/getconversation";
  Map data = {
    'username' :username,
  };
  try {
    response = await http.post(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token},body: json.encode(data));
  }
  catch (e) {
    print(e.toString());
    return ConversationResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
//    log("DATA :"+ json.decode(response.body).toString());
    ConversationResponse data = ConversationResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{
    return ConversationResponse(code: 1, message: "Une Erreur est survenue");
  }


}



Future<OldMessageResponse> getUserMessagePageable(String username, int startInd, int endInd) async{

  String token = await getCurrentUserToken();
  var response;
  final String path = "/conversation/getconversationpage";
  final data = {
    'username' :username,
    'startInd' :startInd.toString(),
    'endInd' :endInd.toString(),
  };
  final uri = Uri.http(URL.replaceAll("https://", ""),path, data);
  try {
    response = await http.get(uri,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token},);
  }
  catch (e) {
    print(e.toString());
    return OldMessageResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    OldMessageResponse data = OldMessageResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{
    return OldMessageResponse(code: 1, message: response.error.message.toString());
  }


}
