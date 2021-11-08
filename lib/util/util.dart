


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

setOutlineBorder(borderSide, borderRadius, color){
  return
    OutlineInputBorder(
    borderSide: BorderSide(width: borderSide, color: color),
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
BorderRoundedColor(double size, color){
  return OutlineInputBorder(

    // width: 0.0 produces a thin "hairline" border
    borderSide: BorderSide(color: color, width: size),
    borderRadius: BorderRadius.circular(25.0),

  );
}

BaseButtonRoundedColor(double width, double height,color){
  return  ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(width,height)),

      backgroundColor: MaterialStateProperty.all(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: color)
          )
      ));
}
///////////////////////////////////




Future<String> getCurrentUserToken()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.get("token");
  return token;
}
Future<String> getCurrentUserType()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String type = sharedPreferences.get("type");
  return type;
}
deleteInfo() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("token","");
  sharedPreferences.setString("type","");

}
