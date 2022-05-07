import 'dart:developer';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:socialgamblingfront/model/GameModel.dart';

import '../selectgamble/SelectGamble.dart';

class SelectGame extends StatefulWidget {
  static final routeName = '/selectgame';
  final String username;

  const SelectGame({this.username});

  @override
  _SelectGameState createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {

  TextEditingController searchController = new TextEditingController();

  int selectedIndex = 0;
  List<GameModel> games = [];
  GameModel game1 = new GameModel(id: "1", image: "asset/images/unity.png", name: "Quiz", description: "Répondez à un maximum de question pour remporter la partie");
  GameModel game2 = new GameModel(id: "2", image: "asset/images/light_up.png", name: "LightUp", description: "Jeu d'arccade. L'objectif est d'éclater les ballons blancs");
  final tooltipController = JustTheController();




  @override
  initState(){
    super.initState();

  }

  Widget cardGame(GameModel gameModel){
    return  InkWell(
        onTap:() async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectGamble(username:widget.username ,game:gameModel.name ,)));

          // log(result.toString());

        } ,
        child: Card(
          elevation: 20,
          color:  Colors.red[700],
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: 300,
            minWidth: 100,
            maxWidth: 100,
          ),
          child:  Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:  Image(image: AssetImage(gameModel.image), fit: BoxFit.fitHeight, height: 100),),
              ListTile(

                title: Text(gameModel.name),
                subtitle: Text(gameModel.description, overflow: TextOverflow.ellipsis,),
                trailing: IconButton(icon: Icon(Icons.info), tooltip: gameModel.description, onPressed: () {
                },
                ),
              ),
            ],
          ),
        )
    )
      );
  }


  @override
  Widget build(BuildContext context) {
    games.clear();
    games.add(game1);
    games.add(game2);
    // games.add(game3);
    return Scaffold(

        appBar: AppBar(
          leading: BackButton(color: Colors.black,),
          backgroundColor: Colors.red[700] ,
          title: Text("Selection du Jeu",style: TextStyle(color: Colors.black)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            gridOfGame(games.length)
          ],
        )
    );
  }

  Widget gridOfGame(int itemCount) {
    return Expanded(child: GridView.builder(
      itemCount: itemCount,

      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 9 / 10,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemBuilder: (context, index) {
        return cardGame(games[index]);



    },
    ));


  }
}
