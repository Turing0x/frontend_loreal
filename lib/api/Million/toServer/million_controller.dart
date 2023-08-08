import 'package:frontend_loreal/api/Million/domain/million_model.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils_exports.dart';

Future<List<MillionGame>> getAllMillion(String jornal, String date) async {
  try {
    final queryData = {'jornal': jornal, 'date': date};

    final res = await http.get(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/million', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast('Ha ocurrido algo grave');
      return [];
    }

    final List<MillionGame> lists = [];

    decodeData['data'].forEach((value) {
      final dataTemp = MillionGame.fromJson(value);
      lists.add(dataTemp);
    });

    return lists;
  } catch (e) {
    return [];
  }
}
