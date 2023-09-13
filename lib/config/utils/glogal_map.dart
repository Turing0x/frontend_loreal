import '../enums/main_list_enum.dart';

Map<String, int> toBlockIfOutOfLimit = <String, int>{};

Map<String, Map<String, int>> toBlockIfOutOfLimitFCPC =
    <String, Map<String, int>>{};

Map<String, Map<String, int>> toBlockIfOutOfLimitTerminal =
    <String, Map<String, int>>{};
Map<String, Map<String, int>> toBlockIfOutOfLimitDecena =
    <String, Map<String, int>>{};

List<Map<String, dynamic>> hasBeenDone = [];

Map<String, List<dynamic>> listado = <String, List<dynamic>>{
  MainListEnum.fijoCorrido.toString(): [],
  MainListEnum.parles.toString(): [],
  MainListEnum.centenas.toString(): [],
};

Map<String, dynamic> listadoCandado = {
  'candado': [],
};

Map<String, dynamic> listadoDecena = {
  'decena': [],
};

Map<String, dynamic> listadoMillon = {
  'millon': [],
};

Map<String, dynamic> listadoPosicion = {
  'posicion': [],
};

Map<String, dynamic> listadoTerminal = {
  'terminal': [],
};

void clearAllMaps() {
  listadoCandado['candado']?.clear();
  listadoDecena['decena']?.clear();
  listadoMillon['millon']?.clear();
  listadoPosicion['posicion']?.clear();
  listadoTerminal['terminal']?.clear();
}
