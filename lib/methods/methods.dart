import 'package:frontend_loreal/api/DrawList/MainList/models/centenas/centenas_model.dart';
import 'package:frontend_loreal/api/DrawList/MainList/models/fijo_corrido/fijo_corrido_model.dart';
import 'package:frontend_loreal/api/DrawList/MainList/models/parles/parles_model.dart';
import 'package:frontend_loreal/extensions/lista_general_extensions.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:frontend_loreal/api/List/domain/list_model.dart';
import 'package:frontend_loreal/enums/lista_general_enum.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontend_loreal/enums/main_list_enum.dart';
import 'package:frontend_loreal/utils_exports.dart';

List<dynamic> _convertirPayloadListaPrincipal(Map<String, dynamic> map) {
  List<dynamic> listaPrincipal = [
    ...(map[ListaGeneralEnum.candado.asString] as Map<String, dynamic>)
        .entries
        .map((e) {
      if (e.key == MainListEnum.fijoCorrido.toString()) {
        return _fijosCorridos(e.value);
      }
      if (e.key == MainListEnum.parles.toString()) {
        return _parles(e.value);
      }
      if (e.key == MainListEnum.centenas.toString()) {
        return _centenas(e.value);
      }
    }).toList(),
  ];

  return _lista(listaPrincipal);
}

Map<String, dynamic> _jwtAMap(String signature) {
  JWT jwt = JWT.verify(signature, SecretKey(dotenv.env['SECRETKEY_JWT']!));
  return jwt.payload;
}

List<dynamic> boliList(List<BoliList> lista) {
  List<dynamic> listaPrincipal = [];
  final map = _jwtAMap(lista[0].signature!);
  listaPrincipal.addAll(_convertirPayloadListaPrincipal(map));
  return listaPrincipal;
}

List<dynamic> _fijosCorridos(List<dynamic> fijosCorridos) =>
    FijoCorridoList.fromList(fijosCorridos).list;

List<dynamic> _parles(List<dynamic> parles) => ParlesList.fromList(parles).list;

List<dynamic> _centenas(List<dynamic> centenas) =>
    CentenasList.fromList(centenas).list;

List<dynamic> _lista(List<dynamic> lista) =>
    lista.expand((element) => element).toList();

void toggleExpandedTile(ExpandedTileController expandedTileController) {
  if (expandedTileController.isExpanded) {
    expandedTileController.copyWith(isExpanded: false);
    return;
  }
  expandedTileController.copyWith(isExpanded: true);
  return;
}
