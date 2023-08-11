import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/api/MakePDF/toServer/pdf_data_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'socket.dart';

final socketProvider = Provider(SocketServices.new);

class SocketServices {
  
  final ProviderRef ref;
  Socket get _socketClient => ref.read(socketClientProvider).socket!;
  final socketResponse = StreamController<Payments>();

  SocketServices(this.ref) {
    //
  }
  
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

}