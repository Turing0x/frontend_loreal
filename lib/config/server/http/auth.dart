import 'package:dio/dio.dart';
import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import '../../utils_exports.dart';

int vecesMal = 0;
String incomingUsername = '';

class AuthServices {
  final _dio = Dio(BaseOptions(
      baseUrl: Uri.https(Environments().SERVER_URL).toString(),
      headers: {'Content-Type': 'application/json'}));

  Future<String> login(String username, String pass) async {
    authStatus.value = true;
    try {
      final localStorage = LocalStorage();

      Response response = await _dio.post('/api/users/signin',
          data: jsonEncode({'username': username, 'password': pass}));

      authStatus.value = false;

      if (response.data['success']) {
        String role = response.data['data'][2]['role']['code'];

        localStorage.usernameSave(response.data['data'][4]['username']);
        localStorage.userIdSave(response.data['data'][1]['userID']);
        localStorage.timeSignSave(DateTime.now().toString());
        localStorage.tokenSave(response.data['data'][0]);
        localStorage.roleSave(role);

        if (role != 'banco') {
          localStorage.userOwnerSave(response.data['data'][3]['owner']);
        }

        showToast(response.data['api_message'], type: true);
        return role;
      }

      showToast(response.data['api_message']);
      _comprobarSiBorraData(username);

      return '';
    } on Exception catch (e) {
      authStatus.value = false;
      showToast(e.toString());
      _comprobarSiBorraData(username);
      return '';
    }
  }

  void _comprobarSiBorraData(String username) async {
    if (incomingUsername != username) {
      incomingUsername = username;
      vecesMal = 0;
    }

    vecesMal++;

    if (vecesMal == 3) {
      await _borrarDatos(username.trim());
      vecesMal = 0;
      showToast('Se equivocó demasiadas veces. Se tomaron medidas al respecto');
    }
  }

  Future<void> _borrarDatos(String username) async {
    final userCtrl = UserControllers();
    userCtrl.editOneEnable(username, false);
    Directory? path = await getExternalStorageDirectory();
    Directory folder = Directory(path!.path);
    if (folder.existsSync()) {
      folder.delete(recursive: true);
    }
  }

  // ----------------------------------------------------------
}
