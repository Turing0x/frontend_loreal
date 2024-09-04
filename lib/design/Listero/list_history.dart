import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/list_controller.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils/file_manager.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/Listero/pdf_listero.dart';
import 'package:frontend_loreal/design/Pintar_lista/Candado/candado.dart';
import 'package:frontend_loreal/design/Pintar_lista/Decena/decena.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/centenas.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/fijos_corridos.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/parles.dart';
import 'package:frontend_loreal/design/Pintar_lista/Millon/million.dart';
import 'package:frontend_loreal/design/Pintar_lista/Posicion/posicion.dart';
import 'package:frontend_loreal/design/Pintar_lista/Terminal/terminal.dart';
import 'package:frontend_loreal/design/Pintar_lista/methods.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista/list_model.dart';
import 'package:frontend_loreal/models/Lista_Calcs/calcs_model.dart';
import 'package:frontend_loreal/models/Lista_Candado/candado_model.dart';
import 'package:frontend_loreal/models/Lista_Decena/decena_model.dart';
import 'package:frontend_loreal/models/Lista_Main/centenas/centenas_model.dart';
import 'package:frontend_loreal/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:frontend_loreal/models/Lista_Main/parles/parles_model.dart';
import 'package:frontend_loreal/models/Lista_Millon/million_model.dart';
import 'package:frontend_loreal/models/Lista_Posicion/posicion_model.dart';
import 'package:frontend_loreal/models/Lista_Terminal/terminal_model.dart';
import 'package:frontend_loreal/models/PDFs/invoice_listero.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

String lotThisDay = '';
String listID = '';
List<BoliList> listFind = [];
final listControllers = ListControllers();

class ListsHistory extends ConsumerStatefulWidget {
  const ListsHistory({super.key, required this.canEditList});

  final bool canEditList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListsHistoryState();
}

class _ListsHistoryState extends ConsumerState<ListsHistory> {
  String datePicked = DateFormat.MMMd().format(DateTime.now());
  int cont = 0;

  String userNAME = '';

  @override
  void initState() {
    LocalStorage.getUsername().then((value) {
      setState(() {
        userNAME = value!;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showTheBottom = ref.watch(showButtomtoEditAList);
    final theBottom = ref.read(showButtomtoEditAList.notifier);
    final theList = ref.read(toEditAList.notifier);

    return Scaffold(
      appBar: showAppBar('Mis listas anteriores', actions: [
        IconButton(
            icon: const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
            onPressed: () => (listFind.isNotEmpty) ? makePdf() : null),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const JornadAndDate(),
            encabezado(
                context, 'Resultados de la búsqueda', false, () {}, false),
            Visibility(
                visible: showTheBottom,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: btnWithIcon(context, Colors.red[300],
                          const Icon(Icons.cancel_outlined), 'Cancelar', () {
                        theList.state.clear();
                        theBottom.state = false;
                      }, MediaQuery.of(context).size.width * 0.7),
                    ),
                    SizedBox(
                      width: 150,
                      child: btnWithIcon(
                          context,
                          Colors.blue[300],
                          const Icon(Icons.delete_sweep_outlined),
                          'Eliminar', () async {
                        bool okay = await listControllers.editOneList(
                            listID, theList.state);
                        if (okay) {
                          eraseDataOfStorage();
                          theList.state.clear();
                          theBottom.state = false;
                          cambioListas.value = !cambioListas.value;
                        }
                      }, MediaQuery.of(context).size.width * 0.7),
                    ),
                  ],
                )),
            ShowList(
              ref: ref,
              canEditList: widget.canEditList,
            ),
          ],
        ),
      ),
    );
  }

