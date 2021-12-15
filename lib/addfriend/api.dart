import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/response/SigninResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<BasicResponse> addFriends(String username) async{
  var response;

  final String PATH = "/user/addfriend";
  String token = await getCurrentUserToken();

  Map data = {
    "username" : username
  };
  try {
    response = await http.post(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1);
  }



}

Future<FriendsResponse> getUserInvitations() async{

  String token = await getCurrentUserToken();
  var response;
  final String PATH = "/user/getinvitations";

  try {
    response = await http.get(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token});
  }
  catch (e) {
    print(e.toString());
    return json.decode(response.body);
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    FriendsResponse data = FriendsResponse.fromJsonDataInvitaions(json.decode(response.body));
    return data ;
  }
  else{
    return json.decode(response.body);
  }


}


Future<BasicResponse> confirmFriends(String username, bool isAccepted) async{
  var response;

  final String PATH = "/user/acceptfriend";
  String token = await getCurrentUserToken();
  Map data = {
    "username":username,
    "isAccepted":isAccepted
  };
  try {
    response = await http.put(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1);
  }



}



Future<BasicResponse> sendMoneyToFriends(String username, int amount) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response;

  final String PATH = "/user/sendmoney";
  String token = await getCurrentUserToken();
  Map data = {
    "username":username,
    "amount":amount,
  };
  try {
    response = await http.put(URL+PATH,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));

    if(response.statusCode == 200){
      sharedPreferences.setString("money", result.payload['money'].toString());
    }
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1, message: "Erreur : une erreur est survenue");
  }



}

