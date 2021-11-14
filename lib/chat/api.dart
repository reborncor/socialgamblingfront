import 'dart:convert';
import 'dart:developer';


import 'package:socialgamblingfront/response/ConversationResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<ConversationResponse> getUserConversation(String username) async{

  String token = await getCurrentUserToken();
  var response;
  final String PATH = "/conversation/getconversation";
  Map data = {
    'username' :username,
  };
  try {
    response = await http.post(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token},body: json.encode(data));
  }
  catch (e) {
    print(e.toString());
    return ConversationResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    ConversationResponse data = ConversationResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{
    return ConversationResponse(code: 1, message: response.error.message.toString());
  }


}
