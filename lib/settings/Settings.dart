
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
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
          disabledBorder: BorderRoundedColor(3,Colors.amber[300]),
          border: OutlineInputBorder(),
          labelText: text,

        ),
        //validatePassword,        //Function to check validation
      )
      ,);
  }


  Widget userParametre(UserModel userModel){
    return Column(children: <Widget>[
      paddingTextLabel(userModel.firstName),
      paddingTextLabel(userModel.lastName),
      paddingTextLabel(userModel.email),



      Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 15, bottom: 0),
        child : ElevatedButton(
          style: BaseButtonRoundedColor(200,40,Colors.amber[300]),

          onPressed: () async {
//            await deleteInfo();
            Navigator.popAndPushNamed(context, '/signin' );
          },
          child: Text("Se deconnecter"),
        ),)



    ],);
  }



  @override
  Widget build(BuildContext context) {
    UserModel user = new UserModel(id: 'id', username: 'user00', firstName: 'Thomas', lastName: 'Dubois', email: 'email@mail.com');
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.amber[300],
      ),
      body: Center(
        child:userParametre(user)
      ),
    );
  }
}
