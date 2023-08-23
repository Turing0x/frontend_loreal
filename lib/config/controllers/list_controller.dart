import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_loreal/models/Lista/list_model.dart';
import 'package:frontend_loreal/models/Lista/list_offline_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const storage = FlutterSecureStorage();

Future<Map<String, dynamic>> getAllList(
    {String jornal = '', String date = '', String username = ''}) async {
  try {
    final queryData = {
      'incomingUsername': username,
      'jornal': jornal,
      'date': date
    };

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/list', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(
          'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
      return {'data': [], 'lotOfToday': 'Sin datos'};
    }

    final List<BoliList> lists = [];
    String lotOfToday = 'Sin datos';

    decodeData['data'][0].forEach((value) {
      final userTemp = BoliList.fromJson(value);
      lists.add(userTemp);
    });

    if (decodeData['data'][1] != null) {
      lotOfToday = decodeData['data'][1]['lot'];
    }

    return {'data': lists, 'lotOfToday': lotOfToday};
  } catch (e) {
    return {'data': [], 'lotOfToday': 'Sin datos'};
  }
}

Future<List<BoliList>> getListById(String id) async {
  try {
    final res = await http
        .get(Uri.http(dotenv.env['SERVER_URL']!, '/api/list/$id'), headers: {
      'Content-Type': 'application/json',
      'access-token': (await AuthServices.getToken())!
    });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(
          'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
      return [];
    }

    final List<BoliList> lists = [];

    final actual = BoliList.fromJson(decodeData['data']);
    lists.add(actual);
    return lists;
  } catch (e) {
    return [];
  }
}

Future<Map<String, dynamic>> getAllListByJD(
    String jornal, String date, String cant) async {
  try {
    final queryData = {'jornal': jornal, 'date': date, 'cant': cant};

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/list', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(decodeData['api_message']);
      return {'data': [], 'lotOfToday': ''};
    }

    final List<BoliList> lists = [];
    String lotOfToday = '';

    decodeData['data'][0].forEach((value) {
      final dataTemp = BoliList.fromJson(value);
      lists.add(dataTemp);
    });
    lotOfToday = decodeData['data'][1];

    return {'data': lists, 'lotOfToday': lotOfToday};
  } catch (e) {
    return {'data': [], 'lotOfToday': ''};
  }
}

Future<bool> saveOneList(String date, String jornal, String signature,
    {String owner = ''}) async {
  try {
    EasyLoading.show(status: 'Guardando lista...');

    final response =
        await http.post(Uri.http(dotenv.env['SERVER_URL']!, '/api/list'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'owner': owner,
              'signature': signature,
              'jornal': jornal,
              'date': date,
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return true;
    }

    EasyLoading.showError(decodeData['api_message']);
    return false;
  } on Exception catch (_) {
    EasyLoading.showError('Ha ocurrido un error');
    return false;
  }
}

Future<bool> saveManyList(String owner, List<OfflineList> lists) async {
  try {
    EasyLoading.show(status: 'Guardando lista...');

    final response =
        await http.post(Uri.http(dotenv.env['SERVER_URL']!, '/api/list/many'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({'owner': owner, 'lists': lists}));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return true;
    }

    EasyLoading.showError(decodeData['api_message']);
    return false;
  } on Exception catch (_) {
    EasyLoading.showError('Ha ocurrido un error');
    return false;
  }
}

Future<bool> deleteOneList(String id) async {
  try {
    EasyLoading.show(status: 'Eliminando lista...');
    final res = await http.delete(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/list/$id'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;

    if (res.statusCode == 200) {
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

Future<bool> editOneList(String id, List<String> listOfIds) async {
  try {
    EasyLoading.show(status: 'Editando lista...');
    final res =
        await http.put(Uri.http(dotenv.env['SERVER_URL']!, '/api/list/$id'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({'listOfIds': listOfIds}));

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
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
