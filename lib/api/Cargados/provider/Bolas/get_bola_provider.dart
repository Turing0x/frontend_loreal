import 'package:frontend_loreal/api/Cargados/controllers/cargados_controllers.dart';
import 'package:frontend_loreal/api/Cargados/models/cargados_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_bola_provider.g.dart';

@riverpod
Future<List<BolaCargadaModel>> getBolasCargadasref(
    GetBolasCargadasRef ref, String jornal, String date) async {
  final list = await getBolasCargadas(date: date, jornal: jornal);
  return list;
}
