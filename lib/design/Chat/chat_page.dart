import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:frontend_loreal/config/server/socket/socket.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/models/Chat/chat_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, 
    required this.username,
    required this.id
  });

  final String id;
  final String username;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  TextEditingController msgCtrl = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];
  String myId = '';

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

    AuthServices.getUserId().then((value){
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
              alignment: ( messages[index].messageType == "receiver" )
                ? Alignment.topLeft: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ( messages[index].messageType  == "receiver" )
                    ? Colors.grey.shade200: Colors.blue[200],
                ),
                padding: const EdgeInsets.all(16),
                child: Text(messages[index].text, style: const TextStyle(fontSize: 15),),
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

                SocketServices().socket.emit('message', ChatMessage(
                  messageType: 'receiver',
                  sender: widget.id, 
                  senderUsername: 'Banco',
                  receiver: widget.id, 
                  receiverUsername: widget.username,
                  date: Date(
                    date: todayGlobal, 
                    time: TimeOfDay.now().toString()), 
                  text: msgCtrl.text.trim()
                ));

                setState(() {
                  messages.add(
                    ChatMessage(
                      senderUsername: 'Banco',
                      receiverUsername: widget.username,
                      messageType: 'sender',
                      receiver: widget.id, 
                      sender: myId,
                      date: Date(
                        date: todayGlobal, 
                        time: TimeOfDay.now().toString()), 
                      text: msgCtrl.text.trim()
                    )
                  );

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