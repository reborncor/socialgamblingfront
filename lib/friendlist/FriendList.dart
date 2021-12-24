
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialgamblingfront/addfriend/AddFriends.dart';
import 'package:socialgamblingfront/addfriend/api.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/friendlist/api.dart';
import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/util/util.dart';

class FriendList extends StatefulWidget {

  final routeName = '/friendlist';

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> with WidgetsBindingObserver{
  FriendsResponse response;
  List<FriendModel> friends = [];

  TextEditingController moneyToSendController = TextEditingController();
  Brightness _brightness;


  bool isDarkMode = false;
  fetchData() async {
    bool result = await getIsDarkMode();
    setState(() {
      isDarkMode = result;
    });
  }
  @override
  initState(){
    fetchData();
    WidgetsBinding.instance?.addObserver(this);
    _brightness = WidgetsBinding.instance?.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }


  Widget showMoneyToSendDialog(BuildContext context, String receiverUsername) {
    return new AlertDialog(
      backgroundColor: Colors.grey[50],
      title: Text("Envoyer des Dens à $receiverUsername"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children : <Widget>[
            ElevatedButton(
              style : BaseButtonRoundedColor(60,40,Colors.amber),
                onPressed: (){moneyToSendController.text = (int.parse(moneyToSendController.text)-1).toString();}, child: Text('-',style: TextStyle(color: Colors.black))),
            Expanded(child: TextField(
              textAlign: TextAlign.center,
                controller: moneyToSendController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ])),
            ElevatedButton( style : BaseButtonRoundedColor(60,40,Colors.amber),
                onPressed: (){moneyToSendController.text = (int.parse(moneyToSendController.text)+1).toString();}, child: Text('+',style: TextStyle(color: Colors.black),)),

          ]

          ),

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
        ElevatedButton(
          style: BaseButtonRoundedColor(60,40,Colors.amber),
          onPressed: () async {
            var result = await sendMoneyToFriends(receiverUsername, int.parse(moneyToSendController.text));
            if(result.code == SUCESS){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result.message)),
              );
              Navigator.pop(context);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result.message)),
              );
            }
          },
          child: Text("Envoyer",style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
  Widget itemFriend(String image, String username){
    return Padding(padding: EdgeInsets.all(2),
      child: Card(
        elevation: 0,
        color: Colors.red[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat.withUsername(receiverUsername: username,)),
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_circle, size: 30,),
                  Padding(padding: EdgeInsets.all(10)
                    ,child: Text(username,style: TextStyle(fontSize: 15),),)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(onPressed: (){
                  showDialog(context: context, builder: (context) => showMoneyToSendDialog(context, username));
                }, icon: Icon(Icons.toll, size: 30, color: Colors.red[700])),
                IconButton(icon: Icon(Icons.videogame_asset, size: 30), color: Colors.red[700], onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectGame()),
                  );

                },)
              ],)

          ],
        ),
      )
       ,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : null,
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
                    setState(() {
                      isDarkMode = data as bool;
                    });
                  }catch(e){
                    fetchData();
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
      body: FutureBuilder(
        future: getUserFriends(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
                response = snapshot.data;
                if(response.code == BAN ||response.code == NOT_CONNECTED) Navigator.pushReplacementNamed(context,SignIn.routeName);
                friends = response.friends;
                return Center(

                  child: (friends.length == 0 ) ?
                  ElevatedButton(
                    style: BaseButtonRoundedColor(100.0,50.0,Colors.red[50]),
                      onPressed: () => Navigator.push(context,  MaterialPageRoute(builder: (context) => AddFriends()),),
                      child: Text("Ajouter des amis !",style: TextStyle(color: Colors.black),),)
                      :ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return itemFriend('image', friends[index].username);
                    },
                  )
                );
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
