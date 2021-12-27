import 'dart:convert';
import 'dart:core';

import 'MessageModel.dart';
import 'MessageModel.dart';



class CreditCardModels{

  String cardNumber  ;
  String expiryDate ;
  String cardHolderName ;
  String cvvCode  ;

  CreditCardModels({ this.cardNumber,  this.expiryDate, this.cardHolderName,this.cvvCode });


  CreditCardModels.jsonData({this.cardNumber,  this.expiryDate, this.cardHolderName, this.cvvCode});

  factory CreditCardModels.fromJsonData(Map<String,  dynamic> json){
    return CreditCardModels.jsonData(

    );
  }

  Map<String, dynamic> toJson() => {
    "cardNumber" : cardNumber,
    "expiryDate" : expiryDate,
    "cardHolderName" : cardHolderName,
    "cvvCode" : cvvCode,
  };

}


