import 'package:frontend_loreal/config/controllers/million_controller.dart';
import 'package:frontend_loreal/models/Millon/million_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_all_million_provider.g.dart';

@riverpod
Future<List<MillionGame>> getTodosMillion(
    GetTodosMillionRef ref, String jornal, String date) async {
  final millionControllers = MillionControllers();
  final list = await millionControllers.getAllMillion(jornal, date);
  return list;
}
