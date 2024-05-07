import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/opt_list_tile.dart';

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

    LocalStorage.getStatusBlock().then((value) {
      if (value != null) {
        toEditState.value = bool.parse(value);
      }
    });

    final username = LocalStorage.getUsername();
    username.then((value) {
      userName = value!;
      chUsername.state = value;
    });

    final userID = LocalStorage.getUserId();
    userID.then((value) {
      mainID = value!;
      setIdToSearch.state = value;
    });

    AdaptiveTheme.getThemeMode().then((value){
      if(value!.isDark){
        setState(() {
          isDark = true;
        });
      }
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
            Text('Añadir sorteo', style: TextStyle(color: Colors.white),)
          ]),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 10),
            dinamicGroupBox('Cargados y Bote', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customBolaBtn(context, 
                    onTap: () => Navigator.pushNamed(context, 'bola_cargada_page'), 
                    icon: Icons.sports_baseball_outlined, 
                    text: 'Bolas'),
                  customBolaBtn(context, 
                    onTap: () => Navigator.pushNamed(context, 'parle_cargada_page'), 
                    icon: Icons.format_list_numbered_outlined, 
                    text: 'Parlés')
                ],
              ),
              const SizedBox(height: 15),
            ]),
            optListTile(
                Icons.groups_outlined,
                'Equipo de trabajo',
                'Control total sobre los usurios del sistema',
                () => Navigator.pushNamed(context, 'user_control_page',
                    arguments: [userName, 'Banco', mainID]),
                true),
            optListTile(
                Icons.attach_money_rounded,
                'Solo Premio',
                'Ver las jugadas que dieron premio',
                () => Navigator.pushNamed(context, 'only_winners'),
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
                true)

          ],
        )));
  }

  GestureDetector customBolaBtn(BuildContext context, {
    void Function()? onTap,
    IconData? icon,
    String text = '',
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: (!isDark) ? Colors.blue[100] : const Color(0xff282828),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            textoDosis(text, 15, color: (isDark) ? Colors.white : Colors.black)
          ],
        ),
      ),
    );
  }
}
