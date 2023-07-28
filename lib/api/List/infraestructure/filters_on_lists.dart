import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date.dart';
import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date_bloc.dart';
import 'package:frontend_loreal/api/List/widgets/toServer/list_controller.dart';
import 'package:frontend_loreal/extensions/string_extensions.dart';
import 'package:frontend_loreal/riverpod/filters_provider.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/no_data.dart';
import 'package:frontend_loreal/widgets/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpod/declarations.dart';

class FiltersOnAllLists extends ConsumerStatefulWidget {
  const FiltersOnAllLists({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FiltersOnAllListsState();
}

class _FiltersOnAllListsState extends ConsumerState<FiltersOnAllLists> {
  TextEditingController cantElements = TextEditingController(text: '5');

  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);
    final toFilter = ref.watch(filterCrtl);

    return Scaffold(
      appBar: showAppBar('Todas las listas', actions: [
        IconButton(
            onPressed: () {
              Orden? orden = Orden.mayor;
              Parametro? parametro = Parametro.bruto;

              showInfoDialog(
                  context,
                  'Aplicar filtros',
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      txtCant(),
                      Row(
                        children: [
                          Flexible(
                            child: RadioListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: textoDosis('Mayor', 20),
                              value: Orden.mayor,
                              groupValue: orden,
                              onChanged: (value) {
                                orden = value;
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: textoDosis('Menor', 20),
                              value: Orden.menor,
                              groupValue: orden,
                              onChanged: (value) {
                                orden = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: RadioListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: textoDosis('Bruto', 20),
                              value: Parametro.bruto,
                              groupValue: parametro,
                              onChanged: (value) {
                                parametro = value!;
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: textoDosis('Limpio', 20),
                              value: Parametro.limpio,
                              groupValue: parametro,
                              onChanged: (value) {
                                parametro = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: RadioListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: textoDosis('Premio', 20),
                              value: Parametro.premio,
                              groupValue: parametro,
                              onChanged: (value) {
                                parametro = value!;
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: textoDosis('Perdido', 20),
                              value: Parametro.perdido,
                              groupValue: parametro,
                              onChanged: (value) {
                                parametro = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: RadioListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: textoDosis('Ganado', 20),
                          value: Parametro.ganado,
                          groupValue: parametro,
                          onChanged: (value) {
                            parametro = value!;
                          },
                        ),
                      ),
                    ],
                  ), () {
                final filtCrtl = ref.watch(filterCrtl);

                filtCrtl.pagination = cantElements.text.intParsed;
                filtCrtl.parameter = parametro.toString();
                filtCrtl.typeOrder = orden.toString();

                setState(() {});
              });
            },
            icon: const Icon(Icons.filter_alt_outlined))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const JornadAndDate(),
            encabezado(
                context, 'Resultados de la búsqueda', false, () {}, false),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: showList(janddate, toFilter),
            )
          ],
        ),
      ),
    );
  }

  TxtInfo txtCant() {
    return TxtInfo(
        left: 10,
        right: 10,
        texto: 'Cantidad:',
        color: Colors.grey[200],
        icon: Icons.numbers_outlined,
        keyboardType: TextInputType.number,
        controlador: cantElements,
        onChange: (valor) => setState(() {}));
  }

  FutureBuilder<Map<String, dynamic>> showList(
      JAndDateModel janddate, Filters toFilter) {
    return FutureBuilder(
      future: getAllListByJD(janddate.currentJornada, janddate.currentDate,
          toFilter.pagination.toString()),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingWidget(context);
        }

        if (snapshot.data!['data'].isEmpty || snapshot.data!.isEmpty) {
          return noData(context);
        }

        String lot = snapshot.data!['lotOfToday'];
        final lists = snapshot.data!['data'];

        lists.sort((a, b) {
          var aFiltro =
              (a.calcs as Map<String, dynamic>)[toFilter.parameter] as int;
          var bFiltro =
              (b.calcs as Map<String, dynamic>)[toFilter.parameter] as int;

          return (toFilter.typeOrder == 'mayor')
              ? bFiltro.compareTo(aFiltro)
              : aFiltro.compareTo(bFiltro);
        });

        return ListView.builder(
            itemCount: lists!.length,
            itemBuilder: (context, index) {
              final calcs = lists[index].calcs as Map<String, dynamic>;
              final owner = lists[index].owner as Map<String, dynamic>;

              return Container(
                padding: const EdgeInsets.only(left: 10),
                height: 110,
                color: (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                alignment: Alignment.center,
                child: ListTile(
                    title: textoDosis(owner['username'], 28,
                        fontWeight: FontWeight.bold),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            boldLabel(
                                'B: ',
                                calcs['bruto'].toStringAsFixed(0).toString(),
                                18),
                            boldLabel(
                                'L: ',
                                calcs['limpio'].toStringAsFixed(0).toString(),
                                18),
                            boldLabel(
                                'P: ',
                                calcs['premio'].toStringAsFixed(0).toString(),
                                18),
                            boldLabel(
                                'P: ',
                                (calcs['perdido'] < calcs['ganado'])
                                    ? 0.toString()
                                    : calcs['perdido']
                                        .toStringAsFixed(0)
                                        .toString(),
                                18),
                            boldLabel(
                                'G: ',
                                (calcs['perdido'] > calcs['ganado'])
                                    ? 0.toString()
                                    : calcs['ganado']
                                        .toStringAsFixed(0)
                                        .toString(),
                                18),
                          ],
                        ),
                        textoDosis(lot, 22, fontWeight: FontWeight.bold)
                      ],
                    ),
                    trailing:
                        const Icon(Icons.arrow_right, color: Colors.black),
                    tileColor:
                        (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                    onTap: () {
                      Navigator.pushNamed(context, 'list_detail', arguments: [
                        janddate.currentDate,
                        janddate.currentJornada,
                        owner['username'],
                        lot
                      ]);
                    }),
              );
            });
      },
    );
  }
}

enum Orden { mayor, menor }

enum Parametro { bruto, limpio, premio, ganado, perdido }
