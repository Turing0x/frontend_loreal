// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontend_loreal/models/Limites/limited_parle.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

final limitsControllers = LimitsControllers();
class LimitedParles extends StatefulWidget {
  const LimitedParles({super.key});

  @override
  State<LimitedParles> createState() => _LimitedParlesState();
}

class _LimitedParlesState extends State<LimitedParles> {
  String jornada = 'dia';
  Map<String, List<List<int>>> parlesLimitado = <String, List<List<int>>>{};
  TextEditingController number = TextEditingController();

  @override
  void initState() {
    Future<List<LimitedParleModel>> limits = limitsControllers.getLimitedParleToday();
    limits.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          parlesLimitado = convertListToMap(value);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: showAppBar('Parlé limitado', actions: [
        IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () {
            if (parlesLimitado.isNotEmpty) {
              limitsControllers.saveDataLimitsParle(parlesLimitado);
              return;
            }

            showToast('Añada algún número para limitar');
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

  Widget rowNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        textoDosis('Número:', 20),
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: number,
                maxLength: null,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,-]')),
                  NumberTextInputFormatter(
                    groupDigits: 2,
                    groupSeparator: '-',
                  )
                ],
                onChanged: (valor) => setState(() {
                  if (kDebugMode) {
                    print(valor.length);
                  }
                }),
                style: const TextStyle(fontFamily: 'Dosis'),
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.numbers_outlined, color: Colors.black),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                elevation: 2,
              ),
              onPressed: number.text.isNotEmpty
                  ? () => setState(() {
                        if (number.text.length < 4) {
                          showToast('Revise los campos por favor');
                          return;
                        }

                        final candado = number.text.split('-').map((e) => e.intParsed).toList();
                        final comb = combinaciones(candado);

                        for (var element in comb) {
                          parlesLimitado.addAll({
                            jornada: _insertar(
                                jornada: jornada,
                                numero: element)
                          });
                        }

                        number.text = '';
                      })
                  : null,
              child: textoDosis('Limitar', 20, color: Colors.white),
            ),
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
      height: size.height * 0.70,
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
    ValueNotifier<List<List<List<int>>>> toChange = ValueNotifier(_insertarColumnas(jornada));

    return ValueListenableBuilder(
      valueListenable: toChange,
      builder: (context, value, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
        
              final subList = value[index];

              return GestureDetector(
                onTap: () {
                  int index = parlesLimitado[jornada]!.indexOf(subList[0]);
                  parlesLimitado[jornada]!.removeAt(index);
                  value.removeAt(index);

                  toChange.value = List.from(value);

                },
                child: containerRayaDebajo(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...subList
                              .map(
                                (listado) => fila(listado),
                              )
                              .toList()
                        ],
                      ),
                    ),
                  ),
                ));
            },
          ),
        );
      },
    );
  }

  Row fila(List<int> lista) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...lista.map(
          (numero) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: NumeroRedondoWidget(
              numero: numero.toString().rellenarCon0(2),
            ),
          ),
        ),
      ],
    );
  }

  List<List<int>> _insertar(
      {required String jornada, required List<int> numero}) {
    final arr = parlesLimitado[jornada];
    if (arr == null) return [numero];
    return [...arr, numero];
  }

  List<List<List<int>>> _insertarColumnas(String jornada) {
    final arr = parlesLimitado[jornada] ?? [];
    final List<List<List<int>>> columnas = [];
    for (var i = 0; i < arr.length; i += 1) {
      int fin = i + 1;
      if (fin > arr.length) fin = arr.length;
      columnas.add(arr.sublist(i, fin));
    }
    return columnas;
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

  List combinaciones( List<int> candado ){

    List resultado = [];

    for( int i = 0; i < candado.length - 1; i++ ){
      for ( int j = i + 1; j < candado.length; j++ ){
        resultado.add([candado[i], candado[j]]);
      } 
    }

    return resultado;

  }
}