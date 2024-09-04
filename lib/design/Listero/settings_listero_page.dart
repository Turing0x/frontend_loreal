import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/opt_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsListeroPage extends ConsumerStatefulWidget {
  const SettingsListeroPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsListeroPageState();
}

class _SettingsListeroPageState extends ConsumerState<SettingsListeroPage> {
  TextEditingController newPass = TextEditingController();

  bool directSend = false;
  bool autoFocus = false;
  bool showTime = false;
  bool openPdf = false;

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
    return Scaffold(
      appBar: showAppBar('Ajustes del sistema'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            optListTile(
                Icons.change_circle_outlined,
                'Cambiar contraseña',
                'Cambiar la clave de acceso al sistema',
                () => Navigator.pushNamed(context, 'change_pass_page'),
                true,
                color: Colors.grey[200]),
            optListTile(
                Icons.link_off_outlined,
                'Clave Offline',
                'Establecer contraseña para el módulo Offline',
                () => Navigator.pushNamed(context, 'config_off_page'),
                true),
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
            const SizedBox(height: 10),
            cerrarSesionWidget(context),
          ],
        ),
      ),
    );
  }
}
