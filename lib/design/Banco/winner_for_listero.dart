import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Pintar_lista/Candado/candado.dart';
import 'package:frontend_loreal/design/Pintar_lista/Decena/decena.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/centenas.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/fijos_corridos.dart';
import 'package:frontend_loreal/design/Pintar_lista/MainList/parles.dart';
import 'package:frontend_loreal/design/Pintar_lista/Millon/million.dart';
import 'package:frontend_loreal/design/Pintar_lista/Posicion/posicion.dart';
import 'package:frontend_loreal/design/Pintar_lista/Terminal/terminal.dart';
import 'package:frontend_loreal/models/Lista/only_winner.dart';
import 'package:frontend_loreal/models/Lista_Candado/candado_model.dart';
import 'package:frontend_loreal/models/Lista_Decena/decena_model.dart';
import 'package:frontend_loreal/models/Lista_Main/centenas/centenas_model.dart';
import 'package:frontend_loreal/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:frontend_loreal/models/Lista_Main/parles/parles_model.dart';
import 'package:frontend_loreal/models/Lista_Millon/million_model.dart';
import 'package:frontend_loreal/models/Lista_Posicion/posicion_model.dart';
import 'package:frontend_loreal/models/Lista_Terminal/terminal_model.dart';

class WinForListeroPage extends StatefulWidget {
  const WinForListeroPage({super.key, 
    this.pos = false,
    required this.groupedByOwner});

  final Map<String, List<OnlyWinner>> groupedByOwner;
  final bool pos;

  @override
  State<WinForListeroPage> createState() => _WinForListeroPageState();
}

class _WinForListeroPageState extends State<WinForListeroPage> {

  bool customTileExpanded = false;
  Map<String, int> totalMoneyByOwner = {};
  late Map<String, List<OnlyWinner>> insideGroupedByOwner;

  bool change = true;

  @override
  void initState() {
    insideGroupedByOwner = widget.groupedByOwner;
    for (var entry in widget.groupedByOwner.entries) {
      int totalMoney = 0;
      for (var winner in entry.value) {
        totalMoney += winner.element!.dinero!;
      }
      totalMoneyByOwner[entry.key] = totalMoney;
    }

    for (var entry in widget.groupedByOwner.entries) {
      for (var winner in entry.value) {
        if (winner.element != null && winner.element!.numplay != null) {
          String numplayKey = winner.element!.numplay.toString();
          if (!totalMoneyByOwner.containsKey(numplayKey)) {
            totalMoneyByOwner[numplayKey] = 0;
          }

          totalMoneyByOwner[numplayKey] 
            = (totalMoneyByOwner[numplayKey]?? 0) 
              + winner.element!.dinero!;
        
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: showAppBar('Premio por Listero'),
      body: Column(
        children: [
          Visibility(
            visible: widget.pos,
            child: OutlinedButton(onPressed: () {
              if(change){
                changeAggrupation();
              }else {
                setState(() {
                  change = true;
                  insideGroupedByOwner = widget.groupedByOwner;
                });
              }
            },
            child: textoDosis(change ? 'Por Número' : 'Por Listero', 18)),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                itemCount: insideGroupedByOwner.length,
                itemBuilder: (context, index) {
                  return insideGroupedByOwner.entries.map((entry) {
                    String key = entry.key;
                    List<OnlyWinner> value = entry.value;
                    return detailsWidget(key, value);
                  }).toList()[index];
                })
            ),
          )
        ],
      ),
    );
  }

  ExpansionTile detailsWidget(String owner, List<OnlyWinner> data) {
    return ExpansionTile(
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textoDosis(' $owner ', 23,
                fontWeight: FontWeight.bold),
            textoDosis(' -> ${totalMoneyByOwner[owner]} ', 23,
                fontWeight: FontWeight.bold),
          ]),
      trailing: Icon(
        customTileExpanded
          ? Icons.arrow_drop_down_circle
          : Icons.arrow_drop_down),
      onExpansionChanged: (bool expanded) {
        setState(() => customTileExpanded = expanded);
      },
      children: data.map((value) {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: fila(
            type: value.play,
              data: value.element!),
        );
      }).toList(),
    );
  }

  changeAggrupation() {
    Map<String, List<OnlyWinner>> groupedByNumplay = {};

    for (var entry in widget.groupedByOwner.entries) {
      for (var winner in entry.value) {
        if (winner.element!= null && winner.element!.numplay != null) {
          if (!groupedByNumplay.containsKey(winner.element!.numplay.toString())) {
            groupedByNumplay[winner.element!.numplay.toString()] = [];
          }
          groupedByNumplay[winner.element!.numplay.toString()]!.add(winner);
        }
      }
    }

    setState(() {
      insideGroupedByOwner = groupedByNumplay;
    });
    change = false;
  }

  Widget fila( {required dynamic type, required ElementData data}) {

    String jsonString = json.encode(data.toJson());
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    final widgetMap = {
      'bola': (data) => FijosCorridosListaWidget(
          fijoCorrido: FijoCorridoModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'parle': (data) =>
          ParlesListaWidget(parles: ParlesModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'centena': (data) => CentenasListaWidget(
          centenas: CentenasModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'candado': (data) =>
          CandadoListaWidget(candado: CandadoModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'terminal': (data) => TerminalListaWidget(
          terminal: TerminalModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'posicion': (data) => PosicionlListaWidget(
          posicion: PosicionModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'decena': (data) =>
          DecenaListaWidget(numplay: DecenaModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
      'million': (data) =>
          MillionListaWidget(numplay: MillionModel.fromJson(jsonMap), color: Colors.white, canEdit: false),
    };

    final widgetBuilder = widgetMap[type];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }
}
