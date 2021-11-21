import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/addfriend/api.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/friendlist/api.dart';
import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';

class AddFriends extends StatefulWidget {

  final routeName = '/addfriends';

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  FriendsResponse response;
  List<FriendModel> friends = [];
  TextEditingController friendUsernameController = TextEditingController();

  Widget itemFriend(String image, String username){
    return Padding(padding: EdgeInsets.all(8),
      child: InkWell(
          onTap: () {
          },
          child: Card(
            elevation: 0,
            color: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              Expanded(child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(username),
                trailing: Card(
                  child: GestureDetector(
                    onTap: () async {
                      BasicResponse result = await confirmFriends(username, true);
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.message)),
                        );
                      });

                    },
                    child: SizedBox(
                      width:150,
                      child :ListTile(
                          leading :Image.asset('asset/images/add_account.png',width: 30,),
                          title: Text('Accepter',style: TextStyle(fontSize: 10),)) ,),
                ),),),),
              IconButton(icon: Icon(Icons.clear), onPressed: () async {
                BasicResponse result = await confirmFriends(username, false);
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.message)),
                  );
                });
              },),

    ]),)
      ),
    );

  }
  Widget inputAddFriend(){
    return Flexible(child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: TextField(
          controller: friendUsernameController,
          onChanged: (value) {
            //Future Ajouter recherche Users
          },
          decoration: InputDecoration(
            hintText: "Ajouter un ami !",
//        prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),),
        IconButton(icon: Icon(Icons.search), onPressed: () async {
//          friendUsernameController.clear();
          BasicResponse response = await addFriends(friendUsernameController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        },),

      ],
    ),
    );
  }
  Widget getListPendingInvitations(){
    return  FutureBuilder(
      future: getUserInvitations(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            response = snapshot.data;
            friends = response.friends;
            return Card(

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(itemCount: friends.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return itemFriend("", friends[index].username);
                    },),

                )
            );
          }
          else{
            return Text("Pas d'amis");
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

        title: Text("Ajouter des amis"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          inputAddFriend(),
          SizedBox.fromSize(size: Size(20,20),),
          getListPendingInvitations(),

        ],
      )

    );
  }
}
