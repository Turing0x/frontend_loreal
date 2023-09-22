import 'dart:async';

import 'package:frontend_loreal/models/Lista/list_offline_model.dart';

import 'bd_provider.dart';

class ListasBloc {
  static final ListasBloc _singleton = ListasBloc._internal();

  factory ListasBloc() {
    return _singleton;
  }

  ListasBloc._internal() {
    getTodosListas();
  }

  final _listasControlador = StreamController<List<OfflineList>>.broadcast();

  Stream<List<OfflineList>> get listasStream => _listasControlador.stream;

  getTodosListas() async {
    _listasControlador.sink.add(await DBProviderListas.db.getTodasListas());
  }

  agregarLista(String date, String jornal, String signature, String bruto,
      String limpio) {
    DBProviderListas.db.nuevaLista(date, jornal, signature, bruto, limpio);
    getTodosListas();
  }

  eliminarLista(String id) {
    DBProviderListas.db.eliminarLista(id);
    getTodosListas();
  }

  dispose() {
    _listasControlador.close();
  }
}
