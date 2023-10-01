// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/models/Sorteo/sorteos_model.dart';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SorteosControllers {

  late Dio _dio;

  SorteosControllers() {
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
      Response response = await _dio.get('/api/sorteos',
        queryParameters: queryData);

      if (!response.data['success']) {
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
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
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
        return '';
      }

      return response.data['data']['lot'];
    } on Exception catch (e) {
      showToast(e.toString());
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
    } on Exception catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  Future<bool> editDataSorteo(String id, String lot) async {
    try {

      await _initializeDio();
      Response response = await _dio.put('/api/sorteos/$id',
        data: jsonEncode({ 'lot': lot }));

      if (response.data['success']) {
        showToast(response.data['api_message'], type: true);
        return true;
      }

      showToast(response.data['api_message']);
      return false;
    } on Exception catch (e) {
      showToast(e.toString());
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
    } on Exception catch (e) {
      EasyLoading.showError('Algo grave ha ocurrido');
      showToast(e.toString());
      return false;
    }
  }

}
