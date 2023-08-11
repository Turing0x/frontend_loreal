import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/Chat/models/chat_status.dart';
import '../server/socket/socket_methods.dart';

final dataProvider = StateNotifierProvider<DataProvider, ChatStatus>(DataProvider.new);

final socketService = StreamProvider((ref) {
  final ss = ref.read(socketProvider);

  return ss.socketResponse.stream;
});

class DataProvider extends StateNotifier<ChatStatus> {
  final StateNotifierProviderRef ref;
  bool isCreator = false;
  DataProvider(this.ref) : super(ChatStatus()) {
    
  }
  SocketServices get _socketServices => ref.read(socketProvider);
  
}
