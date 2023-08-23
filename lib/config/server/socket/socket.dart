// ignore_for_file: constant_identifier_names, avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

final socketClientProvider = Provider((_) => SocketServices());

class SocketServices {

  late socket_io.Socket _socket;

  socket_io.Socket get socket => _socket;

  SocketServices(){ _initConfig(); }

  void _initConfig(){

    _socket = socket_io.io(dotenv.env['SERVER_SOCKET']!, {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.on('connect', ( _ ) {
      print('conectado');
    });

    _socket.on('disconnect', ( _ ) {
      print('desconectado');
    });
    
  }

}