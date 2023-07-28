import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataOfflineList extends StateNotifier<OfflineList> {
  DataOfflineList() : super(OfflineList());

  void cleanInfo() {
    state = OfflineList();
  }

  set owner(String setowner) {
    state = state.copyWith(owner: setowner);
  }
  
  set jornal(String setjornal) {
    state = state.copyWith(jornal: setjornal);
  }
  
  set date(String setdate) {
    state = state.copyWith(date: setdate);
  }

  set signature(String setsignature) {
    state = state.copyWith(signature: setsignature);
  }

  set bruto(String setbruto) {
    state = state.copyWith(bruto: setbruto);
  }

  set limpio(String setlimpio) {
    state = state.copyWith(limpio: setlimpio);
  }
  
  void actualizarEstado({
    String? owner,
    String? jornal,
    String? date,
    String? signature,
    String? bruto,
    String? limpio
  }) {
    state = state.copyWith(
      owner: owner,
      jornal: jornal,
      date: date,
      signature: signature,
      bruto: bruto,
      limpio: limpio,
    );
  }
}

class OfflineList {
  
  final String? owner;
  final String? jornal;
  final String? date;
  final String? signature;
  final String? bruto;
  final String? limpio;

  OfflineList({
    this.owner = 'Vacío',
    this.jornal = 'Vacío',
    this.date = 'Vacío',
    this.signature = 'Vacío',
    this.bruto = 'Vacío',
    this.limpio = 'Vacío',
  });

  copyWith({
    String? owner,
    String? jornal,
    String? date,
    String? signature,
    String? bruto,
    String? limpio,
  }) {
    return OfflineList(
      owner: owner ?? this.owner,
      jornal: jornal ?? this.jornal,
      date: date ?? this.date,
      signature: signature ?? this.signature,
      bruto: bruto ?? this.bruto,
      limpio: limpio ?? this.limpio,
    );
  }

}