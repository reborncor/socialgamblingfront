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


class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  Brightness _brightness;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }

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
        primaryColor: Colors.white,
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        canvasColor: Colors.white,

      ),
      darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          backgroundColor: Colors.grey[900]
      ) ,
      themeMode: _brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}

