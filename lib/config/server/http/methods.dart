import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';

Future<String> rutaInicial() async {
  final role = await LocalStorage.getRole();
  // final lastTime = await LocalStorage.getTimeSign();

  if (role != null) {
    return _rutaInicial(role);
  }

  return 'signIn_page';
}

cerrarSesion(BuildContext context) async {
  final contex = Navigator.of(context);

  await LocalStorage.roleDelete();
  await LocalStorage.tokenDelete();
  await LocalStorage.userIdDelete();
  await LocalStorage.timeSignDelete();

  toBlockIfOutOfLimit.clear();
  toBlockIfOutOfLimitFCPC.clear();
  toBlockIfOutOfLimitTerminal.clear();
  toBlockIfOutOfLimitDecena.clear();

  clearAllMaps();

  contex.pushNamedAndRemoveUntil(
      'signIn_page', (Route<dynamic> route) => false);
}

String _rutaInicial(String role) {
  Map<String, String> mainPages = {
    'banco': 'main_banquero_page',
    'colector general': 'main_colector_page',
    'colector simple': 'main_colector_page',
    'listero': 'main_listero_page',
  };

  return mainPages[role]!;
}

bool excede100Minutos(DateTime fecha) {
  DateTime horaActual = DateTime.now();
  Duration diferencia = horaActual.difference(fecha);

  if (diferencia.inMinutes > 95) {
    return true;
  }

  return false;
}
