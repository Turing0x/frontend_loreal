import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend_loreal/config/environments/env.environments.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<BolaCargadaModel>> getBolasCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    final token = await LocalStorage.getToken();

    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.get(
        Uri.https(Environments().SERVER_URL, '/api/list/cargados', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');
      return [];
    }

    final List<BolaCargadaModel> cargados = [];
    
    final lot = (decodeData['data'] as List).last;
    List<String> este = [];
    if(lot != null && lot != ''){
      este = (lot['lot'] as String).substring(1).split(' ');
      globallot = este;
    } else{ globallot = []; }

    (decodeData['data'] as List).removeLast();
    for (var data in decodeData['data']) {
      updateDataBasedOnLot(data, este);
      final actual = BolaCargadaModel.fromJson(data);
      cargados.add(actual);
    }

    EasyLoading.showToast('Información cargada');

    return cargados;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}

Future<List<BolaCargadaModel>> getParleCargadas(
    {String jornal = '', String date = ''}) async {
  try {
    final token = await LocalStorage.getToken();

    EasyLoading.show(status: 'Buscando cargados');

    final queryData = {'jornal': jornal, 'date': date};
    final res = await http.get(
        Uri.https(Environments().SERVER_URL, '/api/list/parle', queryData),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token!
        });

    final decodeData = json.decode(res.body) as Map<String, dynamic>;
    if (decodeData['success'] == false) {
      EasyLoading.showError('Ha ocurrido un error');

      return [];
    }

    final List<BolaCargadaModel> cargados = [];

    final lot = (decodeData['data'] as List).last;
    var este = [];
    if(lot != null && lot != ''){
      este = (lot['lot'] as String).substring(1).split(' ');
      globallot = (este as List<String>);
    } else{ globallot = []; }

    (decodeData['data'] as List).removeLast();
    for (var data in decodeData['data']) {

      if(este.isNotEmpty){
        List<String> splitted = data['numero'].split('--');
        if((este.contains(splitted[0]) && este.contains(splitted[1])) && splitted[0] != splitted[1]){
          data.addAll({
            'dinero': data['total'] * 1000
          });
        } else { data['dinero'] = 0; }
      } else { data['dinero'] = 0; }

      final actual = BolaCargadaModel.fromJson(data);
      cargados.add(actual);
    }

    EasyLoading.showToast('Información cargada');

    return cargados;
  } catch (e) {
    EasyLoading.showError('Ha ocurrido un error');
    return [];
  }
}

void updateDataBasedOnLot(Map<String, dynamic> data, List<String> este) {
  String splitted = data['numero'];

  if (este.isNotEmpty) {
    if (splitted == este[0]) {
      updateDataWithJugadaAndDinero(data, 'fijo', data['total'] * 75);
    } else if (splitted == este[1] || splitted == este[2]) {
      updateDataWithJugadaAndDinero(data, 'corrido', data['totalCorrido'] * 25);
    } else if (splitted.contains('p') && splitted == este[0]) {
      updateDataWithJugadaAndDinero(data, 'fijop', data['total'] * 75);
    } else if (splitted.contains('p') && splitted == este[1]) {
      updateDataWithJugadaAndDinero(data, 'corrido1p', data['totalCorrido'] * 75);
    } else if (splitted.contains('p') && splitted == este[2]) {
      updateDataWithJugadaAndDinero(data, 'corrido2p', data['totalCorrido'] * 75);
    } else {
      setDataToZero(data);
    }
  } else {
    setDataToZero(data);
  }
}

void updateDataWithJugadaAndDinero(Map<String, dynamic> data, String jugada, int dinero) {
  data.addAll({
    'jugada': jugada,
    'dinero': dinero,
  });
}

void setDataToZero(Map<String, dynamic> data) {
  data['dinero'] = 0;
  data['jugada'] = 'nada';
}