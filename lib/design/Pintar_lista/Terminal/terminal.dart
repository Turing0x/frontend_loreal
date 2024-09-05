import 'package:flutter/material.dart';
import 'package:safe_chat/config/riverpod/declarations.dart';
import 'package:safe_chat/config/utils/glogal_map.dart';
import 'package:safe_chat/config/utils/to_edit_list.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/common/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_chat/models/Lista_Terminal/terminal_model.dart';

import '../../../config/enums/lista_general_enum.dart';

class TerminalListaWidget extends ConsumerStatefulWidget {
  const TerminalListaWidget({
    super.key,
    required this.terminal,
    required this.color,
    this.canEdit = false,
  });

  final TerminalModel terminal;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TerminalListaWidgetState();
}

class _TerminalListaWidgetState extends ConsumerState<TerminalListaWidget> {
  bool isInList = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theList1 = ref.watch(toEditAList.notifier);
      setState(() {
        isInList = theList1.state.contains(widget.terminal.uuid);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int sum = (widget.terminal.fijo + widget.terminal.corrido) * 10;

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

              listadoTerminal.values.first.removeWhere(
                  (element) => element['uuid'] == widget.terminal.uuid);

              toJoinListM.addCurrentList(
                  key: ListaGeneralEnum.terminal, data: listadoTerminal);

              payCrtl.restaTotalBruto80 = sum;
              payCrtl.restaLimpioListero =
                  (sum * (getLimit.porcientoBolaListero / 100)).toInt();

              showToast(context, 'La jugada fue eliminada exitosamente');
            }
          },
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.terminal);
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
                      'Terminal: ', widget.terminal.terminal.toString(), size),
                  subtitle: Row(mainAxisSize: MainAxisSize.min, children: [
                    textoDosis('Fijo: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.terminal.fijo.toString(),
                        margin: margin,
                        color: widget.color,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 10),
                    textoDosis('Corrido: ', 20),
                    NumeroRedondoWidget(
                        numero: widget.terminal.corrido.toString(),
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
                          textoDosis('\$${widget.terminal.dinero}', 16,
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
