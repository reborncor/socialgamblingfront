import 'dart:developer';

import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/GameModel.dart';
import 'package:socialgamblingfront/util/util.dart';

class SelectGamble extends StatefulWidget {
  static final routeName = '/selectgamble';

  @override
  _SelectGambleState createState() => _SelectGambleState();
}

class _SelectGambleState extends State<SelectGamble> {

  TextEditingController searchController = new TextEditingController();

  int selectedIndex = 0;
  List<GameModel> games = [];
  GameModel game1 = new GameModel(id: "1", image: "asset/images/donkeykong.jpg", name: "Donkey Kong", description: "Lorem Ipsum");
  GameModel game2 = new GameModel(id: "2", image: "asset/images/mario.jpg", name: "Mario", description: "Lorem Ipsum ....ssdqsds");
  GameModel game3 = new GameModel(id: "3", image: "asset/images/snake.jpg", name: "Snake", description: "Lorem Ipsum");
  List<String> gambles = ['10','20','30','50','100'];
  String selectedValue = "";

  @override
  initState(){
    super.initState();
  }

  Widget showSelectDensDialog(BuildContext context, int palier) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        title: Text("Selectioner la somme à parier"),
        content: Container(
            height: 300,
            width: double.maxFinite,
            child: Stack(children: <Widget>[
              Center( child: Text(selectedValue, style: TextStyle(fontSize: 40, color: Colors.amber),),),
              CircleList(
                origin: Offset(-60, 50),
                innerRadius: 5,
                children: List.generate(10, (index) {
                  int value = index+palier;
                  return InkWell(child: Text(value.toString(), style: TextStyle(fontSize: 30, color: Colors.red[700]),), onTap: (){setState(() {
                    setState(() {
                      log('$index');
                      selectedValue = value.toString();
                    });
                  });},);
                }),
              )
            ])),
        actions: <Widget>[
          ElevatedButton(
            style: BaseButtonRoundedColor(60,40,Colors.red[700]),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text("Annuler",),
          ),
          ElevatedButton(
            style: BaseButtonRoundedColor(60,40,Colors.amber),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text("Ok",),
          ),
        ],
      );
    },);
  }
  Widget cardGame(String gamble, int niveau){

    return  InkWell(
        onTap:() {
          setState(() {
            selectedValue = gamble;
          });
          showDialog(context: context, builder: (context) => showSelectDensDialog(context, int.parse(gamble)),);
        } ,
        child: Card(
          elevation: 20,
          color: Colors.red[700] ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(gamble, style: TextStyle(fontSize: 40),),
                  Text('Palier '+niveau.toString()),
                ],
            )
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    games.clear();
    games.add(game1);
    games.add(game2);
    games.add(game3);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor:  Colors.red[700],
          title: Text("Selection du Palier",style: TextStyle(color: Colors.black),),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            gridOfGamble(gambles.length)
          ],
        )
    );
  }

  Widget gridOfGamble(int itemCount) {
    return Expanded(child: GridView.builder(
      itemCount: itemCount,

      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 10 / 10,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemBuilder: (context, index) {
        return cardGame(gambles[index], index);



      },
    ));


  }
}
