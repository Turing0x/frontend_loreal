import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<BolaCargadaModel>> getBolasCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/list/cargados', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');
      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    for (var data in decodeData['data']) {
      final actual = BolaCargadaModel.fromJson(data);
      cargados.add(actual);
    }

    EasyLoading.showToast('Información cargada');

    return cargados;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}

Future<List<BolaCargadaModel>> getParleCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/list/parle', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');

      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    for (var data in decodeData['data']) {
      final actual = BolaCargadaModel.fromJson(data);
      cargados.add(actual);
    }

    EasyLoading.showToast('Información cargada');

    return cargados;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}
