

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:socialgamblingfront/addfriend/AddFriends.dart';
import 'package:socialgamblingfront/chat/Chat.dart';
import 'package:socialgamblingfront/confirmgame/ConfirmGame.dart';
import 'package:socialgamblingfront/menu/Menu.dart';
import 'package:socialgamblingfront/payment/Payment.dart';
import 'package:socialgamblingfront/resultgame/ResultGame.dart';
import 'package:socialgamblingfront/selectgamble/SelectGamble.dart';
import 'package:socialgamblingfront/selectgame/SelectGame.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/signup/SignUp.dart';
import 'package:socialgamblingfront/socketService/HttpService.dart';
import 'package:socialgamblingfront/socketService/SocketService.dart';
import 'package:socialgamblingfront/splashscreen/SplashScreen.dart';
import 'package:socialgamblingfront/store/BlodenStore.dart';
import 'package:socialgamblingfront/tab/TabView.dart';
import 'package:socialgamblingfront/util/config.dart';
import 'package:socialgamblingfront/util/util.dart';

import 'model/ThemeModel.dart';


final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {

  await setUpEnv();
  runApp(MyApp());
}

setUpEnv() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage((message) => firebaseMessagingBackgroundHandler(message) );
  FirebaseMessaging _firebaseMessaging =FirebaseMessaging.instance;
  NOTIFICATION_TOKEN = await _firebaseMessaging.getToken();

  socketService = createSocket();
  FirebaseMessaging.instance.getInitialMessage().then((value) => {});
  socketService.initialise();
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message received");

    print(event.notification.title);
    print(event.notification.body);
    //
    var eventType = event.data['eventType'];
    if (eventType == "EVENT_GAME"){
      var customKey = event.data['customToken'];
      var gamble = event.data['gamble'];
      var username = event.data['username'];
      var gameName = event.data['gameName'];
      showMyDialog(event.notification.title,event.notification.body,username, gamble, customKey, gameName );
    }


  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
    print("message clicked");

    print(event.category);

    print(event.notification.title);
    print(event.notification.body);
    var eventType = event.data['eventType'];
    if (eventType == "EVENT_GAME"){
      var customKey = event.data['customToken'];
      var gamble = event.data['gamble'];
      var username = event.data['username'];
      var gameName = event.data['gameName'];
      showMyDialog(event.notification.title,event.notification.body,username, gamble, customKey, gameName );
    }


  }
  );





  URL = dotenv.get('API_URL', fallback: 'API_URL N/A');
  STRIPE_KEY = dotenv.get('STRIPE_KEY', fallback: 'STRIPE_KEY N/A');
  Stripe.publishableKey = STRIPE_KEY;

  HttpOverrides.global = MyHttpOverrides();


}

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//
//   print("Handling a background message");
// }

void showMyDialog(String title, String text, String username, String gamble, String customKey, String gameName) {
  showDialog(
      context: navigatorKey.currentContext,
      builder: (context) => Center(
        child:AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton( style: BaseButtonRoundedColor(60,40,Colors.amber),onPressed: () => navigateTo(context, ConfirmGame.invited(username: username,userGamble: int.parse(gamble), isInvited: true, customKey : customKey, gameName: gameName,)), child: Text("Accepter")),
            ElevatedButton( style: BaseButtonRoundedColor(60,40,Colors.amber), onPressed: () => Navigator.pop(context), child: Text("Refuser"))
          ],
        )
      )
  );
}

class MyApp extends StatelessWidget  {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {



    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
            return MaterialApp(

              routes: {
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
                '/confirmgame' : (context) => ConfirmGame(),
                '/resultgame' : (context) => ResultGame(),




              },
              title: 'Bloden',

              theme: ThemeData.light(),
              darkTheme  : ThemeData(
                  brightness: Brightness.dark,
                  primaryColorDark: Colors.black,
                  indicatorColor: Colors.white,
                  backgroundColor: Colors.grey[900],
                  iconTheme: IconThemeData(color: Colors.black),
                  textTheme: TextTheme(
                   bodyText1: TextStyle(color: Colors.black),
                      bodyText2: TextStyle(color: Colors.black),
                    headline1: TextStyle(color: Colors.black),
                    headline2: TextStyle(color: Colors.black),
                    caption: TextStyle(color: Colors.black),
                    subtitle1: TextStyle(color: Colors.black),


                  )

              ) ,
              themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
              home: SplashScreen(),
              navigatorKey: navigatorKey,
            );
          }),
    );


  }
}

