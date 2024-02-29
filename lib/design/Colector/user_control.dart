import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Usuario/user_show_model.dart';

String prioriRole = '';

class UserControlPageColector extends ConsumerStatefulWidget {
  const UserControlPageColector(
      {super.key,
      required this.username,
      required this.actualRole,
      required this.idToSearch});

  final String idToSearch;
  final String username;
  final String actualRole;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserControlPageColectorState();
}

class _UserControlPageColectorState
    extends ConsumerState<UserControlPageColector> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initInfoUser = ref.read(toCreateUser.notifier);
      if (initInfoUser.state == 'a, b') {
        initInfoUser.state = widget.username;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Control de usuarios', actions: [
        IconButton(
            onPressed: () {
              syncUserControl.value = !syncUserControl.value;
            },
            icon: const Icon(Icons.refresh_outlined))
      ]),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: [
          columnTop(),
          const SizedBox(height: 20),
          Expanded(child: ShowList(idToSearch: widget.idToSearch))
        ]),
      ),
    );
  }

  Column columnTop() {
    return Column(
      children: [
        ListTile(
          iconColor: Colors.black,
          leading: const Icon(
            Icons.person_outline_outlined,
            size: 30,
          ),
          title: textoDosis(widget.username, 28, fontWeight: FontWeight.w600),
          subtitle: textoDosis(widget.actualRole, 16),
          trailing: OutlinedButton.icon(
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: 20,
              ),
              label: textoDosis('Nuevo usuario', 16),
              onPressed: () => Navigator.pushNamed(
                  context, 'create_user_for_colector',
                  arguments: [widget.username])),
        ),
        const Divider(
          color: Colors.black,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}

class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key, required this.idToSearch});

  final String idToSearch;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {
  @override
  Widget build(BuildContext context) {

    final userCtrl = UserControllers();

    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: syncUserControl,
          builder: (_, __, ___) {
            return FutureBuilder(
              future: userCtrl.getAllUsers(id: widget.idToSearch),
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
                        leading: const Icon(Icons.person_outline_outlined,
                            color: Colors.black),
                        title: textoDosis(users[index].username, 18,
                            fontWeight: FontWeight.bold),
                        subtitle: textoDosis(users[index].role['name'], 20),
                        trailing: (users[index].role['code'] == 'listero')
                            ? btnEnable(context, users[index].id,
                                users[index].username, users[index].enable)
                            : const Icon(Icons.arrow_right_rounded,
                                color: Colors.black, size: 30),
                        onTap: () {
                          if (users[index].role['code'] != 'listero') {
                            setState(() {
                              Navigator.pushNamed(
                                  context, 'user_control_page_colector',
                                  arguments: [
                                    users[index].username,
                                    users[index].role['name'],
                                    users[index].id
                                  ]);
                            });
                          }
                        },
                        onLongPress: () {
                          final userCtrl = UserControllers();

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
          }),
    );
  }

  Switch btnEnable(
      BuildContext context, String id, String username, bool enable) {
        final userCtrl = UserControllers();
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
