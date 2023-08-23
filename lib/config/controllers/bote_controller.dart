import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:frontend_loreal/models/Bote/bote_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<BoteModel>> makeABote(
    String date, String jornal, int fijo, int parle, int centena) async {
  try {
    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.post(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/list/bote', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        },
        body: jsonEncode({'fijo': fijo, 'parle': parle, 'centena': centena}));

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      return [];
    }

    final List<BoteModel> botados = [];

    final actual = BoteModel.fromJson(decodeData['data']);
    botados.add(actual);

    return botados;
  } catch (e) {
    return [];
  }
}