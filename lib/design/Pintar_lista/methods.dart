import 'package:safe_chat/config/methods/decode_json_to_map.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:safe_chat/design/Pintar_lista/Calcs/conv_calcs.dart';
import 'package:safe_chat/design/Pintar_lista/Candado/conv_candado.dart';
import 'package:safe_chat/design/Pintar_lista/Decena/conv_decena.dart';
import 'package:safe_chat/design/Pintar_lista/MainList/conv_main_list.dart';
import 'package:safe_chat/design/Pintar_lista/Millon/conv_millon.dart';
import 'package:safe_chat/design/Pintar_lista/Posicion/conv_posicion.dart';
import 'package:safe_chat/design/Pintar_lista/Terminal/conv_terminales.dart';

List<dynamic> boliList(String signature) {
  final listaDevolver = <dynamic>[];

  final map = jwtAMap(signature);
  listaDevolver.addAll(convertirPayloadListaPrincipal(map));
  _agregarPayloadCandado(map, listaDevolver);
  _agregarPayloadTerminales(map, listaDevolver);
  _agregarPayloadPosicion(map, listaDevolver);
  _agregarPayloadDecena(map, listaDevolver);
  _agregarPayloadMillon(map, listaDevolver);
  listaDevolver.addAll(convertirPayloadCalcs(map));

  return listaDevolver;
}

void _agregarPayloadCandado(
    Map<String, dynamic> map, List<dynamic> listaDevolver) {
  if (map['ListaGeneralEnum.candado'].isEmpty) {
    return;
  }

  map['ListaGeneralEnum.candado']['candado'].forEach((each) {
    final getuuid = each['uuid'];
    final getnumplay = each['numplay'];
    final getfijo = each['fijo'];
    final getdinero = each['dinero'];

    listaDevolver.addAll(convertirPayloadCandado(
        getuuid, getnumplay, getfijo, int.parse(getdinero.round().toString())));
  });
}

void _agregarPayloadTerminales(
    Map<String, dynamic> map, List<dynamic> listaDevolver) {
  if (map['ListaGeneralEnum.terminal'].isEmpty) {
    return;
  }

  map['ListaGeneralEnum.terminal']['terminal'].forEach((each) {
    final getuuid = each['uuid'];
    final getnumplay = each['numplay'];
    final getfijo = each['fijo'];
    final getcorrido = each['corrido'];
    final getdinero = each['dinero'];

    listaDevolver.addAll(convertirPayloadTerminales(getuuid, getnumplay,
        getfijo, getcorrido, int.parse(getdinero.round().toString())));
  });
}

void _agregarPayloadPosicion(
    Map<String, dynamic> map, List<dynamic> listaDevolver) {
  if (map['ListaGeneralEnum.posicion'].isEmpty) {
    return;
  }

  map['ListaGeneralEnum.posicion']['posicion'].forEach((each) {
    final getuuid = each['uuid'];
    final getnumplay = each['numplay'].toString();
    final getfijo = each['fijo'];
    final getcorrido = each['corrido'];
    final getcorrido2 = each['corrido2'];
    final getdinero = each['dinero'];

    listaDevolver.addAll(convertirPayloadPosicion(getuuid, getnumplay, getfijo,
        getcorrido, getcorrido2, int.parse(getdinero.round().toString())));
  });
}

void _agregarPayloadDecena(
    Map<String, dynamic> map, List<dynamic> listaDevolver) {
  if (map['ListaGeneralEnum.decena'].isEmpty) {
    return;
  }

  map['ListaGeneralEnum.decena']['decena'].forEach((each) {
    final getuuid = each['uuid'];
    final getnumplay = each['numplay'];
    final getfijo = each['fijo'];
    final getcorrido = each['corrido'];
    final getdinero = each['dinero'];

    listaDevolver.addAll(convertirPayloadDecena(getuuid, getnumplay, getfijo,
        getcorrido, int.parse(getdinero.round().toString())));
  });
}

void _agregarPayloadMillon(
    Map<String, dynamic> map, List<dynamic> listaDevolver) {
  if (map['ListaGeneralEnum.millon'].isEmpty) {
    return;
  }

  map['ListaGeneralEnum.millon']['millon'].forEach((each) {
    final getuuid = each['uuid'];
    final getnumplay = each['numplay'];
    final getfijo = each['fijo'];
    final getcorrido = each['corrido'];
    final getdinero = each['dinero'];

    listaDevolver.addAll(convertirPayloadMillon(getuuid, getnumplay, getfijo,
        getcorrido, int.parse(getdinero.round().toString())));
  });
}

void toggleExpandedTile(ExpandedTileController expandedTileController) {
  if (expandedTileController.isExpanded) {
    expandedTileController.copyWith(isExpanded: false);
    return;
  }
  expandedTileController.copyWith(isExpanded: true);
  return;
}
