import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:frontend_loreal/design/Lista/list_detail.dart';
import 'package:frontend_loreal/design/Pintar_lista/Candado/candado.dart';
import 'package:frontend_loreal/design/Pintar_lista/Decena/decena.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/centenas.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/fijos_corridos.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/parles.dart';
import 'package:frontend_loreal/design/Pintar_lista/Millon/million.dart';
import 'package:frontend_loreal/design/Pintar_lista/Posicion/posicion.dart';
import 'package:frontend_loreal/design/Pintar_lista/Terminal/terminal.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:frontend_loreal/models/Lista/only_winner.dart';
import 'package:frontend_loreal/models/Lista_Candado/candado_model.dart';
import 'package:frontend_loreal/models/Lista_Decena/decena_model.dart';
import 'package:frontend_loreal/models/Lista_Main/centenas/centenas_model.dart';
import 'package:frontend_loreal/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:frontend_loreal/models/Lista_Main/parles/parles_model.dart';
import 'package:frontend_loreal/models/Lista_Millon/million_model.dart';
import 'package:frontend_loreal/models/Lista_Posicion/posicion_model.dart';
import 'package:frontend_loreal/models/Lista_Terminal/terminal_model.dart';

String lotThisDay = '';
String typeFilter = 'todos';

class OnlyWinnersPage extends ConsumerStatefulWidget {
  const OnlyWinnersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnlyWinnersPageState();
}

class _OnlyWinnersPageState extends ConsumerState<OnlyWinnersPage> {

