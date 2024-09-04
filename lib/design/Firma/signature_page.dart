import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sticker_maker/config/controllers/signature.controller.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:sticker_maker/design/common/encabezado.dart';

import 'package:sticker_maker/design/common/simple_txt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class SignaturePage extends ConsumerStatefulWidget {
  const SignaturePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignaturePageState();
}

class _SignaturePageState extends ConsumerState<SignaturePage> {
  String sign = '';
  TextEditingController signatureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signatureControllers = SignatureControllers();
    return Scaffold(
      appBar: showAppBar('Firma general', actions: [
        IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, 'signature_storage_page'),
            icon: const Icon(Icons.sd_storage_outlined))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const JornadAndDate(),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300]),
                  onPressed: () {
                    final janddate = ref.watch(janddateR);
                    signatureControllers
                        .generateSignture(
                            janddate.currentDate, janddate.currentJornada)
                        .then((value) {
                      setState(() {
                        sign = value;
                      });
                    });
                  },
                  child: textoDosis('Generar firma', 20, color: Colors.white)),
            ),
            encabezado(context, 'Información', true, () async {
              if (sign == '') {
                showToast(context, 'Antes debe generar una firma');
                return;
              }

              final janddate = ref.watch(janddateR);

              Directory? appDocDirectory = await getExternalStorageDirectory();
              Directory('${appDocDirectory?.path}/Signatures')
                  .create(recursive: true)
                  .then((Directory directory) async {
                final file = File(
                    '${directory.path}/Firma-${janddate.currentDate}-${janddate.currentJornada}.txt');
                await file.writeAsString(sign);

                showToast(context, 'Firma guardada exitosamente', type: true);
              }).catchError((onError) {
                showToast(context, onError);
              });
            }, false, btnText: 'Guardar', btnIcon: Icons.save_alt_rounded),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                      onPressed: () {
                        if (sign == '') {
                          showToast(context, 'Antes debe generar una firma');
                          return;
                        }
                      },
                      icon: const Icon(Icons.copy_rounded),
                      label: textoDosis('Copiar', 18)),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300]),
                      onPressed: () {
                        if (sign == '' || signatureController.text.isEmpty) {
                          showToast(context,
                              'Faltan datos para realizar esta acción');
                          return;
                        }

                        if (sign == signatureController.text) {
                          showToast(context,
                              'Ambas firmas son idénticas. Todo en órden',
                              type: true);
                          return;
                        }

                        showToast(
                            context, 'Las firmas son distintas. Algo esta mal');
                      },
                      icon: const Icon(Icons.security_rounded),
                      label: textoDosis('Comprobar', 18, color: Colors.white))
                ],
              ),
            ),
            SimpleTxt(
                right: 42,
                icon: Icons.security_rounded,
                texto: 'Pega aquí la firma',
                keyboardType: TextInputType.text,
                controlador: signatureController,
                onChange: (valor) => setState(() {})),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 0))
                  ]),
              child: textoDosis(sign, 18, maxLines: 200),
            ),
          ],
        ),
      ),
    );
  }
}
