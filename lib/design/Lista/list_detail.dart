import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/list_controller.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/Listero/pdf_listero.dart';
import 'package:frontend_loreal/design/Pintar_lista/methods.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista/list_model.dart';
import 'package:frontend_loreal/models/Lista_Calcs/calcs_model.dart';
import 'package:frontend_loreal/models/PDFs/invoice_listero.dart';
import 'package:frontend_loreal/design/Pintar_lista/Candado/candado.dart';
import 'package:frontend_loreal/design/Pintar_lista/Decena/decena.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/centenas.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/fijos_corridos.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/parles.dart';
import 'package:frontend_loreal/design/Pintar_lista/Millon/million.dart';
import 'package:frontend_loreal/design/Pintar_lista/Posicion/posicion.dart';
import 'package:frontend_loreal/design/Pintar_lista/Terminal/terminal.dart';
import 'package:frontend_loreal/models/Lista_Candado/candado_model.dart';
import 'package:frontend_loreal/models/Lista_Decena/decena_model.dart';
import 'package:frontend_loreal/models/Lista_Main/centenas/centenas_model.dart';
import 'package:frontend_loreal/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:frontend_loreal/models/Lista_Main/parles/parles_model.dart';
import 'package:frontend_loreal/models/Lista_Millon/million_model.dart';
import 'package:frontend_loreal/models/Lista_Posicion/posicion_model.dart';
import 'package:frontend_loreal/models/Lista_Terminal/terminal_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

final listControllers = ListControllers();

class ListDetails extends ConsumerStatefulWidget {
  const ListDetails({
    super.key,
    required this.date,
    required this.jornal,
    required this.username,
    required this.lotIncoming,
  });

  final String date, jornal, username, lotIncoming;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListDetailsState();
}

class _ListDetailsState extends ConsumerState<ListDetails> {
  String datePicked = DateFormat.MMMd().format(DateTime.now());
  String id = '';

  bool change = false;

  List<BoliList> infoList = [];

  void makePDF() async {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (infoList.isEmpty) {
      return;
    }

    final calcs = infoList[0].calcs as Map<String, dynamic>;
    final list = boliList(infoList[0].signature!);

    final invoice = InvoiceListero(
        infoListero: InvoiceInfoListero(
            fechaActual: formatFechaActual,
            fechaTirada: infoList[0].date!,
            jornada: infoList[0].jornal!,
            listero: widget.username,
            lote: widget.lotIncoming),
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

  void deleteList() async {
    // ignore: use_build_context_synchronously
    showInfoDialog(
        context,
        'Eliminación de listas',
        FittedBox(
            child:
                textoDosis('Está seguro que desea eliminar esta lista?', 20)),
        () {
      final wasDelete = listControllers.deleteOneList(id);
      wasDelete.then((value) {
        if (value) {
          Navigator.pushReplacementNamed(context, 'main_banquero_page');
        }
      });
    });
  }

  @override
  void initState() {
    LocalStorage.getRole().then((value) {
      if (value == 'banco' && widget.lotIncoming == '') {
        setState(() {
          change = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Detalles de la lista', actions: [
        IconButton(
          icon: const Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          onPressed: () => makePDF(),
        ),
        (change)
            ? IconButton(
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.white,
                ),
                onPressed: () => deleteList())
            : IconButton(
                icon: const Icon(
                  Icons.details_outlined,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(
                    context, 'list_review_page',
                    arguments: [infoList.first, widget.lotIncoming]))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            boldLabel('Sorteo del momento -> ', widget.lotIncoming, 23),
            showList()
          ],
        ),
      ),
    );
  }

  Widget showList() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        child: FutureBuilder(
          future: listControllers.getAllList(
              username: widget.username,
              jornal: widget.jornal,
              date: widget.date),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return waitingWidget(context);
            }
            if (snapshot.data!['data']!.isEmpty || snapshot.data!.isEmpty) {
              return noData(context);
            }

            final data = snapshot.data!['data'];

            final list = boliList(data[0].signature!);
            final decoded = data[0].calcs as Map<String, dynamic>;

            id = data[0].id!;
            infoList = data;

            list.sort(((a, b) {
              if (b is! CalcsModel && a is! CalcsModel) {
                return b.dinero - a.dinero;
              }
              return 0;
            }));

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          boldLabel(
                              'B: ',
                              decoded['bruto'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'L: ',
                              decoded['limpio'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'P: ',
                              decoded['premio'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'P: ',
                              decoded['perdido'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'G: ',
                              decoded['ganado'].toStringAsFixed(0).toString(),
                              18),
                        ],
                      )),
                  const Divider(
                    color: Colors.black,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final color = (isDark)
                              ? Colors.black26
                              : (index % 2 != 0)
                                  ? Colors.grey[200]
                                  : Colors.grey[50];

                          return Container(
                            color: color,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: fila(data: list[index], color: color!),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget fila({required dynamic data, required Color color}) {
    final widgetMap = {
      FijoCorridoModel: (data) => FijosCorridosListaWidget(
            fijoCorrido: data,
            color: color,
          ),
      ParlesModel: (data) => ParlesListaWidget(
            parles: data,
            color: color,
          ),
      CentenasModel: (data) => CentenasListaWidget(
            centenas: data,
            color: color,
          ),
      CandadoModel: (data) => CandadoListaWidget(
            candado: data,
            color: color,
          ),
      TerminalModel: (data) => TerminalListaWidget(
            terminal: data,
            color: color,
          ),
      PosicionModel: (data) => PosicionlListaWidget(
            posicion: data,
            color: color,
          ),
      DecenaModel: (data) => DecenaListaWidget(
            numplay: data,
            color: color,
          ),
      MillionModel: (data) => MillionListaWidget(
            numplay: data,
            color: color,
          ),
    };

    final widgetBuilder = widgetMap[data.runtimeType];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }

  Widget sumEachList() {
    return FutureBuilder(
        future: listControllers.getListById(id),
        builder: (_, AsyncSnapshot<List<BoliList>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boldLabel('B: ', '0', 18),
                  boldLabel('L: ', '0', 18),
                  boldLabel('P: ', '0', 18),
                  boldLabel('P: ', '0', 18),
                  boldLabel('G: ', '0', 18),
                ],
              ),
            );
          }

          final list = snapshot.data;
          final decoded = list![0].calcs as Map<String, dynamic>;

          return Container(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boldLabel(
                    'B: ', decoded['bruto'].toStringAsFixed(0).toString(), 18),
                boldLabel(
                    'L: ', decoded['limpio'].toStringAsFixed(0).toString(), 18),
                boldLabel(
                    'P: ', decoded['premio'].toStringAsFixed(0).toString(), 18),
                boldLabel('P: ',
                    decoded['perdido'].toStringAsFixed(0).toString(), 18),
                boldLabel(
                    'G: ', decoded['ganado'].toStringAsFixed(0).toString(), 18),
              ],
            ),
          );
        });
  }
}
