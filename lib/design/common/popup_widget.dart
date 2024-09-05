import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_loreal/config/controllers/list_controller.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/enums/poput_tipo.dart';
import 'package:frontend_loreal/config/utils/file_manager.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/database/list_table/bd_bloc.dart';

class PopupWidget extends ConsumerWidget {
  const PopupWidget({
    super.key,
    this.icon,
    this.username = '',
    this.offline = false,
  });

  final Icon? icon;
  final bool offline;
  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toJoinList = ref.watch(toJoinListR);

    final totalBruto80 = ref.watch(paymentCrtl).totalBruto80.toInt();
    final totalBruto70 = ref.watch(paymentCrtl).totalBruto70.toInt();

    final getLimit = ref.watch(globalLimits);

    double double1 = (100 - getLimit.porcientoBolaListero) / 100;
    double double2 = (100 - getLimit.porcientoParleListero) / 100;

    int totalBruto = totalBruto80 + totalBruto70;
    int totalLimpio =
        ((totalBruto80 * double1) + (totalBruto70 * double2)).toInt();

    Map<String, int> listado = {};

    return PopupMenuButton<PopupTipo>(
      icon: icon ?? const Icon(Icons.more_vert),
      enabled: toJoinList.currentList.isNotEmpty,
      onSelected: (value) async {
        Map<PopupTipo, void Function()> methods = {
          PopupTipo.toServer: () {
            final toJoinListM = ref.read(toJoinListR.notifier);

            listado['bruto'] = totalBruto;
            listado['limpio'] = totalLimpio;

            toJoinListM.addCurrentList(
                key: ListaGeneralEnum.calcs, data: listado);

            enviarMethod(context, toJoinList.currentList, ref);
            return;
          },
          PopupTipo.toStorage: () {
            final toJoinListM = ref.read(toJoinListR.notifier);

            listado['bruto'] = totalBruto;
            listado['limpio'] = totalLimpio;

            toJoinListM.addCurrentList(
                key: ListaGeneralEnum.calcs, data: listado);

            final jwt = _jwt(toJoinList.currentList);

            saveListOffline(todayGlobal, jornalGlobal, jwt,
                totalBruto.toString(), totalLimpio.toString(), ref, context);

            return;
          },
          PopupTipo.obtenerKey: () {
            final toJoinListM = ref.read(toJoinListR.notifier);

            listado['bruto'] = totalBruto;
            listado['limpio'] = totalLimpio;

            toJoinListM.addCurrentList(
                key: ListaGeneralEnum.calcs, data: listado);

            String signature = _jwt(toJoinList.currentList);

            Map<String, String> infoList = {
              'Responsable': username,
              'Jornal': jornalGlobal,
              'Date': todayGlobal,
              'Bruto': totalBruto.toString(),
              'Limpio': totalLimpio.toString(),
              'Firma': signature,
            };

            obtenerKeyMethod(context, jsonEncode(infoList));
            return;
          }
        };

        final toJoinListM = ref.read(toJoinListR.notifier);
        if (toJoinListM.isEmpty() || totalBruto == 0) {
          showToast(context, 'Lista vacía, no hay información para procesar');
          return;
        }

        methods[value]!.call();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupTipo>>[
        PopupMenuItem(
          value: offline ? PopupTipo.toStorage : PopupTipo.toServer,
          child: textoDosis('Enviar al servidor', 18),
        ),
        PopupMenuItem(
          value: PopupTipo.toStorage,
          child: textoDosis('Guardar en el dispositivo', 18),
        ),
        PopupMenuItem(
          value: PopupTipo.obtenerKey,
          child: textoDosis('Obtener firma', 18),
        ),
      ],
    );
  }

  void enviarMethod(BuildContext context, dynamic lista, WidgetRef ref) async {
    final toJoinListM = ref.read(toJoinListR.notifier);
    final payCrtl = ref.read(paymentCrtl.notifier);
    final listControllers = ListControllers();

    final jwt = _jwt(lista);

    final result =
        await listControllers.saveOneList(todayGlobal, jornalGlobal, jwt);
    if (result) {
      fileManagerWriteGlobal(toBlockIfOutOfLimit);
      fileManagerWriteFCPC(toBlockIfOutOfLimitFCPC);
      fileManagerWriteTerminal(toBlockIfOutOfLimitTerminal);
      fileManagerWriteDecena(toBlockIfOutOfLimitDecena);
      toJoinListM.clearList();
      payCrtl.limpioAllCalcs();

      clearAllMaps();
    }
  }

  saveListOffline(String date, String jornal, String signature, String bruto,
      String limpio, WidgetRef ref, BuildContext context) {
    final toJoinListM = ref.read(toJoinListR.notifier);
    final listasBloc = ListasBloc();
    final payCrtl = ref.read(paymentCrtl.notifier);

    listasBloc.agregarLista(date, jornal, signature, bruto, limpio);

    showToast(context,
        'Lista guardada correctamente en el almacenamiento del celular',
        type: true);

    fileManagerWriteGlobal(toBlockIfOutOfLimit);
    fileManagerWriteFCPC(toBlockIfOutOfLimitFCPC);
    fileManagerWriteTerminal(toBlockIfOutOfLimitTerminal);
    fileManagerWriteDecena(toBlockIfOutOfLimitDecena);

    toJoinListM.clearList();
    payCrtl.limpioAllCalcs();
    clearAllMaps();
  }

  void obtenerKeyMethod(BuildContext context, String lista) {
    final obtenerKey = _jwt(lista);

    mostrarDialogo(
      context,
      title: 'Clave para enviar por SMS',
      titleBoton: 'Aceptar',
      mostrarCancelar: false,
      cerrarAutomatico: false,
      shape: shape(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              textoDosis('Firma encriptada', 14, fontWeight: FontWeight.bold),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.copy, color: Colors.black),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: obtenerKey));
                  })
            ],
          ),
          textoDosis(obtenerKey, 14, maxLines: 4),
        ],
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  String _jwt(dynamic lista) => JWT(
        lista,
        issuer: '63a8970549e4771a0786abb9',
      ).sign(SecretKey(dotenv.env['SECRETKEY_JWT']!), noIssueAt: true);
}
