
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/confirmgame/ConfirmGame.dart';
import 'package:socialgamblingfront/response/GameResponse.dart';
import 'package:socialgamblingfront/resultgame/api.dart';


import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/store/api.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';


class ResultGame extends StatefulWidget {

  final routeName = '/resultgame';
  final String customKey;
  final String gameName;
  final String otherPlayer;
  const ResultGame({this.customKey, this.gameName, this.otherPlayer,}) ;
  @override
  _ResultGameState createState() => _ResultGameState();
}

class _ResultGameState extends State<ResultGame> with WidgetsBindingObserver{
  StreamController<dynamic> streamController =  StreamController();
  PGameResponse response;
  int timeLeft = 15;
  Timer everysecond;
  bool isUserWon = false;
  bool isPlayer1 = false;
  int amount;
  String username;
  bool leftView = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    everysecond = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        if(this.mounted){
          setState(() {
            timeLeft =  timeLeft - 1;
          });
        }

      }catch(e){
        print(e);
      }

    });


    super.initState();


  }
  fetchData() async {
    final gameId  = await getGameId();
    username = await getCurrentUsername();
    response = await getResultGame(gameId);
    this.isUserWon = (username == response.game.winner);
    this.isPlayer1 = (username == response.game.player1);
    await getUserMoney();
    await handleUserLevel(this.isUserWon);
    streamController.add("event");
    streamController.close();
    // log(response.game.id)
    // delayedQuit();
  }

  delayedQuit(){
    if(this.mounted){
      Future.delayed(const Duration(milliseconds: 15000), () {

        if(!this.leftView) {
          Navigator.pushReplacementNamed(context, TabView.routeName);
        }


      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[700],
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {

                  try{
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Setting()),
                    );

                  }catch(e){

                  }


                },
                child: Icon(
                  Icons.account_circle,color: Colors.black,size: 30,
                ),
              )
          ),
        ],

        title: Text("Resultat de la partie",style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Image(image : AssetImage('asset/images/user.png'), width: 100, height: 100,),
                    Text(this.isUserWon ? "Victoire" : "Defaite", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),) ,
                    Text(this.username,style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: this.isUserWon ? Colors.green : Colors.red,
                          width: 3
                        )
                      ),
                      child :Center(child : Text((response.game.player1Gamble+response.game.player2Gamble).toString(),style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))) ,
                    ),
                    Text(this.isUserWon ?
                    "Gain : + "
                        + (this.isPlayer1 ? response.game.player2Gamble.toString() : response.game.player1Gamble.toString())
                        :"Perte : -"+((this.isPlayer1 ? response.game.player1Gamble.toString() : response.game.player2Gamble.toString())),style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)) ,
                  ])
                  ),
                  Padding(padding: EdgeInsets.all(20) , child : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Text(this.isUserWon ? "Rejouer :" : "Revanche :",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                        style: BaseButtonRoundedColor(75,40,Colors.green[700]),

                        onPressed: () {
                          navigateTo(context, ConfirmGame(customKey: widget.customKey,gameName: widget.gameName,userGamble: response.game.player1Gamble, username: widget.otherPlayer,));
                        },
                        child: Text("Oui")),
                    ElevatedButton(
                        style: BaseButtonRoundedColor(75,40,Colors.red[700]),

                        onPressed: () {
                          this.leftView = true;
                          Navigator.pushNamed(context, TabView.routeName);
                        },
                        child: Text("Non")),
                    Text(timeLeft.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))

                  ],))


                ],);
            }
            else{
              return Center(child :Text("Pas de données"));
            }
          }
          else{
            return Center(

                child: CircularProgressIndicator(
                  color: Colors.red[700],
                )
            );
          }
        },


      ),

    );
  }
}
