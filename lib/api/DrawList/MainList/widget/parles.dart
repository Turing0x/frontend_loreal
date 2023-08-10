import 'package:frontend_loreal/api/DrawList/MainList/models/parles/parles_model.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/num_redondo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/to_edit_list.dart';

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
          onDoubleTap: () {
            if (widget.canEdit) {
              managerOfElementsOnList(ref, widget.parles.uuid);
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
                      ...widget.parles.numplay.map(
                        (e) => Flexible(
                            child: textoDosis(
                                '${twoDigits(e.toString())} - ', size)),
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
