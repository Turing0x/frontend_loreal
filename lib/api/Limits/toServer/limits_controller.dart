// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:frontend_loreal/api/Limits/domain/limited_ball.dart';
import 'package:frontend_loreal/api/Limits/domain/limited_parle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frontend_loreal/api/Limits/domain/limits_model.dart';
import '../../../server/http/auth.dart';
import '../../../utils_exports.dart';

Future<List<Limits>> getDataLimits() async {
  try {
    EasyLoading.show(status: 'Buscando limites');
    final res = await http
        .get(Uri.http(dotenv.env['SERVER_URL']!, '/api/limits'), headers: {
      'Content-Type': 'application/json',
      'access-token': (await AuthServices.getToken())!
    });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('No hay datos para mostrar');
      return [];
    }

    final List<Limits> limitsData = [];

    final actual = Limits.fromJson(decodeData['data'][0]);
    limitsData.add(actual);

    EasyLoading.showToast('Información cargada');
    return limitsData;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}

Future<List<Limits>> getLimitsOfUser(String id) async {
  try {
    final res = await http
        .get(Uri.http(dotenv.env['SERVER_URL']!, '/api/limits/$id'), headers: {
      'Content-Type': 'application/json',
      'access-token': (await AuthServices.getToken())!
    });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(
          'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
      return [];
    }

    final List<Limits> limitsData = [];

    if (decodeData['data'][0] is Map<String, dynamic>) {
      final actual = Limits.fromJson(decodeData['data'][0]);
      limitsData.add(actual);
      return limitsData;
    }

    final actual = Limits.fromJson(decodeData['data']['limits']);
    limitsData.add(actual);

    return limitsData;
  } catch (e) {
    return [];
  }
}

