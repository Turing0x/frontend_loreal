import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/database/list_table/bd_provider.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/Listero/pdf_listero.dart';
import 'package:frontend_loreal/design/Pintar_lista/methods.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/models/Lista/list_offline_model.dart';
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

class ListDetailsOffline extends ConsumerStatefulWidget {
  const ListDetailsOffline({
    super.key,
    required this.id,
  });

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListDetailsOfflineState();
}

class _ListDetailsOfflineState extends ConsumerState<ListDetailsOffline> {
  String datePicked = DateFormat.MMMd().format(DateTime.now());
  String lotThisDay = '';
  String totalBruto = '';

  List<OfflineList> infoList = [];
  String userNameOffline = '';
  String signature = '';

  @override
  void initState() {
    final username = LocalStorage.getUsername();
    username.then((value) => {userNameOffline = value!});
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
            onPressed: () => makePdf())
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            sumEachList(),
            const Divider(
              color: Colors.black,
              indent: 20,
              endIndent: 20,
            ),
            showList()
          ],
        ),
      ),
    );
  }

  void makePdf() {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    final list = boliList(signature);

    final invoice = InvoiceListero(
        infoListero: InvoiceInfoListero(
            fechaActual: formatFechaActual,
            fechaTirada: infoList[0].date!,
            jornada: infoList[0].jornal!,
            listero: userNameOffline,
            lote: ''),
        infoList: [
          InvoiceItemList(
              lista: list,
              bruto: double.parse(infoList[0].bruto.toString()),
              limpio: double.parse(infoList[0].limpio.toString()),
              premio: 0,
              pierde: 0,
              gana: 0)
        ]);

    PdfInvoiceApiListero.generate(invoice);
    showToast(context, 'Lista exportada exitosamente', type: true);
  }

  Widget showList() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        width: double.infinity,
        child: FutureBuilder(
          future: DBProviderListas.db.getLista(widget.id),
          builder: (context, AsyncSnapshot<List<OfflineList>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return waitingWidget(context);
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return noData(context);
            }

            final list = boliList(snapshot.data![0].signature!);
            signature = snapshot.data![0].signature!;
            infoList = snapshot.data!;

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final color =
                        (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50];
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
        future: DBProviderListas.db.getLista(widget.id),
        builder: (_, AsyncSnapshot<List<OfflineList>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boldLabel('B: ', '0', 25),
                  const SizedBox(width: 30),
                  boldLabel('L: ', '0', 25),
                ],
              ),
            );
          }

          final list = snapshot.data;

          return Container(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                boldLabel('B: ', list![0].bruto.toString(), 25),
                const SizedBox(width: 30),
                boldLabel('L: ', list[0].limpio.toString(), 25),
              ],
            ),
          );
        });
  }
}
