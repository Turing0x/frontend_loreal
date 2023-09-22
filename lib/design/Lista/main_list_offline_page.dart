import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils/file_manager.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Lista/candado.dart';
import 'package:frontend_loreal/design/Lista/decena.dart';
import 'package:frontend_loreal/design/Lista/full_million.dart';
import 'package:frontend_loreal/design/Lista/posicion.dart';
import 'package:frontend_loreal/design/Lista/terminales.dart';
import 'package:frontend_loreal/design/Listero/main_listero_page.dart';
import 'package:frontend_loreal/design/common/popup_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_upgrade/r_upgrade.dart';

class MainMakeListOffline extends ConsumerStatefulWidget {
  const MainMakeListOffline({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainMakeListOfflineState();
}

class _MainMakeListOfflineState extends ConsumerState<MainMakeListOffline> {
  TextEditingController apuesta = TextEditingController();
  String username = '';

  @override
  void initState() {
    RUpgrade.stream.listen((DownloadInfo info) {
      ref.read(release.notifier).actualizarState(
            info: info,
          );
    });

    LocalStorage.getUsername().then((value) {
      if (value!.isNotEmpty) {
        username = value;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      toGetAllLimits();
    });

    getsavePdfFolder().then((value) async {
      if (value != jornalGlobal) {
        await deleteAllFiles();
        return;
      }

      await readAllFilesAndSaveInMaps();
    });

    super.initState();
  }

  String getCorrido = '';
  String getCentena = '';
  String getParle = '';
  String getFijo = '';

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
              ? () async {
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
              : null,
        ),
        PopupWidget(username: username, offline: true),
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

  Row rowArriba() {
    final layoutModelM = ref.read(currentPage.notifier);
    final toBlockAnyBtn = ref.read(toBlockAnyBtnR);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AbsorbPointer(
          absorbing: toBlockAnyBtn.blockStateMain,
          child: btnDynamic(
              const Icon(Icons.auto_awesome_mosaic_outlined,
                  color: Colors.black),
              'Principales',
              (() => Navigator.pushNamed(context, 'make_list', arguments: [
                    getFijo,
                    getCorrido,
                    getParle,
                    getCentena,
                  ]))),
        ),
        btnDynamic(const Icon(Icons.lock_outlined, color: Colors.black),
            'Candado', () => layoutModelM.state = const CandadoWidget()),
        btnDynamic(
            const Icon(Icons.two_k_outlined, color: Colors.black),
            'Raspaito',
            (() =>
                layoutModelM.state = const FullMillionWidget(offline: true))),
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

  toGetAllLimits() async {
    final setLimits = ref.watch(globalLimits);

    final corrido = await storage.read(key: 'corrido');
    final centena = await storage.read(key: 'centena');
    final parle = await storage.read(key: 'parle');
    final fijo = await storage.read(key: 'fijo');
    final porcientoParleListero =
        await storage.read(key: 'porcientoParleListero');
    final porcientoBolaListero =
        await storage.read(key: 'porcientoBolaListero');

    setState(() {
      getCorrido = corrido ?? '500';
      getCentena = centena ?? '500';
      getParle = parle ?? '500';
      getFijo = fijo ?? '500';
    });

    setLimits.porcientoBolaListero = int.parse(porcientoParleListero!);
    setLimits.porcientoParleListero = int.parse(porcientoBolaListero!);
  }
}
