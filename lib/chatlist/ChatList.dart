import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';

class ChatList extends StatefulWidget {

  final routeName = '/chatlist';

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  Widget itemFriend(String image, String username){
    return Padding(padding: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/chat');
        },
    child: Card(
        elevation: 0,
        color: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: Text(username),
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
        title: Text("Chat"),
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
