import 'package:dio/dio.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
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
        baseUrl: Uri.http(Environments().SERVER_URL).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<CalcsOfList>> getCalcsOfOneList(
      {String lot = '', String signature = ''}) async {
    try {
      final queryData = {'lot': lot, 'signature': signature};

      await _initializeDio();
      Response response =
          await _dio.get('/api/calcs', queryParameters: queryData);

      if (!response.data['success']) {
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
