import 'package:sticker_maker/config/enums/lista_general_enum.dart';
import 'package:sticker_maker/config/extensions/lista_general_extensions.dart';
import 'package:sticker_maker/models/Lista_Calcs/calcs_model.dart';

List<dynamic> convertirPayloadCalcs(Map<String, dynamic> map) {
  final mapaActual =
      map[ListaGeneralEnum.calcs.asString] as Map<String, dynamic>;

  final millon = CalcsModel(
      bruto: mapaActual.values.first, limpio: mapaActual.values.last);

  return [millon];
}
