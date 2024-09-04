import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sticker_maker/config/controllers/list_controller.dart';
import 'package:sticker_maker/config/database/list_table/bd_provider.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/server/http/local_storage.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/encabezado.dart';
import 'package:sticker_maker/design/common/no_data.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontend_loreal/models/Lista/list_offline_model.dart';

final listControllers = ListControllers();

class PendingLists extends StatefulWidget {
  const PendingLists({super.key});

  @override
  State<PendingLists> createState() => _PendingListsState();
}

class _PendingListsState extends State<PendingLists> {
  String? username = '';
  List<OfflineList> toSend = [];
  bool enable = false;

  @override
  void initState() {
    DBProviderListas.db.getTodasListas().then((value) {
      setState(() {
        for (var e in value) {
          {
            toSend.add(e);
          }
        }
      });
    });

    LocalStorage.getUsername().then((value) {
      setState(() {
        username = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Listas pendientes'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            encabezado(
                context,
                'Aún pendientes',
                toSend.length > 1,
                () => showInfoDialog(
                        context,
                        'Confirmar envío',
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textoDosis('Esta accion enviará al servidor', 18),
                            textoDosis('todas las listas pendientes.', 18),
                            textoDosis('Está seguro que desea hacerlo?', 18,
                                fontWeight: FontWeight.bold),
                          ],
                        ), () {
                      sendMany(toSend);
                      Navigator.pop(context);
                    }),
                false,
                btnIcon: Icons.send_outlined,
                btnText: 'Enviar todas'),
            (toSend.isEmpty) ? noData(context) : showList()
          ],
        ),
      ),
    );
  }

  void sendMany(List<OfflineList> lists) async {
    bool status = await listControllers.saveManyList(username!, lists);

    if (!status) {
      return;
    }

    for (var element in toSend) {
      await DBProviderListas.db.eliminarLista(element.id!);
    }

    toSend.clear();
    cambioListas.value = !cambioListas.value;
  }

  SizedBox showList() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        width: double.infinity,
        child: ValueListenableBuilder(
            valueListenable: cambioListas,
            builder: (_, __, ___) {
              return ListView.builder(
                  itemCount: toSend.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: 80,
                      color:
                          (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                      alignment: Alignment.center,
                      child: ListTile(
                        title: textoDosis(toSend[index].jornal!, 25,
                            fontWeight: FontWeight.bold),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            boldLabel('B: ', toSend[index].bruto!, 25),
                            const SizedBox(width: 20),
                            boldLabel('L: ', toSend[index].limpio!, 25)
                          ],
                        ),
                        tileColor: (index % 2 != 0)
                            ? Colors.grey[200]
                            : Colors.grey[50],
                        onTap: () => Navigator.pushNamed(
                            context, 'list_detail_offline',
                            arguments: [toSend[index].id!]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            btnSend(context, toSend[index]),
                            // shareFile(
                            //     toSend[index].date!,
                            //     toSend[index].jornal!,
                            //     toSend[index].bruto!,
                            //     toSend[index].limpio!,
                            //     toSend[index].signature!),
                            btnDeleteList(toSend[index].id!),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }

  IconButton btnDeleteList(String id) {
    return IconButton(
      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar decisión'),
            content: const Text('Está seguro que desea eliminar esta lista?'),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400], elevation: 2),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400], elevation: 2),
                  icon: const Icon(Icons.thumb_up_outlined),
                  label: const Text('Eliminarlo'),
                  onPressed: () {
                    DBProviderListas.db.eliminarLista(id);
                    toSend.removeWhere((element) => element.id == id);
                    showToast(context, 'Lista eliminada exitosamente',
                        type: true);
                    cambioListas.value = !cambioListas.value;
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  IconButton btnSend(BuildContext context, OfflineList list) {
    return IconButton(
      icon: const Icon(Icons.upload_outlined, color: Colors.green),
      onPressed: () => {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar decisión'),
            content: const Text(
                'Está seguro que desea enviar esta lista al servidor?'),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400], elevation: 2),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400], elevation: 2),
                  icon: const Icon(Icons.thumb_up_outlined),
                  label: const Text('Enviarla'),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    bool status = await listControllers.saveOneList(
                        list.date!, list.jornal!, list.signature!);

                    if (status) {
                      toSend.removeWhere((element) => element.id == list.id);
                      DBProviderListas.db.eliminarLista(list.id!);
                    }

                    cambioListas.value = !cambioListas.value;
                    navigator.pop();
                  }),
            ],
          ),
        )
      },
    );
  }

  // IconButton shareFile(String date, String jornal, String bruto, String limpio,
  //     String signature) {
  //   return IconButton(
  //       icon: const Icon(
  //         Icons.share_outlined,
  //         color: Colors.blue,
  //       ),
  //       onPressed: () {
  //         Map<String, String> infoList = {
  //           'Responsable': username!,
  //           'Jornal': jornal,
  //           'Date': date,
  //           'Bruto': bruto,
  //           'Limpio': limpio,
  //           'Firma': signature,
  //         };

  //         final obtenerKey = _jwt(jsonEncode(infoList));

  //         // ShareExtend.share(obtenerKey, 'text');
  //       });
  // }

  String jwt(dynamic lista) => JWT(
        lista,
        issuer: '63a8970549e4771a0786abb9',
      ).sign(SecretKey(dotenv.env['SECRETKEY_JWT']!), noIssueAt: true);
}
