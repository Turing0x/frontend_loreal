import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/simple_txt.dart';

class OfflinePass extends StatefulWidget {
  const OfflinePass({super.key});

  @override
  State<OfflinePass> createState() => _OfflinePassState();
}

class _OfflinePassState extends State<OfflinePass> {
  TextEditingController passController = TextEditingController();

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
              child:
                  SvgPicture.asset('lib/assets/undraw_my_password_re_ydq7.svg'),
            ),
            const SizedBox(height: 130),
            textoDosis('Trabajar sin conexión a internet', 20,
                fontWeight: FontWeight.bold, textAlign: TextAlign.center),
            SimpleTxt(
                color: Colors.grey[300],
                icon: Icons.password_outlined,
                texto: 'Clave de acceso',
                obscureText: true,
                keyboardType: TextInputType.text,
                controlador: passController,
                onChange: (valor) => setState(() {})),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  elevation: 2,
                ),
                label: textoDosis('Acceder', 20, color: Colors.white),
                icon: const Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Future<String?> offlinePass =
                      LocalStorage.getpassListerOffline();
                  offlinePass.then((value) {
                    if (passController.text != value) {
                      showToast('Contraseña incorrecta');
                      return;
                    }

                    showToast('La clave es correcta', type: true);
                    goPage('main_make_list_offline');
                  });
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.18),
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
