import 'dart:core';




class CreditCardModels{

  String cardNumber  ;
  String expiryDate ;
  String cardHolderName ;
  String cvvCode  ;

  CreditCardModels({ this.cardNumber,  this.expiryDate, this.cardHolderName,this.cvvCode });


  CreditCardModels.jsonData({this.cardNumber,  this.expiryDate, this.cardHolderName, this.cvvCode});

  factory CreditCardModels.fromJsonData(Map<String,  dynamic> json){
    return CreditCardModels.jsonData(
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cardHolderName: json['cardHolderName'],
      cvvCode: json['cvvCode'],


    );
  }

  Map<String, dynamic> toJson() => {
    "cardNumber" : cardNumber,
    "expiryDate" : expiryDate,
    "cardHolderName" : cardHolderName,
    "cvvCode" : cvvCode,
  };

}


