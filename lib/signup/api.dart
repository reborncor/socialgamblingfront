import 'dart:convert';

import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:http/http.dart'as http;



Future<BasicResponse> signUpUser(UserModel userModel) async{
  var response;

  final String PATH = "/user/signup";

  Map data =  userModel.toJson();
  try {
    response = await http.post(URL+PATH,
        headers: {"Content-type": "application/json"}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: json.decode(response.body)['code'], message: json.decode(response.body)['message']);
  }





}
