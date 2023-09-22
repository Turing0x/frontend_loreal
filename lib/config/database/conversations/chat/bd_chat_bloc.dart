import 'dart:async';

import 'package:frontend_loreal/models/Chat/sql_chat.dart';

import 'bd_chat_provider.dart';

class ChatBloc {
  static final ChatBloc _singleton = ChatBloc._internal();

  factory ChatBloc() {
    return _singleton;
  }

  ChatBloc._internal() {
    getAllChats();
  }

  final _chatCtrl = StreamController<List<SQLChat>>.broadcast();

  Stream<List<SQLChat>> get messageStream => _chatCtrl.stream;

  getAllChats() async {
    _chatCtrl.sink.add(await DBProviderChat.db.getAllChats());
  }

  addChat({String receiverID = '', String receiver = '', String text = ''}) {
    DBProviderChat.db.newChat(receiverID, receiver);
    getAllChats();
  }

  deleteMessage(String id) {
    DBProviderChat.db.chatDelete(id);
    getAllChats();
  }

  dispose() {
    _chatCtrl.close();
  }
}
