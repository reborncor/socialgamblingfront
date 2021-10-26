import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';

class SplashScreen extends StatefulWidget {

  final routeName = 'splashscreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Splash"),
      ),
      body: Center(

        child: ElevatedButton(child: Text('Accueil'),
          onPressed:() {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => SignIn()),
//            );
          Navigator.pushNamed(context, SignIn.routeName);
          }
        )
      ),

    );
  }
}
