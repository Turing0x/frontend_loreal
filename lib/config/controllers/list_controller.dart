import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/models/Lista/list_model.dart';
import 'package:frontend_loreal/models/Lista/list_offline_model.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/models/Lista/only_winner.dart';

class ListControllers {
  final storage = const FlutterSecureStorage();
  late Dio _dio;

  ListControllers() {
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

  Future<Map<String, dynamic>> getAllList(
      {String jornal = '', String date = '', String username = ''}) async {
    try {
      final queryData = {
        'incomingUsername': username,
        'jornal': jornal,
        'date': date
      };

      await _initializeDio();
      Response response =
          await _dio.get('/api/list', queryParameters: queryData);
      if (!response.data['success']) {
        return {'data': [], 'lotOfToday': 'Sin datos'};
      }

      final List<BoliList> lists = [];
      String lotOfToday = 'Sin datos';

      response.data['data'][0].forEach((value) {
        final userTemp = BoliList.fromJson(value);
        lists.add(userTemp);
      });

      if (response.data['data'][1] != null) {
        lotOfToday = response.data['data'][1]['lot'];
      }

      return {'data': lists, 'lotOfToday': lotOfToday};
    } catch (e) {
      return {'data': [], 'lotOfToday': 'Sin datos'};
    }
  }

  Future<List<BoliList>> getListById(String id) async {
    try {
      await _initializeDio();
      Response response = await _dio.get('/api/list/$id');
      if (!response.data['success']) {
        return [];
      }

      final List<BoliList> lists = [];

      final actual = BoliList.fromJson(response.data['data']);
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

      await _initializeDio();
      Response response =
          await _dio.get('/api/list', queryParameters: queryData);

      if (!response.data['success']) {
        return {'data': [], 'lotOfToday': ''};
      }

      final List<BoliList> lists = [];
      String lotOfToday = '';

      response.data['data'][0].forEach((value) {
        final dataTemp = BoliList.fromJson(value);
        lists.add(dataTemp);
      });
      lotOfToday = response.data['data'][1];

      return {'data': lists, 'lotOfToday': lotOfToday};
    } catch (e) {
      return {'data': [], 'lotOfToday': ''};
    }
  }

  Future<Map<String, dynamic>> getOnlyWinners(
      String jornal, String date) async {
    try {
      final queryData = {'jornal': jornal, 'date': date};

      await _initializeDio();
      Response response =
          await _dio.get('/api/list/winners', queryParameters: queryData);

      if (!response.data['success']) {
        return {'data': [], 'lotOfToday': ''};
      }

      final List<OnlyWinner> lists = [];
      String lotOfToday = '';

      lotOfToday = response.data['data'].last['lot'];
      response.data['data'].removeLast();

      response.data['data'].forEach((value) {
        final dataTemp = OnlyWinner.fromJson(value);
        lists.add(dataTemp);
      });

      return {'data': lists, 'lotOfToday': lotOfToday};
    } catch (e) {
      return {'data': [], 'lotOfToday': ''};
    }
  }

  Future<bool> saveOneList(String date, String jornal, String signature,
      {String owner = ''}) async {
    try {
      EasyLoading.show(status: 'Guardando lista...');

      await _initializeDio();
      Response response = await _dio.post('/api/list',
          data: jsonEncode({
            'owner': owner,
            'signature': signature,
            'jornal': jornal,
            'date': date,
          }));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return true;
      }

      EasyLoading.showError(response.data['api_message']);
      return false;
    } on Exception catch (_) {
      EasyLoading.showError('Ha ocurrido un error');
      return false;
    }
  }

  Future<bool> saveManyList(String owner, List<OfflineList> lists) async {
    try {
      EasyLoading.show(status: 'Guardando lista...');

      await _initializeDio();
      Response response = await _dio.post('/api/list/many',
          data: jsonEncode({'owner': owner, 'lists': lists}));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return true;
      }

      EasyLoading.showError(response.data['api_message']);
      return false;
    } on Exception catch (_) {
      EasyLoading.showError('Ha ocurrido un error');
      return false;
    }
  }

  Future<bool> deleteOneList(String id) async {
    try {
      EasyLoading.show(status: 'Eliminando lista...');

      await _initializeDio();
      Response response = await _dio.delete('/api/list/$id');

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

  Future<bool> editOneList(String id, List<String> listOfIds) async {
    try {
      EasyLoading.show(status: 'Editando lista...');

      await _initializeDio();
      Response response = await _dio.put('/api/list/$id',
          data: jsonEncode({'listOfIds': listOfIds}));

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
}
