import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/to_edit_list.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista_Main/parles/parles_model.dart';

import '../../../config/enums/lista_general_enum.dart';
import '../../../config/enums/main_list_enum.dart';
import '../../../config/utils/glogal_map.dart';

class ParlesListaWidget extends ConsumerStatefulWidget {
  const ParlesListaWidget({
    super.key,
    required this.parles,
    required this.color,
    this.canEdit = false,
  });
  final ParlesModel parles;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParlesListaWidgetState();
}

class _ParlesListaWidgetState extends ConsumerState<ParlesListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.parles.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(String n) => n.toString().padLeft(2, '0');
    const size = 25.0;

    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onLongPress: () {
            if (widget.canEdit) {
              final toJoinListM = ref.read(toJoinListR.notifier);
              final payCrtl = ref.watch(paymentCrtl.notifier);
              final getLimit = ref.watch(globalLimits);

              listado[MainListEnum.parles.toString()]!
                  .removeWhere((element) => element.uuid == widget.parles.uuid);

              toJoinListM.addCurrentList(
                  key: ListaGeneralEnum.principales, data: listado);

              payCrtl.restaTotalBruto70 = widget.parles.fijo;
              payCrtl.restaLimpioListero =
                  (widget.parles.fijo * (getLimit.porcientoParleListero / 100))
                      .toInt();

              showToast(context, 'La jugada fue eliminada exitosamente');
            }
          },
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.parles);
              setState(() {
                isInList = !isInList;
              });
              return;
            }
          },
          child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: textoDosis('Parlé: ', size,
                              fontWeight: FontWeight.bold)),
                      ...widget.parles.numplay.join(' -').split(' ').map(
                            (e) => Flexible(
                                child:
                                    textoDosis(twoDigits(e.toString()), size)),
                          ),
                    ],
                  ),
                  subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                    textoDosis('Apuesta: ', 20),
                    NumeroRedondoWidget(
                      numero: widget.parles.fijo.toString(),
                      margin: 3.0,
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          textoDosis('\$${widget.parles.fijo}', 16,
                              fontWeight: FontWeight.bold),
                          textoDosis('\$${widget.parles.dinero}', 16,
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
