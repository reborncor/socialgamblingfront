
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialgamblingfront/addfriend/api.dart';
import 'package:socialgamblingfront/model/FriendModel.dart';
import 'package:socialgamblingfront/model/ThemeModel.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/FriendsResponse.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/util/util.dart';

class AddFriends extends StatefulWidget {

  final routeName = '/addfriends';

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  FriendsResponse response;
  List<FriendModel> friends = [];
  TextEditingController friendUsernameController = TextEditingController();

  ThemeModel themeNotifier;


  Widget itemFriend(String image, String username){
    return Padding(padding: EdgeInsets.all(8),
          child: Card(
            color: Colors.red[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              Expanded(child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.black,),
                title: Text(username),
                trailing: Card(
                  color: Colors.green[100],
                  child: GestureDetector(
                    onTap: () async {
                      BasicResponse result = await confirmFriends(username, true);
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.message)),
                        );
                      });

                    },
                    child: SizedBox(
                      width:150,
                      child :ListTile(
                          leading :Image.asset('asset/images/add_account.png',width: 30,),
                          title: Text('Accepter',style: TextStyle(fontSize: 10),)) ,),
                ),),),),
              IconButton(icon: Icon(Icons.clear, color: Colors.black,), onPressed: () async {
                BasicResponse result = await confirmFriends(username, false);
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.message)),
                  );
                });
              },),

    ]),)

    );

  }
  Widget inputAddFriend(){
    return Flexible(child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextField(
          style: TextStyle(color: themeNotifier.isDark ? Colors.white : Colors.black),

          controller: friendUsernameController,
          onChanged: (value) {
            //Future Ajouter recherche Users
          },
          decoration: InputDecoration(
            focusedBorder: setOutlineBorder(3.0, 25.0, ),
            enabledBorder: setOutlineBorder(3.0, 25.0, ),
            border:setOutlineBorder(3.0, 25.0, ),
            hintText: "Ajouter un ami !",
            prefixIcon: IconButton(icon :Icon(Icons.clear, color: themeNotifier.isDark ? Colors.white : Colors.black,), onPressed: () => friendUsernameController.clear(),),

          ),
        ),),
        IconButton(icon: Icon(Icons.search, color: themeNotifier.isDark ? Colors.white : Colors.black,), onPressed: () async {
//          friendUsernameController.clear();
          BasicResponse response = await addFriends(friendUsernameController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        },),

      ],
    ),
    );
  }
  Widget getListPendingInvitations(){
    return  FutureBuilder(
      future: getUserInvitations(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            response = snapshot.data;
            friends = response.friends;
            return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(itemCount: friends.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return itemFriend("", friends[index].username);
                    },),
            );
          }
          else{
            return Text("Vous avez aucun amis");
          }
        }
        else{
          return Center(

              child: CircularProgressIndicator(
                color:Colors.red[700] ,
              )
          );
        }
      },

    );
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeModel>(builder: (context, ThemeModel themeNofitier, child) {
      this.themeNotifier = themeNofitier;
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: BackButton(
              color: Colors.black,
            ),
            backgroundColor:Colors.red[700] ,
            actions: <Widget>[
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

            title: Text("Ajouter des amis",style: TextStyle(color: Colors.black)),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox.fromSize(size: Size(20, 20),),
              inputAddFriend(),
              SizedBox.fromSize(size: Size(20,20),),
              getListPendingInvitations(),

            ],
          )

      );
    },);
  }
}