  void makePdf() async {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    final calcs = listFind[0].calcs as Map<String, dynamic>;
    final list = boliList(listFind[0].signature!);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final invoice = InvoiceListero(
        infoListero: InvoiceInfoListero(
            fechaActual: formatFechaActual,
            fechaTirada: listFind[0].date!,
            jornada: listFind[0].jornal!,
            listero: userNAME,
            lote: lotThisDay),
        infoList: [
          InvoiceItemList(
              lista: list,
              bruto: double.parse(calcs['bruto'].toStringAsFixed(2).toString()),
              limpio:
                  double.parse(calcs['limpio'].toStringAsFixed(2).toString()),
              premio:
                  double.parse(calcs['premio'].toStringAsFixed(2).toString()),
              pierde:
                  double.parse(calcs['perdido'].toStringAsFixed(2).toString()),
              gana: double.parse(calcs['ganado'].toStringAsFixed(2).toString()))
        ]);

    Map<String, dynamic> itsDone = await PdfInvoiceApiListero.generate(invoice);

    final openPdf = prefs.getBool('openPdf');
    if (openPdf ?? false) {
      OpenFile.open(itsDone['path']);
    }
    showToast(context, 'Lista exportada exitosamente', type: true);
  }

  void eraseDataOfStorage() {
    final list = ref.read(toManageTheMoney.notifier);

    for (var each in list.state) {
      if (each is FijoCorridoModel) {
        toBlockIfOutOfLimitFCPC.update(each.numplay.toString().rellenarCon0(2),
            (value) {
          return {
            'fijo': value['fijo']! - (each.fijo!),
            'corrido': value['corrido']! - (each.corrido!),
            'corrido2': value['corrido2']!,
          };
        });
      }

      if (each is MillionModel) {
        toBlockIfOutOfLimitFCPC.update(each.numplay.toString(), (value) {
          return {
            'fijo': value['fijo']! - each.fijo,
            'corrido': value['corrido']! - each.corrido,
          };
        });
      }

      if (each is PosicionModel) {
        toBlockIfOutOfLimitFCPC.update(each.numplay.toString().rellenarCon0(2),
            (value) {
          return {
            'fijo': value['fijo']! - each.fijo,
            'corrido': value['corrido']! - each.corrido,
            'corrido2': value['corrido2']! - each.corrido2,
          };
        });
      }

      if (each is TerminalModel) {
        toBlockIfOutOfLimitTerminal.update(each.terminal.toString(), (value) {
          return {
            'fijo': value['fijo']! - each.fijo,
            'corrido': value['corrido']! - each.corrido,
          };
        });
      }

      if (each is DecenaModel) {
        toBlockIfOutOfLimitDecena.update(each.numplay.toString(), (value) {
          return {
            'fijo': value['fijo']! - each.fijo,
            'corrido': value['corrido']! - each.corrido,
          };
        });
      }

      if (each is CentenasModel) {
        toBlockIfOutOfLimit.update(each.numplay, (value) => value - each.fijo);
      }

      if (each is ParlesModel) {
        String a = each.numplay[0];
        String b = each.numplay[1];

        String joined =
            '${a.toString().rellenarCon00(2)}${b.toString().rellenarCon00(2)}';
        String joined1 =
            '${b.toString().rellenarCon00(2)}${a.toString().rellenarCon00(2)}';

        toBlockIfOutOfLimit.update(joined, (value) => value - each.fijo);

        toBlockIfOutOfLimit.update(joined1, (value) => value - each.fijo);
      }

      if (each is CandadoModel) {
        List allCombinations = combinaciones(each.numplay);
        int dineroForEachParle = each.fijo ~/
            ((each.numplay.length * (each.numplay.length - 1)) / 2);

        for (var element in allCombinations) {
          String joined =
              '${element[0].toString().rellenarCon00(2)}${element[1].toString().rellenarCon00(2)}';
          String joined1 =
              '${element[1].toString().rellenarCon00(2)}${element[0].toString().rellenarCon00(2)}';

          toBlockIfOutOfLimit.update(
              joined, (value) => value - dineroForEachParle);

          toBlockIfOutOfLimit.update(
              joined1, (value) => value - dineroForEachParle);
        }
      }
    }

    fileManagerWriteGlobal(toBlockIfOutOfLimit);
    fileManagerWriteFCPC(toBlockIfOutOfLimitFCPC);
    fileManagerWriteTerminal(toBlockIfOutOfLimitTerminal);
    fileManagerWriteDecena(toBlockIfOutOfLimitDecena);
    list.state.clear();
  }

