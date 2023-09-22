import 'dart:async';

import 'package:frontend_loreal/models/Chat/sql_message.dart';

import 'bd_messages_provider.dart';

class MessagesBloc {

  final _messageCtrl = StreamController<List<SQLMessage>>.broadcast();

  Stream<List<SQLMessage>> get messageStream => _messageCtrl.stream;

  getAllMessahesOfChat( String chatId ) async {
    _messageCtrl.sink.add(await DBProviderMessages.db.getAllMessages(chatId));
  }

  addMessage({String receiverID = '', String receiver = '', String text = ''}) {
    DBProviderMessages.db.newMessage(text);
  }

  dispose() {
    _messageCtrl.close();
  }
}
