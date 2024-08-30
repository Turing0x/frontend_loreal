import 'package:sticker_maker/config/controllers/cargados_controllers.dart';
import 'package:sticker_maker/models/Cargados/cargados_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_bola_provider.g.dart';

@riverpod
Future<List<BolaCargadaModel>> getBolasCargadasref(
    GetBolasCargadasRef ref, String jornal, String date) async {
  final list = await getBolasCargadas(date: date, jornal: jornal);
  return list;
}
