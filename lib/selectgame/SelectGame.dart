import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/GameModel.dart';
import 'package:socialgamblingfront/selectgamble/SelectGamble.dart';

class SelectGame extends StatefulWidget {
  static final routeName = '/selectgame';

  @override
  _SelectGameState createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {

  TextEditingController searchController = new TextEditingController();

  int selectedIndex = 0;
  List<GameModel> games = [];
  GameModel game1 = new GameModel(id: "1", image: "asset/images/donkeykong.jpg", name: "Donkey Kong", description: "Lorem Ipsum");
  GameModel game2 = new GameModel(id: "2", image: "asset/images/mario.jpg", name: "Mario", description: "Lorem Ipsum ....ssdqsds");
  GameModel game3 = new GameModel(id: "3", image: "asset/images/snake.jpg", name: "Snake", description: "Lorem Ipsum");

  Widget cardGame(GameModel gameModel){
    return  InkWell(
        onTap:() {
          print('CLICK');
          Navigator.pushNamed(context, SelectGamble.routeName);
        } ,
        child: Card(
          elevation: 20,
          color: Colors.amber[300],
          shape: RoundedRectangleBorder(
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
              Image(image: AssetImage(gameModel.image), width: 100, height: 100),
              ListTile(

                title: Text(gameModel.name),
                subtitle: Text(gameModel.description),
                trailing: IconButton(icon: Icon(Icons.bookmark), onPressed: () => {},),
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
    games.add(game3);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text("Selection du Jeu"),
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
