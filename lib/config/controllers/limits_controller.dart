// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:safe_chat/config/environments/env.environments.dart';
import 'package:safe_chat/config/globals/variables.dart';
import 'package:safe_chat/config/server/http/local_storage.dart';
import 'package:safe_chat/models/Limites/limited_ball.dart';
import 'package:safe_chat/models/Limites/limited_parle.dart';
import 'package:safe_chat/models/Limites/limits_model.dart';
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
        baseUrl: Uri.https(Environments().SERVER_URL).toString(),
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

  Future<void> saveDataLimits(
      String fijo,
      String corrido,
      String parle,
      String centena,
      String limites_millon_Fijo,
      String limites_millon_Corrido) async {
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
      if ((response.data['data'] as List).isEmpty) {
        EasyLoading.showError('No hay datos para mostrar');
        return [];
      }

      final actual = LimitedBallModel.fromJson(response.data['data'][0]);
      data.add(actual);

      return data;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveDataLimitsParle(Map<String, List<List<int>>> parle) async {
    try {
      EasyLoading.show(status: 'Guardando parlés limitados');

      await _initializeDio();
      Response response = await _dio.post('/api/limitnumbers/parle',
          data: jsonEncode({'parle': parle}));

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

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

      return result;
    } catch (e) {
      EasyLoading.showError('Información cargada');
      return [];
    }
  }

  // Limites para los usuarios de manera independiente
  Future<void> saveDataLimitsBallsToUser(
      String id, Map<String, List<int>> bola) async {
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

      return;
    } catch (e) {
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  // Limites para todos los usuarios del cargado
  Future<void> saveDataLimitsBallsToUserCargados(
      String bola, String jornal) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response = await _dio.put('/api/users/cargados/$bola/$jornal');

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      return;
    } catch (e) {
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  Future<void> saveDataLimitsPerleToUserCargados(
      String parle, String jornal) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response =
          await _dio.put('/api/users/cargadoparle/$parle/$jornal');

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      return;
    } catch (e) {
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  // Limites para un listero del cargado
  Future<void> saveDataLimitsBallsToUserCargadosListero(
      String username, String bola, String jornal) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response =
          await _dio.put('/api/users/listerocargados/$username/$bola/$jornal');

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      return;
    } catch (e) {
      EasyLoading.showError('Ha ocurrido un error');
    }
  }

  Future<void> saveDataLimitsParleToUserCargadosListero(
      String username, String parle, String jornal) async {
    try {
      EasyLoading.show(status: 'Guardando bolas limitadas');

      await _initializeDio();
      Response response = await _dio
          .put('/api/users/listerocargadoparle/$username/$parle/$jornal');

      if (response.data['success']) {
        EasyLoading.showSuccess('Limites configurados satisfactoriamente');
        return;
      }

      return;
    } catch (e) {
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
