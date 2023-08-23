import 'package:frontend_loreal/design/common/pdf_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget columnasBote({
  required List<dynamic> listaPrincipal,
}) =>
    pw.Container(
      margin: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.topLeft,
      child: construirColumnas(
        listaPrincipal,
        element: _element,
      ),
    );

pw.Widget _element(dynamic element) {
  return pw.Row(
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          ...element.numero
              .map((numero) => numeroRedondo(
                    numero: numero.toString(),
                    mostrarBorde: false,
                    margin: 2,
                    isParles: true,
                    fontWeight: pw.FontWeight.bold,
                  ))
              .toList(),
        ],
      ),
      pw.SizedBox(width: 10),
      botadoDinero(
        numero: element.botado,
        margin: 2,
      )
    ],
  );
}

pw.Widget botadoDinero({
  required num? numero,
  bool mostrarBorde = true,
  bool isParles = false,
  int lenght = 2,
  double margin = 1,
  PdfColor? color,
  PdfColor? fontColor,
  pw.FontWeight? fontWeight,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: tieneBorde(mostrarBorde: mostrarBorde, numero: numero)
            ? PdfColors.black
            : PdfColors.white),
    width: !isParles ? 40 : null,
    height: !isParles ? 40 : null,
    child: pw.Container(
      margin: pw.EdgeInsets.all(margin),
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: tieneBorde(mostrarBorde: mostrarBorde, numero: numero)
            ? color ?? PdfColors.white
            : PdfColors.white,
      ),
      child: pw.Center(
          child: textoDosisPDF(
              numero?.toStringAsFixed(0) ?? '', tamLetra(numero),
              fontWeight: fontWeight, color: fontColor)),
    ),
  );
}

bool tieneBorde({num? numero, required bool mostrarBorde}) {
  if (numero != null && mostrarBorde) return true;
  return false;
}

double tamLetra(num? numero) {
  if (numero != null && numero.toStringAsFixed(0).length >= 4) return 10;
  return 15;
}
