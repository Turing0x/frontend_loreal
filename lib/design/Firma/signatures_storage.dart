import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SignaturesStoragePage extends StatefulWidget {
  const SignaturesStoragePage({super.key});

  @override
  State<SignaturesStoragePage> createState() => _SignaturesStoragePageState();
}

class _SignaturesStoragePageState extends State<SignaturesStoragePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(
        'Almacenamiento de firmas',
      ),
      body: SingleChildScrollView(
        child: showFileList(),
      ),
    );
  }

  ValueListenableBuilder<bool> showFileList() {
    return ValueListenableBuilder(
      valueListenable: cambioListas,
      builder: (context, value, child) => FutureBuilder(
        future: getDirectory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context);
          }

          List<dynamic> list = snapshot.data!;

          return Container(
            margin: const EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final color =
                    (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  height: 50,
                  child: ListTile(
                      tileColor: color,
                      minLeadingWidth: 20,
                      title: textoDosis(list[index].split('/')[9], 18,
                          fontWeight: FontWeight.bold),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [copyContent(list[index])],
                      ),
                      onTap: () => OpenFile.open(list[index]),
                      onLongPress: () {
                        final file = File(list[index]);
                        try {
                          file.deleteSync();
                          showToast(context, 'Documento eliminado exitosamente',
                              type: true);
                          cambioListas.value = !cambioListas.value;
                        } catch (e) {
                          showToast(
                              context, 'No se pudo eliminar el documento');
                        }
                      }),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List> getDirectory() async {
    try {
      List<String> paths = [];

      Directory? appDocDirectory = await getExternalStorageDirectory();
      final fileList =
          Directory('${appDocDirectory?.path}/Signatures').listSync();
      for (var file in fileList) {
        paths.add(file.path);
      }

      return paths;
    } catch (e) {
      return [];
    }
  }

  IconButton copyContent(String path) {
    return IconButton(
        icon: const Icon(
          Icons.copy_rounded,
          color: Colors.green,
        ),
        onPressed: () async {
          try {
            final file = File(path);

            Clipboard.setData(ClipboardData(text: await file.readAsString()));

            showToast(context,
                'El contenido del archivo ha sido copiado correctamente',
                type: true);
          } catch (e) {
            showToast(context, 'No se pudo copiar el contenido');
          }
        });
  }
}
