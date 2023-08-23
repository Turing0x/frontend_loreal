import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_messages.dart';

class ChatRoom extends ConsumerStatefulWidget {
  const ChatRoom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {

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

          noMessages(context)

          // const Expanded(child: ShowList())

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
//   const ShowList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: getAllByRole('colector general'),
//         builder: (context, snapshot) {
          
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return waitingWidget(context);
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return noData(context);
//           }

//           final users = snapshot.data;

//           return ListView.builder(
//             itemCount: users!.length,
//             itemBuilder: (context, index) {
              
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: ListTile(
//                   minLeadingWidth: 20,
//                   title: textoDosis(users[index].username, 18,
//                       fontWeight: FontWeight.bold),
//                   subtitle: textoDosis(users[index].role['name'], 20),
//                   trailing: const Icon(Icons.arrow_right_rounded, color: Colors.black),
//                   onTap: () => Navigator.pushNamed(context, 'chat_page', arguments: [users[index].username]),
                
//                 ),
//               );
          
//             }
          
//           );
        
//         },
//       ),

//     );

//   }

// }