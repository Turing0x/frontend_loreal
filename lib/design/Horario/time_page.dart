import 'package:flutter/material.dart';
import 'package:safe_chat/config/controllers/time_controller.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/common/encabezado.dart';
import 'package:safe_chat/models/Horario/time_model.dart';
import 'package:intl/intl.dart';

final timeControllers = TimeControllers();

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => TimePageState();
}

class TimePageState extends State<TimePage> {
  String dayStart = '';
  String dayEnd = '';
  String nigthStart = '';
  String nigthEnd = '';

  @override
  void initState() {
    Future<List<Time>> times = timeControllers.getDataTime();
    times.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          dayStart = value[0].dayStart;
          dayEnd = value[0].dayEnd;
          nigthStart = value[0].nightStart;
          nigthEnd = value[0].nightEnd;
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
                padding: 10,
                'Jornada del día',
                [dayStarttimePicker(), dayEndtimePicker()]),
            dinamicGroupBox(
                padding: 10,
                'Jornada de la noche',
                [nigthStarttimePicker(), nigthEndtimePicker()]),
            const SizedBox(height: 20),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      elevation: 2,
                    ),
                    child:
                        textoDosis('Guardar cambios', 20, color: Colors.white),
                    onPressed: () => timeControllers.saveDataTime(
                        dayStart, dayEnd, nigthStart, nigthEnd))),
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: textoDosis(dayStart, 20),
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
                      dayStart = '${newTime.hour}:${newTime.minute}';
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: textoDosis(dayEnd, 20),
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
                      dayEnd = '${newTime.hour}:${newTime.minute}';
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: textoDosis(nigthStart, 20),
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
                      nigthStart = '${newTime.hour}:${newTime.minute}';
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: textoDosis(nigthEnd, 20),
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
                      nigthEnd =
                          '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
                    });
                  }
                }),
          )
        ],
      ),
    );
  }

  String stringToTimeOfDay(String time) {
    var df = DateFormat("H:mm a");
    var dt = df.parse(time);
    return DateFormat('HH:mm').format(dt);
  }
}
