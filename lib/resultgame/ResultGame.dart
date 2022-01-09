
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socialgamblingfront/addfriend/AddFriends.dart';


import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';


class ResultGame extends StatefulWidget {

  final routeName = '/resultgame';

  @override
  _ResultGameState createState() => _ResultGameState();
}

class _ResultGameState extends State<ResultGame> with WidgetsBindingObserver{
  StreamController<dynamic> streamController =  StreamController();
  bool isUserReady = false;
  bool isPlayerReady = false;
  int timeLeft = 15;
  Timer everysecond;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    everysecond = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        if(this.mounted){
          setState(() {
            timeLeft =  timeLeft - 1;
          });
        }

      }catch(e){
        print(e);
      }

    });


    super.initState();


  }
  fetchData(){
    streamController.add("event");
    streamController.close();
    delayedQuit();
  }

  delayedQuit(){
    Future.delayed(const Duration(milliseconds: 15000), () {
      Navigator.pushReplacementNamed(context, TabView.routeName);

    });
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

        title: Text("Resultat de la partie",style: TextStyle(color: Colors.black)),
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
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Image(image : AssetImage('asset/images/user.png'), width: 100, height: 100,),
                    Text("Victoire", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),) ,
                    Text("Username",style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.green,
                          width: 3
                        )
                      ),
                      child :Text("50 Dens",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)) ,
                    ),
                    Text("Gain : + 20",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)) ,
                  ])
                  ),
                  Padding(padding: EdgeInsets.all(20) , child : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Text("Revanche :",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                        style: BaseButtonRoundedColor(75,40,Colors.green[700]),

                        onPressed: () {},
                        child: Text("Oui")),
                    ElevatedButton(
                        style: BaseButtonRoundedColor(75,40,Colors.red[700]),

                        onPressed: () {
                          Navigator.pushNamed(context, TabView.routeName);
                        },
                        child: Text("Non")),
                    Text(timeLeft.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))

                  ],))


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
