import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/models/Millon/million_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<MillionGame>> getAllMillion(String jornal, String date) async {
  try {
    final queryData = {'jornal': jornal, 'date': date};

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/million', queryData),
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