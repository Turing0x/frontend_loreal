import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/server/socket/socket.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

class ChatRoom extends ConsumerStatefulWidget {
  const ChatRoom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {

    final sService = SocketServices().socket;

    LocalStorage.getUserId().then((value){
      sService.emit('sign', value);
    });

    sService.on('messageList', (data) {
      if( (data as List).isNotEmpty ){
        setState(() {
          for( var _ in data ){
            // messages.add({
            //   'username': msg.,
            //   'last': msg,
            // });
          }
        });
      }
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message_outlined),
        onPressed: () => Navigator.pushNamed(context, 'contact_page'),
      ),
      appBar: showAppBar('Sala de chat'),
      body: Column(
        children: [

          txtBuscar(),

          const SizedBox(height: 20),

          // ( messages.isEmpty )
          //   ? noMessages(context)
          //   : Expanded(child: ShowList(messages: messages))

        ],

      ),

    );
  
  }

  Padding txtBuscar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
      ),
    );
  }

}

// class ShowList extends StatelessWidget {
//   const ShowList({super.key,
//     required this.messages});

//   final List<List<ChatMessage>> messages;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: messages.length,
//         itemBuilder: (context, index) {
          
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: ListTile(
//               minLeadingWidth: 20,
//               title: textoDosis(messages[index].senderUsername, 18,
//                   fontWeight: FontWeight.bold),
//               subtitle: textoDosis(messages.last.text, 20),
//               trailing: const Icon(Icons.arrow_right_rounded, color: Colors.black),
//               onTap: () => Navigator.pushNamed(context, 'chat_page', 
//                 arguments: [
//                   messages[index].sender,
//                   messages[index].senderUsername,
//                   messages
//                 ]),
            
//             ),
//           );
      
//         }
      
//       )

//     );

//   }

// }