// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend_loreal/models/Horario/time_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';

import '../server/http/local_storage.dart';

class TimeControllers {
  late Dio _dio;

  TimeControllers() {
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

  Future<List<Time>> getDataTime() async {
    try {
      await _initializeDio();
      Response response = await _dio.get('/api/time');
      if (!response.data['success']) {
        return [];
      }
      final List<Time> timeData = [];

      response.data['data'].forEach((value) {
        final each_time = Time.fromJson(value);
        timeData.add(each_time);
      });

      return timeData;
    } catch (e) {
      return [];
    }
  }

  void saveDataTime(String day_start, String day_end, String night_start,
      String night_end) async {
    try {
      EasyLoading.show(status: 'Configurando horarios...');

      await _initializeDio();
      Response response = await _dio.post('/api/time',
          data: jsonEncode({
            'dayStart': day_start,
            'dayEnd': day_end,
            'nightStart': night_start,
            'nightEnd': night_end
          }));

      String api_message = response.data['api_message'];
      if (response.data['success']) {
        EasyLoading.showSuccess(api_message);
        return;
      }

      EasyLoading.showError(api_message);
      return;
    } catch (e) {
      return;
    }
  }
}
