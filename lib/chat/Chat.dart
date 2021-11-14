import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/chat/api.dart';
import 'package:socialgamblingfront/model/MessageModel.dart';
import 'package:socialgamblingfront/response/ConversationResponse.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {

  final routeName = '/chat';
  String receiverUsername ;

  Chat();
  Chat.withUsername({this.receiverUsername});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  IO.Socket socket;
  ConversationResponse response;
  List<MessageModel> messages = [];

  @override
  initState(){
//    init();
    super.initState();
  }
  init(){

    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'query': {"chatId" : "test"},
      'upgrade':false,
    });
    log("Test");
    socket.onConnecting((data) => print(data));

    socket.onConnect((data) => {
      log("Connected"),
//      socket.emit("new_message","test")
      socket.emit("conversation", (data) => log(data.toString())),
    });
    socket.onDisconnect((data) => log("Disconnect:" +data.toString()));

    socket.on('send_conversation', (data) => log("Data :"+data.toString()));

  }


  Widget messageEditor(){
    return Row(
      children: <Widget>[
        Expanded(
            child: TextField(
          decoration: InputDecoration(
            enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
            focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
            border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
          ),
          onTap: (){
            log("EDIT");
          },
        )),
    IconButton(onPressed: () {
      log("Envoyer !");
    }, icon: Icon(Icons.send))
      ],
    );
  }
  Widget itemMessage(MessageModel messageModel){
    return Padding(padding: EdgeInsets.all(16),
        child : Align(
          alignment:(messageModel.senderId == "1") ? Alignment.centerLeft : Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 100,
              maxWidth: 300
            ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.account_circle),
                 Expanded(child:  Card(

                   color: (messageModel.senderId == "1") ? Colors.teal : Colors.white70 ,
                   child: ListTile(
                     title: Text(messageModel.content),
                     trailing: IconButton(icon: Icon(Icons.videogame_asset), onPressed: () => {},),
                   ),
                 ),)
                ],
              ),

          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],

        title: Text("Chat"),
      ),
      body:FutureBuilder(
        future: getUserConversation(widget.receiverUsername),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){

              response = snapshot.data;
              messages = response.conversation.chat;

              return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,

                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return itemMessage(messages[index]);
                          },
                        ),
                        Expanded(flex: 0,child: messageEditor())]

              );
            }
            else{
              return Center(child: Text("Pas de conversation avec l'utilisateur"));
            }
          }
          else{
            return Center(

                child: CircularProgressIndicator(
                  color: Colors.amber[300],
                )
            );
          }
        },

//      )Center(
//
//          child: ListView.builder(
//            itemCount: friends.length,
//            itemBuilder: (context, index) {
//              return itemFriend('image', friends[index].username);
//          },
//          )

      ),

    );
  }

}
