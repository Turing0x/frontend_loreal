import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Usuario/user_show_model.dart';

final userCtrl = UserControllers();
class BanksControlPage extends ConsumerStatefulWidget {
  const BanksControlPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BanksControlPageState();
}

class _BanksControlPageState extends ConsumerState<BanksControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Control de Bancos', actions: [
        IconButton(
            onPressed: () {
              syncUserControl.value = !syncUserControl.value;
            },
            icon: const Icon(Icons.refresh_outlined))
      ]),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        onPressed: () => Navigator.pushNamed(context, 'new_banco_page'),
        label: const Row(children: [
          Icon(Icons.add_box_outlined, color: Colors.white),
          SizedBox(width: 10),
          Text('Nuevo banco')
        ]),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: ValueListenableBuilder<bool>(
            valueListenable: syncUserControl,
            builder: (_, __, ___) => showList()),
      ),
    );
  }

  FutureBuilder<List<User>> showList() {

    return FutureBuilder(
      future: userCtrl.getAllBanks(),
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingWidget(context);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return noData(context);
        }

        final users = snapshot.data;
        return ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) {
              return ListTile(
                minLeadingWidth: 20,
                leading: Icon(Icons.person_outline_outlined,
                    color: (!isDark) ? Colors.black : Colors.white),
                title: textoDosis(users[index].username, 18,
                    fontWeight: FontWeight.bold),
                subtitle: textoDosis(users[index].role['name'], 20),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    btnEnable(context, users[index].id, users[index].username,
                        users[index].enable)
                  ],
                ),
                onLongPress: () {
                  showInfoDialog(
                      context,
                      'Confirmar eliminación del usuario',
                      Text(
                          'Se eliminará el usuario ${users[index].username}. Seguro desea hacerlo?',
                          style: subtituloListTile), (() {
                    userCtrl.deleteOne(users[index].id);
                    syncUserControl.value = !syncUserControl.value;
                    Navigator.pop(context);
                  }));
                },
              );
            });
      },
    );
  }

  Switch btnEnable(
      BuildContext context, String id, String username, bool enable) {
    bool state = enable;
    return Switch(
      value: state,
      onChanged: (value) {
        showInfoDialog(
            context,
            'Confirmar acción',
            Text(
                'Se inhabilitará el acceso al sistema al usuario $username. Seguro desea hacerlo?',
                style: subtituloListTile), (() {
          userCtrl.editOneEnable(id, value);
          setState(() {
            state = value;
          });
          Navigator.pop(context);
        }));
      },
    );
  }
}
