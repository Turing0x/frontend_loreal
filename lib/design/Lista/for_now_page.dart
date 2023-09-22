import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/enums/lista_general_enum.dart';
import '../../config/riverpod/declarations.dart';
import '../../config/utils_exports.dart';
import '../../models/Lista_Calcs/calcs_model.dart';
import '../../models/Lista_Candado/candado_model.dart';
import '../../models/Lista_Decena/decena_model.dart';
import '../../models/Lista_Main/centenas/centenas_model.dart';
import '../../models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import '../../models/Lista_Main/parles/parles_model.dart';
import '../../models/Lista_Millon/million_model.dart';
import '../../models/Lista_Posicion/posicion_model.dart';
import '../../models/Lista_Terminal/terminal_model.dart';
import '../Pintar_lista/Candado/candado.dart';
import '../Pintar_lista/Decena/decena.dart';
import '../Pintar_lista/MainList/centenas.dart';
import '../Pintar_lista/MainList/fijos_corridos.dart';
import '../Pintar_lista/MainList/parles.dart';
import '../Pintar_lista/Millon/million.dart';
import '../Pintar_lista/Posicion/posicion.dart';
import '../Pintar_lista/Terminal/terminal.dart';
import '../Pintar_lista/methods.dart';
import '../common/no_data.dart';

class ForNowList extends ConsumerStatefulWidget {
  const ForNowList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForNowListState();
}

class _ForNowListState extends ConsumerState<ForNowList> {
  @override
  Widget build(BuildContext context) {

    final toJoinListM = ref.read(toJoinListR.notifier);

    return Scaffold(
      appBar: showAppBar('Lista hasta el momento'),
      body: SingleChildScrollView(
        child: ( toJoinListM.isEmpty() )
          ? Center(child: noData(context))
          : dataList(),
      ),
    );
  }

  Column dataList() {

    List<dynamic> list = boliList( signList() );
    final calcs = list.last as CalcsModel;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.only( left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              boldLabel( 'B: ', calcs.bruto.toString(), 18 ),
              boldLabel( 'L: ', calcs.limpio.toString(), 18),
            ],
          )),
        divisor,
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.83,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final color = (index % 2 != 0)
                  ? Colors.grey[200]
                  : Colors.grey[50];
              return Container(
                color: color,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15),
                  child: fila(data: list[index], color: color!),
                ),
              );
            }),
        ),
      ],
    );
  }

  Widget fila({required dynamic data, required Color color}) {
    final widgetMap = {
      FijoCorridoModel: (data) => FijosCorridosListaWidget(
            fijoCorrido: data,
            color: color,
            canEdit: true,
          ),
      ParlesModel: (data) => ParlesListaWidget(
            parles: data,
            color: color,
            canEdit: true,
          ),
      CentenasModel: (data) => CentenasListaWidget(
            centenas: data,
            color: color,
            canEdit: true,
          ),
      CandadoModel: (data) => CandadoListaWidget(
            candado: data,
            color: color,
            canEdit: true,
          ),
      TerminalModel: (data) => TerminalListaWidget(
            terminal: data,
            color: color,
            canEdit: true,
          ),
      PosicionModel: (data) => PosicionlListaWidget(
            posicion: data,
            color: color,
            canEdit: true,
          ),
      DecenaModel: (data) => DecenaListaWidget(
            numplay: data,
            color: color,
            canEdit: true,
          ),
      MillionModel: (data) => MillionListaWidget(
        numplay: data, 
        color: color),
    };

    final widgetBuilder = widgetMap[data.runtimeType];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }

  String signList(){

    final toJoinList = ref.watch(toJoinListR);

    final totalBruto80 = ref.watch(paymentCrtl).totalBruto80.toInt();
    final totalBruto70 = ref.watch(paymentCrtl).totalBruto70.toInt();

    final getLimit = ref.watch(globalLimits);

    double double1 = (100 - getLimit.porcientoBolaListero) / 100;
    double double2 = (100 - getLimit.porcientoParleListero) / 100;

    int totalBruto = totalBruto80 + totalBruto70;
    int totalLimpio =
        ((totalBruto80 * double1) + (totalBruto70 * double2)).toInt();
    
    Map<String, int> listado = {};

    final toJoinListM = ref.read(toJoinListR.notifier);

    listado['bruto'] = totalBruto;
    listado['limpio'] = totalLimpio;

    toJoinListM.addCurrentList(
        key: ListaGeneralEnum.calcs, data: listado);

    return _jwt(toJoinList.currentList);
  }

  String _jwt(dynamic lista) => JWT( lista, issuer: '63a8970549e4771a0786abb9' )
    .sign(SecretKey(dotenv.env['SECRETKEY_JWT']!), noIssueAt: true);

}