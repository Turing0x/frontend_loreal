import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class JornadAndDate extends ConsumerStatefulWidget {
  const JornadAndDate({super.key, this.showDate = true});

  final bool showDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JornadAndDateState();
}

class _JornadAndDateState extends ConsumerState<JornadAndDate> {
  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);
    final janddateM = ref.read(janddateR.notifier);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              textoDosis('Jornada:', 20),
              Flexible(
                child: RadioListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: textoDosis('Día', 20),
                  value: 'dia',
                  groupValue: janddate.currentJornada,
                  onChanged: (value) {
                    janddateM.setCurrentJornada(value.toString());
                  },
                ),
              ),
              Flexible(
                child: RadioListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: textoDosis('Noche', 20),
                  value: 'noche',
                  groupValue: janddate.currentJornada,
                  onChanged: (value) {
                    janddateM.setCurrentJornada(value.toString());
                  },
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.showDate,
          child: Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textoDosis('Fecha:', 20, fontWeight: FontWeight.bold),
                Flexible(
                  child: Container(
                      height: 40,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          
                          borderRadius: BorderRadius.circular(10)),
                      child: textoDosis(janddate.currentDate, 20)),
                ),
                Flexible(
                  child: OutlinedButton(
                      child: textoDosis('Cambiar', 16),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat.MMMd().format(pickedDate);
                          janddateM.setCurrentDate(formattedDate);
                        }
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
