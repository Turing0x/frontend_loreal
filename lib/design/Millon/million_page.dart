import 'package:flutter/material.dart';
import 'package:safe_chat/config/controllers/sorteo_controller.dart';
import 'package:safe_chat/config/riverpod/declarations.dart';
import 'package:safe_chat/config/riverpod/get_all_million_provider.dart';
import 'package:safe_chat/config/riverpod/observar_million_provider.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:safe_chat/design/Fecha_Jornada/jornal_and_date_bloc.dart';
import 'package:safe_chat/design/common/no_data.dart';
import 'package:safe_chat/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String lotThisDay = '';

class MillionGamePage extends ConsumerStatefulWidget {
  const MillionGamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MillionGamePageState();
}

class _MillionGamePageState extends ConsumerState<MillionGamePage> {
  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);
    return Scaffold(
      appBar: showAppBar('Jugada Raspaito'),
      body: Column(
        children: [
          const JornadAndDate(),
          const Divider(color: Colors.black, indent: 20, endIndent: 20),
          searchLot(),
          const SizedBox(height: 10),
          sumEachList(),
          const SizedBox(height: 10),
          Expanded(
            child: ShowList(
              janddate: janddate,
              ref: ref,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchLot() {
    final janddate = ref.watch(janddateR);
    final sorteosControllers = SorteosControllers();

    return ValueListenableBuilder(
        valueListenable: cambioMillionGame,
        builder: (_, __, ___) {
          return FutureBuilder(
              future: sorteosControllers.getSorteoByJD(
                  janddate.currentJornada, janddate.currentDate),
              builder: (_, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return boldLabel('Sorteo del momento -> ', 'Sin dato', 23);
                }

                final millions = snapshot.data;
                lotThisDay = millions!;

                return boldLabel('Sorteo del momento -> ', lotThisDay, 23);
              });
        });
  }

  Padding sumEachList() {
    final janddate = ref.watch(janddateR);
    final bruto = ref.watch(
        TotalBrutoProvider(janddate.currentJornada, janddate.currentDate));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          boldLabel('Bruto: ', bruto.toString(), 20),
          boldLabel('Limpio: ', (bruto * 0.80).round().toString(), 20),
        ],
      ),
    );
  }
}

class ShowList extends StatelessWidget {
  const ShowList({super.key, required this.janddate, required this.ref});

  final JAndDateModel janddate;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
          valueListenable: cambioMillionGame,
          builder: (_, __, ___) {
            return ref
                .watch(GetTodosMillionProvider(
                    janddate.currentJornada, janddate.currentDate))
                .when(
                  data: (data) {
                    if (data.isEmpty) return noData(context);

                    final millions = data;

                    return ListView.builder(
                        itemCount: millions.length,
                        itemBuilder: (context, index) {
                          String millionLot =
                              millions[index].millionPlay.millionLot;

                          int fijo = millions[index].millionPlay.fijo;
                          int corrido = millions[index].millionPlay.corrido;
                          int dinero = millions[index].millionPlay.dinero;

                          int sum = fijo + corrido;

                          return ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 30, right: 16),
                              tileColor: (index % 2 != 0)
                                  ? Colors.grey[200]
                                  : Colors.grey[50],
                              title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textoDosis(millionLot, 32,
                                        fontWeight: FontWeight.bold),
                                    const SizedBox(width: 10),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child:
                                          textoDosis(millions[index].owner, 15),
                                    )
                                  ]),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  boldLabel('Fijo: ', fijo.toString(), 19),
                                  const SizedBox(width: 20),
                                  boldLabel(
                                      'Corrido: ', corrido.toString(), 19),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  textoDosis('\$$sum', 16,
                                      fontWeight: FontWeight.bold),
                                  textoDosis('\$$dinero ', 16,
                                      color: Colors.red[400])
                                ],
                              ));
                        });
                  },
                  error: (error, stackTrace) =>
                      throw Exception('Error al cargar los datos'),
                  loading: () => waitingWidget(context),
                );
          }),
    );
  }
}
