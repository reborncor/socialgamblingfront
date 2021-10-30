import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';

class FriendList extends StatefulWidget {

  final routeName = '/friendlist';

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  Widget itemFriend(String image, String username){
    return Padding(padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: <Widget>[
              GestureDetector(
                onTap: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => SignIn()),
//            );

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
              Icon(Icons.videogame_asset, size: 30,)
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
      body: Center(

          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return itemFriend('image', 'User numero :'+index.toString());
          },
          )

      ),

    );
  }
}
