import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Cargados/provider/Parles/get_parles_provider.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParleCargadoPage extends ConsumerWidget {
  const ParleCargadoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: showAppBar('Perlés cargados'),
        body: const Column(
          children: [
            JornadAndDate(),
            Divider(
              color: Colors.black,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(child: ShowList())
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
            .watch(GetParlesCargadosProvider(
                janddate.currentJornada, janddate.currentDate))
            .when(
              data: (data) {
                if (data.isEmpty) {
                  return noData(context);
                }

                final list = data..sort((a, b) => b.fijo - a.fijo);

                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      String cadena = list[index].numero;
                      Iterable<String> numeros = cadena
                          .split(",")
                          .map((e) => e.trim().padLeft(2, '0'));
                      String cadenaResultante = numeros.join(", ");

                      return GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          color: (isDark)
                              ? Colors.transparent
                              : (index % 2 != 0)
                                  ? Colors.grey[200]
                                  : Colors.grey[50],
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 80,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                textoDosis(
                                    cadenaResultante.replaceAll(',', ' -- '),
                                    25,
                                    fontWeight: FontWeight.bold),
                                textoDosis(
                                    ' --> ${list[index].fijo.toString()}', 25)
                              ]),
                        ),
                        onTap: () => Navigator.pushNamed(
                            context, 'see_details_parle_cargada',
                            arguments: [
                              list[index].numero.toString(),
                              list[index].fijo.toString(),
                              list[index].listeros,
                              janddate.currentJornada
                            ]),
                      );
                    });
              },
              error: (error, stack) => Container(),
              loading: () => waitingWidget(context),
            ));
  }
}
