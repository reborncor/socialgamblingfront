
import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/resultgame/ResultGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;



class ConfirmGame extends StatefulWidget {

  final routeName = '/confirmgame';
  final int userGamble;
  final String username;
  final bool isInvited;
  final String customKey;
  final String gameName;
  const ConfirmGame({this.userGamble, this.username, this.isInvited = false, this.customKey, this.gameName});
  const ConfirmGame.invited({this.userGamble, this.username, this.isInvited, this.customKey, this.gameName});

  @override
  _ConfirmGameState createState() => _ConfirmGameState();
}

class _ConfirmGameState extends State<ConfirmGame> with WidgetsBindingObserver{
  StreamController<dynamic> streamController =  StreamController();
  bool isUserReady = false;
  bool isPlayerReady = false;
  int player2Gamble = 0;
  int player1Gamble = 0;
  String currentUserName;
  String username;
  IO.Socket socket;
  String gameId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.player1Gamble = this.widget.userGamble;
    this.player2Gamble = this.widget.userGamble;
    this.username = this.widget.username;
    fetchData();
    socket = socketService.getSocket();
    socket.on("confirmed_game", (data) => {log("GAME CONFIRME"), showSnackBar(context, "Partie Confirmé !")});
    socket.on("create_game", (data) async => {
      log("Partie créee"),
      log(data),
      this.gameId = data,
      await saveNewGame(data),

        if(this.isPlayerReady){
        launchGame()
      }
    });
    socket.on("confirmed_player", (data) => {log("Joueur 2 pret"), this.isPlayerReady = true, streamController.add("player_ready")});
    socket.on("game_over", (data) async  => {
      log("PARTIE TERMINEE"),
      // showSnackBar(context, "Partie terminée !"),
      await saveNewGame(data),
      navigateTo(context, ResultGame(customKey : widget.customKey, userGamble: widget.userGamble, gameName: widget.gameName, otherPlayer:widget.username, )) });

    super.initState();
  }





  void userConfirmGame(){

    socket.emit("confirm_game",
        {
          "username" : currentUserName,
          "key" : widget.customKey ,
          "receiverUsername" :username,
          "gameName" : widget.gameName,
          "gamble":widget.userGamble,
          "ready" : (this.isUserReady && this.isPlayerReady) });
  }
  fetchData() async {
    this.currentUserName = await getCurrentUsername();
    socketService.onInitGameSession(currentUserName, widget.customKey);
    streamController.add("event");
  }

  launchGame() async {
    final result = await LaunchApp.isAppInstalled(
        androidPackageName: 'com.DefaultCompagny.Quiz',
        iosUrlScheme: 'pulsesecure://'
    );

    if(result){
      await LaunchApp.openApp(
        androidPackageName: 'com.DefaultCompagny.Quiz',
        iosUrlScheme: 'pulsesecure://',
        appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
        // openStore: false
      );
    }
  }
  startGame() async {
    // final result = await createGame(this.username, player1Gamble, player2Gamble);
    // if(result.code == SUCCESS){
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(result.message)),
    //   );
    //
    // }
    // else{
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(result.message)),
    //   );
    // }

    userConfirmGame();
    showSnackBar(context, "Joueur confirmé");

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

        title: Text("Jeu",style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
          return Center(

          child: CircularProgressIndicator(
          color: Colors.red[700],
          )
          );
          }
          if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  flex: 0,
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width : 100,child:
                        Column(children: [
                          Image(image : AssetImage('asset/images/user.png'), width: 100, height: 100,),
                          Text(this.currentUserName,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text(this.widget.userGamble.toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) ,])),
                        Text("VS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                        Container(width : 100,child:
                        Column(children: [
                          Image(image : AssetImage('asset/images/user.png'), width: 100, height: 100,),
                          Text(this.widget.username,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) ,
                          Text(this.widget.userGamble.toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) ,])),
                      ],)),
                Text("Somme Total :"+(widget.userGamble*2).toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Visibility(child:Icon(Icons.check,size: 20,color: Colors.green,), visible: isUserReady,),
                      Visibility(child:Icon(Icons.check,size: 20,color: Colors.green,), visible: isPlayerReady,),
                    ],
                  ),
                  AutoSizeText("Commencer",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50), maxLines: 1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: BaseButtonRoundedColor(75,40,Colors.green[700]),
                          onPressed: () {
                        setState(() {
                          this.isUserReady = true;
                          startGame();
                        });}, child: Text('Oui')),

                      ElevatedButton(
                          style: BaseButtonRoundedColor(75,40,Colors.red[700]),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, TabView.routeName);


                            setState(() {
                          this.isUserReady = false;
                        });
                      }, child: Text('Non')),


                    ],
                  ),

                ],)

              ],);
            }
            else{
              return Center(child :Text("Pas de données"));
            }
          }



      ),

    );
  }
}
