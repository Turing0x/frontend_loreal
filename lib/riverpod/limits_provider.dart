import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalLimitsProvider extends StateNotifier<GlobalLimits> {
  GlobalLimitsProvider() : super(GlobalLimits());

  void cleanLimits() {
    state = GlobalLimits();
  }

  set fijo(int fijo) {
    state = state.copyWith(fijo: fijo);
  }
  
  set corrido(int corrido) {
    state = state.copyWith(corrido: corrido);
  }
  
  set parle(int parle) {
    state = state.copyWith(parle: parle);
  }

  set centena(int centena) {
    state = state.copyWith(centena: centena);
  }

  set limitesmillonFijo(int limitesmillonFijo) {
    state = state.copyWith(limitesmillonFijo: limitesmillonFijo);
  }

  set limitesmillonCorrido(int limitesmillonCorrido) {
    state = state.copyWith(limitesmillonCorrido: limitesmillonCorrido);
  }
  
  set porcientoParleListero(int porcientoParleListero) {
    state = state.copyWith(porcientoParleListero: porcientoParleListero);
  }
  
  set porcientoBolaListero(int porcientoBolaListero) {
    state = state.copyWith(porcientoBolaListero: porcientoBolaListero);
  }

  void actualizarEstado({
    int? parle,
    int? fijo,
    int? centena,
    int? corrido,
    int? limitesmillonFijo,
    int? limitesmillonCorrido,
    int? porcientoParleListero,
    int? porcientoBolaListero,
  }) {
    state = state.copyWith(
      parle: parle,
      fijo: fijo,
      centena: centena,
      corrido: corrido,
      limitesmillonFijo: limitesmillonFijo,
      limitesmillonCorrido: limitesmillonCorrido,
      porcientoParleListero: porcientoParleListero,
      porcientoBolaListero: porcientoBolaListero,
    );
  }
}

class GlobalLimits {
  int parle;
  int fijo;
  int centena;
  int corrido;
  int limitesmillonFijo;
  int limitesmillonCorrido;
  int porcientoParleListero;
  int porcientoBolaListero;

  GlobalLimits({
    this.parle = 500,
    this.fijo = 500,
    this.centena = 500,
    this.corrido = 500,
    this.limitesmillonFijo = 100,
    this.limitesmillonCorrido = 100,
    this.porcientoParleListero = 30,
    this.porcientoBolaListero = 20,
  });

  copyWith({
    int? parle,
    int? fijo,
    int? centena,
    int? corrido,
    int? limitesmillonFijo,
    int? limitesmillonCorrido,
    int? porcientoParleListero,
    int? porcientoBolaListero,
  }) {
    return GlobalLimits(
      parle: parle ?? this.parle,
      centena: centena ?? this.centena,
      fijo: fijo ?? this.fijo,
      corrido: corrido ?? this.corrido,
      limitesmillonFijo: limitesmillonFijo ?? this.limitesmillonFijo,
      limitesmillonCorrido: limitesmillonCorrido ?? this.limitesmillonCorrido,
      porcientoParleListero: porcientoParleListero ?? this.porcientoParleListero,
      porcientoBolaListero: porcientoBolaListero ?? this.porcientoBolaListero,
    );
  }
}
