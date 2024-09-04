import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.RichText boldLabelPDF(String texto, String another, double? fontSize,
    {PdfColor? color = PdfColors.black}) {
  return pw.RichText(
    text: pw.TextSpan(
      // Here is the explicit parent TextStyle
      style: pw.TextStyle(
        fontSize: fontSize,
        color: color,
      ),
      children: <pw.TextSpan>[
        pw.TextSpan(
            text: texto, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TextSpan(text: another),
      ],
    ),
  );
}

pw.Widget textoDosisPDF(
  String texto,
  double? fontSize, {
  pw.FontWeight? fontWeight = pw.FontWeight.normal,
  pw.TextAlign? textAlign = pw.TextAlign.left,
  PdfColor? color = PdfColors.black,
  int? maxLines,
}) {
  return pw.Text(
    texto,
    maxLines: maxLines,
    style: pw.TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}

pw.Widget rayaPDF() {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 2.5),
    child: pw.Container(
      height: 1,
      width: 5,
      color: PdfColor.fromRYB(0, 0, 0),
    ),
  );
}

pw.Widget construirColumnas(
  List<dynamic> lista, {
  int maxPorColumn = 23,
  required pw.Widget Function(dynamic) element,
}) {
  final max = (lista.length / maxPorColumn).ceil();

  return pw.Wrap(
    children: [
      for (var i = 0; i < max; i++)
        pw.Container(
          padding: const pw.EdgeInsets.all(5),
          margin: pw.EdgeInsets.zero,
          width: 280,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.black,
            ),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              for (var j = 0; j < maxPorColumn; j++)
                if (i * maxPorColumn + j < lista.length)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 5),
                    child: element(lista[i * maxPorColumn + j]),
                  ),
            ],
          ),
        ),
    ],
  );
}

pw.Widget numeroRedondo({
  required String numero,
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
        color: tieneBorde(mostrarBorde: mostrarBorde, numero: int.parse(numero))
            ? PdfColors.black
            : PdfColors.white),
    width: !isParles ? 40 : null,
    height: !isParles ? 40 : null,
    child: pw.Container(
      margin: pw.EdgeInsets.all(margin),
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: tieneBorde(mostrarBorde: mostrarBorde, numero: int.parse(numero))
            ? color ?? PdfColors.white
            : PdfColors.white,
      ),
      child: pw.Center(
          child: textoDosisPDF(
              numero.rellenarCon0(lenght), tamLetra(int.parse(numero)),
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
