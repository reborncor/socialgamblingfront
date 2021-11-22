
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/UserResponse.dart';
import 'package:socialgamblingfront/settings/api.dart';
import 'package:socialgamblingfront/util/util.dart';


class Setting extends StatefulWidget {

  @override
  SettingState createState() => SettingState();
}


class SettingState extends State<Setting> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Widget paddingTextLabel(String text){
    return  Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 15.0, top: 15, bottom: 0),
      child: TextField(
        enabled: false,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, ),
        decoration: InputDecoration(
          disabledBorder: BorderRoundedColor(3,Colors.red[700]),
          border: OutlineInputBorder(),
          labelText: text,

        ),
        //validatePassword,        //Function to check validation
      )
      ,);
  }


  Widget userParametre(){
    return FutureBuilder(
      future: getUserInformation(),
      builder: (context, snapshot) {
      
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasData){
          UserResponse response = snapshot.data;
          UserModel userModel = response.user;
          return Column(children: <Widget>[
            paddingTextLabel(userModel.firstName),
            paddingTextLabel(userModel.lastName),
            paddingTextLabel(userModel.email),



            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child : ElevatedButton(
                style: BaseButtonRoundedColor(200,40,Colors.red[700]),

                onPressed: () async {
//            await deleteInfo();
                  Navigator.popAndPushNamed(context, '/signin' );
                },
                child: Text("Se deconnecter"),
              ),)



          ],);
        }
        else{
          return Center(child: Text("Pas de donnée"),);
        }
      }
      else return Center(child: Text("Chargement en cours"),);
    },);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.red[700],
      ),
      body: Center(
        child:userParametre()
      ),
    );
  }
}
