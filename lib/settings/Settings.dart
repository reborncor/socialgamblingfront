
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/UserResponse.dart';
import 'package:socialgamblingfront/settings/api.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class Setting extends StatefulWidget with WidgetsBindingObserver {

  @override
  SettingState createState() => SettingState();
}


class SettingState extends State<Setting> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  StreamController<UserResponse> streamController = StreamController();
  UserResponse response = UserResponse();


  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0), // millisecond => minute.
    //onChange: (value) => print('onChange $value'),
    //onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    //onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  bool isDarkMode = false;
  int test = 0;
  bool isDark = false;

  fetchData() async {

    bool result = await getIsDarkMode();
    response = await getUserInformation();
    setState(() {
      isDarkMode = result;
      streamController.add(response);
      streamController.close();
    });
  }
  @override
  void initState() {

    super.initState();
    fetchData();

  }

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose();
  }

  Widget paddingTextLabel(String text){
    return  Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 15.0, top: 15, bottom: 0),
      child: TextField(
        enabled: false,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, ),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          disabledBorder: BorderRoundedColor(3,isDarkMode ?  Colors.white : Colors.red[700]),
          border: OutlineInputBorder(),
          label: Center(child: Text(text),),
          labelStyle: TextStyle(color: getUserStatusColors(text, isDarkMode) )
        ),
        //validatePassword,        //Function to check validation
      )
      ,);
  }


  Widget userParametre(){
    Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    isDark = brightnessValue == Brightness.dark;

    return StreamBuilder<dynamic>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        stopWatchTimer.clearPresetTime();
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasData){
          UserResponse response = snapshot.data;
          if(response.code == 2) Navigator.popAndPushNamed(context, SignIn.routeName);
          UserModel userModel = response.user;

          DateTime userDateOfBan = DateTime.fromMillisecondsSinceEpoch(userModel.dateOfBan * 1000);

          var dateToCheck = new DateTime(userDateOfBan.year, userDateOfBan.month, userDateOfBan.day, userDateOfBan.hour+24);
          var moment = DateTime.now();
          var timeLeftHours =(userModel.dateOfBan != 0) ? (dateToCheck.millisecondsSinceEpoch - moment.millisecondsSinceEpoch).toDouble() : 0;
          var timeLeftPercentage = (userModel.dateOfBan != 0) ?  (timeLeftHours/86400000).toDouble()*100 : 0;
          // log(timeLeftPercentage.toString());
          stopWatchTimer.setPresetTime(mSec:  timeLeftHours.toInt());
          stopWatchTimer.onExecute.add(StopWatchExecute.start);
          return  ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 10,top: 10),child: Icon(Icons.account_circle_rounded, size: 100,),),
              paddingTextLabel(userModel.firstName),
              paddingTextLabel(userModel.lastName),
              paddingTextLabel(userModel.email),
              paddingTextLabel(userModel.money.toString()+" Dens"),
              paddingTextLabel(getUserStatus(userModel.money)),
              paddingTextLabel("Victoire : "+userModel.wins.toString()+"/"+userModel.games.toString()),

              Padding(padding: const EdgeInsets.all(15),
                  child:(userModel.dateOfBan != 0.0) ?
                  SizedBox(
                    child:  Stack(
                      children: [
                        Center(
                          child:  Container(
                            width : 200,
                            height: 200,
                            child:CircularProgressIndicator(
                              value: (100-timeLeftPercentage)/100,
                              strokeWidth: 8,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 50),child : Center(child: Text('Temps restant', style: TextStyle(color:isDarkMode ?  Colors.white : Colors.red[700] ),),)),
                        Center(child: StreamBuilder<int>(
                          stream: stopWatchTimer.rawTime,
                          initialData: stopWatchTimer.rawTime.value,
                          builder: (context, snapshot) {
                            final value = snapshot.data;
                            final displayTime = StopWatchTimer.getDisplayTime(value, hours: true,milliSecond: false);
                            return  Text(
                              displayTime.toString(),
                              style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.red[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            );
                          },

                        ),)
                      ],
                    ),
                    height: 200,
                    width: 200,
                  ) : null
              ) ,

              Padding(padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Dark Mode", style: TextStyle( fontSize : 15, fontWeight : FontWeight.bold, color: isDarkMode ? Colors.white: Colors.black),),
                    Switch(
                      value: isDark,
                      inactiveTrackColor: Colors.grey,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.red[700],
                      onChanged: (bool value) =>
                          setState(() {
                            // log(value.toString());
                        isDark = value;
                        // brightnessValue = Brightness.light;

                          }),
                    ),
                  ],
                )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child : ElevatedButton(
                  style: BaseButtonRoundedColor(200,40,Colors.red[700]),

                  onPressed: () async {
                    Navigator.pushNamed(context, '/payment' );
                  },
                  child: Text("Parametre de paiement"),
                ),),

              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child : ElevatedButton(
                  style: BaseButtonRoundedColor(200,40,Colors.red[700]),

                  onPressed: () async {
                    await deleteInfo();
                    Navigator.pushReplacementNamed(context, '/signin' );
                  },
                  child: Text("Se deconnecter"),
                ),),




            ],);
        }
        else{
          return Center(child: Text("Pas de donnée"),);
        }
      }
      else return Center(child: Text("Chargement en cours"),);
    },);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: isDarkMode ? Colors.grey[900] : null,
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text("Parametre", style: TextStyle(color: Colors.black),),
        leading: BackButton(
          color: Colors.black,
          onPressed:() {
            Navigator.pop(context,isDarkMode);
          },
        ),

      ),
      body:
      Center(child:userParametre() )

    );
  }
}
