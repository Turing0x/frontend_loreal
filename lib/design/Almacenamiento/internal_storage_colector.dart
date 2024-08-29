import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class InternalStorageColectorPage extends StatefulWidget {
  const InternalStorageColectorPage({super.key});

  @override
  State<InternalStorageColectorPage> createState() =>
      _InternalStoragePageSColectortate();
}

class _InternalStoragePageSColectortate
    extends State<InternalStorageColectorPage> {
  bool alternar = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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

                    showToast(context, 'Todo los documentos fueron eliminados',
                        type: true);
                    navigator.pop();
                    cambioListas.value = !cambioListas.value;
                  } catch (e) {
                    showToast(context, 'No se pudo eliminar el documento');
                  }
                }))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            encabezado(context, 'Opciones', true, () {
              setState(() {
                alternar = !alternar;
              });
            }, false,
                btnText: 'Alternar vistas', btnIcon: Icons.alt_route_outlined),
            (alternar)
                ? valesResumenes(size)
                : SizedBox(
                    height: size.height * 0.7,
                    width: double.infinity,
                    child: showFolderList(size))
          ],
        ),
      ),
    );
  }

  SizedBox valesResumenes(Size size) {
    return SizedBox(
        height: size.height * 0.7,
        width: double.infinity,
        child: showFolderVales(size));
  }

  ValueListenableBuilder<bool> showFolderVales(Size size) {
    return ValueListenableBuilder(
      valueListenable: cambioListas,
      builder: (context, value, child) => FutureBuilder(
        future: getDirectoryOfVales(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context);
          }

          List<dynamic> list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'see_lists_on_folder',
                      arguments: [list[index], 'Vale']);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 8,
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 0))
                      ]),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder_open_rounded,
                        size: 28,
                      ),
                      const SizedBox(width: 20),
                      FittedBox(
                        child: textoDosis(list[index].split('/')[9], 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      deleteFolder(list[index])
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  ValueListenableBuilder<bool> showFolderList(Size size) {
    return ValueListenableBuilder(
      valueListenable: cambioListas,
      builder: (context, value, child) => FutureBuilder(
        future: getDirectoryOfLists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context);
          }

          List<dynamic> list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'see_lists_on_folder',
                      arguments: [list[index], 'Lista']);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 8,
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 0))
                      ]),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder_open_rounded,
                        size: 28,
                      ),
                      const SizedBox(width: 20),
                      FittedBox(
                        child: textoDosis(list[index].split('/')[9], 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      deleteFolder(list[index])
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List> getDirectory() async {
    try {
      List<String> paths = [];

      Directory? appDocDirectory = await getExternalStorageDirectory();
      if (!Directory('${appDocDirectory?.path}/PDFDocs').existsSync()) {
        return [];
      }

      final fileList = Directory('${appDocDirectory?.path}/PDFDocs').listSync();
      for (var file in fileList) {
        paths.add(file.path);
      }

      return paths;
    } catch (e) {
      return [];
    }
  }

  Future<List> getDirectoryOfLists() async {
    try {
      List<String> paths = [];

      Directory? appDocDirectory = await getExternalStorageDirectory();
      if (!Directory('${appDocDirectory?.path}/PDFList').existsSync()) {
        return [];
      }

      final fileList = Directory('${appDocDirectory?.path}/PDFList').listSync();
      for (var file in fileList) {
        paths.add(file.path);
      }

      return paths;
    } catch (e) {
      return [];
    }
  }

  Future<List> getDirectoryOfVales() async {
    try {
      List<String> paths = [];

      Directory? appDocDirectory = await getExternalStorageDirectory();
      if (!Directory('${appDocDirectory?.path}/PDFDocs').existsSync()) {
        return [];
      }

      final fileList = Directory('${appDocDirectory?.path}/PDFDocs').listSync();
      for (var file in fileList) {
        paths.add(file.path);
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
            showToast(context, 'Documento eliminado exitosamente', type: true);
            cambioListas.value = !cambioListas.value;
          } catch (e) {
            showToast(context, 'No se pudo eliminar el documento');
          }
        });
  }

  IconButton deleteFolder(String path) {
    return IconButton(
        icon:
            const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
        onPressed: () => showInfoDialog(
                context,
                'Confirmar',
                Column(mainAxisSize: MainAxisSize.min, children: [
                  textoDosis('Está seguro que desea eliminar esta carpeta?', 20,
                      maxLines: 2, fontWeight: FontWeight.w700),
                  textoDosis(
                      'Todo el contenido en su interior será eliminado de forma irreversible',
                      18,
                      maxLines: 3)
                ]), () {
              final folder = Directory(path);
              try {
                folder.deleteSync(recursive: true);
                showToast(context, 'Documento eliminado exitosamente',
                    type: true);
                cambioListas.value = !cambioListas.value;
                Navigator.pop(context);
              } catch (e) {
                showToast(context, 'No se pudo eliminar el documento');
              }
            }));
  }
}
