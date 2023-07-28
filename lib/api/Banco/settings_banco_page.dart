import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils_exports.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool openPdf = false;
  @override
  void initState() {
    RUpgrade.stream.listen((DownloadInfo info) {
      ref.read(release.notifier).actualizarState(
            info: info,
          );
    });

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
      appBar: showAppBar('Ajustes del sistema', actions: [
        buscarActualziacionWidget(context),
      ]),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            optListTile(
                Icons.security,
                'Firma general',
                'Genera la firma general para la jornada actual',
                () => Navigator.pushNamed(context, 'signature_page'),
                true),
            optListTile(
                Icons.list,
                'Recibo de listas OFFLINE',
                'Guarda en el servidor las listas que recibes vía OFFLINE',
                () => Navigator.pushNamed(context, 'offline_list_control'),
                true),
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
            optListTile(
                Icons.change_circle_outlined,
                'Cambiar contraseña',
                'Cambiar la clave de acceso al sistema',
                () => Navigator.pushNamed(context, 'change_pass_page'),
                true,
                color: Colors.grey[200]),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            cerrarSesionWidget(context),
          ],
        ),
      )),
    );
  }
}
