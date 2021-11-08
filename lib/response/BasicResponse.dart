import 'dart:core';



class BasicResponse<T>{

  int code;
  String message;
  T payload ;

  BasicResponse({ this.code,this.message, this.payload});




}


