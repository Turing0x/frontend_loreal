import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/server/socket/socket.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/models/Chat/chat_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, 
    required this.username,
    required this.id,
    required this.incomingMessages,
  });

  final String id;
  final String username;
  final List incomingMessages;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  TextEditingController msgCtrl = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];
  String myId = '';
  String myUsername = '';

  @override
  void initState() {

    final sService = SocketServices().socket;

    sService.onConnect((text) {
      sService.on('message', (data) {
        setState(() {
          messages.add(ChatMessage.fromJson(data));
        });
      });
    });

    if( widget.incomingMessages.isNotEmpty ){
      for (var element in widget.incomingMessages) {
        messages.add(element);
      }
    }

    LocalStorage.getUserId().then((value){
      myId = value!;
    });

    super.initState();
  }

  @override
  void dispose() {
    final sService = SocketServices().socket;
    sService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Chat privado con ${widget.username}'),
      body: Column( mainAxisSize: MainAxisSize.min,
        children: [

          messagesList(),

          messageField(),

        ],

      ),

    );

  }

  Flexible messagesList() {
    return Flexible(
      child: ListView.builder(
        itemCount: messages.length,
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: (context, index){
          return Container(
            padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
            child: Align(
              alignment: ( messages[index].messages.messageType == "receiver" )
                ? Alignment.topLeft: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ( messages[index].messages.messageType  == "receiver" )
                    ? Colors.grey.shade200: Colors.blue[200],
                ),
                padding: const EdgeInsets.all(16),
                child: Text(messages[index].messages.msglist, style: const TextStyle(fontSize: 15),),
              ),
            ),
          );
        },
      ),
    );
  }

  Align messageField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
    
            Expanded(
              child: TextField(
                controller: msgCtrl,
                onChanged: (valor) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: "Escribe aquí el mensaje...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none
                ),
              ),
            ),
    
            const SizedBox(width: 15),
            
            FloatingActionButton(
              onPressed: ( msgCtrl.text.isEmpty ) ? null : () {

                _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

                ChatMessage chatMessage = ChatMessage(
                  receiver: UserInfo(
                    id: widget.id, 
                    username: ( myUsername == 'admin' )
                      ? 'Banco' : myUsername
                  ),
                  sender: UserInfo(
                    id: myId, 
                    username: ( myUsername == 'admin' )
                      ? 'Banco' : myUsername
                  ),
                  messages: Messages(
                    messageType: 'receiver', 
                    date: Date(
                      time: todayGlobal, 
                      date: TimeOfDay.now().toString()
                    ), 
                    msglist: msgCtrl.text.trim()
                  )
                );

                SocketServices().socket.emit('message', chatMessage);

                setState(() {
                  messages.add(chatMessage);
                  msgCtrl.text = '';
                });
                
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(Icons.send,color: Colors.white,size: 18,),
            ),
          
          ],
          
        ),

      ),

    );
  }

}