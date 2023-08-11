import 'package:frontend_loreal/api/User/toServer/users_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import '../../utils_exports.dart';

int vecesMal = 0;
String incomingUsername = '';

class AuthServices {
  final _storage = const FlutterSecureStorage();

  // ----------------------------------------------------------

  // SAVE
  tokenSave(String token) async {
    _storage.write(key: 'access-token', value: token);
  }

  roleSave(String role) async {
    _storage.write(key: 'role', value: role);
  }

  userIdSave(String id) async {
    _storage.write(key: 'userID', value: id);
  }

  usernameSave(String username) async {
    _storage.write(key: 'username', value: username);
  }

  timeSignSave(String time) async {
    _storage.write(key: 'lastTime', value: time);
  }

  statusBlockSave(bool enable) async {
    _storage.write(key: 'lastEnable', value: enable.toString());
  }

  // ----------------------------------------------------------

  // GET
  static Future<String?> getToken() async {
    final token = await storage.read(key: 'access-token');
    return token;
  }

  static Future<String?> getUsername() async {
    final token = await storage.read(key: 'username');
    return token;
  }

  static Future<String?> getUserId() async {
    final userId = await storage.read(key: 'userID');
    return userId;
  }

  static Future<String?> getRole() async {
    final token = await storage.read(key: 'role');
    return token;
  }

  static Future<String?> getpassListerOffline() async {
    final passOffline = await storage.read(key: 'passListerOffline');
    return passOffline;
  }

  static Future<String?> getTimeSign() async {
    final passOffline = await storage.read(key: 'lastTime');
    return passOffline;
  }

  static Future<String?> getStatusBlock() async {
    final passOffline = await storage.read(key: 'lastEnable');
    return passOffline;
  }

  // ----------------------------------------------------------

  // DELETE
  static Future<void> tokenDelete() async {
    await storage.delete(key: 'access-token');
  }

  static Future<void> usernameDelete() async {
    await storage.delete(key: 'username');
  }

  static Future<void> userIdDelete() async {
    await storage.delete(key: 'userID');
  }

  static Future<void> roleDelete() async {
    await storage.delete(key: 'role');
  }

  static Future<void> timeSignDelete() async {
    await storage.delete(key: 'lastTime');
  }

  static Future<void> statusBlockDelete() async {
    await storage.delete(key: 'lastEnable');
  }

  // ----------------------------------------------------------

  Future<String> login(String username, String pass) async {
    authStatus.value = true;
    try {
      var url = Uri.http(dotenv.env['SERVER_URL']!, '/api/users/signin');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': pass}));

      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      authStatus.value = false;

      if (response.statusCode == 200) {
        String role = decodeData['data'][2]['role']['code'];

        usernameSave(decodeData['data'][4]['username']);
        userIdSave(decodeData['data'][1]['userID']);
        timeSignSave(DateTime.now().toString());
        tokenSave(decodeData['data'][0]);
        roleSave(role);

        showToast(decodeData['api_message'], type: true);
        return role;
      }

      showToast(decodeData['api_message']);
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
    editOneEnable(username, false);
    Directory? path = await getExternalStorageDirectory();
    Directory folder = Directory(path!.path);
    if (folder.existsSync()) {
      folder.delete(recursive: true);
    }
  }

  // ----------------------------------------------------------
}