  String title = 'Solo Premios';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(title, actions: [
        PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      enabled: true,
      onSelected: (value) async {
        Map<String, void Function()> methods = {
          'todos': () {
            setState(() {
              typeFilter = 'todos';
              title = 'Solo Premios';
            });
          },
          'fcpos': () {
            setState(() {
              typeFilter = 'fcpos';
              title = 'Por Número';
            });
          },
          'bolas': () {
            setState(() {
              typeFilter = 'bolas';
              title = 'Bolas, Terminal y Decena';
            });
          },
          'parle': () {
            setState(() {
              typeFilter = 'parle';
              title = 'Parles y Candado';
            });
          },
          'pos': () {
            setState(() {
              typeFilter = 'pos';
              title = 'Centenas y Posición';
            });
          },
        };

        methods[value]!.call();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'todos',
          child: textoDosis('Todas las jugadas', 18),
        ),
        PopupMenuItem(
          value: 'fcpos',
          child: textoDosis('Por Número', 18),
        ),
        PopupMenuItem(
          value: 'bolas',
          child: textoDosis('Bolas, Terminal y Decena', 18),
        ),
        PopupMenuItem(
          value: 'parle',
          child: textoDosis('Parles y Candado', 18),
        ),
        PopupMenuItem(
          value: 'pos',
          child: textoDosis('Centenas y Posición', 18),
        )
      ],
    )
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const JornadAndDate(),
            encabezado(
                context, 'Resultados de la búsqueda', false, () {}, false),
            ShowList(
              ref: ref
            ),
          ],
        ),
      ),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  List<dynamic> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final janddate = widget.ref.watch(janddateR);

    return ValueListenableBuilder(
        valueListenable: cambioListas,
        builder: (_, __, ___) {
          return FutureBuilder(
            future: listControllers.getOnlyWinners( janddate.currentJornada, janddate.currentDate),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingWidget(context);
              }
              if (snapshot.data!['data']!.isEmpty || 
              snapshot.data!['data']!.length == 1 || 
              snapshot.data!.isEmpty) {
                return noData(context);
              }

              List<ByNumplay> listByNumplay = [];
              List<OnlyWinner> list = snapshot.data!['data'];
              String lot = snapshot.data!['lotOfToday'];
              lotThisDay = lot;

              int premio = 0;

              List<OnlyWinner> aux = [];
              if(typeFilter == 'todos'){
                aux = list;
              } else if(typeFilter == 'bolas'){
                aux = list.where((play) => 
                  play.play == 'bola' ||
                  play.play == 'terminal' ||
                  play.play == 'decena').toList();
              } else if(typeFilter == 'parle'){
                aux = list.where((play) => play.play == 'parle' || play.play == 'candado').toList();
              } else if(typeFilter == 'pos'){
                aux = list.where((play) => play.play == 'posicion' || play.play == 'centena').toList();
              } else if(typeFilter == 'fcpos'){

                Map<String, int> groupedByNumplay = {};
                String fijo = lotThisDay.split(' ')[0].substring(1);

                final parlesLot = combinaciones(lotThisDay.split(' ').map(
                (e) {
                  if(e.length == 3){
                    return int.parse(e.substring(1));
                  }
                  return int.parse(e);
                }).toList());

                for (var winner in list) {
                  ElementData data = winner.element!;
                  if ( data.numplay != null ) {
                    if (winner.play == 'parle' || winner.play == 'candado') {
                      
                      final candado = combinaciones(winner.element!.numplay);

                      for(var parle in parlesLot){
                        if(listContainsList(candado, parle)){

                          String parl = parle.toString().replaceAll(RegExp(r'\[|\]'), '');

                          if(!groupedByNumplay.containsKey(parl)){
                            groupedByNumplay.addAll({parl: 0});
                          }
                          groupedByNumplay.update(parl,
                            (value) => value + data.dinero!);
                        }
                      }

                    } else {

                      if(data.numplay.toString() == fijo){
                        if(!groupedByNumplay.containsKey('c${data.numplay.toString()}')){
                          groupedByNumplay.addAll({'c${data.numplay.toString()}': 0});
                        }
                        groupedByNumplay.update('c${data.numplay.toString()}', 
                          (value) => value + data.corrido! * 25);
                      }

                      if(!groupedByNumplay.containsKey(data.numplay.toString())){
                        groupedByNumplay.addAll({data.numplay.toString(): 0});
                      }
                      groupedByNumplay.update(data.numplay.toString(), 
                        (value) => value + data.dinero!);
                    }
                  } else {
                    if(!groupedByNumplay.containsKey(data.terminal.toString())){
                      groupedByNumplay.addAll({data.terminal.toString(): 0});
                    }
                    groupedByNumplay.update(data.terminal.toString(), 
                      (value) => value + data.dinero!);
                  }
                }

                if(groupedByNumplay.containsKey('c$fijo')){
                  int fijoCorrido = groupedByNumplay['c$fijo']!;
                  groupedByNumplay.update(fijo, 
                    (value) => value - fijoCorrido);
                }

                listByNumplay = groupedByNumplay.entries.map((entry){
                  return ByNumplay(numplay: entry.key, dinero: entry.value);
                }).toList();

                premio = listByNumplay.fold(
                  0, (value, element) => value + element.dinero);

              }

              if(typeFilter != 'fcpos'){
                premio = aux.fold(0, (value, element) => value + element.element!.dinero!);
                aux.sort(((a, b) { return b.element!.dinero! - a.element!.dinero!; }));
              }{
                listByNumplay.sort(((a, b) { return b.dinero - a.dinero; }));
              }

              return Column(
                children: [
                  boldLabel('Sorteo del momento -> ', lot, 23),
                  boldLabel('Premio Total -> ', premio.toString(), 23),

                  OutlinedButton(
                    onPressed: (){
                      Map<String, List<OnlyWinner>> groupedByOwner = {};
                      for (var winner in aux) {
                        if (!groupedByOwner.containsKey(winner.owner)) {
                            groupedByOwner[winner.owner!] = [];
                        }
                        groupedByOwner[winner.owner!]!.add(winner);
                      }

                      Navigator.pushNamed(context, 'winner_for_listero_page', arguments: [
                        groupedByOwner,
                        typeFilter == 'pos' || typeFilter == 'bolas' 
                      ]);

                    }, 
                    child: textoDosis('Ver por Listero', 18)),

                  (typeFilter == 'fcpos')
                    ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: ListView.builder(
                        itemCount: listByNumplay.length,
                        itemBuilder: (context, index) {
                          final color = (index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50];
                          return Container(
                            padding: const EdgeInsets.only(top: 10),
                            color: color,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      (listByNumplay[index].numplay.contains('c'))
                                        ? textoDosis('${
                                          listByNumplay[index].numplay.split('c')[1]
                                        } en corrido', 22)
                                        : textoDosis(listByNumplay[index].numplay.toString(), 22),
                                      textoDosis(' -> ${listByNumplay[index].dinero}', 
                                          20, fontWeight: FontWeight.bold),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                    : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: ListView.builder(
                        itemCount: aux.length,
                        itemBuilder: (context, index) {
                          final color = (index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50];
                          return Container(
                            padding: const EdgeInsets.only(top: 10),
                            color: color,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                textoDosis('Lista: ${aux[index].owner}', 20, fontWeight: FontWeight.bold),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: fila(
                                    type: aux[index].play,
                                      data: aux[index].element!,
                                      color: color!),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          );
        });
  }

  Widget fila( {required dynamic type, required ElementData data, required Color color}) {

    String jsonString = json.encode(data.toJson());
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    final widgetMap = {
      'bola': (data) => FijosCorridosListaWidget(
          fijoCorrido: FijoCorridoModel.fromJson(jsonMap), color: color, canEdit: false),
      'parle': (data) =>
          ParlesListaWidget(parles: ParlesModel.fromJson(jsonMap), color: color, canEdit: false),
      'centena': (data) => CentenasListaWidget(
          centenas: CentenasModel.fromJson(jsonMap), color: color, canEdit: false),
      'candado': (data) =>
          CandadoListaWidget(candado: CandadoModel.fromJson(jsonMap), color: color, canEdit: false),
      'terminal': (data) => TerminalListaWidget(
          terminal: TerminalModel.fromJson(jsonMap), color: color, canEdit: false),
      'posicion': (data) => PosicionlListaWidget(
          posicion: PosicionModel.fromJson(jsonMap), color: color, canEdit: false),
      'decena': (data) =>
          DecenaListaWidget(numplay: DecenaModel.fromJson(jsonMap), color: color, canEdit: false),
      'million': (data) =>
          MillionListaWidget(numplay: MillionModel.fromJson(jsonMap), color: color, canEdit: false),
    };

    final widgetBuilder = widgetMap[type];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }

  List<List<int>> combinaciones(List<dynamic> array) {
    List<List<int>> resultado = [];

    for (int i = 0; i < array.length - 1; i++) {
      for (int j = i + 1; j < array.length; j++) {
        resultado.add([
          (array[i].runtimeType == String) ? int.parse(array[i]) : array[i],
        (array[j].runtimeType == String) ? int.parse(array[j]) : array[j]]);
      }
    }
  
    return resultado;
  }

  bool listContainsList(List<List<int>> listOfLists, List<dynamic> target) {
    return 
      listOfLists.any((list) => list.equals(target)) || 
      listOfLists.any((list) => list.equals(target.reversed.toList()));
  }

}

class ByNumplay {
  final String numplay;
  final int dinero;

  ByNumplay({required this.numplay, required this.dinero});
}