  List combinaciones(List array) {
    List resultado = [];

    for (int i = 0; i < array.length - 1; i++) {
      for (int j = i + 1; j < array.length; j++) {
        resultado.add([array[i], array[j]]);
      }
    }

    return resultado;
  }
}

class ShowList extends StatefulWidget {
  const ShowList({
    super.key,
    required this.ref,
    required this.canEditList,
  });

  final WidgetRef ref;
  final bool canEditList;

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  List<dynamic> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final janddate = widget.ref.watch(janddateR);

    return ValueListenableBuilder(
        valueListenable: cambioListas,
        builder: (_, __, ___) {
          return FutureBuilder(
            future: listControllers.getAllList(
                username: globalUserName,
                jornal: janddate.currentJornada,
                date: janddate.currentDate),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingWidget(context);
              }
              if (snapshot.data!['data']!.isEmpty || snapshot.data!.isEmpty) {
                return noData(context);
              }

              List list = snapshot.data!['data'];
              String lot = snapshot.data!['lotOfToday'];
              lotThisDay = lot;

              final toDraw = boliList(list[0].signature!);
              listID = list[0].id!;

              listFind.clear();
              listFind.add(list[0]);

              final decoded = list[0].calcs as Map<String, dynamic>;

              toDraw.sort(((a, b) {
                if (b is! CalcsModel && a is! CalcsModel) {
                  return b.dinero - a.dinero;
                }
                return 0;
              }));

              return Column(
                children: [
                  boldLabel('Sorteo del momento -> ', lot, 23),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          boldLabel(
                              'B: ',
                              decoded['bruto'].toStringAsFixed(0).toString(),
                              18),
                          const SizedBox(width: 20),
                          boldLabel(
                              'L: ',
                              decoded['limpio'].toStringAsFixed(0).toString(),
                              18),
                          const SizedBox(width: 20),
                          boldLabel(
                              'P: ',
                              decoded['premio'].toStringAsFixed(0).toString(),
                              18),
                          const SizedBox(width: 20),
                          boldLabel(
                              'P: ',
                              decoded['perdido'].toStringAsFixed(0).toString(),
                              18),
                          const SizedBox(width: 20),
                          boldLabel(
                              'G: ',
                              decoded['ganado'].toStringAsFixed(0).toString(),
                              18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: ListView.builder(
                        itemCount: toDraw.length,
                        itemBuilder: (context, index) {
                          final color = (index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50];
                          return Container(
                            color: color,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: fila(
                                  widget.canEditList && lot == 'Sin datos',
                                  widget.ref,
                                  data: toDraw[index],
                                  color: color!),
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          );
        });
  }

  Widget fila(bool canEditList, ref,
      {required dynamic data, required Color color}) {
    final widgetMap = {
      FijoCorridoModel: (data) => FijosCorridosListaWidget(
          fijoCorrido: data, color: color, canEdit: canEditList),
      ParlesModel: (data) =>
          ParlesListaWidget(parles: data, color: color, canEdit: canEditList),
      CentenasModel: (data) => CentenasListaWidget(
          centenas: data, color: color, canEdit: canEditList),
      CandadoModel: (data) =>
          CandadoListaWidget(candado: data, color: color, canEdit: canEditList),
      TerminalModel: (data) => TerminalListaWidget(
          terminal: data, color: color, canEdit: canEditList),
      PosicionModel: (data) => PosicionlListaWidget(
          posicion: data, color: color, canEdit: canEditList),
      DecenaModel: (data) =>
          DecenaListaWidget(numplay: data, color: color, canEdit: canEditList),
      MillionModel: (data) =>
          MillionListaWidget(numplay: data, color: color, canEdit: canEditList),
    };

    final widgetBuilder = widgetMap[data.runtimeType];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }
}
