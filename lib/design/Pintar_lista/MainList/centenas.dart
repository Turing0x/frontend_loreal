import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils/to_edit_list.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista_Main/centenas/centenas_model.dart';

import '../../../config/enums/lista_general_enum.dart';
import '../../../config/enums/main_list_enum.dart';

class CentenasListaWidget extends ConsumerStatefulWidget {
  const CentenasListaWidget({
    super.key,
    required this.centenas,
    required this.color,
    this.canEdit = false,
  });

  final CentenasModel centenas;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CentenasListaWidgetState();
}

class _CentenasListaWidgetState extends ConsumerState<CentenasListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.centenas.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

                listado[MainListEnum.centenas.toString()]!
                  .removeWhere((element) => element.uuid == widget.centenas.uuid);

                toJoinListM.addCurrentList(
                  key: ListaGeneralEnum.principales, data: listado);

                payCrtl.restaTotalBruto70 = widget.centenas.fijo;
                payCrtl.restaLimpioListero =
                    (widget.centenas.fijo * (getLimit.porcientoParleListero / 100))
                        .toInt();

                showToast('La jugada fue eliminada exitosamente');
              }
            },
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.centenas);
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
                      'Centena: ', widget.centenas.numplay.toString(), size),
                  subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                    textoDosis('Apuesta: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.centenas.fijo.toString(),
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
                          textoDosis('\$${widget.centenas.fijo}', 16,
                              fontWeight: FontWeight.bold),
                          textoDosis('\$${widget.centenas.dinero}', 16,
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
