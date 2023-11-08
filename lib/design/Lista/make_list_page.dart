import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/enums/main_list_enum.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Lista/fijos_corridos_container.dart';
import 'package:frontend_loreal/design/Lista/parles_container.dart';

import 'centenas_container.dart';

class MakeList extends ConsumerStatefulWidget {
  const MakeList({
    super.key,
    required this.fijo,
    required this.corrido,
    required this.parle,
    required this.centena,
  });

  final String fijo;
  final String corrido;
  final String parle;
  final String centena;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MakeListState();
}

class _MakeListState extends ConsumerState<MakeList> {
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {

            bool emtyList = listado.values.every((element) => element.isEmpty);
            
            return AlertDialog(
              title: ( emtyList ) 
                ? textoDosis('No ingresó jugadas a la lista. Desea salir igualmente?', 18, maxLines: 2) 
                : textoDosis('La lista será guardada.', 18),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {

                    if ( !emtyList ){
                      final toJoinListM = ref.read(toJoinListR.notifier);

                      toJoinListM.addCurrentList(
                          key: ListaGeneralEnum.principales, data: listado);

                      Navigator.pop(context, true);
                    }
                    
                    Navigator.pop(context, true);

                  },
                  child: ( emtyList ) 
                    ? const Text('Sí, deseo salir!')
                    : const Text('Entiendo'),
                ),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: textoDosis(
                'Limpio: ${ref.watch(paymentCrtl).limpioListero.round()}', 24,
                color: Colors.white),
            actions: [
              IconButton(
                  icon: const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                  ),
                  onPressed: (() {
                    final toJoinListM = ref.read(toJoinListR.notifier);

                    toJoinListM.addCurrentList(
                        key: ListaGeneralEnum.principales, data: listado);

                    Navigator.pop(context);
                    return;
                  }))
            ]),
        body: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Flexible(
                    child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FijosCorridosWidget(
                          fijo: widget.fijo,
                          corrido: widget.corrido,
                          listaFijoCorrido:
                              listado[MainListEnum.fijoCorrido.toString()]!
                                  .cast()),
                      ParlesWidget(
                        parle: widget.parle,
                        listaParles:
                            listado[MainListEnum.parles.toString()]!.cast(),
                      ),
                      CentenasWidget(
                        centena: widget.centena,
                        listaCentenas:
                            listado[MainListEnum.centenas.toString()]!.cast(),
                      ),
                    ],
                  ),
                ))
              ],
            )),
      ),
    );
  }
}
