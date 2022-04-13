
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

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

    socket.onReconnect((data) => {log("Reconnected !") , socket.emit("credentials_game", username)}, );

  }

  onDisconnect(String user){
    // socket.onDisconnect((data) =>  socket.emit("disconnect_user_game", user),);
  }

  Disconnect(){
    socket.disconnect();
  }

  onInvitePlayer(String invitedPlayer, String game, String currentUsername, String gamble, String key){

    socket.emit("invitation_game",{"username":"beta", "game" : game, "key" : key, "currentUsername" : currentUsername,"gamble" :gamble});
  }

  onInitGameSession(String username, String key){
    socket.emit("init_game_session",{"username":"beta", "key" : key,});

  }
  getSocket(){
    return socket;
  }


}