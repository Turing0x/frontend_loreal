import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/Hacer_PDFs/Listero/pdf_listero.dart';
import 'package:sticker_maker/design/Pintar_lista/Candado/candado.dart';
import 'package:sticker_maker/design/Pintar_lista/Decena/decena.dart';
import 'package:sticker_maker/design/Pintar_lista/MainList/centenas.dart';
import 'package:sticker_maker/design/Pintar_lista/MainList/fijos_corridos.dart';
import 'package:sticker_maker/design/Pintar_lista/MainList/parles.dart';
import 'package:sticker_maker/design/Pintar_lista/Millon/million.dart';
import 'package:sticker_maker/design/Pintar_lista/Posicion/posicion.dart';
import 'package:sticker_maker/design/Pintar_lista/Terminal/terminal.dart';
import 'package:sticker_maker/design/Pintar_lista/methods.dart';
import 'package:sticker_maker/models/Lista_Candado/candado_model.dart';
import 'package:sticker_maker/models/Lista_Decena/decena_model.dart';
import 'package:sticker_maker/models/Lista_Main/centenas/centenas_model.dart';
import 'package:sticker_maker/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:sticker_maker/models/Lista_Main/parles/parles_model.dart';
import 'package:sticker_maker/models/Lista_Millon/million_model.dart';
import 'package:sticker_maker/models/Lista_Posicion/posicion_model.dart';
import 'package:sticker_maker/models/Lista_Terminal/terminal_model.dart';
import 'package:sticker_maker/models/PDFs/invoice_listero.dart';
import 'package:intl/intl.dart';

class SeeListDetailAfterSend extends ConsumerStatefulWidget {
  const SeeListDetailAfterSend({
    super.key,
    required this.date,
    required this.jornal,
    required this.owner,
    required this.signature,
    required this.bruto,
    required this.limpio,
  });

  final String date;
  final String jornal;
  final String owner;
  final String signature;
  final String bruto;
  final String limpio;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeeListDetailAfterSendState();
}

class _SeeListDetailAfterSendState
    extends ConsumerState<SeeListDetailAfterSend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Detalles de la lista', actions: [
        IconButton(
          icon: const Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          onPressed: () async {
            DateTime now = DateTime.now();
            String formatFechaActual =
                DateFormat('dd/MM/yyyy hh:mm a').format(now);

            final list = boliList(widget.signature);

            final invoice = InvoiceListero(
                infoListero: InvoiceInfoListero(
                    fechaActual: formatFechaActual,
                    fechaTirada: widget.date,
                    jornada: widget.jornal,
                    listero: widget.owner,
                    lote: ''),
                infoList: [
                  InvoiceItemList(
                      lista: list,
                      bruto: double.parse(widget.bruto.toString()),
                      limpio: double.parse(widget.limpio.toString()),
                      premio: 0,
                      pierde: 0,
                      gana: 0)
                ]);

            PdfInvoiceApiListero.generate(invoice);
            showToast(context, 'Lista exportada exitosamente', type: true);
          },
        )
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

  Widget showList() {
    final list = boliList(widget.signature);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final color = (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50];
            return Container(
              color: color,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: fila(data: list[index], color: color!),
              ),
            );
          }),
    );
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
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            boldLabel('B: ', widget.bruto, 25),
            const SizedBox(width: 30),
            boldLabel('L: ', widget.limpio, 25),
          ],
        ));
  }
}
