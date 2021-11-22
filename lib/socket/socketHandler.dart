import 'dart:developer';

import 'package:socialgamblingfront/util/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


void connectToServer() {

  IO.Socket socket = IO.io('http://localhost:3000');
  log("check");

  socket.on('connection', (data) => log("Connexion"));
  socket.on('event', (data) => print(data));
  socket.on('fromServer', (_) => print(_));
}
