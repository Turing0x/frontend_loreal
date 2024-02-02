// ignore_for_file: non_constant_identifier_names, avoid_print
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/models/Limites/limited_ball.dart';
import 'package:frontend_loreal/models/Limites/limited_parle.dart';
import 'package:frontend_loreal/models/Limites/limits_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LimitsControllers {

  late Dio _dio;

  LimitsControllers() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final token = await LocalStorage.getToken();

    _dio = Dio(
      BaseOptions(
        baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<Limits>> getDataLimits() async {
    try {
      EasyLoading.show(status: 'Buscando limites');
      
      await _initializeDio();
      Response response = await _dio.get('/api/limits');
      if (!response.data['success']) {
        EasyLoading.showError('No hay datos para mostrar');
        return [];
      }

      final List<Limits> limitsData = [];

      final actual = Limits.fromJson(response.data['data'][0]);
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
      
      await _initializeDio();
      Response response = await _dio.get('/api/limits/$id');
      if (!response.data['success']) {
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
        return [];
      }

      final List<Limits> limitsData = [];
      final data = response.data['data'];

      if (data[0] is Map<String, dynamic>) {
        final actual = Limits.fromJson(data[0]);
        limitsData.add(actual);
        return limitsData;
      }

      final actual = Limits.fromJson(data['limits']);
      limitsData.add(actual);

      return limitsData;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveDataLimits(String fijo, String corrido, String parle, String centena,
      String limites_millon_Fijo, String limites_millon_Corrido) async {
    try {
      EasyLoading.show(status: 'Configurando límites...');

      await _initializeDio();
      Response response = await _dio.post('/api/limits', 
        data: jsonEncode({
          'fijo': fijo,
          'corrido': corrido,
          'parle': parle,
          'centena': centena,
          'limitesMillonFijo': limites_millon_Fijo,
          'limitesMillonCorrido': limites_millon_Corrido,
        }));

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      EasyLoading.showError('No se pudo configurar los límites');
      return;
    } catch (e) {
      EasyLoading.showError('Algo grave ha ocurrido');
    }
  }

  Future<void> editLimitsOfUser(
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

      await _initializeDio();
      Response response = await _dio.put('/api/users/$id', 
        data: jsonEncode({'limits': limits_obj}));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return;
      }

      EasyLoading.showError(response.data['api_message']);
      return;
    } catch (e) {
      EasyLoading.showSuccess(e.toString());
    }
  }

  Future<void> saveDataLimitsBalls(Map<String, List<int>> bola) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response = await _dio.post('/api/limitnumbers', 
        data: jsonEncode({
          'date': todayGlobal,
          'bola': bola,
        }));

      if (response.data['success']) {
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

      await _initializeDio();
      Response response = await _dio.get('/api/limitnumbers');

      if (!response.data['success']) {
        EasyLoading.showError('No hay datos para mostrar');
        return [];
      }

      final List<LimitedBallModel> data = [];
      if ( (response.data['data'] as List).isEmpty ) {
        EasyLoading.showError('No hay datos para mostrar');
        return [];
      }

      final actual = LimitedBallModel.fromJson(response.data['data'][0]);
      data.add(actual);

      EasyLoading.showToast('Información cargada');
      return data;
    } catch (e) {
      EasyLoading.showToast('Información cargada');
      return [];
    }
  }

  Future<void> saveDataLimitsParle(Map<String, List<List<int>>> parle) async {
    try {
      EasyLoading.show(status: 'Guardando parlés limitados');

      await _initializeDio();
      Response response = await _dio.post('/api/limitnumbers/parle',
        data: jsonEncode({ 'parle': parle }));

      if (response.data['success']) {
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

      await _initializeDio();
      Response response = await _dio.get('/api/limitnumbers/parle');

      if (!response.data['success']) {
        EasyLoading.showError('Ha ocurrido un error');
        return [];
      }

      final data = response.data['data'];
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
  Future<void> saveDataLimitsBallsToUser(String id, Map<String, List<int>> bola) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response = await _dio.put('/api/users/$id',
        data: jsonEncode({
          'bola': {
            'bola': bola,
          }
        }));

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      EasyLoading.showToast('No se pudo configurar los límites');
      return;
    } catch (e) {
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  Future<void> saveDataLimitsBallsToUserCargados(String bola, String jornal) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response = await _dio.put('/api/users/cargados/$bola/$jornal');

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      EasyLoading.showToast('No se pudo configurar los límites');
      return;
    } catch (e) {
      print(e);
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  Future<void> saveDataLimitsPerleToUserCargados(String parle, String jornal) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response = await _dio.put('/api/users/cargadoparle/$parle/$jornal');

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      EasyLoading.showToast('No se pudo configurar los límites');
      return;
    } catch (e) {
      print(e);
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  Future<List<LimitedBallModel>> getLimitsBallsOfUser(String id) async {
    try {
      EasyLoading.show(status: 'Buscando bolas limitadas para hoy');

      await _initializeDio();
      Response response = await _dio.get('/api/limits/bola/$id');

      if (!response.data['success']) {
        EasyLoading.showInfo(response.data['api_message']);
        return [];
      }

      final List<LimitedBallModel> data = [];
      final actual = LimitedBallModel.fromJson(response.data['data']);
      data.add(actual);

      EasyLoading.showInfo(response.data['api_message']);

      return data;
    } catch (e) {
      EasyLoading.showError('Nada que mostrar');
      return [];
    }
  }

  Future<void> saveDataLimitsParleToUser(
      String id, Map<String, List<List<int>>> parle) async {
    try {
      EasyLoading.show(status: 'Guardando parlés limitados');

      await _initializeDio();
      Response response = await _dio.put('/api/users/$id',
        data: jsonEncode({
          'parle': {
            'parle': parle,
          }
        }));

      if (response.data['success']) {
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

      await _initializeDio();
      Response response = await _dio.get('/api/limits/parle/$id');

      if (!response.data['success']) {
        EasyLoading.showInfo(response.data['api_message']);
        return [];
      }

      final data = response.data['data'];
      final List<LimitedParleModel> result = [];
      final mapa = data['parle'] as Map<String, dynamic>;
      for (var key in mapa.keys) {
        final actual = LimitedParleModel.fromJson({
          'bola': {key: mapa[key]},
        });
        result.add(actual);
      }

      EasyLoading.showInfo(response.data['api_message']);

      return result;
    } catch (e) {
      EasyLoading.showError('Nada que mostrar');
      return [];
    }
  }

}