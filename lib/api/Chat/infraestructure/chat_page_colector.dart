import 'package:frontend_loreal/server/http/auth.dart';
import 'package:frontend_loreal/server/socket/socket.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPageColector extends StatefulWidget {
  const ChatPageColector({super.key});

  @override
  State<ChatPageColector> createState() => _ChatPageColectorState();
}

class _ChatPageColectorState extends State<ChatPageColector> {

  TextEditingController msgCtrl = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];

  @override
  void initState() {

    final sService = SocketServices().socket;

    AuthServices.getUserId().then((value){
      sService.emit('sign', value);
    });

    sService.onConnect((data) {
      sService.on('message', (data) {
        setState(() {

          messages.add(
            ChatMessage(
              messageContent: data,
              messageType: 'receiver'));
        });
      });
    });
    
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: showAppBar('Chat interno'),
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
                child: Text(messages[index].messageContent, style: const TextStyle(fontSize: 15),),
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
                  duration: const Duration(milliseconds: 100), curve: Curves.easeOut);

                SocketServices().socket.emit('message', {
                  'targetId': '6442c99299ec608e0267b63a',
                  'data': msgCtrl.text.trim()
                });

                setState(() {

                  messages.add(ChatMessage(
                    messageContent: msgCtrl.text.trim(), 
                    messageType: "sender"));

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

class ChatMessage{
  final String messageContent;
  final String messageType;
  ChatMessage({ required this.messageContent, required this.messageType});
}