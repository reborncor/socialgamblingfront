import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/friendlist/api.dart';
import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';

class FriendList extends StatefulWidget {

  final routeName = '/friendlist';

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  FriendsResponse response;
  List<FriendModel> friends = [];


  Widget itemFriend(String image, String username){
    return Padding(padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: <Widget>[
              GestureDetector(
                onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Chat()),
            );

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.account_circle, size: 30,),
                    Padding(padding: EdgeInsets.all(10)
                    ,child: Text(username,style: TextStyle(fontSize: 15),),)
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.videogame_asset, size: 30), color: Colors.amber[300], onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectGame()),
                );

              },)
            ],
      )
       ,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber[300],
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

        title: Text("Mes amis"),
      ),
      body: FutureBuilder(
        future: getUserFriends(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
                response = snapshot.data;
                friends = response.friends;
                return Center(

                  child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return itemFriend('image', friends[index].username);
                    },
                  )
                );
            }
            else{
              return Text("Pas d'amis");
            }
          }
          else{
            return Text('Erreur requete');
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
