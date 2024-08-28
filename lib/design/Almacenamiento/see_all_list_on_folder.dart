import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:open_file/open_file.dart';

class SeeListsOnFolder extends StatefulWidget {
  const SeeListsOnFolder({super.key, required this.path});

  final String path;

  @override
  State<SeeListsOnFolder> createState() => _SeeListsOnFolderState();
}

class _SeeListsOnFolderState extends State<SeeListsOnFolder> {
  List<String> files = [];

  bool isType = true;

  @override
  void initState() {
    final fileList = Directory(widget.path).listSync();
    for (var file in fileList) {
      setState(() {
        files.add(file.path);
      });
    }

    if (fileList.isNotEmpty) {
      if (fileList[0] is Directory) {
        isType = false;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(
        'Carpeta: ${widget.path.split('/')[9]}',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            encabezado(
                context, 'Listado de documentos', false, () => null, false),
            (isType) ? showFileList(files) : showFoldersList(files),
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> showFoldersList(List<String> files) {
    return ValueListenableBuilder(
        valueListenable: cambioListas,
        builder: (context, value, child) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'see_lists_on_folder',
                          arguments: [files[index], 'Lista']);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
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
                            child: textoDosis(files[index].split('/')[10], 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          deleteFolder(files[index])
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  ValueListenableBuilder<bool> showFileList(List<String> files) {
    return ValueListenableBuilder(
        valueListenable: cambioListas,
        builder: (context, value, child) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  List<String> fileName = [];

                  if (files[index].split('/').length == 11) {
                    fileName = files[index].split('/')[10].split('-');
                  } else {
                    fileName = files[index].split('/')[11].split('-');
                  }

                  return GestureDetector(
                    onTap: () => OpenFile.open(files[index]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            Icons.picture_as_pdf_outlined,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          (fileName[0] == 'BOTE')
                              ? textoDosis(
                                  '${fileName[0]} -> ${fileName[2]}', 18,
                                  fontWeight: FontWeight.bold)
                              : textoDosis(
                                  '${fileName[0]} -> ${fileName[1]}', 18,
                                  fontWeight: FontWeight.bold),
                          const Spacer(),
                          deleteFile(files[index])
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  IconButton deleteFile(String path) {
    return IconButton(
        icon: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.red,
        ),
        onPressed: () {
          final directory = Directory(widget.path);
          final file = File(path);

          try {
            if (directory.listSync().length != 1) {
              file.deleteSync();
              showToast('Documento eliminado exitosamente', type: true);
              files.remove(path);
              cambioListas.value = !cambioListas.value;
              return;
            }

            directory.deleteSync(recursive: true);
            Navigator.pop(context);
            showToast('Documento eliminado exitosamente', type: true);
            cambioListas.value = !cambioListas.value;
          } catch (e) {
            showToast('No se pudo eliminar el documento');
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
                showToast('Documento eliminado exitosamente', type: true);
                cambioListas.value = !cambioListas.value;
                Navigator.pop(context);
              } catch (e) {
                showToast('No se pudo eliminar el documento');
              }
            }));
  }
}