void saveDataLimits(String fijo, String corrido, String parle, String centena,
    String limites_millon_Fijo, String limites_millon_Corrido) async {
  try {
    EasyLoading.show(status: 'Configurando límites...');
    final response =
        await http.post(Uri.http(dotenv.env['SERVER_URL']!, '/api/limits'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'fijo': fijo,
              'corrido': corrido,
              'parle': parle,
              'centena': centena,
              'limitesMillonFijo': limites_millon_Fijo,
              'limitesMillonCorrido': limites_millon_Corrido,
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (decodeData['success'] == true) {
      EasyLoading.showSuccess('Limites configurados satisfactoriamente');
      return;
    }

    EasyLoading.showError('No se pudo configurar los límites');
    return;
  } catch (e) {
    EasyLoading.showError('Algo grave ha ocurrido');
  }
}

void editLimitsOfUser(
    String fijo,
    String corrido,
    String parle,
    String centena,
    String limites_millon_Fijo,
    String limites_millon_Corrido,
    String id) async {
  try {
    EasyLoading.show(status: 'Guardando configuración de límites');

    final limits_obj = {
      'fijo': fijo,
      'corrido': corrido,
      'parle': parle,
      'centena': centena,
      'limitesMillonFijo': limites_millon_Fijo,
      'limitesMillonCorrido': limites_millon_Corrido,
    };

    final response =
        await http.put(Uri.http(dotenv.env['SERVER_URL']!, '/api/users/$id'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({'limits': limits_obj}));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (decodeData['success'] == true) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
    return;
  } catch (e) {
    EasyLoading.showSuccess(e.toString());
  }
}

void saveDataLimitsBalls(Map<String, List<int>> bola) async {
  try {
    EasyLoading.show(status: 'Guardando bolas limitadas');
    final response = await http.post(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/limitnumbers'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        },
        body: jsonEncode({
          'date': todayGlobal,
          'bola': bola,
        }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (decodeData['success'] == true) {
      EasyLoading.showSuccess('Limites configurados satisfactoriamente');
      return;
    }

    EasyLoading.showToast('No se pudo configurar los límites');
    return;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
  }
}

Future<List<LimitedBallModel>> getLimitedBallToday() async {
  try {
    EasyLoading.show(status: 'Buscando bolas limitados');

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/limitnumbers'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });
    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('No hay datos para mostrar');
      return [];
    }

    final List<LimitedBallModel> data = [];
    final actual = LimitedBallModel.fromJson(decodeData['data'][0]);
    data.add(actual);

    EasyLoading.showToast('Información cargada');
    return data;
  } catch (e) {
    EasyLoading.showToast('Información cargada');
    return [];
  }
}

void saveDataLimitsParle(Map<String, List<List<int>>> parle) async {
  try {
    EasyLoading.show(status: 'Guardando parlés limitados');
    final response = await http.post(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/limitnumbers/parle'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        },
        body: jsonEncode({
          'parle': parle,
        }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (decodeData['success'] == true) {
      EasyLoading.showSuccess('Limites configurados satisfactoriamente');
      return;
    }

    EasyLoading.showToast('No se pudo configurar los límites');
    return;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
  }
}

Future<List<LimitedParleModel>> getLimitedParleToday() async {
  try {
    EasyLoading.show(status: 'Buscando parlés limitados');

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/limitnumbers/parle'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');
      return [];
    }

    final data = decodeData['data'];
    final List<LimitedParleModel> result = [];
    for (var element in data) {
      final mapa = element['parle'] as Map<String, dynamic>;
      for (var key in mapa.keys) {
        final actual = LimitedParleModel.fromJson({
          'bola': {key: mapa[key]},
        });
        result.add(actual);
      }
    }
    EasyLoading.showToast('Información cargada');

    return result;
  } catch (e) {
    EasyLoading.showError('Información cargada');
    return [];
  }
}

// Limites para los usuarios de manera independiente
void saveDataLimitsBallsToUser(String id, Map<String, List<int>> bola) async {
  try {
    EasyLoading.show(status: 'Guardando bolas limitadas');
    final response =
        await http.put(Uri.http(dotenv.env['SERVER_URL']!, '/api/users/$id'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'bola': {
                'bola': bola,
              }
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (decodeData['success'] == true) {
      EasyLoading.showSuccess('Limites configurados satisfactoriamente');
      return;
    }

    EasyLoading.showToast('No se pudo configurar los límites');
    return;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
  }
}

Future<List<LimitedBallModel>> getLimitsBallsOfUser(String id) async {
  try {
    EasyLoading.show(status: 'Buscando bolas limitadas para hoy');

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/limits/bola/$id'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showInfo(decodeData['api_message']);
      return [];
    }

    final List<LimitedBallModel> data = [];
    final actual = LimitedBallModel.fromJson(decodeData['data']);
    data.add(actual);

    EasyLoading.showInfo(decodeData['api_message']);

    return data;
  } catch (e) {
    EasyLoading.showError('Nada que mostrar');
    return [];
  }
}

void saveDataLimitsParleToUser(
    String id, Map<String, List<List<int>>> parle) async {
  try {
    EasyLoading.show(status: 'Guardando parlés limitados');
    final response =
        await http.put(Uri.http(dotenv.env['SERVER_URL']!, '/api/users/$id'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'parle': {
                'parle': parle,
              }
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (decodeData['success'] == true) {
      EasyLoading.showSuccess('Limites configurados satisfactoriamente');
      return;
    }

    EasyLoading.showToast('No se pudo configurar los límites');
    return;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
  }
}

Future<List<LimitedParleModel>> getLimitsParleOfUser(String id) async {
  try {
    EasyLoading.show(status: 'Buscando parles limitadas para hoy');

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/limits/parle/$id'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showInfo(decodeData['api_message']);
      return [];
    }

    final data = decodeData['data'];
    final List<LimitedParleModel> result = [];
    final mapa = data['parle'] as Map<String, dynamic>;
    for (var key in mapa.keys) {
      final actual = LimitedParleModel.fromJson({
        'bola': {key: mapa[key]},
      });
      result.add(actual);
    }

    EasyLoading.showInfo(decodeData['api_message']);

    return result;
  } catch (e) {
    EasyLoading.showError('Nada que mostrar');
    return [];
  }
}
