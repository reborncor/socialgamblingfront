import 'dart:developer';

import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialgamblingfront/confirmgame/ConfirmGame.dart';
import 'package:socialgamblingfront/model/GameModel.dart';
import 'package:socialgamblingfront/util/util.dart';

class SelectGamble extends StatefulWidget {
  static final routeName = '/selectgamble';
  final String username;

  const SelectGamble({Key key, this.username}) : super(key: key);

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
  List<String> gambles = ['10','20','30','40','50'];
  List<String> gamblesPalier = ['0-10','11-20','21-30','31-40','41-50'];
  List<String> pyramidGambles = ['50','40','30','20','10'];
  TextEditingController moneyToSendController = TextEditingController();

  String selectedValue = "";

  final List<ChartData> chartData = [
    ChartData('Palier 5', 100, Colors.greenAccent),
    ChartData('Palier 4', 50, Colors.red),
    ChartData('Palier 3', 30,Colors.greenAccent),
    ChartData('Palier 2', 20,Colors.greenAccent),
    ChartData('Palier 1', 10,Colors.greenAccent)

  ];

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
             Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.red[700], width: 3.0),

                   shape: BoxShape.circle,
                 ),
                 child:  CircleList(

               origin: Offset(-65, 60),
               innerRadius: 5,
               children: List.generate(10, (index) {
                 int value = index+palier-9;
                 return InkWell(
                   customBorder:  RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Text(value.toString(), style: TextStyle(fontSize: 30, color: Colors.red[700]),), onTap: (){setState(() {
                   setState(() {
                     log('$selectedValue');
                     selectedValue = value.toString();
                     moneyToSendController.text = value.toString();
                   });
                 });},);
               }),
             ))
            ])),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[


          ElevatedButton(
            style: BaseButtonRoundedColor(60,40,Colors.red[700]),
            onPressed: () async {
              Navigator.pop(context, selectedValue);
            },
            child: Text("Annuler",),
          ),
          Container(width : 50, child: TextField(
            onChanged: (value) => setState((){
              selectedValue = moneyToSendController.text;
            }),
              style: TextStyle(fontSize: 25, color: Colors.amber),
              textAlign: TextAlign.center,
              controller: moneyToSendController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ]),),
          ElevatedButton(
            style: BaseButtonRoundedColor(60,40,Colors.amber),
            onPressed: () async {
              setState((){
                selectedValue = moneyToSendController.text;
              });
              Navigator.pop(context, selectedValue);
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
            selectedValue = gambles[niveau];
            moneyToSendController.text =  gambles[niveau];
          });
          showDialog(
            context: context,
            builder: (context) => showSelectDensDialog(context, int.parse(gambles[niveau])),
          ).then((value) => {
            setState((){
              this.selectedValue = value as String;
            })
          });
        } ,
        child: Card(
          elevation: 30.0,
            color: Colors.red[700] ,
          // shadowColor: Colors.amber,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 2.0),

            borderRadius: BorderRadius.circular(50),
          ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(gamble, style: TextStyle(fontSize: 40),),
                  Card(elevation: 10.0, color: Colors.red[700],child: Text('Palier '+(niveau+1).toString(), style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold ),)),
                ],
            )
        )
    );
  }

  void sendInvitation() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmGame(userGamble: int.parse(this.selectedValue), username: widget.username,)),);
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

              // pyramidOfGamble(),
            gridOfGamble(gambles.length),
            ElevatedButton(
                style: BaseButtonRoundedColor(200,40,Colors.red[700]),
                onPressed: () {
                  if(this.selectedValue != ""){
                    sendInvitation();
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Veuillez selectionner un montant à parier")),
                    );
                  }

            }, child: Text("Confirmer : $selectedValue Dens"))
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
        return cardGame(gamblesPalier[index], index);



      },
    ));


  }



}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}