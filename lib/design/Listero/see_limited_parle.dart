import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:frontend_loreal/models/Limites/limited_parle.dart';

class SeeLimitedParle extends StatefulWidget {
  const SeeLimitedParle({super.key, required this.userID});

  final String userID;

  @override
  State<SeeLimitedParle> createState() => _SeeLimitedParleState();
}

class _SeeLimitedParleState extends State<SeeLimitedParle> {
  Map<String, List<List<int>>> bolaLimitada = <String, List<List<int>>>{};
  String jornada = 'dia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Parlés limitados para hoy'),
      body: SingleChildScrollView(child: showList()),
    );
  }

  Widget showList() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height * 0.9,
        width: double.infinity,
        child: FutureBuilder(
          future: getLimitsParleOfUser(widget.userID),
          builder: (context, AsyncSnapshot<List<LimitedParleModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return waitingWidget(context);
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return noData(context);
            }

            final list = snapshot.data!;
            bolaLimitada = convertListToMap(list);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                diaNocheColumn(size, 'Dia'),
                diaNocheColumn(size, 'Noche'),
              ],
            );
          },
        ));
  }

  // convert List<LimitedParleModel> to Map<String, List<List<int>>>
  Map<String, List<List<int>>> convertListToMap(List<LimitedParleModel> list) {
    Map<String, List<List<int>>> map = <String, List<List<int>>>{};
    final List<List<int>> listDia = [];
    final List<List<int>> listNoche = [];
    for (var element in list) {
      final bola = element.bola;
      final lista = bola.values.first as List<dynamic>;
      for (var value in lista) {
        final listaInt = (value as List<dynamic>).map((e) => e as int).toList();
        if (bola.keys.first == 'dia') {
          listDia.add(listaInt);
        } else {
          listNoche.add(listaInt);
        }
      }
    }
    map.addAll({'dia': listDia, 'noche': listNoche});
    return map;
  }

  Flexible diaNocheColumn(Size size, String jornada) {
    return Flexible(
        child: Container(
      margin: const EdgeInsets.only(top: 5, left: 10, right: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      height: size.height * 0.85,
      width: size.width * 0.5,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black)),
            ),
            width: double.infinity,
            height: 35,
            child: textoDosis(jornada, 18),
          ),
          diaNocheWidget(jornada.toLowerCase()),
        ],
      ),
    ));
  }

  Column diaNocheWidget(String jornada) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._insertarColumnas(jornada)
            .map((subList) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...subList
                          .map(
                            (numero) => NumeroRedondoWidget(
                              numero: numero.toString(),
                            ),
                          )
                          .toList()
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  List<List<int>> _insertarColumnas(String jornada) {
    final arr = bolaLimitada[jornada] ?? [];
    final List<int> newList = arr.expand((element) => element).toList();
    final List<List<int>> columnas = [];
    for (var i = 0; i < newList.length; i += 2) {
      int fin = i + 2;
      if (fin > newList.length) fin = newList.length;
      columnas.add(newList.sublist(i, fin));
    }
    return columnas;
  }
}
