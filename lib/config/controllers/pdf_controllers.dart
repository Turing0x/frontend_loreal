import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sticker_maker/config/server/http/local_storage.dart';
import 'package:sticker_maker/models/pdf_data_model.dart';
import 'package:sticker_maker/config/environments/env.environments.dart';
import 'package:sticker_maker/config/extensions/lista_general_extensions.dart';
import 'package:sticker_maker/models/Usuario/user_show_model.dart';

class PdfControllers {
  late Dio _dio;

  PdfControllers() {
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

  Future<List<PdfData>> getDataToPDF(
      String username, String date, String jornal,
      {String makeResumen = '',
      String startDate = '',
      String endDate = ''}) async {
    try {
      final queryData = {
        'jornal': jornal,
        'date': date,
        'makeResumen': makeResumen,
        'startDate': startDate,
        'endDate': endDate
      };

      await _initializeDio();
      Response response =
          await _dio.get('/api/vales/$username', queryParameters: queryData);

      if (!response.data['success']) {
        return [];
      }

      final List<PdfData> data = [];

      response.data['data'][0].forEach((value) {
        final eachData = PdfData.fromJson(value);
        data.add(eachData);
      });

      globalRoleToPDF = response.data['data'][1];
      globalGastoToPDF = response.data['data'][2] / 100;

      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getAllPeople(
      String initialId, String date, String jornal) async {
    try {
      final queryData = {
        'initialId': initialId,
        'jornal': jornal,
        'date': date,
      };

      await _initializeDio();
      Response response =
          await _dio.get('/api/vales/all', queryParameters: queryData);

      if (!response.data['success']) {
        EasyLoading.showError('Ha ocurrido algo grave');
        return [];
      }

      final List<User> data = [];

      response.data['data'].forEach((value) {
        final eachData = User.fromJson(value);
        data.add(eachData);
      });

      return data;
    } catch (e) {
      return [];
    }
  }
}
