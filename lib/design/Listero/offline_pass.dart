import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/simple_txt.dart';

class ConfigOfflinePass extends StatefulWidget {
  const ConfigOfflinePass({super.key});

  @override
  State<ConfigOfflinePass> createState() => _ConfigOfflinePassState();
}

class _ConfigOfflinePassState extends State<ConfigOfflinePass> {
  TextEditingController newOfflinePass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 250,
              margin: EdgeInsets.only(
                  left: size.width * .09,
                  right: size.width * .09,
                  top: size.width * .25),
              child: SvgPicture.asset(
                  'lib/assets/undraw_mobile_browsers_re_kxol.svg'),
            ),
            const SizedBox(height: 100),
            textoDosis('Clave para el módulo OFFLINE', 20,
                fontWeight: FontWeight.bold, textAlign: TextAlign.center),
            SimpleTxt(
                icon: Icons.password_outlined,
                texto: 'Nueva clave',
                obscureText: true,
                keyboardType: TextInputType.text,
                controlador: newOfflinePass,
                left: 50,
                right: 50,
                onChange: (valor) => setState(() {})),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.security_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    elevation: 2,
                  ),
                  label: textoDosis('Cambiar clave', 20, color: Colors.white),
                  onPressed: () async {
                    if (newOfflinePass.text == '') {
                      showToast(context, 'Escriba la contraseña por favor');
                      return;
                    }

                    const storage = FlutterSecureStorage();
                    await storage.write(
                        key: 'passListerOffline', value: newOfflinePass.text);
                    showToast(context, 'Clave establecida con éxito',
                        type: true);
                    if (context.mounted) Navigator.pop(context);
                  }),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.22),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                elevation: 2,
              ),
              label: textoDosis('Ir atrás', 20),
              icon: const Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void goPage(String page) => Navigator.popAndPushNamed(context, page);
}
