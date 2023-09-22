import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:frontend_loreal/models/Limites/limited_ball.dart';

class SeeLimitedBall extends StatefulWidget {
  const SeeLimitedBall({super.key, required this.userID});

  final String userID;

  @override
  State<SeeLimitedBall> createState() => _SeeLimitedBallState();
}

class _SeeLimitedBallState extends State<SeeLimitedBall> {
  Map<String, List<int>> bolaLimitada = <String, List<int>>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Bolas limitadas para hoy'),
      body: SingleChildScrollView(child: showList()),
    );
  }

  Widget showList() {
    Size size = MediaQuery.of(context).size;
    final limitsControllers = LimitsControllers();
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        child: FutureBuilder(
          future: limitsControllers.getLimitsBallsOfUser(widget.userID),
          builder: (context, AsyncSnapshot<List<LimitedBallModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return waitingWidget(context);
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return noData(context);
            }

            final list = snapshot.data!;

            list[0].bola.forEach((key, value) {
              for (var number in value) {
                bolaLimitada
                    .addAll({key: _insertar(jornada: key, numero: number)});
              }
            });

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

  List<int> _insertar({required String jornada, required int numero}) {
    final arr = bolaLimitada[jornada];
    if (arr == null) return [numero];
    return [...arr, numero];
  }

  List<List<int>> _insertarColumnas(String jornada) {
    final arr = bolaLimitada[jornada] ?? [];
    final List<List<int>> columnas = [];
    for (var i = 0; i < arr.length; i += 3) {
      int fin = i + 3;
      if (fin > arr.length) fin = arr.length;
      columnas.add(arr.sublist(i, fin));
    }
    return columnas;
  }
}
