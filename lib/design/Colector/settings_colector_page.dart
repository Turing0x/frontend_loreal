import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/opt_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsColectorPage extends ConsumerStatefulWidget {
  const SettingsColectorPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsColectorPageState();
}

class _SettingsColectorPageState extends ConsumerState<SettingsColectorPage> {
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
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            optListTile(
                Icons.change_circle_outlined,
                'Cambiar contraseña',
                'Cambiar la clave de acceso al sistema',
                () => Navigator.pushNamed(context, 'change_pass_page'),
                true,
                color: Colors.grey[200]),
            const SizedBox(height: 10),
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
      )),
    );
  }
}
