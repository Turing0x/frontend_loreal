import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/server/http/methods.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/models/Usuario/user_show_model.dart';

import 'package:dio/dio.dart';

class UserControllers {
  late Dio _dio;

  UserControllers() {
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

  Future<List<User>> getAllUsers({String id = ''}) async {
    try {
      final queryData = {'id': id};

      await _initializeDio();
      Response response =
          await _dio.get('/api/users', queryParameters: queryData);
      if (!response.data['success']) {
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
        return [];
      }

      final List<User> users = [];

      if (id != '') {
        if (response.data['data'].isNotEmpty) {
          for (var toShow in response.data['data']) {
            final actual = User.fromJson(toShow);
            users.add(actual);
          }
        }
        return users;
      }

      response.data['data'].forEach((value) {
        final userTemp = User.fromJson(value);
        users.add(userTemp);
      });

      return users;
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getAllBanks() async {
    try {
      await _initializeDio();
      Response response = await _dio.get('/api/users/banksUsers');
      if (!response.data['success']) {
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
        return [];
      }

      final List<User> users = [];

      response.data['data'].forEach((value) {
        final userTemp = User.fromJson(value);
        users.add(userTemp);
      });

      return users;
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getMyPeople(String id) async {
    try {
      await _initializeDio();
      Response response = await _dio.get('/api/users/myPeople/$id');
      if (!response.data['success']) {
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
        return [];
      }

      final List<User> users = [];

      response.data['data'].forEach((value) {
        final userTemp = User.fromJson(value);
        users.add(userTemp);
      });

      return users;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getUserById(String jornal, String date,
      {String id = 'admin',
      bool userInfo = true,
      bool makeResumen = false,
      String startDate = '',
      String endDate = ''}) async {
    try {
      final queryData = (makeResumen)
          ? {'jornal': jornal, 'startDate': startDate, 'endDate': endDate}
          : {'jornal': jornal, 'date': date};

      String endpoint =
          (makeResumen) ? '/api/list/resumen/$id' : '/api/users/$id';

      await _initializeDio();
      Response response = await _dio.get(endpoint, queryParameters: queryData);
      if (!response.data['success']) {
        showToast(response.data['api_message']);
        return {'data': [], 'missign': [], 'lotOfToday': ''};
      }

      final List<User> users = [];
      List missingLists = [];
      String lotOfToday = '';

      if (userInfo) {
        final actual = User.fromJson(response.data['data'][0]);
        users.add(actual);
        return {'data': users, 'missign': [], 'lotOfToday': ''};
      }

      if (!makeResumen) {
        if (response.data['data'][0] != []) {
          for (var toShow in response.data['data'][1]) {
            final actual = User.fromJson(toShow);
            users.add(actual);
          }
          missingLists = response.data['data'][2];
          lotOfToday = response.data['data'][3]['lot'];
        }

        return {
          'data': users,
          'missign': missingLists,
          'lotOfToday': lotOfToday
        };
      }

      if (response.data['data'] != []) {
        for (var toShow in response.data['data']) {
          final actual = User.fromJson(toShow);
          users.add(actual);
        }
      }

      return {
        'data': users,
      };
    } catch (e) {
      return {'data': [], 'missign': [], 'lotOfToday': ''};
    }
  }

  void saveOne(String name, String pass, String owner) async {
    try {
      EasyLoading.show(status: 'Creando usuario...');

      await _initializeDio();
      Response response = await _dio.post('/api/users',
          data:
              jsonEncode({'username': name, 'password': pass, 'owner': owner}));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return;
      }

      EasyLoading.showError(response.data['api_message']);
    } catch (e) {
      EasyLoading.showError('Ha ocurrido un error. $e');
    }
  }

  Future<bool> editOneEnable(String id, bool enable) async {
    try {
      EasyLoading.show(status: 'Cambiando acceso al sistema...');

      await _initializeDio();
      Response response = await _dio.put('/api/users/changeEnable/$id',
          data: jsonEncode({'enable': enable}));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return true;
      }

      EasyLoading.showError(response.data['api_message']);
      return false;
    } catch (e) {
      EasyLoading.showError('Ha ocrrido un error grave');
      return false;
    }
  }

  void deleteOne(String id) async {
    try {
      EasyLoading.show(status: 'Eliminando usuario...');

      await _initializeDio();
      Response response = await _dio.delete('/api/users/$id');
      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return;
      }

      EasyLoading.showError(response.data['api_message']);
      return;
    } catch (e) {
      return;
    }
  }

  void changePass(
      String actualPass, String newPass, BuildContext context) async {
    try {
      EasyLoading.show(status: 'Cambiando contraseña...');
      final cont = Navigator.of(context);

      await _initializeDio();
      Response response = await _dio.post('/api/users/chpass',
          data: jsonEncode({'actualPass': actualPass, 'newPass': newPass}));

      if (response.data['success']) {
        cont.pushNamedAndRemoveUntil(
            'signIn_page', (Route<dynamic> route) => false);
        if (context.mounted) await cerrarSesion(context);

        EasyLoading.showSuccess(response.data['api_message']);
        return;
      }

      EasyLoading.showError(response.data['api_message']);
      return;
    } on Exception catch (e) {
      showToast(e.toString());
    }
  }

  void resetPass(String userId) async {
    try {
      EasyLoading.show(status: 'Reseteando la contraseña...');

      await _initializeDio();
      final queryData = {'userId': userId};

      Response response =
          await _dio.post('/api/users/resetpass', queryParameters: queryData);

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return;
      }

      EasyLoading.showError(response.data['api_message']);
      return;
    } on Exception catch (e) {
      showToast(e.toString());
    }
  }

  Future<bool> checkJWT() async {
    try {
      await _initializeDio();
      Response response = await _dio.post('/api/users/checkJWT');
      if (!response.data['success']) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
