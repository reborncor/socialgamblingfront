
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../util/config.dart';

class SocketService {

  IO.Socket socket;
  initialise(String username){
    socket = IO.io(URL, <String, dynamic>{
      'transports': ['websocket'],
      'upgrade':false,
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnecting((data) => print(data));
    socket.onConnect((data) => {
      log("Connected"),
      socket.emit("credentials_game", username),
      socket.emit("credentials_notification",{"username":username, "token" :NOTIFICATION_TOKEN})
    });
    socket.onDisconnect((data) =>  socket.emit("disconnect_user_game", username),);

    socket.onReconnect((data) => log("Reconnected !"));

  }

  onDisconnect(String user){
    // socket.onDisconnect((data) =>  socket.emit("disconnect_user_game", user),);
  }

  onInvitePlayer(){
    
  }
  getSocket(){
    return socket;
  }


}