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
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 2), () {
      setState(() {
        Navigator.pushNamed(context, SignIn.routeName);
      });

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
//      appBar: AppBar(
//
//        title: Text("Splash"),
//      ),
      body: Center(

        child: CircularProgressIndicator(
          color: Colors.amber[300],
          semanticsLabel: 'Nom du Jeu',
        )
      ),

    );
  }
}
