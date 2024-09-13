import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/config/globals/variables.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/opt_list_tile.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool openPdf = false;
  bool darkMode = false;
  String textToShow = 'Activar Modo Oscuro';

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      if (value.getBool('openPdf') != null) {
        setState(() {
          openPdf = value.getBool('openPdf')!;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seechUsername = ref.watch(chUser);

    return Scaffold(
      appBar: showAppBar('Ajustes del sistema'),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            optListTile(
                Icons.watch_later_outlined,
                'Horarios de operabilidad',
                'Establece los horarios de acceso',
                () => Navigator.pushNamed(context, 'config_time_page'),
                true),
            optListTile(
                Icons.attach_money_outlined,
                'Sistema de pagos',
                'Establece los pagos por jugada',
                () => Navigator.pushNamed(context, 'payments_page'),
                true),
            optListTile(
                Icons.vertical_align_center_outlined,
                'Límites',
                'Establece los límites de jugadas',
                () => Navigator.pushNamed(context, 'global_limits_page'),
                true),
            optListTile(
                Icons.numbers_outlined,
                'Bolas limitadas',
                'Limitación de bolas (día y noche)',
                () => Navigator.pushNamed(context, 'limited_ball_page'),
                true),
            optListTile(
                Icons.numbers_outlined,
                'Parlés limitados',
                'Limitación de parlés (día y noche)',
                () => Navigator.pushNamed(context, 'limited_parles_page'),
                true),
            optListTile(
                Icons.mode_standby,
                'Raspaito',
                'Revisar esta jugada específica',
                () => Navigator.pushNamed(context, 'million_game_page'),
                true),
            optListTile(
                Icons.warning_amber_outlined,
                'Bote',
                'Hacer un bote de la jugada',
                () => Navigator.pushNamed(context, 'bote_page'),
                true),
            optListTile(
                Icons.security,
                'Firma general',
                'Genera la firma general para la jornada actual',
                () => Navigator.pushNamed(context, 'signature_page'),
                true),
            optListTile(
                Icons.summarize_outlined,
                'Resúmen de listas',
                'Resúmen de listas por rango de fechas',
                () => Navigator.pushNamed(context, 'make_resumen',
                    arguments: [seechUsername]),
                true),
            optListTile(
                Icons.list,
                'Recibo de listas OFFLINE',
                'Guarda en el servidor las listas que recibes vía OFFLINE',
                () => Navigator.pushNamed(context, 'offline_list_control'),
                true),
            optListTile(
                Icons.change_circle_outlined,
                'Cambiar contraseña',
                'Cambiar la clave de acceso al sistema',
                () => Navigator.pushNamed(context, 'change_pass_page'),
                true,
                color: isDark ? Colors.transparent : Colors.grey[200]),
            SwitchListTile(
              value: openPdf,
              onChanged: (value) async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setBool('openPdf', value);

                setState(() {
                  openPdf = value;
                });
              },
              title: Text(
                'Acción sobre vales',
                style: tituloListTile,
              ),
              subtitle: Text('Abrir los vales automáticamente',
                  style: subtituloListTile),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 20),
            cerrarSesionWidget(context),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
