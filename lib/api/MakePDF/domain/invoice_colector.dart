class InvoiceColector {
  final InvoiceInfoColector infoColector;
  final List<InvoiceItemColector> usersColector;

  const InvoiceColector({
    required this.infoColector,
    required this.usersColector,
  });
}

class InvoiceInfoColector {
  final String fechaActual;
  final String fechaTirada;
  final String jornada;
  final String coleccion;
  final String lote;

  const InvoiceInfoColector({
    required this.fechaActual,
    required this.fechaTirada,
    required this.jornada,
    required this.coleccion,
    required this.lote,
  });
}

class InvoiceItemColector {
  final String codigo;
  final int exprense;
  final double limpio;
  final double premio;
  final double pierde;
  final double gana;

  const InvoiceItemColector({
    required this.codigo,
    required this.exprense,
    required this.limpio,
    required this.premio,
    required this.pierde,
    required this.gana,
  });
}