import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils/to_edit_list.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/Lista_Posicion/posicion_model.dart';

class PosicionlListaWidget extends ConsumerStatefulWidget {
  const PosicionlListaWidget({
    super.key,
    required this.posicion,
    required this.color,
    this.canEdit = false,
  });

  final PosicionModel posicion;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PosicionlListaWidgetState();
}

class _PosicionlListaWidgetState extends ConsumerState<PosicionlListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.posicion.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int sum = widget.posicion.fijo +
        widget.posicion.corrido +
        widget.posicion.corrido2;

    const size = 25.0;
    const margin = 3.0;

    return Row(
      children: [
        Expanded(
            child: GestureDetector(
            onLongPress: () {
              final toJoinListM = ref.read(toJoinListR.notifier);
              final payCrtl = ref.watch(paymentCrtl.notifier);
              final getLimit = ref.watch(globalLimits);

              listadoPosicion.values.first.removeWhere((element)
                  => element['uuid'] == widget.posicion.uuid);

              toJoinListM.addCurrentList(
                key: ListaGeneralEnum.posicion, data: listadoPosicion);
              
              int limpioListero =
                  (sum * (getLimit.porcientoBolaListero / 100)).toInt();

              payCrtl.restaTotalBruto80 = sum;
              payCrtl.restaLimpioListero = limpioListero;

              showToast('La jugada fue eliminada exitosamente');
            },
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.posicion.uuid);
              setState(() {
                isInList = !isInList;
              });
              return;
            }
          },
          child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ListTile(
                  title: boldLabel('Posición: ',
                      widget.posicion.numplay.toString().padLeft(2, '0'), size),
                  subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                    textoDosis('Fijo: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.posicion.fijo.toString(),
                        margin: margin,
                        color: widget.color,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    textoDosis('Corridos: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.posicion.corrido.toString(),
                        margin: margin,
                        color: widget.color,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 5),
                    NumeroRedondoWidget(
                        numero: widget.posicion.corrido2.toString(),
                        margin: margin,
                        color: widget.color,
                        fontWeight: FontWeight.bold)
                  ]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          textoDosis('\$$sum', 16, fontWeight: FontWeight.bold),
                          textoDosis('\$${widget.posicion.dinero}', 16,
                              color: Colors.red[400])
                        ],
                      ),
                      (isInList)
                          ? Container(
                              margin: const EdgeInsets.only(left: 10),
                              child:
                                  const Icon(Icons.check, color: Colors.black),
                            )
                          : Container()
                    ],
                  ))),
        ))
      ],
    );
  }
}
