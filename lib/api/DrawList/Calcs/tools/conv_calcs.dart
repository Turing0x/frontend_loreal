import 'package:frontend_loreal/api/DrawList/Calcs/models/calcs_model.dart';
import 'package:frontend_loreal/extensions/lista_general_extensions.dart';
import 'package:frontend_loreal/enums/lista_general_enum.dart';

List<dynamic> convertirPayloadCalcs(Map<String, dynamic> map) {
  final mapaActual =
      map[ListaGeneralEnum.calcs.asString] as Map<String, dynamic>;

  final millon = CalcsModel(
      bruto: mapaActual.values.first, limpio: mapaActual.values.last);

  return [millon];
}
