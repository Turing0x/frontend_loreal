// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

final socketClientProvider = Provider((_) => SocketServices());

class SocketServices {

  late final socket_io.Socket? socket;

  socketClient() {
    socket = socket_io.io(dotenv.env['SERVER_URL']!, {
      'transports': ['websocket'],
      'autoConnect': true
    });
    socket!.connect();
  }

}