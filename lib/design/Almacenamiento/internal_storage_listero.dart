import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class InternalStorageListeroPage extends StatefulWidget {
  const InternalStorageListeroPage({super.key});

  @override
  State<InternalStorageListeroPage> createState() =>
      _InternalStoragePageSListerotate();
}

class _InternalStoragePageSListerotate
    extends State<InternalStorageListeroPage> {
  late String _radioValue;

  bool btnAll = false;
  bool alternar = true;
  late bool btnDia;
  late bool btnNoche;

  @override
  void initState() {
    _radioValue = jornalGlobal;
    if (jornalGlobal == 'dia') {
      btnDia = true;
      btnNoche = false;
    } else {
      btnNoche = true;
      btnDia = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: showAppBar('Almacenamiento interno', actions: [
        IconButton(
            icon: const Icon(
              Icons.folder_delete_outlined,
              color: Colors.white,
            ),
            onPressed: () => showInfoDialog(context, 'Eliminar documentos',
                    textoDosis('Eliminar todo?', 18), () async {
                  try {
                    Directory? appDocDirectory =
                        await getExternalStorageDirectory();
                    final filePath = Directory(appDocDirectory!.path);

                    filePath.deleteSync(recursive: true);

                    showToast('Todo los documentos fueron eliminados',
                        type: true);
                    navigator.pop();
                    cambioListas.value = !cambioListas.value;
                  } catch (e) {
                    showToast('No se pudo eliminar el documento');
                  }
                }))
      ]),
      body: SingleChildScrollView(
        child: filtrosTop(),
      ),
    );
  }

  Column filtrosTop() {
    return Column(
      children: [
        btnJornda(),
        divisor,
        showFileList(),
      ],
    );
  }

  ValueListenableBuilder<bool> showFileList() {
    return ValueListenableBuilder(
      valueListenable: cambioListas,
      builder: (context, value, child) => FutureBuilder(
        future: getDirectory(),
        builder: (context, snapshot) {
          List<dynamic> list = [];

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context);
          }

          if (_radioValue != 't') {
            list = snapshot.data!
                .where((element) =>
                    element.split('/')[9].split('-')[2] == _radioValue)
                .toList();
          } else {
            list = snapshot.data!;
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final color =
                    (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50];

                return ListTile(
                  tileColor: color,
                  minLeadingWidth: 20,
                  title: FittedBox(
                      child: textoDosis(list[index].split('/')[11], 16,
                          fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      openFile(list[index]),
                      shareFile(list[index]),
                      deleteFile(list[index])
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Container btnJornda() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            onPressed: () {
              setState(() {
                btnAll = true;
                btnDia = false;
                btnNoche = false;
                _radioValue = 't';
              });
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: (btnAll) ? Colors.blue[100] : null),
            child: textoDosis('Todos', 16,
                fontWeight: (btnAll) ? FontWeight.bold : FontWeight.normal),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                btnDia = true;
                btnAll = false;
                btnNoche = false;
                _radioValue = 'dia';
              });
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: (btnDia) ? Colors.blue[100] : null),
            child: textoDosis('Día', 16,
                fontWeight: (btnDia) ? FontWeight.bold : FontWeight.normal),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                btnNoche = true;
                btnAll = false;
                btnDia = false;
                _radioValue = 'noche';
              });
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: (btnNoche) ? Colors.blue[100] : null),
            child: textoDosis('Noche', 16,
                fontWeight: (btnNoche) ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Future<List> getDirectory() async {
    try {
      List<String> paths = [];

      Directory? appDocDirectory = await getExternalStorageDirectory();
      final fileList = Directory('${appDocDirectory?.path}/PDFList').listSync();
      for (var file in fileList) {
        getAllFilesInside(paths, file);
      }

      return paths;
    } catch (e) {
      return [];
    }
  }

  IconButton openFile(String path) {
    return IconButton(
        icon: const Icon(
          Icons.remove_red_eye_outlined,
          color: Colors.green,
        ),
        onPressed: () => OpenFile.open(path));
  }

  IconButton shareFile(String path) {
    return IconButton(
        icon: const Icon(
          Icons.share_outlined,
          color: Colors.blue,
        ),
        onPressed: () => ShareExtend.share(path, 'file'));
  }

  IconButton deleteFile(String path) {
    return IconButton(
        icon: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.red,
        ),
        onPressed: () {
          final file = File(path);
          try {
            file.deleteSync();
            showToast('Documento eliminado exitosamente', type: true);
            cambioListas.value = !cambioListas.value;
          } catch (e) {
            showToast('No se pudo eliminar el documento');
          }
        });
  }

  List<String> getAllFilesInside(
      List<String> filesInsided, FileSystemEntity path) {
    final fileList = Directory(path.path).listSync();
    for (var inside in fileList) {
      if (inside is Directory) {
        getAllFilesInside(filesInsided, inside);
      } else {
        filesInsided.add(inside.path);
      }
    }

    return filesInsided;
  }
}
