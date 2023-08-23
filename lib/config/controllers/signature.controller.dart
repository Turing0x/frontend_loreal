import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generateSignture(String date, String jornal) async {
  try {
    final queryData = {'jornal': jornal, 'date': date};

    EasyLoading.show(status: 'Generando firma general');

    final res = await http.get(
        Uri.http(
            dotenv.env['SERVER_URL']!, '/api/signature/generate', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido algo grave');
      return '';
    }

    String data = decodeData['data'];

    EasyLoading.showSuccess('Firma generada exitosamente');

    return data;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido algo grave');
    return '';
  }
}
