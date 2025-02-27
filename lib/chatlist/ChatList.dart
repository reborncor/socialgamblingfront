import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/model/ConversationModel.dart';
import 'package:socialgamblingfront/response/ConversationsResponse.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/util/util.dart';

import 'api.dart';

class ChatList extends StatefulWidget {

  final routeName = '/chatlist';

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ConversationsResponse response;
  List<ConversationModel> conversations = [];
  String currentUsername;
  Future<ConversationsResponse> _futureResponse;


  @override
  initState() {
    getCurrentUsername().then((value) => currentUsername = value);
    _futureResponse = getUserConversations();
    super.initState();

  }
  Widget itemFriend(String image, ConversationModel conversationModel) {


    String receiverUserame = conversationModel.members.first == currentUsername ? conversationModel.members.last : conversationModel.members.first;
    return Padding(padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chat.withUsername(receiverUsername: receiverUserame)),
          );
        },
    child: Card(
        elevation: 0,
        color: Colors.red[50] ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      child: ListTile(
        leading: Image( image : AssetImage('asset/images/user.png',), width: 40, height: 40,),
        title: Text(receiverUserame,style: TextStyle(fontSize: 17), ),
        subtitle: Text((conversationModel.chat.length == 0) ? "" : conversationModel.chat.first.content),
        trailing: IconButton(icon: Icon(Icons.videogame_asset, size: 30, color: Colors.red[700],), onPressed: () => {
          Navigator.push(context,
        MaterialPageRoute(builder: (context) => SelectGame(username : receiverUserame)),
        )
        },),
      ),
    )
      ),
    );

  }

  Future<void> refreshData()async{
    _futureResponse = getUserConversations();
    setState(() {
    });
    return;
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
        title: Text("Chat",style: TextStyle(color: Colors.black)),
      ),
      body:FutureBuilder(
        future: _futureResponse,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            response = snapshot.data;
            if(response.code == BAN ||response.code== NOT_CONNECTED) {
              Navigator.pushReplacementNamed(context,SignIn.routeName);
            }
            conversations = response.conversations;
            return RefreshIndicator(
              color: Colors.red[700],
              child: Center(

                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      return itemFriend('image', conversations[index]);
                    },
                  )
              ), onRefresh: () => refreshData(),);
          }
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              response = snapshot.data;
              if(response.code == BAN ||response.code== NOT_CONNECTED) {
                log("DISCONNECTING");
                Navigator.pushReplacementNamed(context,SignIn.routeName);
              }
              conversations = response.conversations;
              return RefreshIndicator(
                color: Colors.red[700],
                child: Center(

                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      return itemFriend('image', conversations[index]);
                    },
                  )
              ), onRefresh: () => refreshData(),);
            }
            else{
              return Center(child: Text("Aucune conversation"));
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
