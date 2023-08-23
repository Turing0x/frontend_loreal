import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'auth.dart';

Future<String> rutaInicial() async {
  final role = await AuthServices.getRole();
  final lastTime = await AuthServices.getTimeSign();

  if (role != null &&
      !excede100Minutos(
          DateTime.parse(lastTime ?? '2020-01-01T00:00:00.000+00:00'))) {
    return _rutaInicial(role);
  }

  return 'signIn_page';
}

cerrarSesion(BuildContext context) async {
  final contex = Navigator.of(context);

  await AuthServices.roleDelete();
  await AuthServices.tokenDelete();
  await AuthServices.userIdDelete();

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
