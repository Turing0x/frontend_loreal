import 'dart:io';

import 'package:frontend_loreal/design/Hacer_PDFs/widgets/bold_text.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/widgets/texto_dosis.dart';
import 'package:frontend_loreal/config/extensions/lista_general_extensions.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/models/PDFs/invoice_colector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

bool globalresumen = false;
String globalstartDate = '';
String globalendDate = '';

double tlimpio = 0;
double tpremio = 0;
double tpierde = 0;
double tgana = 0;

class PdfInvoiceApiColectorSimple {
  static Future<String> generate(InvoiceColector invoice,
      {bool resumen = false,
      String startDate = '',
      String endDate = ''}) async {
    try {
      globalresumen = resumen;
      globalstartDate = startDate;
      globalendDate = endDate;

      final pdf = Document();

      tlimpio = 0;
      tpremio = 0;
      tpierde = 0;
      tgana = 0;

      for (var object in invoice.usersColector) {
        tlimpio += object.limpio;
        tpremio += object.premio;
        tpierde += object.pierde;
        tgana += object.gana;
      }

      pdf.addPage(multiPage(invoice));

      String isType = (globalresumen) ? 'Resumen' : 'Vale';
      final fileName =
          '$isType-${invoice.infoColector.coleccion}-${invoice.infoColector.jornada}-${invoice.infoColector.fechaTirada}';

      final folderName =
          'Vales-${invoice.infoColector.fechaTirada}-${invoice.infoColector.jornada}';

      Directory? appDocDirectory = await getExternalStorageDirectory();
      Directory directory =
          await Directory('${appDocDirectory?.path}/PDFDocs/$folderName')
              .create(recursive: true);

      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      return '';
    }
  }

