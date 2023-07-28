class InvoiceListero {
  final InvoiceInfoListero infoListero;
  final List<InvoiceItemList> infoList;

  const InvoiceListero({
    required this.infoListero,
    required this.infoList,
  });
}

class InvoiceInfoListero {
  final String fechaActual;
  final String fechaTirada;
  final String jornada;
  final String listero;
  final String lote;

  const InvoiceInfoListero({
    required this.fechaActual,
    required this.fechaTirada,
    required this.jornada,
    required this.listero,
    required this.lote,
  });
}

class InvoiceItemList {
  final List<dynamic> lista;
  final double bruto;
  final double limpio;
  final double premio;
  final double pierde;
  final double gana;

  const InvoiceItemList({
    required this.lista,
    required this.bruto,
    required this.limpio,
    required this.premio,
    required this.pierde,
    required this.gana,
  });
}