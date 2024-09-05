import 'package:flutter/material.dart';
import 'package:safe_chat/config/controllers/users_controller.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/common/simple_txt.dart';
import 'package:flutter_svg/svg.dart';

class ChangeAccessPass extends StatefulWidget {
  const ChangeAccessPass({super.key});

  @override
  State<ChangeAccessPass> createState() => _ChangeAccessPassState();
}

class _ChangeAccessPassState extends State<ChangeAccessPass> {
  TextEditingController actualPass = TextEditingController();
  TextEditingController newPass = TextEditingController();

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
                  'lib/assets/undraw_content_team_re_6rlg.svg'),
            ),
            const SizedBox(height: 130),
            textoDosis('Cambiar la clave de acceso al sistema', 20,
                fontWeight: FontWeight.bold, textAlign: TextAlign.center),
            SimpleTxt(
                icon: Icons.password_outlined,
                texto: 'Clave actual',
                obscureText: true,
                keyboardType: TextInputType.text,
                controlador: actualPass,
                left: 50,
                right: 50,
                onChange: (valor) => setState(() {})),
            SimpleTxt(
                icon: Icons.lock_reset_outlined,
                texto: 'Nueva clave',
                obscureText: true,
                keyboardType: TextInputType.text,
                controlador: newPass,
                left: 50,
                right: 50,
                onChange: (valor) => setState(() {})),
            const SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.security_outlined),
                    label: textoDosis('Cambiar clave', 20, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      elevation: 2,
                    ),
                    onPressed: () {
                      final userCtrl = UserControllers();
                      userCtrl.changePass(
                          actualPass.text, newPass.text, context);
                    })),
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
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
