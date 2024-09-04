import 'package:flutter/material.dart';
import 'package:sticker_maker/config/controllers/limits_controller.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/encabezado.dart';
import 'package:sticker_maker/models/Cargados/cargados_model.dart';

import '../../config/globals/variables.dart';

class SeeDetailsBolasCargadas extends StatefulWidget {
  const SeeDetailsBolasCargadas(
      {super.key,
      required this.bola,
      required this.fijo,
      required this.listeros,
      required this.jornal});

  final String bola;
  final String fijo;
  final List<Listero> listeros;
  final String jornal;

  @override
  State<SeeDetailsBolasCargadas> createState() =>
      _SeeDetailsBolasCargadasState();
}

class _SeeDetailsBolasCargadasState extends State<SeeDetailsBolasCargadas> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    widget.listeros.sort((a, b) => b.fijo - a.fijo);

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
                  boldLabel('Total: ', widget.fijo, 30)
                ],
              ),
            ]),
            encabezado(context, 'Listas donde aparece', !withLot, () async {
              final ctrl = LimitsControllers();
              await ctrl.saveDataLimitsBallsToUserCargados(
                  widget.bola, widget.jornal);
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
                    String total = widget.listeros[index].fijo.toString();

                    return (total == '0')
                        ? Container()
                        : detailsWidget(
                            username, total, widget.listeros[index].separados);
                  }),
            )
          ],
        ),
      ),
    );
  }

  ExpansionTile detailsWidget(
      String username, String total, List<Separado> list) {
    return ExpansionTile(
      title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        textoDosis(' $username ', 23, fontWeight: FontWeight.bold),
        textoDosis(' -> $total ', 23, fontWeight: FontWeight.bold),
      ]),
      trailing: (!withLot)
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26)),
              child: textoDosis('Limitar', 16),
              onPressed: () async {
                final ctrl = LimitsControllers();
                await ctrl.saveDataLimitsBallsToUserCargadosListero(
                    username, widget.bola, widget.jornal);
              })
          : Icon(customTileExpanded
              ? Icons.arrow_drop_down_circle
              : Icons.arrow_drop_down),
      onExpansionChanged: (bool expanded) {
        setState(() => customTileExpanded = expanded);
      },
      children: list.map((value) {
        return Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 30),
          child: textoDosis(' --> ${value.fijo} ', 20),
        );
      }).toList(),
    );
  }
}