  static pw.MultiPage multiPage(InvoiceColector invoice) {
    return MultiPage(
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildColeccionAndDate(invoice),
        pw.Divider(color: PdfColors.black, endIndent: 20, indent: 20),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTotales(invoice)
      ],
    );
  }

  static Widget buildHeader(InvoiceColector invoice) => topHeader(invoice);

  static Widget buildColeccionAndDate(InvoiceColector invoice) =>
      leftHeader(invoice);

  static pw.Column topHeader(InvoiceColector invoice) =>
      (globalresumen) ? columnResumen(invoice) : columnCS(invoice);

  static pw.Column columnCS(InvoiceColector invoice) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        pwtextoDosis('VALE DE SALIDA DE COLECTOR SIMPLE', 20,
            fontWeight: FontWeight.bold),
        pwboldLabel('Generado el día: ', invoice.infoColector.fechaActual, 18)
      ],
    );
  }

  static pw.Row leftHeader(InvoiceColector invoice) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        pwboldLabel('Coleccón: ', invoice.infoColector.coleccion, 18),
        pwboldLabel('Gasto: ',
            (tlimpio * globalGastoToPDF).round().toString().intPart, 18)
      ]),
      (globalresumen)
          ? columnTiradaYRango(invoice)
          : columnTiradaYFecha(invoice)
    ]);
  }

  static pw.Column columnTiradaYFecha(InvoiceColector invoice) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      (invoice.infoColector.jornada == 'dia')
          ? pwboldLabel('Tirada de la mañana: ', invoice.infoColector.lote, 18)
          : pwboldLabel('Tirada de la noche: ', invoice.infoColector.lote, 18),
      pwboldLabel('Fecha: ', invoice.infoColector.fechaTirada, 18)
    ]);
  }

  static pw.Column columnResumen(InvoiceColector invoice) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        pwtextoDosis('RESÚMEN POR FECHA DE COLECTOR SIMPLE', 20,
            fontWeight: FontWeight.bold),
        pwboldLabel('Generado el día: ', invoice.infoColector.fechaActual, 18)
      ],
    );
  }

  static pw.Column columnTiradaYRango(InvoiceColector invoice) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      (invoice.infoColector.jornada == 'dia')
          ? pwtextoDosis('Jornada de la mañana', 18,
              fontWeight: FontWeight.bold)
          : pwtextoDosis('Jornada de la noche', 18,
              fontWeight: FontWeight.bold),
      pwboldLabel(
          'Entre las fechas: ', '$globalstartDate -- $globalendDate', 18)
    ]);
  }

  static Widget buildInvoice(InvoiceColector invoice) {
    final headers = [
      'Código',
      'Limpio',
      'Premio',
      'Pierde',
      'Gana',
    ];
    final data = invoice.usersColector.map((item) {
      return [
        item.codigo,
        item.limpio.toString().intPart,
        item.premio.toString().intPart,
        item.pierde.toString().intPart,
        item.gana.toString().intPart
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
      },
    );
  }

  static Widget buildTotales(InvoiceColector invoice) => rowBottom();

  static pw.Row rowBottom() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      columnTotales(),
      (tlimpio > tpremio) ? restaPremio() : restaLimpio(),
      (tpierde > tgana) ? restaGana() : restaPierde()
    ]);
  }

  static pw.Container restaPierde() {
    return Container(
        alignment: Alignment.center,
        width: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          pwtextoDosis(tgana.toString().intPart, 20,
              fontWeight: FontWeight.bold),
          pwtextoDosis('- ${tpierde.toString().intPart}', 20,
              fontWeight: FontWeight.bold),
          pw.Divider(color: PdfColors.black),
          pwtextoDosis((tgana - tpierde).toString().intPart, 20,
              fontWeight: FontWeight.bold),
          pwtextoDosis(
              '+ ${(tlimpio * globalGastoToPDF).round().toString().intPart}',
              20,
              fontWeight: FontWeight.bold),
          pw.Divider(color: PdfColors.black),
          pwtextoDosis(
              ((tgana - tpierde) + (tlimpio * globalGastoToPDF).round())
                  .toString()
                  .intPart,
              20,
              fontWeight: FontWeight.bold),
        ]));
  }

  static pw.Container restaGana() {
    return Container(
        alignment: Alignment.center,
        width: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          pwtextoDosis(tpierde.toString().intPart, 20,
              fontWeight: FontWeight.bold),
          pwtextoDosis('- ${tgana.toString().intPart}', 20,
              fontWeight: FontWeight.bold),
          pw.Divider(color: PdfColors.black),
          pwtextoDosis((tpierde - tgana).toString().intPart, 20,
              fontWeight: FontWeight.bold),
          pwtextoDosis(
              '- ${(tlimpio * globalGastoToPDF).round().toString().intPart}',
              20,
              fontWeight: FontWeight.bold),
          pw.Divider(color: PdfColors.black),
          ((tpierde - tgana) < (tlimpio * globalGastoToPDF))
              ? pwtextoDosis(
                  ((tlimpio * globalGastoToPDF).round() - (tpierde - tgana))
                      .toString()
                      .intPart,
                  20,
                  fontWeight: FontWeight.bold)
              : pwtextoDosis(
                  ((tpierde - tgana) - (tlimpio * globalGastoToPDF).round())
                      .toString()
                      .intPart,
                  20,
                  fontWeight: FontWeight.bold)
        ]));
  }

  static pw.Container restaLimpio() {
    return Container(
        alignment: Alignment.center,
        width: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          pwtextoDosis(tpremio.toString().intPart, 20,
              fontWeight: FontWeight.bold),
          pwtextoDosis('- ${tlimpio.toString().intPart}', 20,
              fontWeight: FontWeight.bold),
          pw.Divider(color: PdfColors.black),
          pwtextoDosis((tpremio - tlimpio).toString().intPart, 20,
              fontWeight: FontWeight.bold),
          sumarGasto()
        ]));
  }

  static pw.Container restaPremio() {
    return Container(
        alignment: Alignment.center,
        width: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          pwtextoDosis(tlimpio.toString().intPart, 20,
              fontWeight: FontWeight.bold),
          pwtextoDosis('- ${tpremio.toString().intPart}', 20,
              fontWeight: FontWeight.bold),
          pw.Divider(color: PdfColors.black),
          pwtextoDosis((tlimpio - tpremio).toString().intPart, 20,
              fontWeight: FontWeight.bold),
          restarGasto()
        ]));
  }

  static pw.Column columnTotales() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      pwtextoDosis('TOTALES', 20, fontWeight: FontWeight.bold),
      pwboldLabel('Limpio: ', tlimpio.toString().intPart, 15),
      pwboldLabel('Premio: ', tpremio.toString().intPart, 15),
      pwboldLabel('Pierde: ', tpierde.toString().intPart, 15),
      pwboldLabel('Gana: ', tgana.toString().intPart, 15)
    ]);
  }

  static pw.Column restarGasto() {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      pwtextoDosis(
          '- ${(tlimpio * globalGastoToPDF).round().toString().intPart}', 20,
          fontWeight: FontWeight.bold),
      pw.Divider(color: PdfColors.black),
      ((tlimpio - tpremio) < (tlimpio * globalGastoToPDF).round())
          ? pwtextoDosis(
              ((tlimpio * globalGastoToPDF).round() - (tlimpio - tpremio))
                  .toString()
                  .intPart,
              20,
              fontWeight: FontWeight.bold)
          : pwtextoDosis(
              ((tlimpio - tpremio) - (tlimpio * globalGastoToPDF).round())
                  .toString()
                  .intPart,
              20,
              fontWeight: FontWeight.bold)
    ]);
  }

  static pw.Column sumarGasto() {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      pwtextoDosis(
          '+ ${(tlimpio * globalGastoToPDF).round().toString().intPart}', 20,
          fontWeight: FontWeight.bold),
      pw.Divider(color: PdfColors.black),
      pwtextoDosis(
          ((tpremio - tlimpio) + (tlimpio * globalGastoToPDF).round())
              .toString()
              .intPart,
          20,
          fontWeight: FontWeight.bold),
    ]);
  }
}
