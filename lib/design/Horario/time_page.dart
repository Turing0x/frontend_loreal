import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/time_controller.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/models/Horario/time_model.dart';
import 'package:intl/intl.dart';

final timeControllers = TimeControllers();
class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => TimePageState();
}

class TimePageState extends State<TimePage> {
  TimeOfDay dayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay dayEnd = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay nigthStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay nigthEnd = const TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    Future<List<Time>> times = timeControllers.getDataTime();
    times.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          dayStart = stringToTimeOfDay(value[0].dayStart);
          dayEnd = stringToTimeOfDay(value[0].dayEnd);
          nigthStart = stringToTimeOfDay(value[0].nightStart);
          nigthEnd = stringToTimeOfDay(value[0].nightEnd);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Horario del sistema'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            encabezado(
                context, 'Establece horarios de trabajo', false, () {}, false),
            dinamicGroupBox(
                'Jornada del día', [dayStarttimePicker(), dayEndtimePicker()]),
            dinamicGroupBox('Jornada de la noche',
                [nigthStarttimePicker(), nigthEndtimePicker()]),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    elevation: 2,
                  ),
                  child: textoDosis('Guardar cambios', 20, color: Colors.white),
                  onPressed: () => timeControllers.saveDataTime(
                      dayStart.format(context),
                      dayEnd.format(context),
                      nigthStart.format(context),
                      nigthEnd.format(context))),
            ),
          ],
        ),
      ),
    );
  }

  Container dayStarttimePicker() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textoDosis('Inicio: ', 20, fontWeight: FontWeight.bold),
          Flexible(
            child: Container(
              height: 40,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: textoDosis(dayStart.format(context), 20),
            ),
          ),
          Flexible(
            child: OutlinedButton(
                child: textoDosis('Cambiar', 16),
                onPressed: () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 00, minute: 00),
                  );
                  if (newTime != null) {
                    setState(() {
                      dayStart = newTime;
                    });
                  }
                }),
          )
        ],
      ),
    );
  }

  Container dayEndtimePicker() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textoDosis('Cierre: ', 20, fontWeight: FontWeight.bold),
          Flexible(
            child: Container(
              height: 40,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: textoDosis(dayEnd.format(context), 20),
            ),
          ),
          Flexible(
            child: OutlinedButton(
                child: textoDosis('Cambiar', 16),
                onPressed: () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 00, minute: 00),
                  );
                  if (newTime != null) {
                    setState(() {
                      dayEnd = newTime;
                    });
                  }
                }),
          )
        ],
      ),
    );
  }

  Container nigthStarttimePicker() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textoDosis('Inicio: ', 20, fontWeight: FontWeight.bold),
          Flexible(
            child: Container(
              height: 40,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: textoDosis(nigthStart.format(context), 20),
            ),
          ),
          Flexible(
            child: OutlinedButton(
                child: textoDosis('Cambiar', 16),
                onPressed: () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 00, minute: 00),
                  );
                  if (newTime != null) {
                    setState(() {
                      nigthStart = newTime;
                    });
                  }
                }),
          )
        ],
      ),
    );
  }

  Container nigthEndtimePicker() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textoDosis('Cierre: ', 20, fontWeight: FontWeight.bold),
          Flexible(
            child: Container(
              height: 40,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: textoDosis(nigthEnd.format(context), 20),
            ),
          ),
          Flexible(
            child: OutlinedButton(
                child: textoDosis('Cambiar', 16),
                onPressed: () async {
                  final TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 00, minute: 00),
                  );
                  if (newTime != null) {
                    setState(() {
                      nigthEnd = newTime;
                    });
                  }
                }),
          )
        ],
      ),
    );
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final format = DateFormat.Hm();
    return TimeOfDay.fromDateTime(format.parse(time));
  }
}
