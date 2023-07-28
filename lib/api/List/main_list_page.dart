import 'package:frontend_loreal/api/List/domain/join_list.dart';
import 'package:frontend_loreal/api/List/widgets/full_million.dart';
import 'package:frontend_loreal/api/List/widgets/terminales.dart';
import 'package:frontend_loreal/api/List/widgets/posicion.dart';
import 'package:frontend_loreal/api/List/widgets/candado.dart';
import 'package:frontend_loreal/api/List/widgets/decena.dart';
import 'package:frontend_loreal/utils/file_manager.dart';
import 'package:frontend_loreal/utils/glogal_map.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/widgets/popup_widget.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_upgrade/r_upgrade.dart';

class MainMakeList extends ConsumerStatefulWidget {
  const MainMakeList({super.key, required this.username});

  final String username;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainMakeListState();
}

class _MainMakeListState extends ConsumerState<MainMakeList> {
  TextEditingController apuesta = TextEditingController();

  @override
  void initState() {
    RUpgrade.stream.listen((DownloadInfo info) {
      ref.read(release.notifier).actualizarState(
            info: info,
          );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final toJoinList = ref.watch(toJoinListR);
    final toJoinListM = ref.read(toJoinListR.notifier);
    final layoutModel = ref.watch(currentPage);

    return Scaffold(
      appBar: showAppBar('Creación de listas', actions: [
        IconButton(
          icon: const Icon(Icons.cleaning_services_outlined),
          onPressed: toJoinList.currentList.isNotEmpty
              ? () => clearData(toJoinListM)
              : null,
        ),
        PopupWidget(
          username: widget.username,
        ),
      ]),
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

    showToast('Lista vaciada', type: true);
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
