import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/MessageModel.dart';

class Chat extends StatefulWidget {

  final routeName = '/chat';

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  List<MessageModel> messages = [];
  MessageModel message1 = new MessageModel(id: "1", content: "Salut ca va ? ", receiverId: "2",senderId: "1" ,time: "" );
  MessageModel message2 = new MessageModel(id: "2", content: "Oui et toi ?", receiverId: "1",senderId: "2", time: "");
  MessageModel message3 = new MessageModel(id: "3", content: "On joue ?", receiverId: "2", senderId: "1", time :"");


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

    messages.add(message1);
    messages.add(message2);
    messages.add(message3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],

        title: Text("Chat"),
      ),
      body: Center(

          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return itemMessage(messages[index]);
            },
          )

      ),

    );
  }
}
