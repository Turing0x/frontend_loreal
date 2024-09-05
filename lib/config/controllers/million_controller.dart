import 'package:dio/dio.dart';
import 'package:safe_chat/config/server/http/local_storage.dart';
import 'package:safe_chat/config/environments/env.environments.dart';
import 'package:safe_chat/models/Millon/million_model.dart';

class MillionControllers {
  late Dio _dio;

  MillionControllers() {
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

  Future<List<MillionGame>> getAllMillion(String jornal, String date) async {
    try {
      final queryData = {'jornal': jornal, 'date': date};
      await _initializeDio();
      Response response =
          await _dio.get('/api/million', queryParameters: queryData);

      if (!response.data['success']) {
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
