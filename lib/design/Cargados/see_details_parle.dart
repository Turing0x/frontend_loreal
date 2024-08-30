import 'package:flutter/material.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/encabezado.dart';
import 'package:sticker_maker/models/Cargados/cargados_model.dart';

import '../../config/controllers/limits_controller.dart';
import '../../config/globals/variables.dart';

class SeeDetailsParlesCargados extends StatefulWidget {
  const SeeDetailsParlesCargados({
    super.key,
    required this.bola,
    required this.fijo,
    required this.listeros,
    required this.jornal,
  });

  final String bola;
  final String fijo;
  final List<Listero> listeros;
  final String jornal;

  @override
  State<SeeDetailsParlesCargados> createState() =>
      _SeeDetailsParlesCargadosState();
}

class _SeeDetailsParlesCargadosState extends State<SeeDetailsParlesCargados> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Revisión por listas'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dinamicGroupBox('Detalles del parle', [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boldLabel('Parle: ', widget.bola.replaceAll(',', ' -- '), 30),
                  const SizedBox(width: 20),
                  boldLabel('Total: ', widget.fijo, 20)
                ],
              ),
            ]),
            encabezado(context, 'Listas donde aparece', !withLot, () async {
              final ctrl = LimitsControllers();
              await ctrl.saveDataLimitsPerleToUserCargados(
                  widget.bola, widget.jornal);
            },
                btnIcon: Icons.label_important_outline_sharp,
                btnText: 'Limitar',
                false),
            SizedBox(
              width: double.infinity,
              height: 700,
              child: ListView.builder(
                  itemCount: widget.listeros.length,
                  itemBuilder: (context, index) {
                    widget.listeros.sort((a, b) => b.fijo - a.fijo);

                    String username =
                        widget.listeros[index].username.toString();
                    String total = widget.listeros[index].fijo.toString();

                    return ExpansionTile(
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textoDosis(' $username ', 23,
                                fontWeight: FontWeight.bold),
                            textoDosis(' -> $total ', 23,
                                fontWeight: FontWeight.bold),
                          ]),
                      trailing: (!withLot)
                          ? OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side:
                                      const BorderSide(color: Colors.black26)),
                              child: textoDosis('Limitar', 16),
                              onPressed: () async {
                                final ctrl = LimitsControllers();
                                await ctrl
                                    .saveDataLimitsParleToUserCargadosListero(
                                        username, widget.bola, widget.jornal);
                              })
                          : Icon(customTileExpanded
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down),
                      onExpansionChanged: (bool expanded) {
                        setState(() => customTileExpanded = expanded);
                      },
                      children: widget.listeros[index].separados.map((value) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                textoDosis('${value.fijo} ', 20),
                                textoDosis(' -> ${value.fijo} ', 20,
                                    fontWeight: FontWeight.bold),
                              ]),
                        );
                      }).toList(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
