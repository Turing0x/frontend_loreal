import 'package:frontend_loreal/api/DrawList/Decena/models/decena_model.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/to_edit_list.dart';

class DecenaListaWidget extends ConsumerStatefulWidget {
  const DecenaListaWidget({
    super.key,
    required this.numplay,
    required this.color,
    this.canEdit = false,
  });

  final DecenaModel numplay;
  final Color color;
  final bool canEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DecenaListaWidgetState();
}

class _DecenaListaWidgetState extends ConsumerState<DecenaListaWidget> {
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
    int sum = (widget.numplay.fijo + widget.numplay.corrido) * 10;

    const size = 25.0;
    const margin = 3.0;
    return Row(
      children: [
        Expanded(
            child: GestureDetector(
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.numplay.uuid);
              setState(() {
                isInList = !isInList;
              });
              return;
            }
            showToast('No puede editar la lista');
          },
          child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ListTile(
                  title: boldLabel(
                      'Decena: ', widget.numplay.numplay.toString(), size),
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
                              color: Colors.red[400]),
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
