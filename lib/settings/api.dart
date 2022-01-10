import 'dart:convert';
import 'package:socialgamblingfront/response/UserResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;
import 'package:socialgamblingfront/util/util.dart';



Future<UserResponse> getUserInformation() async{

  String token = await getCurrentUserToken();
  var response;
  final String path = "/user/getuser";

  try {
    response = await http.get(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token});
  }
  catch (e) {
    print(e.toString());
    return UserResponse(message: "Erreur serveur", code: 1);
  }

  if(response.statusCode == 200) {
//    log("DATA :"+ json.decode(response.body).toString());
    UserResponse data = UserResponse.fromJsonData(json.decode(response.body));
    setUserData("money", data.user.money.toString());
    return data ;
  }
  else{
    return UserResponse(code: json.decode(response.body)['code'], message: json.decode(response.body)['message']);
  }


}
