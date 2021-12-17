
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialgamblingfront/model/UserModel.dart';
import 'package:socialgamblingfront/response/UserResponse.dart';
import 'package:socialgamblingfront/settings/api.dart';
import 'package:socialgamblingfront/signin/SignIn.dart';
import 'package:socialgamblingfront/util/util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class Setting extends StatefulWidget {

  @override
  SettingState createState() => SettingState();
}


class SettingState extends State<Setting> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();




  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0), // millisecond => minute.
    //onChange: (value) => print('onChange $value'),
    //onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    //onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  @override
  void initState() {
    super.initState();
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
          disabledBorder: BorderRoundedColor(3,Colors.red[700]),
          border: OutlineInputBorder(),
          label: Center(child: Text(text),),
          labelStyle: TextStyle(color: Colors.black87)
        ),
        //validatePassword,        //Function to check validation
      )
      ,);
  }


  Widget userParametre(){
    return FutureBuilder(
      future: getUserInformation(),
      builder: (context, snapshot) {
        stopWatchTimer.clearPresetTime();
      
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasData){
          UserResponse response = snapshot.data;
          if(response.code == 2) Navigator.popAndPushNamed(context, SignIn.routeName);
          UserModel userModel = response.user;

          var userDateOfBan = DateTime.fromMillisecondsSinceEpoch(userModel.dateOfBan);
          var dateToCheck = new DateTime(userDateOfBan.year, userDateOfBan.month, userDateOfBan.day, userDateOfBan.hour+24);
          var moment = DateTime.now();
          var timeLeftHours =(userModel.money == 0) ? (dateToCheck.millisecondsSinceEpoch - moment.millisecondsSinceEpoch).toDouble() : 0;
          var timeLeftPercentage =(userModel.money == 0) ?  (timeLeftHours/86400000).toDouble()*100 : 0;
          log(timeLeftPercentage.toString());
          stopWatchTimer.setPresetTime(mSec:  timeLeftHours.toInt());
          stopWatchTimer.onExecute.add(StopWatchExecute.start);
          return Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 10,top: 10),child: Icon(Icons.account_circle_rounded, size: 100,),),
            paddingTextLabel(userModel.firstName),
            paddingTextLabel(userModel.lastName),
            paddingTextLabel(userModel.email),
            paddingTextLabel(userModel.money.toString()+" Dens"),
            paddingTextLabel("Victoire : "+userModel.wins.toString()+"/"+userModel.games.toString()),
            Padding(padding: const EdgeInsets.all(15),
            child:(userModel.money == 0) ?
                SizedBox(
                child:  Stack(
                children: [
                  Center(
                    child:  Container(
                      width : 200,
                    height: 200,
                    child:CircularProgressIndicator(
                      value: timeLeftPercentage,
                      strokeWidth: 8,
                      color: Colors.red[700],
                    ),
                    ),
                ),
                  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 50),child : Center(child: Text('Temps restant'),)),
                  Center(child: StreamBuilder<int>(
                    stream: stopWatchTimer.rawTime,
                    initialData: stopWatchTimer.rawTime.value,
                    builder: (context, snapshot) {
                      final value = snapshot.data;
                      final displayTime = StopWatchTimer.getDisplayTime(value, hours: true,milliSecond: false);
                      return  Text(
                        displayTime.toString(),
                        style: const TextStyle(
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
              ),)



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

      appBar: AppBar(
        title: Text("Parametre", style: TextStyle(color: Colors.black),),
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.red[700],
      ),
      body: Center(
        child:userParametre()
      ),
    );
  }
}
