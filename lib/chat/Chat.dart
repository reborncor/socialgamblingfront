import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialgamblingfront/chat/api.dart';
import 'package:socialgamblingfront/model/MessageModel.dart';
import 'package:socialgamblingfront/model/ThemeModel.dart';
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
  MessageModel newMessage;
  int startInd;
  int endInd;
  ThemeModel themeNotifier;
  scrollListener(){
    log("POSITION : "+scrollController.position.toString());
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
  goUp(){
     scrollController.animateTo(
     scrollController.position.minScrollExtent,
     duration: Duration(seconds: 1),
     curve: Curves.easeOut,
    );
  }

  goDown(){
    if(scrollController.hasClients){
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
    }




  @override
  initState()  {
    startInd = 10;
    endInd = startInd+ 10;
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
    startInd+=10;
    endInd+=10;
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
    streamController.add("ok");
    goDown();
  }

  @override
  void dispose() {

    socket.disconnect();
    super.dispose();
  }
  init(){

    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'upgrade':false,
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnecting((data) => print(data));
    socket.onConnect((data) => {
      log("Connected"),
      socket.emit("credentials", username),
    });

    socket.onDisconnect((data) =>  socket.emit("disconnect_user", username),);
    socket.onReconnect((data) => log("Reconnected !"));

    socket.on('send_conversation', (data) => log("Data :"+data.toString()));

    socket.on("messagesuccess",(data) => {
      if(data == "0"){
        addMessageToList(messageSent),
      }
      else{
        //TODO: Unsend message
      }

    });

    socket.on("instantmessage",(data) =>  {
      log("OK Instant Message"),
      setState(() {
        newMessage = MessageModel.fromJsonData(data);
        addMessageToList(newMessage);
      }),


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
              style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),
              controller: messageToSend,
          decoration: InputDecoration(
            enabledBorder: setOutlineBorder(5.0, 25.0, ),
            focusedBorder: setOutlineBorder(5.0, 25.0, ),
            border: setOutlineBorder(5.0, 25.0, ),
          ),

          onTap: (){
                goDown();
          },
        )),
    IconButton(onPressed: () {
      sendMessage(messageToSend.text);
      messageToSend.clear();
    }, icon: Icon(Icons.send, color : Colors.red[700]))
      ],
    );
  }
  Widget itemMessage(MessageModel messageModel){
    return Padding(padding: EdgeInsets.all(8),
        child : Align(
          alignment:(messageModel.senderUsername == username) ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 100,
              maxWidth: 300
            ),
              child: (messageModel.senderUsername != username) ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image( image : AssetImage('asset/images/user.png',), width: 30, height: 30,),
                  Flexible(child: Card(
                    color: (messageModel.senderUsername == username) ? Colors.red[50] : Colors.white70 ,
                    child: Container(
                      child:Padding(child : Text(messageModel.content), padding: EdgeInsets.all(8),) ,
                    ),),)
                ],
              ) :Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Flexible(child: Card(
                    color: (messageModel.senderUsername == username) ? Colors.red[50] : Colors.white70 ,
                    child: Container(
                      child:Padding(child : Text(messageModel.content), padding: EdgeInsets.all(8),) ,
                    ),),)
                  ,
                  Image( image : AssetImage('asset/images/user.png',), width: 40, height: 40,),
                ],
              ),

          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
     return  Consumer<ThemeModel>(
         builder: (context,ThemeModel themeNotifier , child) {
           this.themeNotifier = themeNotifier;
           return Scaffold(
             appBar: AppBar(
               backgroundColor: Colors.red[700] ,

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
                             reverse: false,
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
     });

  }

}

