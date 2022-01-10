import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialgamblingfront/model/CreditCardModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:http/http.dart'as http;

Future<BasicResponse> updateCreditCard(String cardNumber,String expiryDate,String cardHolderName,String cvvCode) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  CreditCardModels creditCard = new CreditCardModels(cardHolderName: cardHolderName, cardNumber: cardNumber,expiryDate :expiryDate, cvvCode: cvvCode );
  var response;

  final String path = "/user/creditcard";
  String token = await getCurrentUserToken();
  Map data = {
    "creditCard":creditCard.toJson(),
  };
  try {
    response = await http.put(URL+path,
        headers: {"Content-type": "application/json",'Authorization': 'Bearer '+ token}, body: json.encode(data));
    BasicResponse result = BasicResponse.fromJsonData(json.decode(response.body));
    sharedPreferences.setString("creditCard", jsonEncode(result.payload['creditCard']));
    return result ;
  }
  catch (e) {
    print(e.toString());
    return BasicResponse(code: 1, message: "Erreur : $e");
  }



}
