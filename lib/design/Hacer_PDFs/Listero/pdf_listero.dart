import 'dart:io';

import 'package:frontend_loreal/design/Hacer_PDFs/widgets/bold_text.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/widgets/texto_dosis.dart';
import 'package:frontend_loreal/design/common/principal_pdf.dart';
import 'package:frontend_loreal/models/PDFs/invoice_listero.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApiListero {
  static Future<Map<String, dynamic>> generate(InvoiceListero invoice) async {
    try {
      final pdf = Document();

      pdf.addPage(MultiPage(
          build: (context) {
            return [
              buildHeader(invoice),
              SizedBox(height: 1 * PdfPageFormat.cm),
              buildColeccionAndDate(invoice),
              pw.Divider(color: PdfColors.black, endIndent: 20, indent: 20),
              buildTotales(invoice),
              SizedBox(height: 1 * PdfPageFormat.cm),
              principalPDF(
                listaPrincipal: invoice.infoList[0].lista,
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
            ];
          },
          pageFormat: const PdfPageFormat(1500, 1500)));

      final fileName =
          'Lista-${invoice.infoListero.listero}-${invoice.infoListero.jornada}-${invoice.infoListero.fechaTirada}';
      final folderName =
          'Listas-${invoice.infoListero.fechaTirada}-${invoice.infoListero.jornada}';

      String onlyLetters =
          invoice.infoListero.listero.replaceAll(RegExp('[^a-zA-Z]'), '');

      Directory? appDocDirectory = await getExternalStorageDirectory();
      Directory directory = await Directory(
              '${appDocDirectory?.path}/PDFList/$folderName/$onlyLetters')
          .create(recursive: true);

      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      return {'done': true, 'path': file.path};
    } catch (onError) {
      return {'done': false, 'path': onError.toString()};
    }
  }

  static Widget buildHeader(InvoiceListero invoice) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pwtextoDosis('DETALLES DE LISTA', 20, fontWeight: FontWeight.bold),
          pwboldLabel('Generado el día: ', invoice.infoListero.fechaActual, 18)
        ],
      );

  static Widget buildColeccionAndDate(InvoiceListero invoice) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          pwboldLabel('Listero: ', invoice.infoListero.listero, 18),
          pwboldLabel('Fecha: ', invoice.infoListero.fechaTirada, 18),
        ]),
        SizedBox(width: 50),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          pwboldLabel('Sorteo del momento: ', invoice.infoListero.lote, 18),
          pwboldLabel('Jornada: ', invoice.infoListero.jornada, 18),
        ]),
      ]);

  static Widget buildTotales(InvoiceListero invoice) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      pwboldLabel('Bruto: ', invoice.infoList[0].bruto.toString(), 15),
      SizedBox(width: 10),
      pwboldLabel('Limpio: ', invoice.infoList[0].limpio.toString(), 15),
      SizedBox(width: 10),
      pwboldLabel('Premio: ', invoice.infoList[0].premio.toString(), 15),
      SizedBox(width: 10),
      pwboldLabel('Pierde: ', invoice.infoList[0].pierde.toString(), 15),
      SizedBox(width: 10),
      pwboldLabel('Gana: ', invoice.infoList[0].gana.toString(), 15),
    ]);
  }
}
