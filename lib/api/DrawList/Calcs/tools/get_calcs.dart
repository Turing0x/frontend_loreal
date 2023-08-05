import 'package:frontend_loreal/api/DrawList/Calcs/models/other_model.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../utils_exports.dart';

const storage = FlutterSecureStorage();

Future<List<CalcsOfList>> getCalcsOfOneList(
    {String lot = '', String signature = ''}) async {
  try {
    final queryData = {'lot': lot, 'signature': signature};

    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/calcs', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(
          'Por favor, cierre la sesión actual y vuelva a iniciar para poder obetener nuevo datos');
      return [];
    }

    final List<CalcsOfList> lists = [];

    final actual = CalcsOfList.fromJson(decodeData['data']);
    lists.add(actual);

    return lists;
  } catch (e) {
    return [];
  }
}
