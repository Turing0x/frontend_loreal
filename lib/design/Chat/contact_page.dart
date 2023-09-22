import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/models/Usuario/user_show_model.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {

  List<User> contacts = [];
  TextEditingController findCtrl = TextEditingController();

  @override
  void initState() {

    final userCtrl = UserControllers();

    LocalStorage.getUserId().then((value) {
      userCtrl.getMyPeople( value! ).then(
        (value) {
          setState(() {
            contacts = value;
          });
        });
    });
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message_outlined),
        onPressed: (){},
      ),
      appBar: showAppBar('Vista de contactos'),
      body: Column(
        children: [
      
          txtBuscar(),
      
          const SizedBox(height: 20),
      
          Expanded(child: ShowList(list: contacts))
      
        ],
      
      ),

    );
  
  }

  Padding txtBuscar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Encuentre un usuario...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          ),
        ),
      ),
    );
  }

}

class ShowList extends StatelessWidget {
  const ShowList({super.key, 
    required this.list});

  final List<User> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ( list.isEmpty )
        ? noData(context)
        : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                minLeadingWidth: 20,
                title: textoDosis(list[index].username, 18,
                    fontWeight: FontWeight.bold),
                subtitle: textoDosis('Toque para abrir la conversación', 16),
                trailing: const Icon(Icons.arrow_right_rounded, color: Colors.black),
                onTap: () => Navigator.pushNamed(context, 'chat_page', arguments: [
                  list[index].id,
                  list[index].username, []]),
              
              ),
            );
          }
        
        )
    );

  }

}