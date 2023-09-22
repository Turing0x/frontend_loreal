import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/models/Lista_Calcs/other_model.dart';

class CalcsControllers {

  late Dio _dio;

  CalcsControllers() {
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

  Future<List<CalcsOfList>> getCalcsOfOneList(
      {String lot = '', String signature = ''}) async {
    try {
      final queryData = {'lot': lot, 'signature': signature};

      await _initializeDio();
      Response response = await _dio.get('/api/calcs',
        queryParameters: queryData);

      if (response.data['success'] == false) {
        showToast(
            'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
        return [];
      }

      final List<CalcsOfList> lists = [];

      final actual = CalcsOfList.fromJson(response.data['data']);
      lists.add(actual);

      return lists;
    } catch (e) {
      return [];
    }
  }

}
