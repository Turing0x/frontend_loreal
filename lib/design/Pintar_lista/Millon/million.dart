import 'package:flutter/material.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/utils/glogal_map.dart';
import 'package:sticker_maker/config/utils/to_edit_list.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/models/Lista_Millon/million_model.dart';

import '../../../config/enums/lista_general_enum.dart';

class MillionListaWidget extends ConsumerStatefulWidget {
  const MillionListaWidget({
    super.key,
    required this.numplay,
    required this.color,
    this.canEdit = false,
  });

  final MillionModel numplay;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MillionListaWidgetState();
}

class _MillionListaWidgetState extends ConsumerState<MillionListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.numplay.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int sum = widget.numplay.fijo + widget.numplay.corrido;

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

            listadoMillon.values.first.removeWhere(
                (element) => element['uuid'] == widget.numplay.uuid);

            toJoinListM.addCurrentList(
                key: ListaGeneralEnum.millon, data: listadoMillon);

            int limpioListero =
                (sum * (getLimit.porcientoBolaListero / 100)).toInt();

            payCrtl.restaTotalBruto80 = sum;
            payCrtl.restaLimpioListero = limpioListero;

            showToast(context, 'La jugada fue eliminada exitosamente');
          },
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.numplay);
              setState(() {
                isInList = !isInList;
              });
              return;
            }
          },
          child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ListTile(
                  title: boldLabel(
                      'Raspaito: ', widget.numplay.numplay.toString(), size),
                  subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                    textoDosis('Fijo: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.numplay.fijo.toString(),
                        margin: margin,
                        color: widget.color,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    textoDosis('Corrido: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.numplay.corrido.toString(),
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
                          textoDosis('\$${widget.numplay.dinero}', 16,
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
