import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/riverpod/providers_socket.dart';
import 'package:frontend_loreal/utils_exports.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {

  @override
  Widget build(BuildContext context) {

    final sockeServise = ref.watch(socketService);
  
    return Scaffold(
      appBar: showAppBar('Sala de chat', actions: [
        const IconButton(
          onPressed: null, 
          icon: Icon(Icons.add, color: Colors.white,))
      ]),
      body: Column(
        children: [

          Padding(
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
          ),

        ],
      ),
    );
  
  }

}