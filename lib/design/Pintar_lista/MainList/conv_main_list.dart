import 'package:safe_chat/config/enums/lista_general_enum.dart';
import 'package:safe_chat/config/enums/main_list_enum.dart';
import 'package:safe_chat/config/extensions/lista_general_extensions.dart';
import 'package:safe_chat/models/Lista_Main/centenas/centenas_model.dart';
import 'package:safe_chat/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:safe_chat/models/Lista_Main/parles/parles_model.dart';

List<dynamic> convertirPayloadListaPrincipal(Map<String, dynamic> map) {
  List<dynamic> listaPrincipal = [
    ...(map[ListaGeneralEnum.principales.asString] as Map<String, dynamic>)
        .entries
        .map((e) {
      if (e.key == MainListEnum.fijoCorrido.toString()) {
        return _fijoCorridos(e.value);
      }
      if (e.key == MainListEnum.parles.toString()) {
        return _parles(e.value);
      }
      if (e.key == MainListEnum.centenas.toString()) {
        return _centenas(e.value);
      }
    })
  ];
  return _lista(listaPrincipal);
}

List<dynamic> _lista(List<dynamic> lista) =>
    lista.expand((element) => element).toList();

List<dynamic> _fijoCorridos(List<dynamic> fijoCorridos) =>
    FijoCorridoList.fromList(fijoCorridos).list;

List<dynamic> _parles(List<dynamic> parles) => ParlesList.fromList(parles).list;

List<dynamic> _centenas(List<dynamic> centenas) =>
    CentenasList.fromList(centenas).list;
