import 'package:frontend_loreal/config/riverpod/get_all_million_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'observar_million_provider.g.dart';

@riverpod
int totalBruto(TotalBrutoRef ref, String jornal, String date) {
  final provider = ref.watch(GetTodosMillionProvider(jornal, date));
  if (provider.isLoading) return 0;
  if (provider.hasError) return 0;
  return provider.asData!.value.fold(0, (previousValue, element) {
    int fijo = element.millionPlay.fijo;
    int corrido = element.millionPlay.corrido;
    return previousValue + fijo + corrido;
  });
}
