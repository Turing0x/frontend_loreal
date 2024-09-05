import 'package:safe_chat/config/controllers/cargados_controllers.dart';
import 'package:safe_chat/models/Cargados/cargados_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_parles_provider.g.dart';

@riverpod
Future<List<BolaCargadaModel>> getParlesCargadosref(
    GetParlesCargadosRef ref, String jornal, String date) async {
  final list = await getParleCargadas(date: date, jornal: jornal);
  return list;
}
