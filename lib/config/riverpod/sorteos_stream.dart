import 'dart:async';

import 'package:frontend_loreal/config/controllers/sorteo_controller.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/models/Sorteo/sorteos_model.dart';

class SorteosStream {
  static final SorteosStream _singleton = SorteosStream._internal();
  final sorteosControllers = SorteosControllers();

  factory SorteosStream() {
    return _singleton;
  }

  SorteosStream._internal() {
    getAllSorteos();
  }

  final _sorteosController = StreamController<List<Sorteo>>.broadcast();

  Stream<List<Sorteo>> get sorteosStream => _sorteosController.stream;

  getAllSorteos() async {
    _sorteosController.sink.add(await sorteosControllers.getDataSorteo());
  }

  saveSorteo(String lot, String jornal, String date) async {
    final result = await sorteosControllers.saveDataSorteo(lot, jornal, date);
    if (result) cambioSorteo.value = !cambioSorteo.value;
  }

  deleteSorteo(String id) async {
    final result = await sorteosControllers.deleteDataSorteo(id);
    if (result) cambioSorteo.value = !cambioSorteo.value;
  }

  editSorteo(String id, String newLot) async {
    final result = await sorteosControllers.editDataSorteo(id, newLot);
    if (result) cambioSorteo.value = !cambioSorteo.value;
  }
}
