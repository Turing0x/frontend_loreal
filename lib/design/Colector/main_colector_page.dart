import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/time_controller.dart';
import 'package:frontend_loreal/config/methods/update_methods.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/server/http/methods.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/opt_list_tile.dart';
import 'package:frontend_loreal/models/Horario/time_model.dart';
import 'package:intl/intl.dart';

class MainColectorPage extends StatefulWidget {
  const MainColectorPage({super.key});

  @override
  State<MainColectorPage> createState() => _MainColectorPageState();
}

class _MainColectorPageState extends State<MainColectorPage>
    with SingleTickerProviderStateMixin {
  String mainID = '';
  String userName = '';
  String actualRole = '';

  late AnimationController controller;
  bool didDispose = false;

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
        }
      }
    });
  }

  @override
  void initState() {

    final timeControllers = TimeControllers();
    final getID = LocalStorage.getUserId();
    getID.then((value) {
      setState(() {
        mainID = value!;
      });
    });

    LocalStorage.getUsername().then((String? username) {
      setState(() {
        userName = username!;
      });
    });

    LocalStorage.getRole().then((String? username) {
      setState(() {
        actualRole = username!;
      });
    });

    permissionStorage().then((value) async {
      if (!value) {
        await permissionStorage();
      }
    });

    Future<List<Time>> times = timeControllers.getDataTime();
    getServerTimes(times);

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
        appBar: showAppBar('Página principal', actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, 'settings_colector_page'),
          )
        ]),
        body: SingleChildScrollView(
            child: Column(
          children: [
            boxTimerSesion(yuoAreIn, timeForThat, '$horas:$minutos:$segundos'),
            optListTile(
                Icons.list,
                'Control de listas',
                'Visualiza y controla todas las listas en el servidor',
                () => Navigator.pushNamed(context, 'list_control_page',
                    arguments: [userName, mainID]),
                true),
            optListTile(
                Icons.supervisor_account_outlined,
                'Mis usuarios',
                'Control sobre mis usuarios vinculados en el sistema',
                () => {
                      (yuoAreIn.contains('red') || yuoAreIn.contains('fuera'))
                          ? showToast(
                              'Acción bloqueda en este horario. \nInténtelo más tarde')
                          : Navigator.pushNamed(
                              context, 'user_control_page_colector',
                              arguments: [userName, actualRole, mainID])
                    },
                true),
            optListTile(
                Icons.sd_storage_outlined,
                'Almacenamiento interno',
                'Listas y vales guardados en el teléfono',
                () => Navigator.pushNamed(context, 'internal_storage_colector'),
                true),
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
                    arguments: [mainID]),
                true),
            optListTile(
                Icons.numbers_outlined,
                'Parlés limitados',
                'Ver los parlés limitados para el día actual',
                () => Navigator.pushNamed(context, 'see_limited_parle',
                    arguments: [mainID]),
                true)
          ],
        )));
  }

  Container boxTimerSesion(String where, String forTime, String timer) {
    return Container(
        margin: const EdgeInsets.all(20),
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

      DateTime dayStart = format1.parse(value[0].dayStart);
      DateTime dayEnd = format1.parse(value[0].dayEnd);
      DateTime nightStart = format1.parse(value[0].nightStart);
      DateTime nightEnd = format1.parse(value[0].nightEnd);

      Duration dayDifferenceStart = nowStringify.difference(dayStart);
      Duration dayDifferenceEnd = nowStringify.difference(dayEnd);
      Duration nightDifferenceStart = nowStringify.difference(nightStart);
      Duration nightDifferenceEnd = nowStringify.difference(nightEnd);

      bool toStartDay =
          ((!dayDifferenceStart.isNegative && !dayDifferenceEnd.isNegative) ||
              (dayDifferenceStart.isNegative && dayDifferenceEnd.isNegative));

      bool onDaySession =
          (!dayDifferenceStart.isNegative && dayDifferenceEnd.isNegative);

      bool toStartNigth =
          (!dayDifferenceEnd.isNegative && nightDifferenceStart.isNegative);
      bool onNightSession =
          (!nightDifferenceStart.isNegative && nightDifferenceEnd.isNegative);

      if (onDaySession) {
        setState(() {
          yuoAreIn = 'Sesión de la mañana';
          timeForThat = 'Tiempo para el cierre: ';
        });

        startTimer(
            dayDifferenceEnd.inHours.remainder(60).abs(),
            dayDifferenceEnd.inMinutes.remainder(60).abs(),
            dayDifferenceEnd.inSeconds.remainder(60).abs());
      } else if (onNightSession) {
        setState(() {
          yuoAreIn = 'Sesión de la tarde';
          timeForThat = 'Tiempo para el cierre: ';
        });

        startTimer(
            nightDifferenceEnd.inHours.remainder(60).abs(),
            nightDifferenceEnd.inMinutes.remainder(60).abs(),
            nightDifferenceEnd.inSeconds.remainder(60).abs());
      } else if (toStartNigth) {
        setState(() {
          yuoAreIn = 'Estás fuera de sesión';
          timeForThat = 'Tiempo para comenzar: ';
        });

        startTimer(
            nightDifferenceStart.inHours.remainder(60).abs(),
            nightDifferenceStart.inMinutes.remainder(60).abs(),
            nightDifferenceStart.inSeconds.remainder(60).abs());
      } else if (toStartDay) {
        setState(() {
          yuoAreIn = 'Estás fuera de sesión';
          timeForThat = 'Tiempo para comenzar: ';
        });

        startTimer(
            dayDifferenceStart.inHours.remainder(60).abs(),
            dayDifferenceStart.inMinutes.remainder(60).abs(),
            dayDifferenceStart.inSeconds.remainder(60).abs());
      }
    });
  }
}
