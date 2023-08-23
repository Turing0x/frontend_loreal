import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';

class SeeDetailsBolasCargadas extends StatefulWidget {
  const SeeDetailsBolasCargadas({
    super.key,
    required this.bola,
    required this.total,
    required this.listeros,
  });

  final String bola;
  final String total;
  final List<Listero> listeros;

  @override
  State<SeeDetailsBolasCargadas> createState() =>
      _SeeDetailsBolasCargadasState();
}

class _SeeDetailsBolasCargadasState extends State<SeeDetailsBolasCargadas> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                  boldLabel('Total: ', widget.total, 30)
                ],
              ),
            ]),
            encabezado(
                context, 'Listas donde aparece', false, () => null, false),
            SizedBox(
              width: double.infinity,
              height: 700,
              child: ListView.builder(
                  itemCount: widget.listeros.length,
                  itemBuilder: (context, index) {
                    widget.listeros.sort((a, b) => b.total - a.total);

                    String username =
                        widget.listeros[index].username.toString();
                    String total = widget.listeros[index].total.toString();

                    widget.listeros[index].separados
                        .sort((a, b) => b.fijo - a.fijo);

                    return ExpansionTile(
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textoDosis(' $username ', 23,
                                fontWeight: FontWeight.bold),
                            textoDosis(' -> $total ', 23,
                                fontWeight: FontWeight.bold),
                          ]),
                      trailing: Icon(
                        customTileExpanded
                            ? Icons.arrow_drop_down_circle
                            : Icons.arrow_drop_down,
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() => customTileExpanded = expanded);
                      },
                      children: widget.listeros[index].separados.map((value) {
                        if (value.fijo != 0) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 30),
                            child: textoDosis(' --> ${value.fijo} ', 20),
                          );
                        }
                        return Container();
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
