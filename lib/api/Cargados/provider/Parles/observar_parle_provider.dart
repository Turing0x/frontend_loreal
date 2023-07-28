import 'package:frontend_loreal/api/Cargados/provider/Parles/get_parles_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'observar_parle_provider.g.dart';

@riverpod
int totalBruto(TotalBrutoRef ref, String jornal, String date) {
  final provider = ref.watch(GetParlesCargadosProvider(jornal, date));
  if (provider.isLoading) return 0;
  if (provider.hasError) return 0;
  return provider.asData!.value.fold(0, (previousValue, element) {
    int fijo = element.fijo;
    return previousValue + fijo;
  });
}
