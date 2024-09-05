import 'package:flutter/material.dart';
import 'package:safe_chat/config/extensions/string_extensions.dart';
import 'package:safe_chat/config/riverpod/declarations.dart';
import 'package:safe_chat/config/utils/glogal_map.dart';
import 'package:safe_chat/config/utils/to_edit_list.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_chat/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';

import '../../../config/enums/lista_general_enum.dart';
import '../../../config/enums/main_list_enum.dart';

class FijosCorridosListaWidget extends ConsumerStatefulWidget {
  const FijosCorridosListaWidget({
    super.key,
    required this.fijoCorrido,
    required this.color,
    this.canEdit = false,
  });

  final FijoCorridoModel fijoCorrido;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FijosCorridosListaWidgetState();
}

class _FijosCorridosListaWidgetState
    extends ConsumerState<FijosCorridosListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.fijoCorrido.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int sum =
        (widget.fijoCorrido.fijo ?? 0) + (widget.fijoCorrido.corrido ?? 0);

    const size = 25.0;
    const margin = 3.0;
    return Row(children: [
      Expanded(
          child: GestureDetector(
        onLongPress: () {
          final toJoinListM = ref.read(toJoinListR.notifier);
          final payCrtl = ref.watch(paymentCrtl.notifier);
          final getLimit = ref.watch(globalLimits);

          listado[MainListEnum.fijoCorrido.toString()]!.removeWhere(
              (element) => element.uuid == widget.fijoCorrido.uuid);

          toJoinListM.addCurrentList(
              key: ListaGeneralEnum.principales, data: listado);

          int limpioListero =
              (sum * (getLimit.porcientoBolaListero / 100)).toInt();

          payCrtl.restaTotalBruto80 = sum;
          payCrtl.restaLimpioListero = limpioListero;
          showToast(context, 'La jugada fue eliminada exitosamente');
        },
        onDoubleTap: () {
          if (widget.canEdit) {
            managerOfElementsOnList(ref, widget.fijoCorrido);
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
                    'Número: ',
                    widget.fijoCorrido.numplay.toString().rellenarCon00(2),
                    size),
                subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                  textoDosis('Fijo: ', 20),
                  NumeroRedondoWidget(
                      numero: widget.fijoCorrido.fijo.toString(),
                      margin: margin,
                      color: widget.color,
                      fontWeight: FontWeight.bold),
                  const SizedBox(width: 10),
                  textoDosis('Corrido: ', 20),
                  NumeroRedondoWidget(
                      numero: widget.fijoCorrido.corrido.toString(),
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
                        textoDosis('\$${widget.fijoCorrido.dinero}', 16,
                            color: Colors.red[400])
                      ],
                    ),
                    (isInList)
                        ? Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Icon(Icons.check, color: Colors.black),
                          )
                        : Container()
                  ],
                ))),
      ))
    ]);
  }
}
