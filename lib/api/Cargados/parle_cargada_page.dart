import 'package:frontend_loreal/api/Cargados/provider/Parles/get_parles_provider.dart';
import 'package:frontend_loreal/api/Cargados/provider/Parles/observar_parle_provider.dart';
import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/no_data.dart';
import 'package:frontend_loreal/widgets/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParleCargadoPage extends ConsumerWidget {
  const ParleCargadoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final janddate = ref.watch(janddateR);
    final bruto = ref.watch(
        ParleTotalBrutoProvider(janddate.currentJornada, janddate.currentDate));

    return Scaffold(
        appBar: showAppBar('Perlés cargados'),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const JornadAndDate(),
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
            const ShowList()
          ],
        )));
  }
}

class ShowList extends ConsumerWidget {
  const ShowList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final janddate = ref.watch(janddateR);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.68,
      child: Consumer(
        builder: (context, ref, child) {
          return ref
              .watch(GetParlesCargadosProvider(
                  janddate.currentJornada, janddate.currentDate))
              .when(
                data: (data) {
                  if (data.isEmpty) {
                    return noData(context);
                  }
                  final list = data..sort((a, b) => b.total - a.total);

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
                            color: (index % 2 != 0)
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
                                      ' --> Apuesta: ${list[index].fijo.toString()}',
                                      25),
                                ]),
                          ),
                          onTap: () => Navigator.pushNamed(
                              context, 'see_details_parle_cargada',
                              arguments: [
                                list[index].numero.toString(),
                                list[index].fijo.toString(),
                                list[index].total.toString(),
                                list[index].listeros
                              ]),
                        );
                      });
                },
                error: (error, stack) => Container(),
                loading: () => waitingWidget(context),
              );
        },
      ),
    );
  }
}
