import 'package:frontend_loreal/api/Million/domain/million_model.dart';
import 'package:frontend_loreal/api/Million/toServer/million_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_all_million_provider.g.dart';

@riverpod
Future<List<MillionGame>> getTodosMillion(
    GetTodosMillionRef ref, String jornal, String date) async {
  final list = await getAllMillion(jornal, date);
  return list;
}
