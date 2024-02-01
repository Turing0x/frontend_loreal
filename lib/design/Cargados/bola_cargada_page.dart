import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Cargados/provider/Bolas/get_bola_provider.dart';
import 'package:frontend_loreal/design/Cargados/provider/Bolas/observar_bola_provider.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';

class BolaCargadaPage extends ConsumerWidget {
  const BolaCargadaPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final janddate = ref.watch(janddateR);
    final bruto = ref.watch(
        BolaTotalBrutoProvider(janddate.currentJornada, janddate.currentDate));

    return Scaffold(
        appBar: showAppBar('Bolas cargadas'),
        body: Column(
          children: [
            const JornadAndDate(),
            (globallot.isNotEmpty)
              ? boldLabel('Sorteo: ', globallot.join(' - '), 25)
              : Container(),
            const Divider(
              color: Colors.black,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              boldLabel('Bruto: ', bruto.toString(), 25),
              boldLabel('Limpio: ', (bruto * 0.80).round().toString(), 25),
            ]),
            const SizedBox(height: 20),
            const Expanded(child: ShowList())
          ],
        ));
  }
}

class ShowList extends ConsumerWidget {
  const ShowList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final janddate = ref.watch(janddateR);

    return Scaffold(
      body: ref
          .watch(GetBolasCargadasProvider(
              janddate.currentJornada, janddate.currentDate))
          .when(
            data: (data) {
              if (data.isEmpty) {
                return noData(context);
              }

              List<BolaCargadaModel> list = data;
              (globallot.isNotEmpty)
                ? (list.sort((a, b) => b.dinero! - a.dinero!))
                : (list.sort((a, b) => b.total - a.total));

              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        color: (isDark) ? Colors.transparent :(index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50],
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: 80,
                        child: FittedBox(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NumeroRedondoWidget(
                                  numero: list[index].numero,
                                  width: 50,
                                  height: 50,
                                  fontSize: 25,
                                ),
                                textoDosis(
                                    ' -> ${(globallot.isNotEmpty)
                                      ? (list[index].jugada == 'corrido')
                                        ? list[index].totalCorrido
                                        : list[index].total
                                      : list[index].total}', 25,
                                    fontWeight: FontWeight.bold),
                                (list[index].dinero != 0)
                                  ? textoDosis(
                                    ' -> ${list[index].dinero}', 25,
                                    fontWeight: FontWeight.bold)
                                  : Container()
                                
                              ]),
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, 'see_details_bola_cargada',
                          arguments: [
                            list[index].numero.toString(),
                            list[index].total.toString(),
                            list[index].totalCorrido.toString(),
                            list[index].listeros,
                            list[index].jugada
                          ]),
                    );
                  });
            },
            error: (error, stack) => Container(),
            loading: () => waitingWidget(context),
          ),
    );
  }
}
