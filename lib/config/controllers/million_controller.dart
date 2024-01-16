import 'package:dio/dio.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/models/Millon/million_model.dart';

class MillionControllers {

  late Dio _dio;

  MillionControllers() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final token = await LocalStorage.getToken();

    _dio = Dio(
      BaseOptions(
        baseUrl: Uri.https(dotenv.env['SERVER_URL']!).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<MillionGame>> getAllMillion(String jornal, String date) async {
    try {
      final queryData = {'jornal': jornal, 'date': date};
      await _initializeDio();
      Response response = await _dio.get('/api/million',
        queryParameters: queryData);

      if (!response.data['success']) {
        showToast('Ha ocurrido algo grave');
        return [];
      }

      final List<MillionGame> lists = [];

      response.data['data'].forEach((value) {
        final dataTemp = MillionGame.fromJson(value);
        lists.add(dataTemp);
      });

      return lists;
    } catch (e) {
      return [];
    }

  }

}
