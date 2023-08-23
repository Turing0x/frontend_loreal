// ignore_for_file: non_constant_identifier_names
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/server/http/auth.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/models/Pagos/payments_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Payments>> getDataPayments() async {
  try {
    EasyLoading.show(status: 'Cargando parámetros actuales');
    final res = await http
        .get(Uri.http(dotenv.env['SERVER_URL']!, '/api/payments'), headers: {
      'Content-Type': 'application/json',
      'access-token': (await AuthServices.getToken())!
    });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Algo grave ha ocurrido');
      return [];
    }

    final List<Payments> paymentsData = [];

    final actual = Payments.fromJson(decodeData['data'][0]);
    paymentsData.add(actual);

    EasyLoading.showSuccess('Parámetros cargados');
    return paymentsData;
  } catch (e) {
    EasyLoading.showError('Algo grave ha ocurrido');
    return [];
  }
}

Future<List<Payments>> getPaymentsOfUser(String id) async {
  try {
    final res = await http.get(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/payments/$id'),
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

    final List<Payments> paymentsData = [];

    final actual = Payments.fromJson(decodeData['data']['payments']);
    paymentsData.add(actual);

    return paymentsData;
  } catch (e) {
    return [];
  }
}

void saveDataPayments(
    String pagos_jugada_Corrido,
    String pagos_jugada_Centena,
    String pagos_jugada_Parle,
    String pagos_jugada_Fijo,
    String pagos_millon_Fijo,
    String pagos_millon_Corrido,
    String limitados_Corrido,
    String limitados_Parle,
    String limitados_Fijo,
    String parle_listero,
    String bola_listero,
    String time) async {
  try {
    EasyLoading.show(status: 'Estableciendo configuración de parámetros');
    final response =
        await http.post(Uri.http(dotenv.env['SERVER_URL']!, '/api/payments'),
            headers: {
              'Content-Type': 'application/json',
              'access-token': (await AuthServices.getToken())!
            },
            body: jsonEncode({
              'pagos_jugada_Corrido': pagos_jugada_Corrido,
              'pagos_jugada_Centena': pagos_jugada_Centena,
              'pagos_jugada_Parle': pagos_jugada_Parle,
              'pagos_jugada_Fijo': pagos_jugada_Fijo,
              'pagos_millon_Fijo': pagos_millon_Fijo,
              'pagos_millon_Corrido': pagos_millon_Corrido,
              'limitados_Corrido': limitados_Corrido,
              'limitados_Parle': limitados_Parle,
              'limitados_Fijo': limitados_Fijo,
              'parle_listero': parle_listero,
              'bola_listero': bola_listero,
              'time': time
            }));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showSuccess('Parámetros configurados exitosamente');
    return;
  } catch (e) {
    EasyLoading.showSuccess('Error');
  }
}

void editPaymentsOfUser(
    String pagos_jugada_Corrido,
    String pagos_jugada_Centena,
    String pagos_jugada_Parle,
    String pagos_jugada_Fijo,
    String limitados_Corrido,
    String limitados_Parle,
    String limitados_Fijo,
    String parle_listero,
    String bola_listero,
    String pagos_millon_Fijo,
    String pagos_millon_Corrido,
    String exprense,
    String userID) async {
  try {
    EasyLoading.show(status: 'Guadando pagos al usuario');

    final pay_obj = {
      'pagos_jugada_Corrido': pagos_jugada_Corrido,
      'pagos_jugada_Centena': pagos_jugada_Centena,
      'pagos_jugada_Parle': pagos_jugada_Parle,
      'pagos_jugada_Fijo': pagos_jugada_Fijo,
      'limitados_Corrido': limitados_Corrido,
      'limitados_Parle': limitados_Parle,
      'limitados_Fijo': limitados_Fijo,
      'parle_listero': parle_listero,
      'bola_listero': bola_listero,
      'pagos_millon_Fijo': pagos_millon_Fijo,
      'pagos_millon_Corrido': pagos_millon_Corrido,
      'exprense': exprense,
    };

    final response = await http.put(
        Uri.http(dotenv.env['SERVER_URL']!, '/api/users/$userID'),
        headers: {
          'Content-Type': 'application/json',
          'access-token': (await AuthServices.getToken())!
        },
        body: jsonEncode({'payments': pay_obj}));

    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      EasyLoading.showSuccess(decodeData['api_message']);
      return;
    }

    EasyLoading.showError(decodeData['api_message']);
    return;
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
