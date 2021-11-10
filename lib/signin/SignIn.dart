import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/signin/api.dart';
import 'package:socialgamblingfront/signup/SignUp.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SignIn extends StatefulWidget {

  static final routeName = '/signin';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  IO.Socket socket;

  init(){

    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'query': {"chatId" : "test"},
      'upgrade':false,
    });
    log("Test");
    socket.onConnecting((data) => print(data));

    socket.onConnect((data) => {
      log("Connected"),
      socket.emit("new_message","test")
    });
  }



  @override
  initState(){

    super.initState();

  }
  Widget inputUserData(){
    return Center(
      child:Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.all(16),
                child:   TextFormField(
                  controller: usernameController,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Entre votre nom d'utilisateur";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    border: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                    hintText: 'Username',
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrer un mot de passe";
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  focusedBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                  enabledBorder: setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                  border:setOutlineBorder(5.0, 25.0, Colors.amber[300]),
                  hintText: 'Password',
                ),
              ),)
            ,
            Padding(padding: EdgeInsets.all(12),
              child: ElevatedButton(
                style: BaseButtonRoundedColor(60,40,Colors.amber[300]),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    var result =  await signinUser(usernameController.text, passwordController.text);

                    if(result.code ==  0){
                      Navigator.pushNamed(context, TabView.routeName);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(result.message)),
                      );
                    }

                  }

                },
                child: Text('Se connecter'),
              ),),
             ElevatedButton(
                style: BaseButtonRoundedColor(60,40,Colors.amber[300]),
                onPressed: ()  {
                      Navigator.pushNamed(context, SignUp.routeName);
                },
                child: Text("S'inscrire"),
              )
          ],
        ),

      ) ,
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
//      appBar: AppBar(
//         backgroundColor: Colors.amber[300],
//        title: Text("Connexion utilisateur"),
//      ),
      body: Center(

        child: inputUserData()
      ),
      );
  }
}
