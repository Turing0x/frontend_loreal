import 'dart:async';

import 'package:frontend_loreal/api/Lottery/domain/sorteos_model.dart';
import 'package:frontend_loreal/api/Lottery/toServer/sorteo_controller.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';

class SorteosStream {
  static final SorteosStream _singleton = SorteosStream._internal();

  factory SorteosStream() {
    return _singleton;
  }

  SorteosStream._internal() {
    getAllSorteos();
  }

  final _sorteosController = StreamController<List<Sorteo>>.broadcast();

  Stream<List<Sorteo>> get sorteosStream => _sorteosController.stream;

  getAllSorteos() async {
    _sorteosController.sink.add(await getDataSorteo());
  }

  saveSorteo(String lot, String jornal, String date) async {
    final result = await saveDataSorteo(lot, jornal, date);
    if (result) cambioSorteo.value = !cambioSorteo.value;
  }

  deleteSorteo(String id) async {
    final result = await deleteDataSorteo(id);
    if (result) cambioSorteo.value = !cambioSorteo.value;
  }

  editSorteo(String id, String newLot) async {
    final result = await editDataSorteo(id, newLot);
    if (result) cambioSorteo.value = !cambioSorteo.value;
  }
}
