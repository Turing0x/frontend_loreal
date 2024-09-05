import 'package:safe_chat/design/Hacer_PDFs/widgets/texto_dosis.dart';
import 'package:safe_chat/design/common/pdf_widget.dart';
import 'package:safe_chat/models/Lista_Candado/candado_model.dart';
import 'package:safe_chat/models/Lista_Decena/decena_model.dart';
import 'package:safe_chat/models/Lista_Main/centenas/centenas_model.dart';
import 'package:safe_chat/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:safe_chat/models/Lista_Main/parles/parles_model.dart';
import 'package:safe_chat/models/Lista_Millon/million_model.dart';
import 'package:safe_chat/models/Lista_Posicion/posicion_model.dart';
import 'package:safe_chat/models/Lista_Terminal/terminal_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget principalPDF({
  required List<dynamic> listaPrincipal,
}) =>
    pw.Container(
        margin: const pw.EdgeInsets.all(8),
        alignment: pw.Alignment.topLeft,
        child: construirColumnas(
          listaPrincipal,
          element: _element,
        ));

pw.Widget _element(dynamic element) {
  if (element is FijoCorridoModel) {
    return _fijoCorridoView(element);
  }
  if (element is DecenaModel) {
    return _decenaView(element);
  }
  if (element is ParlesModel) {
    return _parlesView(element);
  }
  if (element is CentenasModel) {
    return _centenasView(element);
  }
  if (element is TerminalModel) {
    return _terminalView(element);
  }
  if (element is MillionModel) {
    return _millionView(element);
  }
  if (element is PosicionModel) {
    return _posicionView(element);
  }
  if (element is CandadoModel) {
    return _candadoView(element);
  }

  return pw.Container();
}

pw.Widget _fijoCorridoView(FijoCorridoModel model) {
  return pw.Row(
    children: [
      numeroRedondo(
        numero: model.numplay.toString(),
        mostrarBorde: false,
        fontWeight: pw.FontWeight.bold,
      ),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.corrido.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _parlesView(ParlesModel model) {
  return pw.Row(
    children: [
      pw.SizedBox(width: 10),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          ...model.numplay.map((numero) => numeroRedondo(
                numero: numero.toString(),
                mostrarBorde: false,
                margin: 2,
                isParles: true,
                fontWeight: pw.FontWeight.bold,
              )),
        ],
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _centenasView(CentenasModel model) {
  return pw.Row(
    children: [
      numeroRedondo(
        numero: model.numplay.toString(),
        mostrarBorde: false,
        lenght: 3,
        fontWeight: pw.FontWeight.bold,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _terminalView(TerminalModel model) {
  return pw.Row(
    children: [
      pw.SizedBox(width: 10),
      textoDosisPDF('T->', 18, fontWeight: pw.FontWeight.bold),
      numeroRedondo(
        numero: model.terminal.toString(),
        mostrarBorde: false,
        lenght: 1,
        fontWeight: pw.FontWeight.bold,
      ),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.corrido.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _decenaView(DecenaModel model) {
  return pw.Row(
    children: [
      pw.SizedBox(width: 10),
      textoDosisPDF('D ->', 18, fontWeight: pw.FontWeight.bold),
      numeroRedondo(
        numero: model.numplay.toString(),
        mostrarBorde: false,
        lenght: 1,
        fontWeight: pw.FontWeight.bold,
      ),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.corrido.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _millionView(MillionModel model) {
  return pw.Row(
    children: [
      pw.SizedBox(width: 10),
      pwtextoDosis(model.numplay, 18, fontWeight: pw.FontWeight.bold),
      pw.SizedBox(width: 5),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.corrido.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _candadoView(CandadoModel model) {
  List<String> toPrint =
      model.numplay.map((e) => e.toString().padLeft(2, '0')).toList();

  return pw.Row(
    children: [
      pw.SizedBox(width: 10),
      pw.SizedBox(
          width: 150,
          child: textoDosisPDF(
              toPrint.toString().replaceAll('[', '').replaceAll(']', ''), 18,
              maxLines: 10)),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}

pw.Widget _posicionView(PosicionModel model) {
  return pw.Row(
    children: [
      numeroRedondo(
        numero: model.numplay.toString().padLeft(2, '0'),
        mostrarBorde: false,
        lenght: 1,
        fontWeight: pw.FontWeight.bold,
      ),
      numeroRedondo(
        numero: model.fijo.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.corrido.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      numeroRedondo(
        numero: model.corrido2.toString(),
        margin: 2,
      ),
      pw.SizedBox(width: 10),
      (model.dinero != 0)
          ? numeroRedondo(
              numero: model.dinero.toString(),
              margin: 2,
              fontColor: PdfColors.red)
          : pw.Container()
    ],
  );
}
