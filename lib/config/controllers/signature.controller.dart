import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';

class SignatureControllers {
  late Dio _dio;

  SignatureControllers() {
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

  Future<String> generateSignture(String date, String jornal) async {
    try {
      final queryData = {'jornal': jornal, 'date': date};

      EasyLoading.show(status: 'Generando firma general');
      await _initializeDio();
      Response response =
          await _dio.get('/api/signature/generate', queryParameters: queryData);

      if (!response.data['success']) {
        EasyLoading.showError('Ha ocurrido algo grave');
        return '';
      }

      String data = response.data['data'];

      EasyLoading.showSuccess('Firma generada exitosamente');

      return data;
    } catch (e) {
      EasyLoading.showError('Ha ocurrido algo grave');
      return '';
    }
  }
}
