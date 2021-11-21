import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/chat/api.dart';
import 'package:socialgamblingfront/model/MessageModel.dart';
import 'package:socialgamblingfront/response/ConversationResponse.dart';
import 'package:socialgamblingfront/response/OldMessageResponse.dart';
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
  OldMessageResponse responseOldMessage;
  List<MessageModel> messages = [];
  TextEditingController messageToSend = TextEditingController();
  String username;
  StreamController streamController = StreamController();
  ScrollController scrollController;
  MessageModel messageSent;
  int startInd;
  int endInd;
  scrollListener(){
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        log("reach the bottom");
      });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      fetchOldMessage();
      setState(() {
        log("reach the top");
      });
    }

  }

  @override
  initState()  {
    startInd = 5;
    endInd = startInd+ 5;
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    fetchUsername();
    fetchData();
    init();
    super.initState();
  }
  fetchUsername() async {
    username = await getCurrentUsername();
  }

  fetchOldMessage() async {
    var data = await getUserMessagePageable(widget.receiverUsername, startInd, endInd);
    responseOldMessage = data;
    messages.insertAll(0, responseOldMessage.oldmessages);
    startInd+=5;
    endInd+=5;
    streamController.add("event");
  }

  fetchData() async{
    var data = await getUserConversation(widget.receiverUsername);
    response = data;
    messages = response.conversation.chat;
    streamController.add(data);
  }
  addMessageToList(MessageModel messageModel){
    messages.add(messageModel);
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
  init(){

    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'query': {"chatId" : "test"},
      'upgrade':false,
      'autoConnect': false,
    });
    log("Test");
    socket.connect();
    socket.onConnecting((data) => print(data));
//    socket.on("message", (data) => log("Data :"+data.toString()));
    socket.onConnect((data) => {
      log("Connected"),
//      socket.emit("conversation", (data) => log(data.toString())),
    });

    socket.onDisconnect((data) => log("Disconnect:"));
    socket.onReconnect((data) => log("Reconnected !"));

    socket.on('send_conversation', (data) => log("Data :"+data.toString()));

    socket.on("messagesuccess",(data) => {
      log("OK"),
      addMessageToList(messageSent)

    });

  }

  sendMessage(String message){
    messageSent = MessageModel(time: "",content: message, senderUsername: username ,receiverUsername: widget.receiverUsername, id: "");
    socket.emit("message",messageSent.toJson());

  }


  Widget messageEditor(){
    return Row(
      children: <Widget>[
        Expanded(
            child: TextField(
              controller: messageToSend,
          decoration: InputDecoration(
            enabledBorder: setOutlineBorder(5.0, 25.0, Colors.red[700]),
            focusedBorder: setOutlineBorder(5.0, 25.0, Colors.red[700]),
            border: setOutlineBorder(5.0, 25.0, Colors.red[700]),
          ),
          onTap: (){
//            log("EDIT");
          },
        )),
    IconButton(onPressed: () {
      sendMessage(messageToSend.text);
      messageToSend.clear();
    }, icon: Icon(Icons.send))
      ],
    );
  }
  Widget itemMessage(MessageModel messageModel){
    return Padding(padding: EdgeInsets.all(16),
        child : Align(
          alignment:(messageModel.senderUsername == username) ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 100,
              maxWidth: 300
            ),
              child: (messageModel.senderUsername != username) ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.account_circle,size: 40,),
                 Expanded(child:  Card(

                   color: (messageModel.senderUsername == username) ? Colors.red[300] : Colors.white70 ,
                   child: ListTile(
                     title: Text(messageModel.content),
//                     trailing: IconButton(icon: Icon(Icons.videogame_asset), onPressed: () => {},),
                   ),
                 ),)
                ],
              ) :Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Expanded(child:  Card(

                    color: (messageModel.senderUsername == username) ? Colors.red[300] : Colors.white70 ,
                    child: ListTile(
                      title: Text(messageModel.content),
//                     trailing: IconButton(icon: Icon(Icons.videogame_asset), onPressed: () => {},),
                    ),
                  ),),  Icon(Icons.account_circle, size: 40,),
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
        backgroundColor: Colors.red[700],

        title: Text(widget.receiverUsername),
      ),
      body:StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
            if(snapshot.hasData){
//              response = snapshot.data;
//              messages = response.conversation.chat;

              return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child:new ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                        scrollDirection: Axis.vertical,

                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return itemMessage(messages[index]);
                        },
                      ),),

                        Expanded(flex: 0,child: messageEditor())]

              );
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
