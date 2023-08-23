import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsProvider extends StateNotifier<Payments> {
  PaymentsProvider() : super(Payments());

  void limpioAllCalcs() {
    state = Payments();
  }

  set totalBruto80(int sum) {
    state = state.copyWith(totalBruto80: state.totalBruto80 + sum);
  }

  set totalBruto70(int sum) {
    state = state.copyWith(totalBruto70: state.totalBruto70 + sum);
  }

  set limpioListero(int sum) {
    state = state.copyWith(limpioListero: state.limpioListero + sum);
  }

  set restaTotalBruto80(int sum) {
    state = state.copyWith(totalBruto80: state.totalBruto80 - sum);
  }

  set restaTotalBruto70(int sum) {
    state = state.copyWith(totalBruto70: state.totalBruto70 - sum);
  }

  set restaLimpioListero(int sum) {
    state = state.copyWith(limpioListero: state.limpioListero - sum);
  }

  void actualizarEstado({
    int? totalBruto80,
    int? totalBruto70,
    int? limpioListero,
  }) {
    state = state.copyWith(
      totalBruto80: totalBruto80,
      totalBruto70: totalBruto70,
      limpioListero: limpioListero,
    );
  }
}

class Payments {
  final int totalBruto80;
  final int totalBruto70;
  final int limpioListero;

  Payments({
    this.totalBruto80  = 0,
    this.totalBruto70  = 0,
    this.limpioListero = 0,
  });

  copyWith({
    int? totalBruto80,
    int? totalBruto70,
    int? limpioListero,
  }) {
    return Payments(
      totalBruto80: totalBruto80 ?? this.totalBruto80,
      totalBruto70: totalBruto70 ?? this.totalBruto70,
      limpioListero: limpioListero ?? this.limpioListero,
    );
  }
}
