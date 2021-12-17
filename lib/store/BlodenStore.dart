import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/response/BasicResponse.dart';
import 'package:socialgamblingfront/response/UserResponse.dart';
import 'package:socialgamblingfront/settings/Settings.dart';
import 'package:socialgamblingfront/settings/api.dart';
import 'package:socialgamblingfront/store/BlodenStoreCard.dart';
import 'package:socialgamblingfront/store/api.dart';
import 'package:socialgamblingfront/util/util.dart';

class BlodenStore extends StatefulWidget {
  static final routeName = '/store';

  @override
  _BlodenStoreState createState() => _BlodenStoreState();
}

class _BlodenStoreState extends State<BlodenStore> {

  TextEditingController searchController = new TextEditingController();

  int value = 0;
  List<int> dens = [10,20,50,100];
  int userCurrentDens = 0;

  @override
  initState() {
    fetchData();
    super.initState();
  }

  fetchData() async{
    String response = await getCurrentUserMoney();
    setState(() {
      userCurrentDens = int.parse(response);
    });
  }
  callBack(data){
    setState(() {
      value = data;
    });
  }
  Widget listOfDensToBuy(){
    return  Expanded(child:  ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount :dens.length,
        itemBuilder: (context, index) {
          return BlodenStoreCard(value : dens[index], callBack:callBack);
        })
    );
  }

  buyDensForUser(int amount) async {
    BasicResponse result = await buyDens(amount);
    if(result.code == SUCESS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),

      );
      setState(()  {
        userCurrentDens = userCurrentDens + amount;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.red[700] ,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                  child: Row( children: [
                    Icon(Icons.store,color: Colors.black,size: 30,),
                    Text(userCurrentDens.toString()+' Dens', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),)
                  ]

                  ),
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
          title: Text("Boutique",style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          color: Colors.white70,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              listOfDensToBuy(),

              ElevatedButton(
                  style: BaseButtonRoundedColor(60,40,Colors.red[700]),
                  onPressed: (){buyDensForUser(value);}, child: Text('Acheter Maintenant : $value'))
            ],
          ),
        )
    );
  }
}
