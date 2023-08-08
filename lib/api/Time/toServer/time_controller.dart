// ignore_for_file: non_constant_identifier_names
import 'package:frontend_loreal/server/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frontend_loreal/api/Time/domain/time_model.dart';
import '../../../utils_exports.dart';

Future<List<Time>> getDataTime() async {
  try {
    final res = await http
        .get(Uri.https(dotenv.env['SERVER_URL']!, '/api/time'), headers: {
      'Content-Type': 'application/json',
      'access-token': (await AuthServices.getToken())!
    });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      return [];
    }
    final List<Time> timeData = [];

    decodeData['data'].forEach((value) {
      final each_time = Time.fromJson(value);
      timeData.add(each_time);
    });

    return timeData;
  } catch (e) {
    return [];
  }
}

void saveDataTime(String day_start, String day_end, String night_start,
    String night_end) async {
  try {
    EasyLoading.show(status: 'Configurando horarios...');

    final response =
        await http.post(Uri.https(dotenv.env['SERVER_URL']!, '/api/time'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'dayStart': day_start,
              'dayEnd': day_end,
              'nightStart': night_start,
              'nightEnd': night_end
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
    return;
  } catch (e) {
    showToast(e.toString());
  }
}
