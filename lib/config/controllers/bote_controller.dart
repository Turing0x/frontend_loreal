import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/models/Bote/bote_model.dart';

class BoteControllers {
  late Dio _dio;

  BoteControllers() {
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

  Future<List<BoteModel>> makeABote(
      String date, String jornal, int fijo, int parle, int centena) async {
    try {
      final queryData = {'jornal': jornal, 'date': date};

      await _initializeDio();
      Response response = await _dio.post(
        '/api/list/bote',
        queryParameters: queryData,
        data: {'fijo': fijo, 'parle': parle, 'centena': centena},
      );

      if (!response.data['success']) {
        return [];
      }

      final List<BoteModel> botados = [];

      final actual = BoteModel.fromJson(response.data['data']);
      botados.add(actual);

      return botados;
    } catch (e) {
      return [];
    }
  }
}