import 'dart:convert';


import 'package:socialgamblingfront/response/ConversationsResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<ConversationsResponse> getUserConversations() async{

  String token = await getCurrentUserToken();
  var response;
  final String path = "/conversation/getconversations";

  try {
    response = await http.get(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token});
  }
  catch (e) {
    print(e.toString());
    return ConversationsResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
    ConversationsResponse data = ConversationsResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{
    return ConversationsResponse(code: json.decode(response.body)['code'], message: json.decode(response.body)['message']);
  }


}
