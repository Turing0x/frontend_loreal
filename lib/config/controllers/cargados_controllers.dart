import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<BolaCargadaModel>> getBolasCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    final token = await LocalStorage.getToken();

    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.get(
        Uri.https(Environments().SERVER_URL, '/api/list/cargados', queryData),
        headers: {'Content-Type': 'application/json', 'access-token': token!});

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');
      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    final lot = (decodeData['data'] as List).last;
    if (lot != null && lot != '') {
      withLot = true;
    }

    (decodeData['data'] as List).removeLast();
    for (var data in decodeData['data']) {
      final actual = BolaCargadaModel.fromJson(data);
      cargados.add(actual);
    }

    return cargados;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}

Future<List<BolaCargadaModel>> getParleCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    final token = await LocalStorage.getToken();

    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.get(
        Uri.https(Environments().SERVER_URL, '/api/list/parle', queryData),
        headers: {'Content-Type': 'application/json', 'access-token': token!});

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');

      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    final lot = (decodeData['data'] as List).last;
    if (lot != null && lot != '') {
      withLot = true;
    }

    (decodeData['data'] as List).removeLast();
    for (var data in decodeData['data']) {
      final actual = BolaCargadaModel.fromJson(data);
      cargados.add(actual);
    }

    return cargados;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}
