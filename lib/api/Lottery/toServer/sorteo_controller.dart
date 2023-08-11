// ignore_for_file: non_constant_identifier_names
import '../../../server/http/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frontend_loreal/api/Lottery/domain/sorteos_model.dart';
import '../../../utils_exports.dart';

Future<List<Sorteo>> getDataSorteo() async {
  try {
    final res = await http
        .get(Uri.http(dotenv.env['SERVER_URL']!, '/api/sorteos'), headers: {
      'Content-Type': 'application/json',
      'access-token': (await AuthServices.getToken())!
    });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    final List<Sorteo> sorteosData = [];

    if (decodeData['success'] == false) {
      return [];
    }

    decodeData['data'].forEach((value) {
      final each_params = Sorteo.fromJson(value);
      sorteosData.add(each_params);
    });

    return sorteosData.reversed.toList();
  } on Exception catch (_) {
    return [];
  }
}

Future<String> getSorteoByJD(String jornal, String date) async {
  try {
    final queryData = {'jornal': jornal, 'date': date};

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/sorteos', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(
          'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
      return '';
    }
    final data = decodeData['data'];
    if (data == null || (data as List<dynamic>).isEmpty) return '';
    return data[0]['lot'];
  } catch (e) {
    return '';
  }
}

Future<String> getTheLast() async {
  try {
    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/sorteos/last'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(
          'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
      return '';
    }

    return decodeData['data']['lot'];
  } on Exception catch (e) {
    showToast(e.toString());
    return '';
  }
}

Future<bool> saveDataSorteo(String lot, String jornal, String date) async {
  try {
    EasyLoading.show(status: 'Guardando sorteo...');

    final response =
        await http.post(Uri.http(dotenv.env['SERVER_URL']!, '/api/sorteos'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({'lot': lot, 'jornal': jornal, 'date': date}));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return true;
    }

    EasyLoading.showError(decodeData['api_message']);
    return false;
  } on Exception catch (e) {
    showToast(e.toString());
    return false;
  }
}

Future<bool> editDataSorteo(String id, String lot) async {
  try {
    final response =
        await http.put(Uri.http(dotenv.env['SERVER_URL']!, '/api/sorteos/$id'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'lot': lot,
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      showToast(decodeData['api_message'], type: true);
      return true;
    }

    showToast(decodeData['api_message']);
    return false;
  } on Exception catch (e) {
    showToast(e.toString());
    return false;
  }
}

Future<bool> deleteDataSorteo(String id) async {
  try {
    EasyLoading.show(status: 'Eliminando sorteo...');
    final response = await http.delete(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/sorteos/$id'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return true;
    }

    EasyLoading.showError(decodeData['api_message']);
    return false;
  } on Exception catch (e) {
    EasyLoading.showError('Algo grave ha ocurrido');
    showToast(e.toString());
    return false;
  }
}
