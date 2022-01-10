import 'dart:core';



class PGameModel{
  String id;
  String player1;
  String player2;
  int player1Gamble;
  int player2Gamble;
  String name ;
  String winner;
  String date ;

  PGameModel({ this.player1, this.player2, this.player1Gamble, this.player2Gamble,this.name, this.date, this.winner });


  PGameModel.jsonData({ this. id,this.player1, this.player2,  this.player1Gamble, this.player2Gamble,this.name, this.date, this.winner });

  factory PGameModel.fromJsonData(Map<String,  dynamic> json){
    return PGameModel.jsonData(
      id: json['id'],
      player1: json['player1'],
      player2: json['player2'],
      player1Gamble: json['player1Gamble'],
      player2Gamble: json['player2Gamble'],
      name: json['name'],
      date: json['date'],
      winner: json['winner'],


    );
  }



}


