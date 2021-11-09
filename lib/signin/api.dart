import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/response/SigninResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;



Future<SigninReponse> signinUser(String username, String password) async{
  log("CREDS : "+username +" "+password);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response;

  final String PATH = "/user/signin";

  Map data =  {
    'username' : username,
    'password' : password
  };
  try {
    response = await http.post(URL+PATH,
        headers: {"Content-type": "application/json"}, body: json.encode(data));
  }
  catch (e) {
    print(e.toString());
    return SigninReponse(code: 1);
  }

  if(response.statusCode == 200) {
    log("DATA :"+ json.decode(response.body).toString());
    SigninReponse data = SigninReponse.fromJsonData(json.decode(response.body));
    if(data != null) {
      sharedPreferences.setString("token", data.token);
//      sharedPreferences.setString("username", jsonResponse['payload']);
    }
    return data ;
  }
  else{
    return SigninReponse(code: 1, message: response.error.message.toString());

  }


}
