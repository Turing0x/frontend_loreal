// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:sticker_maker/config/server/http/local_storage.dart';
import 'package:sticker_maker/models/Sorteo/sorteos_model.dart';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sticker_maker/config/environments/env.environments.dart';

class SorteosControllers {
  late Dio _dio;

  SorteosControllers() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final token = await LocalStorage.getToken();

    _dio = Dio(
      BaseOptions(
        baseUrl: Uri.http(Environments().SERVER_URL).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<Sorteo>> getDataSorteo() async {
    try {
      await _initializeDio();
      Response response = await _dio.get('/api/sorteos');
      final List<Sorteo> sorteosData = [];

      if (!response.data['success']) {
        return [];
      }

      response.data['data'].forEach((value) {
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

      await _initializeDio();
      Response response =
          await _dio.get('/api/sorteos', queryParameters: queryData);

      if (!response.data['success']) {
        return '';
      }
      final data = response.data['data'];
      if (data == null || (data as List<dynamic>).isEmpty) return '';
      return data[0]['lot'];
    } catch (e) {
      return '';
    }
  }

  Future<String> getTheLast() async {
    try {
      await _initializeDio();
      Response response = await _dio.get('/api/sorteos/last');
      if (!response.data['success']) {
        return '';
      }

      return response.data['data']['lot'];
    } on Exception catch (_) {
      return '';
    }
  }

  Future<bool> saveDataSorteo(String lot, String jornal, String date) async {
    try {
      EasyLoading.show(status: 'Guardando sorteo...');

      await _initializeDio();
      Response response = await _dio.post('/api/sorteos',
          data: jsonEncode({'lot': lot, 'jornal': jornal, 'date': date}));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return true;
      }

      EasyLoading.showError(response.data['api_message']);
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> editDataSorteo(String id, String lot) async {
    try {
      await _initializeDio();
      Response response =
          await _dio.put('/api/sorteos/$id', data: jsonEncode({'lot': lot}));

      if (response.data['success']) {
        return true;
      }

      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> deleteDataSorteo(String id) async {
    try {
      EasyLoading.show(status: 'Eliminando sorteo...');

      await _initializeDio();
      Response response = await _dio.delete('/api/sorteos/$id');

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return true;
      }

      EasyLoading.showError(response.data['api_message']);
      return false;
    } on Exception catch (_) {
      EasyLoading.showError('Algo grave ha ocurrido');
      return false;
    }
  }
}
