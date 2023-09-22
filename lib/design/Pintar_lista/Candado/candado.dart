import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/to_edit_list.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista_Candado/candado_model.dart';

import '../../../config/enums/lista_general_enum.dart';
import '../../../config/utils/glogal_map.dart';

class CandadoListaWidget extends ConsumerStatefulWidget {
  const CandadoListaWidget({
    super.key,
    required this.candado,
    required this.color,
    this.canEdit = false,
  });

  final CandadoModel candado;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CandadoListaWidgetState();
}

class _CandadoListaWidgetState extends ConsumerState<CandadoListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.candado.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> toPrint = widget.candado.numplay
        .map((e) => e.toString().padLeft(2, '0'))
        .toList();

    const size = 25.0;
    const margin = 3.0;
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
            onLongPress: () {
              if (widget.canEdit) {
                final toJoinListM = ref.read(toJoinListR.notifier);
                final payCrtl = ref.watch(paymentCrtl.notifier);
                final getLimit = ref.watch(globalLimits);

                listadoCandado.values.first.removeWhere((element)
                  => element.toString() == widget.candado.toString());

                toJoinListM.addCurrentList(
                  key: ListaGeneralEnum.candado, data: listadoCandado);

                payCrtl.restaTotalBruto70 = widget.candado.fijo;
                payCrtl.restaLimpioListero =
                    (widget.candado.fijo * (getLimit.porcientoParleListero / 100))
                        .toInt();

                showToast('La jugada fue eliminada exitosamente');
              }
            },
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.candado.uuid);
              setState(() {
                isInList = !isInList;
              });
              return;
            }
          },
          child: GestureDetector(
            onTap: () {

              int dineroForEachParle = widget.candado.fijo ~/
                ((toPrint.length * (toPrint.length - 1)) / 2);

              List allCombinations = combinaciones(toPrint);

              showInfoDialog(context, 'Detalles del candado', Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  boldLabel('Dinero por parle: ', dineroForEachParle.toString(), 20),
                  boldLabel('Cantidad de parles: ', allCombinations.length.toString(), 20),
                  const SizedBox(height: 10),

                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                          allCombinations.map((e) => 
                            textoDosis(e.toString()
                              .replaceAll('[', '')
                              .replaceAll(']', ''), 20) ).toList(),
                      ),
                    ),
                  ),

                ],
              ), () { });
              
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ListTile(
                    title: boldLabel(
                        'Candado: ',
                        toPrint
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''),
                        size),
                    subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                      textoDosis('Apuesta: ', 20),
                      NumeroRedondoWidget(
                          numero: widget.candado.fijo.toString(),
                          margin: margin,
                          color: widget.color,
                          fontWeight: FontWeight.bold),
                      const SizedBox(width: 20),
                    ]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            textoDosis('\$${widget.candado.fijo}', 16,
                                fontWeight: FontWeight.bold),
                            textoDosis('\$${widget.candado.dinero}', 16,
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
          ),
        ))
      ],
    );
  }

  List combinaciones(List array) {
    List resultado = [];

    for (int i = 0; i < array.length - 1; i++) {
      for (int j = i + 1; j < array.length; j++) {
        resultado.add([array[i], array[j]]);
      }
    }

    return resultado;
  }
}
