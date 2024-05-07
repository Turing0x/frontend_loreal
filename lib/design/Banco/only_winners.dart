import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

              List<OnlyWinner> list = snapshot.data!['data'];
              String lot = snapshot.data!['lotOfToday'];
              lotThisDay = lot;

              list.sort(((a, b) {
                return b.element!.dinero! - a.element!.dinero!;
              }));

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
                aux = list.where((play) => play.play == 'pos' || play.play == 'centena').toList();
              }

              return Column(
                children: [
                  boldLabel('Sorteo del momento -> ', lot, 23),

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
                        groupedByOwner
                      ]);

                    }, 
                    child: textoDosis('Ver por Listero', 18)),

                  SizedBox(
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
}
