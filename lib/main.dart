import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialgamblingfront/addfriend/AddFriends.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/menu/Menu.dart';
import 'package:socialgamblingfront/payment/Payment.dart';
import 'package:socialgamblingfront/selectgamble/SelectGamble.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/signup/SignUp.dart';
import 'package:socialgamblingfront/splashscreen/SplashScreen.dart';
import 'package:socialgamblingfront/store/BlodenStore.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/util.dart';

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
        '/tabview': (context) => TabView(),
        '/chat': (context) => Chat(),
        '/selectgame': (context) => SelectGame(),
        '/selectgamble': (context) => SelectGamble(),
        '/signup': (context) => SignUp(),
        '/addfriends': (context) => AddFriends(),
        '/payment' : (context) => Payment(),
        '/store' : (context) => BlodenStore(),


      },
      title: 'Bloden',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.grey[900]
      ),
      home: SplashScreen(),
    );
  }
}

