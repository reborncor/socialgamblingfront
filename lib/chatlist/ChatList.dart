import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/model/ConversationModel.dart';
import 'package:socialgamblingfront/response/ConversationsResponse.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
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

  @override
  initState() {
    getCurrentUsername().then((value) => currentUsername = value);
    super.initState();
  }
  Widget itemFriend(String image, ConversationModel conversationModel) {


    String receiverUserame = conversationModel.members.first == currentUsername ? conversationModel.members.last : conversationModel.members.first;
    return Padding(padding: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chat.withUsername(receiverUsername: receiverUserame)),
          );
        },
    child: Card(
        elevation: 0,
        color: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: Text(receiverUserame),
        subtitle: Text('Lorem ipsum...'),
        trailing: IconButton(icon: Icon(Icons.videogame_asset), onPressed: () => {
        Navigator.pushNamed(context, SelectGame.routeName),
        },),
      ),
    )
      ),
    );

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
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Setting()),
                  );

                },
                child: Icon(
                    Icons.account_circle
                ),
              )
          ),
        ],
        title: Text("Chat"),
      ),
      body:FutureBuilder(
        future: getUserConversations(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              response = snapshot.data;
              conversations = response.conversations;
              return Center(

                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      return itemFriend('image', conversations[index]);
                    },
                  )
              );
            }
            else{
              return Center(child: Text("Pas de conversations"));
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
