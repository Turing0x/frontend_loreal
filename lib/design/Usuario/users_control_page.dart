import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Usuario/user_show_model.dart';

String prioriRole = '';
final userCtrl = UserControllers();

class UserControlPage extends ConsumerStatefulWidget {
  const UserControlPage(
      {super.key,
      required this.username,
      required this.actualRole,
      required this.idToSearch});

  final String idToSearch;
  final String username;
  final String actualRole;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserControlPageState();
}

class _UserControlPageState extends ConsumerState<UserControlPage> {
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
            onPressed: () =>
                Navigator.pushNamed(context, 'bancos_control_page'),
            icon: const Icon(Icons.person_add_alt_1_outlined)),
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
          Expanded(
              child: ShowList(
            idToSearch: widget.idToSearch,
          ))
        ]),
      ),
    );
  }

  Column columnTop() {
    return Column(
      children: [
        ListTile(
          iconColor: (isDark) ? Colors.white : Colors.black,
          leading: const Icon(
            Icons.person_outline_outlined,
            size: 30,
          ),
          title: textoDosis(widget.username, 28, fontWeight: FontWeight.w600),
          subtitle: textoDosis(widget.actualRole, 16),
          trailing: OutlinedButton.icon(
              icon: Icon(
                Icons.add_circle_outline,
                color: (isDark) ? Colors.white : Colors.black,
                size: 20,
              ),
              label: textoDosis('Nuevo usuario', 16),
              onPressed: () => Navigator.pushNamed(context, 'new_user_page',
                  arguments: [widget.username])),
        ),
        Visibility(
          visible: widget.actualRole == 'Banco',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: textoDosis('Acceso al sistema', 18),
              trailing: btnEnable(widget.idToSearch, !toEditState.value),
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  ElevatedButton btnEnable(String id, bool enable) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                (toEditState.value) ? Colors.red[200] : Colors.blue[200]),
        onPressed: () async {
          await userCtrl.editOneEnable(id, enable);
          LocalStorage().statusBlockSave(!toEditState.value);
          setState(() {
            toEditState.value = !toEditState.value;
          });
        },
        child: textoDosis((toEditState.value) ? 'Bloquear' : 'Permitir', 18));
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

                if (users!.every((element) => element.enable)) {
                  toEditState.value = true;
                } else if (users.every((element) => !element.enable)) {
                  toEditState.value = false;
                }

                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        minLeadingWidth: 20,
                        title: textoDosis(users[index].username, 18,
                            fontWeight: FontWeight.bold),
                        subtitle: textoDosis(users[index].role['name'], 20),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            btnResetPassword(context, users[index].id),
                            btnHisPayments(
                                context,
                                users[index].id,
                                users[index].username,
                                users[index].role['code']),
                            btnHisLimits(context, users[index].id,
                                users[index].username),
                            btnEnable(users[index].id, users[index].enable)
                          ],
                        ),
                        onTap: () {
                          if (users[index].role['code'] != 'listero') {
                            setState(() {
                              Navigator.pushNamed(context, 'user_control_page',
                                  arguments: [
                                    users[index].username,
                                    users[index].role['name'],
                                    users[index].id
                                  ]);
                            });
                          }
                        },
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
          }),
    );
  }

  IconButton btnResetPassword(BuildContext context, String id) {
    return IconButton(
        icon: const Icon(
          Icons.lock_reset_outlined,
          color: Colors.red,
        ),
        onPressed: () => showInfoDialog(
                context,
                'Reestablecer contraseña',
                Text(
                    'Estás seguro que deseas reestablecer la contraseña de acceso al sistema este usuario?',
                    style: subtituloListTile), (() {
              userCtrl.resetPass(id);
              Navigator.pop(context);
            })));
  }

  IconButton btnHisPayments(
      BuildContext context, String id, String username, String role) {
    return IconButton(
        icon: const Icon(
          Icons.payment_outlined,
          color: Colors.green,
        ),
        onPressed: () => Navigator.pushNamed(context, 'payments_page_users',
            arguments: [id, username, role]));
  }

  IconButton btnHisLimits(BuildContext context, String id, String username) {
    return IconButton(
        icon: const Icon(
          Icons.label_important_outline_sharp,
          color: Colors.blue,
        ),
        onPressed: () => Navigator.pushNamed(context, 'limits_page_users',
            arguments: [id, username]));
  }

  Switch btnEnable(String id, bool enable) {
    bool state = enable;
    return Switch(
      value: state,
      onChanged: (value) async {
        await userCtrl.editOneEnable(id, value);
        setState(() {
          state = value;
        });
      },
    );
  }
}
