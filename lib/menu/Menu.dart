import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialgamblingfront/model/GameModel.dart';
import 'package:socialgamblingfront/model/ThemeModel.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
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
  GameModel game1 = new GameModel(id: "1", image: "asset/images/unity.png", name: "Quiz", description: "Répondez à un maximum de question pour remporter la partie");
  GameModel game2 = new GameModel(id: "2", image: "asset/images/light_up.png", name: "LightUp", description: "Jeu d'arccade. L'objectif est d'éclater les ballons blancs");

  GameModel game3 = new GameModel(id: "2", image: "asset/images/image-1.png", name: "Prochainement", description: "Jeu disponible à la prochaine version...");
  GameModel game4 = new GameModel(id: "2", image: "asset/images/image-2.png", name: "Prochainement", description: "Jeu disponible à la prochaine version...");

  ThemeModel themeNotifier;


  @override
  initState(){
    super.initState();
  }
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
              ClipRRect( 
                borderRadius: BorderRadius.circular(20),
                child:  Image(image: AssetImage(gameModel.image), fit: BoxFit.fitHeight, height: 180),),
              ListTile(

                title: Text(gameModel.name),
                subtitle: Padding(padding : EdgeInsets.only(bottom: 8, top : 4),child : Text(gameModel.description)),
                trailing: IconButton(icon: Icon(Icons.download), onPressed: () => {
                      redirectTo(gameModel.name, context)

                },),
              ),
            ],
          )
      ),
    ),);
  }

  Widget listOfGame(){
    return  ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount :games.length,
        itemBuilder: (context, index) {
          return cardGame(games[index]);
        });
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
          Text(gameModel.description, style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
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
    games.clear();
    games.add(game1);
    games.add(game2);
    games.add(game3);
    games.add(game4);

    return Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child) {
      this.themeNotifier = themeNotifier;

      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:Colors.red[700]  ,
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {

                      try{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Setting()),
                        );
                      }catch(e) {

                      }

                    },
                    child: Icon(
                      Icons.account_circle,color: Colors.black,size: 30,
                    ),
                  )
              ),

            ],
            title: Text("Menu",style: TextStyle(color: Colors.black)),
          ),
          body:   listOfGame()
      );
    },);
  }
}
