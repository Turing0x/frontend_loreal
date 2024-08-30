import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sticker_maker/config/controllers/users_controller.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/encabezado.dart';
import 'package:sticker_maker/design/common/txt_para_info.dart';

class NewBancoPage extends StatefulWidget {
  const NewBancoPage({super.key});

  @override
  State<NewBancoPage> createState() => _NewBancoPageState();
}

class _NewBancoPageState extends State<NewBancoPage> {
  Timer? _timer;

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Crear nuevo usuario'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              encabezado(context, 'Datos de sesión', false, () {}, true),
              const SizedBox(height: 10),
              TxtInfo(
                  texto: 'Nombre de usuario:*',
                  keyboardType: TextInputType.name,
                  controlador: nameController,
                  icon: Icons.person_outline,
                  onChange: (valor) => (() {})),
              const SizedBox(height: 10),
              TxtInfo(
                  texto: 'Contraseña:*',
                  keyboardType: TextInputType.name,
                  controlador: passController,
                  icon: Icons.password_outlined,
                  onChange: (valor) => (() {})),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add_alt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      elevation: 2,
                    ),
                    label: textoDosis('Crear usuario', 20, color: Colors.white),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final userCtrl = UserControllers();

                      if (nameController.text.isEmpty ||
                          passController.text.isEmpty) {
                        return showToast(
                            context, 'Debe llenar los campos obligatorios');
                      }

                      showInfoDialog(
                          context,
                          'Confirmar crear usuario',
                          Text('Se creará el usuario ${nameController.text}.',
                              style: subtituloListTile), (() {
                        userCtrl.saveOne(nameController.text.trim(),
                            passController.text.trim(), '');
                        Navigator.pop(context);
                      }));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
