import 'package:flutter/material.dart';
import 'package:safe_chat/config/riverpod/declarations.dart';
import 'package:safe_chat/config/utils/file_manager.dart';
import 'package:safe_chat/config/utils/glogal_map.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/Lista/candado.dart';
import 'package:safe_chat/design/Lista/decena.dart';
import 'package:safe_chat/design/Lista/full_million.dart';
import 'package:safe_chat/design/Lista/posicion.dart';
import 'package:safe_chat/design/Lista/terminales.dart';
import 'package:safe_chat/design/common/popup_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_chat/models/Lista/join_list.dart';

class MainMakeList extends ConsumerStatefulWidget {
  const MainMakeList({super.key, required this.username});

  final String username;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainMakeListState();
}

class _MainMakeListState extends ConsumerState<MainMakeList> {
  TextEditingController apuesta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final toJoinList = ref.watch(toJoinListR);
    final toJoinListM = ref.read(toJoinListR.notifier);
    final layoutModel = ref.watch(currentPage);

    return Scaffold(
      appBar: showAppBar('Creación de listas',
          actions: [
            IconButton(
              icon: const Icon(Icons.cleaning_services_outlined),
              onPressed: toJoinList.currentList.isNotEmpty
                  ? () => clearData(toJoinListM)
                  : null,
            ),
            IconButton(
                icon: const Icon(Icons.energy_savings_leaf_outlined),
                onPressed: () => Navigator.pushNamed(context, 'for_now_page')),
            PopupWidget(
              username: widget.username,
            )
          ],
          centerTitle: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dinamicGroupBox('Tipo de jugada', [
              rowArriba(),
              const SizedBox(height: 20),
              rowAbajo(),
            ]),
            SingleChildScrollView(child: layoutModel)
          ],
        ),
      ),
    );
  }

  void clearData(JoinListProvider toJoinListM) async {
    final payCrtl = ref.read(paymentCrtl.notifier);

    toJoinListM.clearList();
    clearAllMaps();

    toBlockIfOutOfLimit.clear();
    toBlockIfOutOfLimitFCPC.clear();
    toBlockIfOutOfLimitTerminal.clear();
    toBlockIfOutOfLimitDecena.clear();

    await readAllFilesAndSaveInMaps();

    payCrtl.limpioAllCalcs();

    showToast(context, 'Lista vaciada', type: true);
  }

  Row rowArriba() {
    final layoutModelM = ref.read(currentPage.notifier);
    final getLimit = ref.watch(globalLimits);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnDynamic(
            const Icon(Icons.auto_awesome_mosaic_outlined, color: Colors.black),
            'Principales',
            (() => Navigator.pushNamed(context, 'make_list', arguments: [
                  getLimit.fijo.toString(),
                  getLimit.corrido.toString(),
                  getLimit.parle.toString(),
                  getLimit.centena.toString(),
                ]))),
        btnDynamic(const Icon(Icons.lock_outlined, color: Colors.black),
            'Candado', () => layoutModelM.state = const CandadoWidget()),
        btnDynamic(const Icon(Icons.two_k_outlined, color: Colors.black),
            'Raspaito', (() => layoutModelM.state = const FullMillionWidget())),
      ],
    );
  }

  Row rowAbajo() {
    final layoutModelM = ref.read(currentPage.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btnDynamic(const Icon(Icons.terminal, color: Colors.black), 'Terminal',
            (() => layoutModelM.state = const TerminalesWidget())),
        btnDynamic(
            const Icon(Icons.thirty_fps_select_outlined, color: Colors.black),
            'Decena',
            (() => layoutModelM.state = const DecenasWidget())),
        btnDynamic(const Icon(Icons.widgets_outlined, color: Colors.black),
            'Posición', (() => layoutModelM.state = const PosicionWidget())),
      ],
    );
  }

  Column btnDynamic(Widget icon, String texto, void Function()? onPressed) {
    return Column(
      children: [
        Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black26)),
            child: IconButton(
              icon: icon,
              onPressed: onPressed,
            )),
        textoDosis(texto, 14)
      ],
    );
  }
}
