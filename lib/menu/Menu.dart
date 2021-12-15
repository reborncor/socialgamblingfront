import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/GameModel.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/store/BlodenStore.dart';
import 'package:socialgamblingfront/util/util.dart';

class Menu extends StatefulWidget {
   static final routeName = '/menu';

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  TextEditingController searchController = new TextEditingController();

  int selectedIndex = 0;
  List<GameModel> games = [];
  GameModel game1 = new GameModel(id: "1", image: "asset/images/donkeykong.jpg", name: "Donkey Kong", description: "Lorem Ipsum");
  GameModel game2 = new GameModel(id: "2", image: "asset/images/mario.jpg", name: "Mario", description: "Lorem Ipsum");
  GameModel game3 = new GameModel(id: "3", image: "asset/images/snake.jpg", name: "Snake", description: "Lorem Ipsum");
  Widget headerApp(){
    return Container(
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          child: Row(
            children: <Widget>[
              Text('Amis', style: TextStyle(fontSize: 20),),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        TextButton(onPressed: (){}, style: ElevatedButton.styleFrom(fixedSize: Size(150,30)), child: Text('Chat', style: TextStyle(fontSize: 20),),)

      ],
     ),
    );
  }
  Widget cardGame(GameModel gameModel){
    return  Padding(padding: EdgeInsets.all(16),
    child: InkWell(
      onTap: () {
        showDialog(context: context, builder:(context) => showGameDialog(context,gameModel));
      },
      child: Card(
          elevation: 20,
          color: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),

          child: Column(
            children: [
              Image(image: AssetImage(gameModel.image)),
              ListTile(

                title: Text(gameModel.name),
                subtitle: Text(gameModel.description),
                trailing: IconButton(icon: Icon(Icons.bookmark), onPressed: () => {},),
              ),
            ],
          )
      ),
    ),);
  }

  Widget listOfGame(){
    return Expanded(child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount :3,
        itemBuilder: (context, index) {
          return cardGame(games[index]);
        })
    );
  }
  Widget searchFriend(){
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "chercher un ami !",
        suffixIcon: InkWell(
          onTap: () => searchController.clear(),
          child: Icon(Icons.search),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget showGameDialog(BuildContext context, GameModel gameModel) {
    return new AlertDialog(
      title: Text(gameModel.name),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(gameModel.description),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: BaseButtonRoundedColor(60,40,Colors.red[700]),

          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text("Fermer",style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    games.add(game1);
    games.add(game2);
    games.add(game3);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[700] ,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  BlodenStore()),
                  );

                },
                child: Icon(
                  Icons.store,color: Colors.black,size: 30,
                ),
              )
          ),
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
                    Icons.account_circle,color: Colors.black,size: 30,
                ),
              )
          ),

        ],
        title: Text("Menu",style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
//          headerApp(),
//          searchFriend(),
          listOfGame()
        ],
      )
    );
  }
}
