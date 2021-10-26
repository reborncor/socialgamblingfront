import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/menu/Menu.dart';
import 'package:socialgamblingfront/util/util.dart';

class SignIn extends StatefulWidget {

  static final routeName = '/signin';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget inputUserData(){
    return Center(
      child:Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.all(16),
                child:   TextFormField(

                  decoration: InputDecoration(
                    enabledBorder: setOutlineBorder(5.0, 25.0, Colors.indigo),
                    focusedBorder: setOutlineBorder(5.0, 25.0, Colors.indigo),
                    border: setOutlineBorder(5.0, 25.0, Colors.indigo),
                    hintText: 'Username',
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  focusedBorder: setOutlineBorder(5.0, 25.0, Colors.indigo),
                  enabledBorder: setOutlineBorder(5.0, 25.0, Colors.indigo),
                  border:setOutlineBorder(5.0, 25.0, Colors.indigo),
                  hintText: 'Password',
                ),
              ),)
            ,
            Padding(padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, Menu.routeName);
                },
                child: Text('Se connecter'),
              ),)
          ],
        ),

      ) ,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Connexion utilisateur"),
      ),
      body: Center(

        child: inputUserData()
      ),
      );
  }
}
