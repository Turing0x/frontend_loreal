import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../server/http/auth.dart';

class MainBanqueroPage extends ConsumerStatefulWidget {
  const MainBanqueroPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainBanqueroPageState();
}

class _MainBanqueroPageState extends ConsumerState<MainBanqueroPage> {
  String mainID = '';
  String userName = '';

  @override
  void initState() {
    final chUsername = ref.read(chUser.notifier);
    final setIdToSearch = ref.read(idToSearch.notifier);

    AuthServices.getStatusBlock().then((value) {
      if (value != null) {
        toEditState.value = bool.parse(value);
      }
    });

    final username = AuthServices.getUsername();
    username.then((value) {
      userName = value!;
      chUsername.state = value;
    });

    final userID = AuthServices.getUserId();
    userID.then((value) {
      mainID = value!;
      setIdToSearch.state = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seechUsername = ref.watch(chUser);

    return Scaffold(
        appBar: showAppBar('Página principal', actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, 'main_settigns_banco'),
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          onPressed: () => Navigator.pushNamed(context, 'sorteos_page'),
          label: const Row(children: [
            Icon(Icons.sports_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text('Añadir sorteo')
          ]),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 10),
            dinamicGroupBox('Revisión de cargados', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  btnBolaCargada(context),
                  btnParleCargado(context),
                  btnBote(context),
                ],
              ),
              const SizedBox(height: 15),
            ]),
            optListTile(
                Icons.mode_standby,
                'Raspaito',
                'Revisar esta jugada específica',
                () => Navigator.pushNamed(context, 'million_game_page'),
                true),
            optListTile(
                Icons.groups_outlined,
                'Equipo de trabajo',
                'Control total sobre los usurios del sistema',
                () => Navigator.pushNamed(context, 'user_control_page',
                    arguments: [userName, 'Banco', mainID]),
                true),
            optListTile(
                Icons.list,
                'Control de listas',
                'Visualiza y controla todas las listas en el servidor',
                () => Navigator.pushNamed(context, 'list_control_page',
                    arguments: [seechUsername, mainID]),
                true),
            optListTile(
                Icons.sd_storage_outlined,
                'Almacenamiento interno',
                'Listas y vales guardados en el teléfono',
                () => Navigator.pushNamed(context, 'internal_storage_page'),
                true),
            optListTile(
                Icons.money_off_csred_outlined,
                'Recogida a colecciones',
                'Lleva la cuenta de la deuda pendiente de cada colección',
                () => Navigator.pushNamed(context, 'colectors_debt_page'),
                true),
            optListTile(
                Icons.chat_bubble_outline_outlined,
                'Sala de chat',
                'Chat interno con los colectores registrados',
                () => Navigator.pushNamed(context, 'chat_room'),
                true),
          ],
        )));
  }

  GestureDetector btnBote(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'bote_page'),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_outlined),
            textoDosis('Bote', 15)
          ],
        ),
      ),
    );
  }

  GestureDetector btnParleCargado(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'parle_cargada_page'),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.format_list_numbered_outlined),
            textoDosis('Parlés', 15)
          ],
        ),
      ),
    );
  }

  GestureDetector btnBolaCargada(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'bola_cargada_page'),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_baseball_outlined),
            textoDosis('Bolas', 15)
          ],
        ),
      ),
    );
  }
}
