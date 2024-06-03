import 'package:intl/intl.dart';

extension StringExtension on String {
  double get doubleParsed => double.parse(this);
  double? get doubleTryParsed => double.tryParse(this);
  int get intParsed => int.parse(this);
  int? get intTryParsed => int.tryParse(this);
  String rellenarCon0(int maxLength) {
    final resta = maxLength - length;
    if (maxLength == 0 || resta == 0) return this;
    return '${_generadorDe0(resta)}$this ';
  }

  String rellenarCon00(int maxLength) {
    final resta = maxLength - length;
    if (maxLength == 0 || resta == 0) return this;
    return '${_generadorDe0(resta)}$this';
  }

  String _generadorDe0(int length) {
    String devolucion = '';
    while (devolucion.length < length) {
      devolucion += '0';
    }
    return devolucion;
  }

  String get quitarFecha => split(' - ')[0];
  String get version => split('.apk')[0];
  String get intPart => split('.')[0].intParsed.numFormat;
}

extension IntExtension on int {
  String get numFormat => NumberFormat('#,###').format(this);
}

extension ListEquals on List<int> {
  bool equals(List<dynamic> other) {
    if (length != other.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}