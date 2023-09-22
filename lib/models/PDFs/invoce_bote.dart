
import 'package:frontend_loreal/models/Bote/bote_model.dart';

class InvoiceBote {
  final InvoiceInfoBote infoBote;
  final List<InvoiceItemList> infoList;

  const InvoiceBote({
    required this.infoBote,
    required this.infoList,
  });
}

class InvoiceInfoBote {
  final String fechaActual;
  final String fechaTirada;
  final String jornada;

  const InvoiceInfoBote({
    required this.fechaActual,
    required this.fechaTirada,
    required this.jornada,
  });
}

class InvoiceItemList {
  final List<Botado> lista;
  final int bruto;

  const InvoiceItemList({
    required this.lista,
    required this.bruto,
  });
}
