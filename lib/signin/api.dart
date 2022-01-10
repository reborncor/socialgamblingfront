import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/response/SigninResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<SigninReponse> signinUser(String username, String password) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response;

  final String path = "/user/signin";

  Map data =  {
    'username' : username,
    'password' : password
  };
  try {
    response = await http.post(URL+path,
        headers: {"Content-type": "application/json"}, body: json.encode(data));
  }
  catch (e) {
    print(e.toString());
    return SigninReponse(code: 1, message: "Erreur serveur");
  }

  if(response.statusCode == 200) {
    SigninReponse data = SigninReponse.fromJsonData(json.decode(response.body));
    print(json.decode(response.body));
    if(data != null) {
      sharedPreferences.setString("token", data.token);
      sharedPreferences.setString("username", data.payload.username);
      sharedPreferences.setString("money", data.payload.money.toString());
      sharedPreferences.setString("dateOfBan", data.payload.dateOfBan.toString());

      saveCard(data.payload.creditCard.cardNumber, data.payload.creditCard.expiryDate, data.payload.creditCard.cardHolderName, data.payload.creditCard.cvvCode);
    }
    return data ;
  }
  else{
    var message;
    try{
      message = json.decode(response.body)['message'];
    }catch(e){
      message = "Une erreur est survenue";
    }
    return SigninReponse(code: json.decode(response.body)['code'], message: message);
  }


}
