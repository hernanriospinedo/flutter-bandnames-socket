import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Ofline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    //Dart client
    //socket_io_client 0.9.10
    //provider 4.3.1
    this._socket = IO.io('http://192.168.43.79:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    //socket.connect();

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      //socket.emit('msg', 'test');
    });

    this._socket.on('disconnet', (_) {
      this._serverStatus = ServerStatus.Ofline;
      notifyListeners();
    });

    // Dart client
    this._socket.on('connect', (_) {
      print('connect');
    });
    this._socket.on('event', (data) => print(data));
    this._socket.on('disconnect', (_) => print('disconnect'));
    this._socket.on('fromServer', (_) => print(_));

    // add this line
    this._socket.connect();

    /* socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje:');
      print('nombre:' + payload['nombre']);
      print('nombre:' + payload['mensaje']);
      print(payload.containsKey('mensaje2') ? payload['mensaje'] : 'no hay');
    });*/
  }
}
