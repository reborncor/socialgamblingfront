import 'dart:convert';
import 'dart:developer';


import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/ConversationsResponse.dart';
import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<ConversationsResponse> getUserConversations() async{

  String token = await getCurrentUserToken();
  var response;
  final String PATH = "/conversation/getconversations";

  try {
    response = await http.get(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token});
  }
  catch (e) {
    print(e.toString());
    return ConversationsResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    ConversationsResponse data = ConversationsResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{
    return ConversationsResponse(code: 1, message: response.error.message.toString());
  }


}
