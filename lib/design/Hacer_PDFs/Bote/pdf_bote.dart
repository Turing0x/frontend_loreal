import 'dart:io';

import 'package:frontend_loreal/design/Hacer_PDFs/Bote/columnas_bote.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/widgets/bold_text.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/widgets/texto_dosis.dart';
import 'package:frontend_loreal/design/common/pdf_widget.dart';
import 'package:frontend_loreal/models/PDFs/invoce_bote.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApiBote {
  static Future<bool> generate(InvoiceBote invoice) async {
    try {
      final pdf = Document();

      pdf.addPage(MultiPage(
          build: (context) {
            return [
              pw.Container(
                margin: const EdgeInsets.only(left: 20),
                child: buildHeader(invoice),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              pw.Container(
                margin: const EdgeInsets.only(left: 20),
                child: buildAndDate(invoice),
              ),
              pw.Divider(color: PdfColors.black, endIndent: 20, indent: 20),
              pw.Container(
                margin: const EdgeInsets.only(left: 40),
                child: boldLabelPDF(
                    'Bruto: ', invoice.infoList[0].bruto.toString(), 18),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              pw.Container(
                margin: const EdgeInsets.only(left: 20),
                child: columnasBote(listaPrincipal: invoice.infoList[0].lista),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
            ];
          },
          pageFormat: const PdfPageFormat(1500, 1500)));

      final fileName =
          'BOTE-${invoice.infoBote.jornada}-${invoice.infoBote.fechaTirada}';

      Directory? appDocDirectory = await getExternalStorageDirectory();
      Directory('${appDocDirectory?.path}/PDFDocs/Botes')
          .create(recursive: true)
          .then((Directory directory) async {
        final file = File('${directory.path}/$fileName.pdf');
        await file.writeAsBytes(await pdf.save());
        return true;
      }).catchError((onError) {
        return false;
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Widget buildHeader(InvoiceBote invoice) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pwtextoDosis('DETALLES DEL BOTE', 20, fontWeight: FontWeight.bold),
          pwboldLabel('Generado el día: ', invoice.infoBote.fechaActual, 18)
        ],
      );

  static Widget buildAndDate(InvoiceBote invoice) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        pwboldLabel('Fecha: ', invoice.infoBote.fechaTirada, 18),
        SizedBox(width: 50),
        pwboldLabel('Jornada: ', invoice.infoBote.jornada, 18),
      ]);
}
