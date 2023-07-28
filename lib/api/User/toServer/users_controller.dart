import 'package:frontend_loreal/server/methods.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../domian/user_show_model.dart';
import '../../../utils_exports.dart';

Future<List<User>> getAllUsers({String id = ''}) async {
  try {
    final queryData = {'id': id};

    final res = await http.get(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users', queryData),
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

    final List<User> users = [];

    if (id != '') {
      if (decodeData['data'][0] != []) {
        for (var toShow in decodeData['data']) {
          final actual = User.fromJson(toShow);
          users.add(actual);
        }
      }

      return users;
    }

    decodeData['data'].forEach((value) {
      final userTemp = User.fromJson(value);
      users.add(userTemp);
    });

    return users;
  } catch (e) {
    return [];
  }
}

Future<List<User>> getAllBanks() async {
  try {
    final res = await http.get(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users/banksUsers'),
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

    final List<User> users = [];

    decodeData['data'].forEach((value) {
      final userTemp = User.fromJson(value);
      users.add(userTemp);
    });

    return users;
  } catch (e) {
    return [];
  }
}

Future<Map<String, dynamic>> getUserById(String jornal, String date,
    {String id = 'admin',
    bool userInfo = true,
    bool makeResumen = false,
    String startDate = '',
    String endDate = ''}) async {
  try {
    final queryData = (makeResumen)
        ? {'jornal': jornal, 'startDate': startDate, 'endDate': endDate}
        : {'jornal': jornal, 'date': date};

    String endpoint =
        (makeResumen) ? '/api/list/resumen/$id' : '/api/users/$id';

    final res = await http.get(
        Uri.https(dotenv.env['SERVER_URL']!, endpoint, queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      showToast(decodeData['api_message']);
      return {'data': [], 'missign': [], 'lotOfToday': ''};
    }

    final List<User> users = [];
    List missingLists = [];
    String lotOfToday = '';

    if (userInfo) {
      final actual = User.fromJson(decodeData['data'][0]);
      users.add(actual);
      return {'data': users, 'missign': [], 'lotOfToday': ''};
    }

    if (!makeResumen) {
      if (decodeData['data'][0] != []) {
        for (var toShow in decodeData['data'][1]) {
          final actual = User.fromJson(toShow);
          users.add(actual);
        }
        missingLists = decodeData['data'][2];
        lotOfToday = decodeData['data'][3]['lot'];
      }

      return {'data': users, 'missign': missingLists, 'lotOfToday': lotOfToday};
    }

    if (decodeData['data'] != []) {
      for (var toShow in decodeData['data']) {
        final actual = User.fromJson(toShow);
        users.add(actual);
      }
    }

    return {
      'data': users,
    };
  } catch (e) {
    return {'data': [], 'missign': [], 'lotOfToday': ''};
  }
}

void saveOne(String name, String pass, String owner) async {
  try {
    EasyLoading.show(status: 'Creando usuario...');
    final response = await http.post(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        },
        body: jsonEncode({'username': name, 'password': pass, 'owner': owner}));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error. $e');
  }
}

Future<bool> editOneEnable(String id, bool enable) async {
  try {
    EasyLoading.show(status: 'Cambiando acceso al sistema...');

    final res = await http.put(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users/changeEnable/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'enable': enable,
        }));

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return true;
    }

    EasyLoading.showError(decodeData['api_message']);
    return false;
  } catch (e) {
    EasyLoading.showError('Ha ocrrido un error grave');
    return false;
  }
}

void deleteOne(String id) async {
  try {
    EasyLoading.show(status: 'Eliminando usuario...');
    final res = await http.delete(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
    return;
  } catch (e) {
    return;
  }
}

void changePass(String actualPass, String newPass, BuildContext context) async {
  try {
    EasyLoading.show(status: 'Cambiando contraseña...');
    final cont = Navigator.of(context);

    final response = await http.post(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users/chpass'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        },
        body: jsonEncode({'actualPass': actualPass, 'newPass': newPass}));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      cont.pushNamedAndRemoveUntil(
          'signIn_page', (Route<dynamic> route) => false);
      if (context.mounted) await cerrarSesion(context);

      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
    return;
  } on Exception catch (e) {
    showToast(e.toString());
  }
}

void resetPass(String userId) async {
  try {
    EasyLoading.show(status: 'Reseteando la contraseña...');

    final queryData = {'userId': userId};

    final response = await http.post(
        Uri.https(
          dotenv.env['SERVER_URL']!,
          '/api/users/resetpass',
          queryData,
        ),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        });

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
    return;
  } on Exception catch (e) {
    showToast(e.toString());
  }
}

Future<bool> checkJWT() async {
  try {
    final res = await http.get(
        Uri.https(dotenv.env['SERVER_URL']!, '/api/users/checkJWT'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken()) ?? ''
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      return false;
    }

    return true;
  } catch (e) {
    return false;
  }
}
