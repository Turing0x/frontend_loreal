// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'socket.dart';

final providerOfSocket = StreamProvider.autoDispose((ref) async* {
  StreamController stream = StreamController();

  SocketServices().socket.onerror((err) => print(err));
  SocketServices().socket.onDisconnect((_) => print('disconnect'));

  SocketServices().socket.onerror((_) {
    print("Error IS ${_.toString()}");
  });

  await for (final value in stream.stream) {
    print('stream value => ${value.toString()}');
    yield value;
  }
});
