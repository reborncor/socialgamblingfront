import 'package:flutter/material.dart';
import 'package:socialgamblingfront/menu/Menu.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/splashscreen/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signin': (context) => SignIn(),
        '/menu': (context) => Menu(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

