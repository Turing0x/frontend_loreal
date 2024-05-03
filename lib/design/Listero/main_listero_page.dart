// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/controllers/payments_controller.dart';
import 'package:frontend_loreal/config/controllers/time_controller.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/methods/update_methods.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/server/http/methods.dart';
import 'package:frontend_loreal/config/utils/file_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/opt_list_tile.dart';
import 'package:frontend_loreal/models/Horario/time_model.dart';
import 'package:frontend_loreal/models/Limites/limits_model.dart';
import 'package:frontend_loreal/models/Pagos/payments_model.dart';
import 'package:intl/intl.dart';
import 'package:r_upgrade/r_upgrade.dart';

class MainListeroPage extends ConsumerStatefulWidget {
  const MainListeroPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainListeroPageState();
}

class _MainListeroPageState extends ConsumerState<MainListeroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool didDispose = false;

  String? username = '';
  String? userID = '';
  String yuoAreIn = 'Está desconectado de la red';
  String timeForThat = 'Verifique INTERNET: ';

  Duration duration = const Duration();
  Timer? timer;

  void startTimer(int hours, int minutes, int seconds) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!didDispose) {
        setState(() {
          (hours < 0) ? seconds++ : seconds--;
          duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
        });
        if (duration == Duration.zero) {
          cerrarSesion(context);
          deleteAllFiles();
        }
      }
    });
  }

  @override
  void initState() {
    final timeControllers = TimeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final toJoinListM = ref.read(toJoinListR.notifier);
      final payCrtl = ref.read(paymentCrtl.notifier);

      toJoinListM.clearList();
      payCrtl.limpioAllCalcs();
    });

    permissionStorage().then((value) async {
      if (!value) {
        await permissionStorage();
      }
    });

    LocalStorage.getUserId().then((value) =>
        {getHisLimits(value!), getHisPayments(value), userID = value});

    LocalStorage.getUsername().then((value) {
      setState(() {
        username = value;
        globalUserName = value!;
      });
    });

    Future<List<Time>> times = timeControllers.getDataTime();
    getServerTimes(times);

    getsavePdfFolder().then((value) async {
      if (value != null) {
        if (value != jornalGlobal) {
          await deleteAllFiles();
          return;
        }
      }

      await readAllFilesAndSaveInMaps();
    });

    RUpgrade.stream.listen((DownloadInfo info) {
      ref.read(release.notifier).actualizarState(
            info: info,
          );
    });

    controller = AnimationController(
      vsync: this,
    );

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        controller.reset();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    didDispose = true;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final horas = twoDigits(duration.inHours.remainder(60));
    final minutos = twoDigits(duration.inMinutes.remainder(60));
    final segundos = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: textoDosis('Listero: $username', 24, color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              boxTimerSesion(
                  yuoAreIn, timeForThat, '$horas:$minutos:$segundos'),
              optListTile(
                  Icons.line_style_outlined, 'Formalizar nueva lista', '', () {
                (yuoAreIn.contains('red') || yuoAreIn.contains('fuera'))
                    ? showToast(
                        'Acción bloqueda en este horario. \nInténtelo más tarde')
                    : Navigator.pushNamed(context, 'main_make_list',
                        arguments: [username]);
              }, true),
              optListTile(
                  Icons.line_axis_outlined,
                  'Parámetros actuales',
                  'Ver los parámetros establecidos por el banco',
                  () => Navigator.pushNamed(context, 'see_payments_page'),
                  true),
              optListTile(
                  Icons.numbers_outlined,
                  'Bolas limitadas',
                  'Ver las bolas limitadas para el día actual',
                  () => Navigator.pushNamed(context, 'see_limited_ball',
                      arguments: [userID]),
                  true),
              optListTile(
                  Icons.numbers_outlined,
                  'Parlés limitados',
                  'Ver los parlés limitados para el día actual',
                  () => Navigator.pushNamed(context, 'see_limited_parle',
                      arguments: [userID]),
                  true),
              optListTile(
                  Icons.history_outlined,
                  'Historial de listas',
                  'Ver mis listas enviadas anteriormente',
                  () => Navigator.pushNamed(context, 'lists_history',
                          arguments: [
                            !(yuoAreIn.contains('red') ||
                                yuoAreIn.contains('fuera'))
                          ]),
                  true),
              optListTile(Icons.pending_actions_outlined, 'Listas pendientes',
                  'Listas pendientes a ser enviadas al servidor', () {
                (yuoAreIn.contains('red') || yuoAreIn.contains('fuera'))
                    ? showToast(
                        'Acción bloqueda en este horario. \nInténtelo más tarde')
                    : Navigator.pushNamed(context, 'pending_lists',
                        arguments: [username]);
              }, true),
              optListTile(
                  Icons.sd_storage_outlined,
                  'Almacenamiento interno',
                  'Listas y vales guardados en el teléfono',
                  () =>
                      Navigator.pushNamed(context, 'internal_storage_listero'),
                  true),
              optListTile(
                  Icons.settings_applications_outlined,
                  'Ajustes del sistema',
                  'Configure el compratameinto del sistema ',
                  () => Navigator.pushNamed(context, 'setting_listero_page'),
                  true),
            ],
          ),
        ),
      ),
    );
  }

  Container boxTimerSesion(String where, String forTime, String timer) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            color: (where.contains('red') || where.contains('fuera'))
                ? Colors.red[100]
                : Colors.blue[100],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textoDosis(where, 23),
            const SizedBox(height: 10),
            boldLabel(forTime, timer, 20)
          ],
        ));
  }

  getServerTimes(Future<List<Time>> times) {
    times.then((value) {
      if (value.isEmpty) return;

      var format = DateFormat('HH:mm');
      var format1 = DateFormat.Hm();

      TimeOfDay now = TimeOfDay.now();
      DateTime nowStringify = format.parse('${now.hour}:${now.minute}');

      DateTime day_start = format1.parse(value[0].dayStart);
      DateTime day_end = format1.parse(value[0].dayEnd);
      DateTime night_start = format1.parse(value[0].nightStart);
      DateTime night_end = format1.parse(value[0].nightEnd);

      Duration day_difference_start = nowStringify.difference(day_start);
      Duration day_difference_end = nowStringify.difference(day_end);
      Duration night_difference_start = nowStringify.difference(night_start);
      Duration night_difference_end = nowStringify.difference(night_end);

      bool to_start_day = ((!day_difference_start.isNegative &&
              !day_difference_end.isNegative) ||
          (day_difference_start.isNegative && day_difference_end.isNegative));

      bool on_day_session =
          (!day_difference_start.isNegative && day_difference_end.isNegative);

      bool to_start_nigth =
          (!day_difference_end.isNegative && night_difference_start.isNegative);
      bool on_night_session = (!night_difference_start.isNegative &&
          night_difference_end.isNegative);

      if (on_day_session) {
        setState(() {
          yuoAreIn = 'Sesión de la mañana';
          timeForThat = 'Tiempo para el cierre: ';
        });

        savePdfFolder('dia');

        startTimer(
            day_difference_end.inHours.remainder(60).abs(),
            day_difference_end.inMinutes.remainder(60).abs(),
            day_difference_end.inSeconds.remainder(60).abs());
      } else if (on_night_session) {
        setState(() {
          yuoAreIn = 'Sesión de la tarde';
          timeForThat = 'Tiempo para el cierre: ';
        });

        savePdfFolder('noche');

        startTimer(
            night_difference_end.inHours.remainder(60).abs(),
            night_difference_end.inMinutes.remainder(60).abs(),
            night_difference_end.inSeconds.remainder(60).abs());
      } else if (to_start_nigth) {
        setState(() {
          yuoAreIn = 'Estás fuera de sesión';
          timeForThat = 'Tiempo para comenzar: ';
        });

        startTimer(
            night_difference_start.inHours.remainder(60).abs(),
            night_difference_start.inMinutes.remainder(60).abs(),
            night_difference_start.inSeconds.remainder(60).abs());
      } else if (to_start_day) {
        setState(() {
          yuoAreIn = 'Estás fuera de sesión';
          timeForThat = 'Tiempo para comenzar: ';
        });

        startTimer(
            day_difference_start.inHours.remainder(60).abs(),
            day_difference_start.inMinutes.remainder(60).abs(),
            day_difference_start.inSeconds.remainder(60).abs());
      }
    });
  }

  getHisLimits(String userID) {
    final setLimits = ref.watch(globalLimits);
    final limitsControllers = LimitsControllers();
    Future<List<Limits>> thisUser = limitsControllers.getLimitsOfUser(userID);
    thisUser.then((value) => {
          if (value.isNotEmpty)
            {
              setLimits.corrido = value[0].corrido,
              setLimits.centena = value[0].centena,
              setLimits.parle = value[0].parle,
              setLimits.fijo = value[0].fijo,
              setLimits.limitesmillonFijo = value[0].limitesmillonFijo,
              setLimits.limitesmillonCorrido = value[0].limitesmillonCorrido,
              toSaveAllLimitsOnStorage(value)
            }
        });
  }

  getHisPayments(String userID) {
    final setLimits = ref.watch(globalLimits);
    final paymentsControllers = PaymentsControllers();
    Future<List<Payments>> forPayments = paymentsControllers.getPaymentsOfUser(userID);
    forPayments.then((value) {
      if (value.isNotEmpty) {
        setLimits.porcientoBolaListero = value[0].bolaListero;
        setLimits.porcientoParleListero = value[0].parleListero;
        toSavePorcientosOnStorage(value);
      }
    });
  }

  toSaveAllLimitsOnStorage(List<Limits> value) async {
    const storage = FlutterSecureStorage();
    storage.write(key: 'corrido', value: value[0].corrido.toString());
    storage.write(key: 'centena', value: value[0].centena.toString());
    storage.write(key: 'parle', value: value[0].parle.toString());
    storage.write(key: 'fijo', value: value[0].fijo.toString());
  }

  toSavePorcientosOnStorage(List<Payments> value) async {
    const storage = FlutterSecureStorage();
    storage.write(
        key: 'porcientoParleListero', value: value[0].parleListero.toString());
    storage.write(
        key: 'porcientoBolaListero', value: value[0].bolaListero.toString());
  }
}

void savePdfFolder(String jornada) async {
  const storage = FlutterSecureStorage();
  storage.write(key: 'pdfFolderSave', value: jornada);
}

Future<String?> getsavePdfFolder() async {
  final isAlready = await storage.read(key: 'pdfFolderSave');
  return isAlready;
}
