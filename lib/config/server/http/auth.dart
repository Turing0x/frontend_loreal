import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sticker_maker/config/controllers/users_controller.dart';
import 'package:sticker_maker/config/environments/env.environments.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/server/http/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:sticker_maker/config/utils_exports.dart';

int vecesMal = 0;
String incomingUsername = '';

class AuthServices {
  final _dio = Dio(BaseOptions(
      baseUrl: Uri.https(Environments().SERVER_URL).toString(),
      headers: {'Content-Type': 'application/json'}));

  Future<String> login(
      String username, String pass, BuildContext context) async {
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

        showToast(context, response.data['api_message'], type: true);
        return role;
      }

      showToast(context, response.data['api_message']);
      _comprobarSiBorraData(username);

      return '';
    } on Exception catch (e) {
      authStatus.value = false;
      showToast(context, e.toString());
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
