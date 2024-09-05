// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:flutter/services.dart';
import 'package:frontend_loreal/models/Limites/limited_ball.dart';

final limitsControllers = LimitsControllers();

class LimitedBallToUser extends StatefulWidget {
  const LimitedBallToUser({super.key, required this.userID});

  final String userID;

  @override
  State<LimitedBallToUser> createState() => _LimitedBallToUserState();
}

class _LimitedBallToUserState extends State<LimitedBallToUser> {
  String jornada = 'dia';
  Map<String, List<int>> bolaLimitada = <String, List<int>>{};
  TextEditingController number = TextEditingController();

  @override
  void initState() {
    Future<List<LimitedBallModel>> limits =
        limitsControllers.getLimitsBallsOfUser(widget.userID);
    limits.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          value[0].bola.forEach((key, value) {
            for (var number in value) {
              bolaLimitada
                  .addAll({key: _insertar(jornada: key, numero: number)});
            }
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: showAppBar('Bola limitada', actions: [
        IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () async {
            if (bolaLimitada.isNotEmpty) {
              await limitsControllers.saveDataLimitsBallsToUser(
                  widget.userID, bolaLimitada);
              return;
            }

            showToast(context, 'Añada algún número para limitar');
          },
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            rowJornada(),
            rowNumber(),
            const Divider(
              color: Colors.black,
              indent: 15,
              endIndent: 15,
            ),
            rowShowNumbers(size)
          ],
        ),
      ),
    );
  }

  Container rowJornada() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Row(
        children: [
          textoDosis('Jornada:', 20),
          Flexible(
            child: RadioListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: textoDosis('Día', 20),
              value: 'dia',
              groupValue: jornada,
              selected: jornada == 'dia',
              onChanged: (value) {
                setState(() {
                  jornada = value!;
                });
              },
            ),
          ),
          Flexible(
            child: RadioListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: textoDosis('Noche', 20),
              value: 'noche',
              selected: jornada == 'noche',
              groupValue: jornada,
              onChanged: (value) {
                setState(() {
                  jornada = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Row rowNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        textoDosis('Número:', 20),
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: number,
              maxLength: 2,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (valor) => setState(() {}),
              style: const TextStyle(fontFamily: 'Dosis'),
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Icon(Icons.numbers_outlined, color: Colors.black),
                focusedBorder: InputBorder.none,
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(10)),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent)),
                onPressed: number.text.isNotEmpty
                    ? () => setState(() {
                          bolaLimitada.addAll({
                            jornada: _insertar(
                                jornada: jornada, numero: number.text.intParsed)
                          });
                          number.text = '';
                        })
                    : null,
                child: textoDosis('Limitar', 20, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Row rowShowNumbers(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        diaNocheColumn(size, 'Dia'),
        diaNocheColumn(size, 'Noche'),
      ],
    );
  }

  Flexible diaNocheColumn(Size size, String jornada) {
    return Flexible(
        child: Container(
      margin: const EdgeInsets.only(top: 5, left: 10, right: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      height: size.height * 0.72,
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

  ValueListenableBuilder diaNocheWidget(String jornada) {
    ValueNotifier<bool> toChange = ValueNotifier(true);

    return ValueListenableBuilder(
      valueListenable: toChange,
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._insertarColumnas(jornada).map((subList) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...subList.map(
                        (numero) => GestureDetector(
                          onTap: () {
                            List<int>? listByJornal = bolaLimitada[jornada];
                            int index = listByJornal!.indexOf(numero);
                            listByJornal.removeAt(index);

                            toChange.value = !toChange.value;
                          },
                          child: NumeroRedondoWidget(
                            numero: numero.toString(),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        );
      },
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
