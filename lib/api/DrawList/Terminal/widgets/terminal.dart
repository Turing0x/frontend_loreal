import 'package:frontend_loreal/api/DrawList/Terminal/models/terminal_model.dart';
import 'package:frontend_loreal/utils/to_edit_list.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../riverpod/declarations.dart';

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
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.terminal.uuid);
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
