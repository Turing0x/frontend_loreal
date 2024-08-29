// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/models/Pagos/payments_model.dart';
import 'dart:convert';

class PaymentsControllers {
  late Dio _dio;

  PaymentsControllers() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final token = await LocalStorage.getToken();

    _dio = Dio(
      BaseOptions(
        baseUrl: Uri.https(Environments().SERVER_URL).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<Payments>> getDataPayments() async {
    try {
      EasyLoading.show(status: 'Cargando parámetros actuales');

      await _initializeDio();
      Response response = await _dio.get('/api/payments');
      if (!response.data['success']) {
        EasyLoading.showError('Algo grave ha ocurrido');
        return [];
      }

      final List<Payments> paymentsData = [];

      final actual = Payments.fromJson(response.data['data'][0]);
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
      await _initializeDio();
      Response response = await _dio.get('/api/payments/$id');
      if (!response.data['success']) {
        return [];
      }

      final List<Payments> paymentsData = [];

      final actual = Payments.fromJson(response.data['data']['payments']);
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

      await _initializeDio();
      Response response = await _dio.post('/api/payments',
          data: jsonEncode({
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

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
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

      await _initializeDio();
      Response response = await _dio.put('/api/users/$userID',
          data: jsonEncode({'payments': pay_obj}));

      if (response.data['success']) {
        EasyLoading.showSuccess(response.data['api_message']);
        return;
      }

      EasyLoading.showError(response.data['api_message']);
      return;
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }
}
