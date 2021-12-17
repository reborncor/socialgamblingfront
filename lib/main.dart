import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialgamblingfront/addfriend/AddFriends.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/menu/Menu.dart';
import 'package:socialgamblingfront/selectgamble/SelectGamble.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/signup/SignUp.dart';
import 'package:socialgamblingfront/splashscreen/SplashScreen.dart';
import 'package:socialgamblingfront/tab/TabView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {



//    connectToServer();
    return MaterialApp(

      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signin': (context) => SignIn(),
        '/menu': (context) => Menu(),
        '/tabview': (context) => TabView(),
        '/chat': (context) => Chat(),
        '/selectgame': (context) => SelectGame(),
        '/selectgamble': (context) => SelectGamble(),
        '/signup': (context) => SignUp(),
        '/addfriends': (context) => AddFriends(),

      },
      title: 'Bloden',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white70
      ),
      home: SplashScreen(),
    );
  }
}

