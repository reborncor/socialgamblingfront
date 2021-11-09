import 'dart:convert';
import 'dart:developer';


import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<FriendsResponse> getUserFriends() async{

  String token = await getCurrentUserToken();
  var response;
  final String PATH = "/user/getfriends";

  try {
    response = await http.get(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token});
  }
  catch (e) {
    print(e.toString());
    return null;
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    FriendsResponse data = FriendsResponse.fromJsonData(json.decode(response.body));
    return data ;
  }
  else{

    log("ERREUR"+ response.statusCode.toString());
  }


}
