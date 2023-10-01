import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';

Dio _dio = Dio(
  BaseOptions(
    baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
    headers: {
      'Content-Type': 'application/json',
    },
  ),
);

Future<List<BolaCargadaModel>> getBolasCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};

    Response response = await _dio.get('/api/list/cargados', 
      queryParameters: queryData);

    if (!response.data['success']) {
      EasyLoading.showError('Ha ocurrido un error');
      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    for (var data in response.data['data']) {
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

    Response response = await _dio.get('/api/list/parle', 
      queryParameters: queryData);

    if (!response.data['success']) {
      EasyLoading.showError('Ha ocurrido un error');

      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    for (var data in response.data['data']) {
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
