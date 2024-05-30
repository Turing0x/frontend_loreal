import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';

import '../../config/globals/variables.dart';

class SeeDetailsBolasCargadas extends StatefulWidget {
  const SeeDetailsBolasCargadas({
    super.key,
    required this.bola,
    required this.total,
    required this.totalCorrido,
    required this.listeros, 
    required this.jugada,
    required this.jornal
  });

  final String bola;
  final String total;
  final String totalCorrido;
  final List<Listero> listeros;
  final String jugada;
  final String jornal;

  @override
  State<SeeDetailsBolasCargadas> createState() =>
      _SeeDetailsBolasCargadasState();
}

class _SeeDetailsBolasCargadasState extends State<SeeDetailsBolasCargadas> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {

    (widget.jugada == 'corrido')
      ? (widget.listeros.sort((a, b) => b.corrido! - a.corrido!))
      : (widget.listeros.sort((a, b) => b.total - a.total));

    return Scaffold(
      appBar: showAppBar('Revisión por listas'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dinamicGroupBox('Detalles de la bola', [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boldLabel('Bola: ', widget.bola, 30),
                  const SizedBox(width: 20),
                  boldLabel('Total: ', (widget.jugada == 'corrido')
                    ? widget.totalCorrido
                    : widget.total, 30)
                  
                ],
              ),
            ]),
            encabezado(
                context, 'Listas donde aparece', 
                false, () async{
                  final ctrl = LimitsControllers();
                  await ctrl.saveDataLimitsBallsToUserCargados(widget.bola, widget.jornal);
                },
                btnIcon: Icons.label_important_outline_sharp,
                btnText: 'Limitar',
                false),
            SizedBox(
              width: double.infinity,
              height: 600,
              child: ListView.builder(
                itemCount: widget.listeros.length,
                itemBuilder: (context, index) {

                  String username =
                      widget.listeros[index].username.toString();
                  String total = (widget.jugada == 'corrido')
                    ? widget.listeros[index].totalCorrido.toString()
                    : widget.listeros[index].total.toString();

                  return (total == '0')
                    ? Container()
                    : detailsWidget(
                      username, 
                      total, 
                      widget.listeros[index].separados);
                }),
            )
          ],
        ),
      ),
    );
  }

  ExpansionTile detailsWidget(String username, String total, List<Separado> list) {

    return ExpansionTile(
      title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textoDosis(' $username ', 23,
                fontWeight: FontWeight.bold),
            textoDosis(' -> $total ', 23,
                fontWeight: FontWeight.bold),
          ]),
      trailing: (globallot.isEmpty)
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black26)
            ),
            child: textoDosis('Limitar', 16),
            onPressed: () async{
              final ctrl = LimitsControllers();
              await ctrl.saveDataLimitsBallsToUserCargadosListero(username, widget.bola, widget.jornal);
            } 
          )
        : Icon(
          customTileExpanded
            ? Icons.arrow_drop_down_circle
            : Icons.arrow_drop_down),
      onExpansionChanged: (bool expanded) {
        setState(() => customTileExpanded = expanded);
      },
      children: list.map((value) {
        if(widget.jugada == 'fijo' || widget.jugada == 'nada' ){
          if (value.fijo != 0) {
            return Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30),
              child: textoDosis(' --> ${value.fijo} ', 20),
            );
          }
        } else {
          if (value.corrido != 0) {
            return Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30),
              child: Column(children: [
                textoDosis(' --> ${value.corrido} ', 20),
                if(value.corrido2 != null)
                  textoDosis(' --> ${value.corrido2} ', 20)
                
              ]),
            );
          }
        }
        
        return Container();
      }).toList(),
    );
  }
}
