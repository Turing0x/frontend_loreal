// ignore_for_file: avoid_print, unused_local_variable

import 'package:frontend_loreal/api/List/widgets/toServer/list_controller.dart';
import 'package:frontend_loreal/methods/decode_JSON_to_map.dart';
import 'package:frontend_loreal/riverpod/data_offline_list.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/no_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineListControl extends ConsumerStatefulWidget {
  const OfflineListControl({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OfflineListControlState();
}

class _OfflineListControlState extends ConsumerState<OfflineListControl> {
  ValueNotifier<List<OfflineList>> pendigLists =
      ValueNotifier<List<OfflineList>>([]);
  ValueNotifier changeState = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar('Control de listas OFFLINE'),
        floatingActionButton: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          onPressed: () {
            Clipboard.getData(Clipboard.kTextPlain).then((value) {
              if (value!.text!.isEmpty) {
                showToast('Sin datos en el portapapeles');
                return;
              }

              showInfo(context, ref, value.text!);
            }).catchError((error) {
              showToast(error.toString());
            });
          },
          label: const Row(children: [
            Icon(Icons.lock_reset_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text('Procesar encriptación')
          ]),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            encabezado(context, 'Listas para enviar', true, () {
              pendigLists.value.clear();
              changeState.value = !changeState.value;
              showToast('Limpieza realizada correctamente', type: true);
            }, false, btnIcon: Icons.clear_all_rounded, btnText: 'Limpiar'),
            showList(context),
          ],
        )));
  }

  SizedBox showList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.90,
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: changeState,
        builder: (context, color, _) => ValueListenableBuilder(
            valueListenable: pendigLists,
            builder: (_, __, ___) {
              if (pendigLists.value.isEmpty) {
                return noData(context);
              }

              final info = pendigLists.value;

              return ListView.builder(
                  itemCount: pendigLists.value.length,
                  itemBuilder: (context, index) {
                    final color =
                        (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50];

                    return Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: 80,
                      color:
                          (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                      alignment: Alignment.center,
                      child: ListTile(
                        title: textoDosis(info[index].owner!, 20,
                            fontWeight: FontWeight.bold),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            boldLabel('Bruto: ', info[index].bruto!, 20),
                            const SizedBox(width: 20),
                            boldLabel('Limpio: ', info[index].limpio!, 20)
                          ],
                        ),
                        tileColor: (index % 2 != 0)
                            ? Colors.grey[200]
                            : Colors.grey[50],
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            btnSend(context, info[index], index),
                            btnDelete(index),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, 'see_list_detail_after_send',
                            arguments: [
                              info[index].date!,
                              info[index].jornal!,
                              info[index].owner!,
                              info[index].signature!,
                              info[index].bruto!,
                              info[index].limpio!
                            ]),
                      ),
                    );
                  });
            }),
      ),
    );
  }

  Future showInfo(BuildContext context, WidgetRef ref, String data) {
    final dataOfflineList = StateNotifierProvider<DataOfflineList, OfflineList>(
        (ref) => DataOfflineList());

    final size = MediaQuery.of(context).size;
    double? fontSize = (size.width * 0.05).round().toDouble();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.only(left: 5, top: 20),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: size.width * 0.95,
            height: size.height * 0.45,
            child: SingleChildScrollView(
              child: ProviderScope(
                child: Consumer(builder: (_, ref, __) {
                  final setDataList = ref.read(dataOfflineList.notifier);
                  final getDataList = ref.watch(dataOfflineList);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: textoDosis('Código de encriptación', 20,
                            fontWeight: FontWeight.bold),
                      ),
                      encabezado(context, 'Revisar portapapeles: ', true, () {
                        Map<String, dynamic> infoDecoded = jwtAMap(data);

                        if (infoDecoded.isNotEmpty) {
                          setDataList.owner = infoDecoded['Responsable']!;
                          setDataList.jornal = infoDecoded['Jornal']!;
                          setDataList.date = infoDecoded['Date']!;
                          setDataList.bruto = infoDecoded['Bruto']!;
                          setDataList.limpio = infoDecoded['Limpio']!;
                          setDataList.signature = infoDecoded['Firma']!;
                        }
                      }, false,
                          btnText: 'Revisar', btnIcon: Icons.paste_outlined),
                      dinamicGroupBox('Información proveniente de la lista', [
                        boldLabel('Listero responsable: ', getDataList.owner!,
                            fontSize),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            boldLabel(
                                'Jorada: ', getDataList.jornal!, fontSize),
                            boldLabel('Fecha: ', getDataList.date!, fontSize),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            boldLabel('Bruto: ', getDataList.bruto!, fontSize),
                            boldLabel(
                                'Limpio: ', getDataList.limpio!, fontSize),
                          ],
                        ),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400], elevation: 2),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Rechazarla'),
                            onPressed: () {
                              setDataList.cleanInfo();
                              Clipboard.setData(const ClipboardData(text: ''));
                              Navigator.pop(context);
                            },
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400],
                                elevation: 2),
                            icon: const Icon(Icons.thumb_up_alt_outlined),
                            label: const Text('Aceptarla'),
                            onPressed: () {
                              pendigLists.value.add(getDataList);

                              setDataList.cleanInfo();
                              changeState.value = !changeState.value;
                              Clipboard.setData(const ClipboardData(text: ''));
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton btnSend(BuildContext context, OfflineList list, int index) {
    return IconButton(
      icon: const Icon(Icons.upload_outlined, color: Colors.blue),
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
                  onPressed: () {
                    saveOneList(
                            owner: list.owner!,
                            list.date!,
                            list.jornal!,
                            list.signature!)
                        .then((value) {
                      if (value) {
                        pendigLists.value.removeAt(index);
                        changeState.value = !changeState.value;
                        Navigator.pop(context);
                      }
                    });
                  }),
            ],
          ),
        )
      },
    );
  }

  IconButton btnDelete(int index) {
    return IconButton(
      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
      onPressed: () {
        pendigLists.value.removeAt(index);

        changeState.value = !changeState.value;
        showToast('Lista eliminada');
      },
    );
  }
}
