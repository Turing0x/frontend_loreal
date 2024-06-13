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

              List<ByNumber> listByNumplay = [];
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

                aux = list;

                Map<String, ByNumber> groupedByNumplay = {};
                String fijo = lotThisDay.split(' ')[0].substring(1);
                String c1 = lotThisDay.split(' ')[1];
                String c2 = lotThisDay.split(' ')[2];

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
                      final candado = combinaciones(data.numplay);
                      for(var parle in parlesLot){
                        if(listContainsList(candado, parle)){
                          String parl = parle.toString().replaceAll(RegExp(r'\[|\]'), '');
                          double fijo = data.fijo! / ((data.numplay.length * (data.numplay.length - 1)) / 2);
                          groupManager(groupedByNumplay, parl, data.dinero!, fijo);
                        }
                      }
                    } else if ( winner.play == 'posicion' ){
                      if(data.numplay.toString() == fijo){
                        groupManager(groupedByNumplay, 
                          'p$fijo', data.dinero!, data.fijo!.toDouble());
                      } else if(data.numplay.toString() == c1){
                        groupManager(groupedByNumplay, 
                          'n$c1', data.dinero!, data.corrido!.toDouble());
                      } else if(data.numplay.toString() == c2){
                        groupManager(groupedByNumplay, 
                          'm$c2', data.dinero!, data.corrido2!.toDouble());
                      }
                    } else if (winner.play == 'bola'){

                      if(data.numplay.toString() == fijo){
                        groupManager(groupedByNumplay, 
                          'c${data.numplay.toString()}', 
                          data.corrido! * 25, data.corrido!.toDouble());

                        groupManager(groupedByNumplay, 
                          data.numplay.toString(), data.dinero!, 
                          data.fijo!.toDouble());

                      } else {
                        groupManager(groupedByNumplay, 
                          data.numplay.toString(), data.dinero!, 
                          data.corrido!.toDouble());
                      }
                    } else {
                      if(data.numplay.toString().length == 1){
                        groupManager(groupedByNumplay, 
                          data.numplay.toString(), data.dinero!, 
                          data.fijo!.toDouble(), type: 'd');
                      }
                    }
                  } else {
                    groupManager(groupedByNumplay, 
                      data.terminal.toString(), data.dinero!, 
                      data.fijo!.toDouble(), type: 't');
                  }
                }

                toLess(groupedByNumplay, 'c$fijo', fijo);

                listByNumplay = groupedByNumplay.entries.map((entry) {
                  return ByNumber(
                    numplay: entry.key,
                    fijo: entry.value.fijo,
                    dinero: entry.value.dinero);
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
                    height: MediaQuery.of(context).size.height * 0.58,
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
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ListTile(
                                title: textoDosis( getName(listByNumplay[index].numplay), 22),
                                subtitle: textoDosis('Dinero: ${
                                  listByNumplay[index].fijo.toStringAsFixed(2)
                                  .replaceAll('.00', '')}', 20, 
                                  fontWeight: FontWeight.bold),
                                trailing: textoDosis(listByNumplay[index].dinero.toString(), 
                                  20, fontWeight: FontWeight.bold)))
                          );
                        }),
                  )
                    : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
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

  getName(String numplay) {
    if(numplay.contains('c')){
      return '${numplay.split('c')[1]} en corrido';
    } else if(numplay.contains('p')){
      return '${numplay.split('p')[1]} en 1ra posición';
    } else if(numplay.contains('n')){
      return '${numplay.split('n')[1]} en 2da posición';
    } else if(numplay.contains('m')){
      return '${numplay.split('m')[1]} en 3ra posición';
    } else if(numplay.contains('d')){
      return '${numplay.split('d')[1]} como decena';
    } else if(numplay.contains('t')){
      return '${numplay.split('t')[1]} como terminal';
    }

    return numplay;
  }

  void groupManager( Map<String, ByNumber> map, String key, int dinero, double fijo, {String? type = ''}) {

    String name = (type == 't') ? 't$key' : ( type == 'd') ? 'd$key' : key;

    map.putIfAbsent(name, () => ByNumber(
      numplay: name,
      fijo: 0,
      dinero: 0,
    ));

    map.update(name, (value) => value.copyWith(
      dinero: value.dinero + dinero,
      fijo: value.fijo + fijo,
    ));
  }

  void toLess(Map<String, ByNumber> map, String key, String target) {
    // Verificar si la clave 'key' existe en el mapa
    if (map.containsKey(key)) {
      int dinero = map[key]!.dinero;

      // Asegurar que la clave 'target' está presente en el mapa antes de actualizarla
      map.update(target, (value) => value.copyWith(
        dinero: value.dinero - dinero
      ));
    }
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

class ByNumber {
  final String numplay;
  final double fijo;
  final int dinero;

  ByNumber({
    required this.numplay, 
    required this.fijo, 
    required this.dinero});
    
  ByNumber copyWith({
    String? numplay, 
    double? fijo, 
    int? dinero}){
    return ByNumber(
      numplay: numplay ?? this.numplay, 
      fijo: fijo ?? this.fijo, 
      dinero: dinero ?? this.dinero);
  }
}