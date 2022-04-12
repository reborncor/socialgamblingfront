
import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socialgamblingfront/confirmgame/api.dart';


import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';


class ConfirmGame extends StatefulWidget {

  final routeName = '/confirmgame';
  final int userGamble;
  final String username;

  const ConfirmGame({this.userGamble, this.username});
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
    initSocket();
    super.initState();
  }

  void initSocket(){
    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'upgrade':false,
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnecting((data) => print(data));
    socket.onConnect((data) => {
      log("Connected"),
      socket.emit("credentials_game", currentUserName),
    });

    socket.onDisconnect((data) =>  socket.emit("disconnect_user_game", currentUserName),);
    socket.onReconnect((data) => log("Reconnected !"));

    socket.on("confirmed_game", (data) => {log("GAME CONFIRME"), showSnackBar(context, "Partie Confirmé !")});
  }

  void userConfirmGame(){
    var uuid = Uuid();
    var v1 = uuid.v1();
    socket.emit("confirm_game", {"username" : currentUserName,"key" : v1 ,"receiverUsername" :username, "token":NOTIFICATION_TOKEN });
  }
  fetchData() async {
    this.currentUserName = await getCurrentUsername();
    streamController.add("event");
    streamController.close();
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
    // showSnackBar(context, "Joueur confirmé");

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
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  flex: 0,
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width : 175,child:
                        Column(children: [
                          Image(image : AssetImage('asset/images/user.png'), width: 100, height: 100,),
                          Text(this.currentUserName,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text(this.widget.userGamble.toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) ,])),
                        Text("VS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                        Container(width : 200,child:
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
