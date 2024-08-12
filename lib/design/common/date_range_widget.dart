import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:intl/intl.dart';

class InitialDateSelect extends ConsumerStatefulWidget {
  const InitialDateSelect({super.key, this.showDate = true});

  final bool showDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitialDateSelectState();
}

class _InitialDateSelectState extends ConsumerState<InitialDateSelect> {
  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(dateRangeR);
    final janddateM = ref.read(dateRangeR.notifier);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textoDosis('Inicio:', 20, fontWeight: FontWeight.bold),
              Flexible(
                child: Container(
                    height: 40,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                    child: textoDosis(janddate.initialDate, 20)),
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
                        janddateM.setInitialDate(formattedDate);
                      }
                    }),
              )
            ],
          ),
        )
      ],
    );
  }
}

class EndDateSelect extends ConsumerStatefulWidget {
  const EndDateSelect({super.key, this.showDate = true});

  final bool showDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EndDateSelectState();
}

class _EndDateSelectState extends ConsumerState<EndDateSelect> {
  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(dateRangeR);
    final janddateM = ref.read(dateRangeR.notifier);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textoDosis('Fin:', 20, fontWeight: FontWeight.bold),
              Flexible(
                child: Container(
                    height: 40,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(10)),
                    child: textoDosis(janddate.endDate, 20)),
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
                        janddateM.setEndDate(formattedDate);
                      }
                    }),
              )
            ],
          ),
        )
      ],
    );
  }
}
