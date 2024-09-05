import 'package:dio/dio.dart';
import 'package:safe_chat/config/environments/env.environments.dart';
import 'package:safe_chat/config/server/http/local_storage.dart';
import 'package:safe_chat/models/Lista_Calcs/other_model.dart';

class CalcsControllers {
  late Dio _dio;

  CalcsControllers() {
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
