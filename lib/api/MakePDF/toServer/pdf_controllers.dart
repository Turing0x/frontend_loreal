import 'package:frontend_loreal/api/MakePDF/toServer/pdf_data_model.dart';
import 'package:frontend_loreal/api/User/domian/user_show_model.dart';
import 'package:frontend_loreal/extensions/lista_general_extensions.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<PdfData>> getDataToPDF(String username, String date, String jornal,
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

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/vales/$username', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      return [];
    }

    final List<PdfData> data = [];

    decodeData['data'][0].forEach((value) {
      final eachData = PdfData.fromJson(value);
      data.add(eachData);
    });

    globalRoleToPDF = decodeData['data'][1];
    globalGastoToPDF = decodeData['data'][2] / 100;

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

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/vales/all', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido algo grave');
      return [];
    }

    final List<User> data = [];

    decodeData['data'].forEach((value) {
      final eachData = User.fromJson(value);
      data.add(eachData);
    });

    return data;
  } catch (e) {
    return [];
  }
}
