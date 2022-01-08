
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socialgamblingfront/addfriend/AddFriends.dart';


import 'package:socialgamblingfront/settings/Settings.dart';


class ConfirmGame extends StatefulWidget {

  final routeName = '/confirmgame';

  @override
  _ConfirmGameState createState() => _ConfirmGameState();
}

class _ConfirmGameState extends State<ConfirmGame> with WidgetsBindingObserver{
  StreamController<dynamic> streamController =  StreamController();
  bool isUserReady = false;
  bool isPlayerReady = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
  fetchData(){
    streamController.add("event");
    streamController.close();
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
              child: IconButton(
                icon: Image.asset('asset/images/add_account.png',width: 30, height: 30,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AddFriends()),
                  );
                },
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {

                  try{
                    final data = await Navigator.push(
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

        title: Text("Mes amis",style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  flex: 0,
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width : 175,child:
                        Column(children: [
                          Image(image : AssetImage('asset/images/add_account.png'), width: 50, height: 50,),
                          Text("Username") ,
                          Text("50") ,])),
                        Text("VS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                        Container(width : 200,child:
                        Column(children: [
                          Image(image : AssetImage('asset/images/add_account.png'), width: 50, height: 50,),
                          Text("Username") ,
                          Text("50") ,])),
                      ],)),
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Visibility(child:Icon(Icons.check,size: 20,color: Colors.green,), visible: isUserReady,),
                      Visibility(child:Icon(Icons.check,size: 20,color: Colors.green,), visible: isPlayerReady,),
                    ],
                  ),
                  Text("Commencer",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 70),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {
                        setState(() {
                          this.isUserReady = true;
                        });}, child: Text('Oui')),

                      ElevatedButton(onPressed: () {

                        setState(() {
                          this.isUserReady = false;
                        });
                      }, child: Text('Non')),


                    ],
                  ),

                ],)

              ],);
            }
            else{
              return Center(child :Text("Pas de données"));
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
