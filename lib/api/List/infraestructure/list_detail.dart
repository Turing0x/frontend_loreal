import 'package:frontend_loreal/api/DrawList/Calcs/models/calcs_model.dart';
import 'package:frontend_loreal/api/List/widgets/toServer/list_controller.dart';
import 'package:frontend_loreal/api/List/domain/list_model.dart';
import 'package:frontend_loreal/api/DrawList/export_all.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoce_listero.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Listero/pdf_listero.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:frontend_loreal/widgets/no_data.dart';
import 'package:frontend_loreal/widgets/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListDetails extends ConsumerStatefulWidget {
  const ListDetails({
    super.key,
    required this.date,
    required this.jornal,
    required this.username,
    required this.lotIncoming,
  });

  final String date, jornal, username, lotIncoming;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListDetailsState();
}

class _ListDetailsState extends ConsumerState<ListDetails> {
  String datePicked = DateFormat.MMMd().format(DateTime.now());
  String id = '';

  List<BoliList> infoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Detalles de la lista', actions: [
        IconButton(
          icon: const Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          onPressed: () async {
            DateTime now = DateTime.now();
            String formatFechaActual =
                DateFormat('dd/MM/yyyy hh:mm a').format(now);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            if (infoList.isEmpty) {
              return;
            }

            final calcs = infoList[0].calcs as Map<String, dynamic>;
            final list = boliList(infoList[0].signature!);

            final invoice = InvoiceListero(
                infoListero: InvoiceInfoListero(
                    fechaActual: formatFechaActual,
                    fechaTirada: infoList[0].date!,
                    jornada: infoList[0].jornal!,
                    listero: widget.username,
                    lote: widget.lotIncoming),
                infoList: [
                  InvoiceItemList(
                      lista: list,
                      bruto: double.parse(
                          calcs['bruto'].toStringAsFixed(2).toString()),
                      limpio: double.parse(
                          calcs['limpio'].toStringAsFixed(2).toString()),
                      premio: double.parse(
                          calcs['premio'].toStringAsFixed(2).toString()),
                      pierde: double.parse(
                          calcs['perdido'].toStringAsFixed(2).toString()),
                      gana: double.parse(
                          calcs['ganado'].toStringAsFixed(2).toString()))
                ]);

            Map<String, dynamic> itsDone =
                await PdfInvoiceApiListero.generate(invoice);

            final openPdf = prefs.getBool('openPdf');
            if (openPdf ?? false) {
              OpenFile.open(itsDone['path']);
            }

            showToast('Lista exportada exitosamente', type: true);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.white,
          ),
          onPressed: () async {
            String? codeRole = await AuthServices.getRole();
            if (codeRole == 'banco' && widget.lotIncoming == '') {
              // ignore: use_build_context_synchronously
              showInfoDialog(
                  context,
                  'Eliminación de listas',
                  FittedBox(
                      child: textoDosis(
                          'Está seguro que desea eliminar esta lista?', 20)),
                  () {
                final wasDelete = deleteOneList(id);
                wasDelete.then((value) {
                  if (value) {
                    Navigator.pushReplacementNamed(
                        context, 'main_banquero_page');
                  }
                });
              });
              return;
            }
            showToast('No puede realizar esta acción');
          },
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            boldLabel('Sorteo del momento -> ', widget.lotIncoming, 23),
            showList()
          ],
        ),
      ),
    );
  }

  Widget showList() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        child: FutureBuilder(
          future: getAllList(
              username: widget.username,
              jornal: widget.jornal,
              date: widget.date),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return waitingWidget(context);
            }
            if (snapshot.data!['data']!.isEmpty || snapshot.data!.isEmpty) {
              return noData(context);
            }

            final data = snapshot.data!['data'];

            final list = boliList(data[0].signature!);
            final decoded = data[0].calcs as Map<String, dynamic>;

            id = data[0].id!;
            infoList = data;

            list.sort(((a, b) {
              if (b is! CalcsModel && a is! CalcsModel) {
                return b.dinero - a.dinero;
              }
              return 0;
            }));

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          boldLabel(
                              'B: ',
                              decoded['bruto'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'L: ',
                              decoded['limpio'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'P: ',
                              decoded['premio'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'P: ',
                              decoded['perdido'].toStringAsFixed(0).toString(),
                              18),
                          boldLabel(
                              'G: ',
                              decoded['ganado'].toStringAsFixed(0).toString(),
                              18),
                        ],
                      )),
                  const Divider(
                    color: Colors.black,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final color = (index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50];
                          return Container(
                            color: color,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: fila(data: list[index], color: color!),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget fila({required dynamic data, required Color color}) {
    final widgetMap = {
      FijoCorridoModel: (data) => FijosCorridosListaWidget(
            fijoCorrido: data,
            color: color,
          ),
      ParlesModel: (data) => ParlesListaWidget(
            parles: data,
            color: color,
          ),
      CentenasModel: (data) => CentenasListaWidget(
            centenas: data,
            color: color,
          ),
      CandadoModel: (data) => CandadoListaWidget(
            candado: data,
            color: color,
          ),
      TerminalModel: (data) => TerminalListaWidget(
            terminal: data,
            color: color,
          ),
      PosicionModel: (data) => PosicionlListaWidget(
            posicion: data,
            color: color,
          ),
      DecenaModel: (data) => DecenaListaWidget(
            numplay: data,
            color: color,
          ),
      MillionModel: (data) => MillionListaWidget(
            numplay: data,
            color: color,
          ),
    };

    final widgetBuilder = widgetMap[data.runtimeType];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }

  Widget sumEachList() {
    return FutureBuilder(
        future: getListById(id),
        builder: (_, AsyncSnapshot<List<BoliList>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boldLabel('B: ', '0', 18),
                  boldLabel('L: ', '0', 18),
                  boldLabel('P: ', '0', 18),
                  boldLabel('P: ', '0', 18),
                  boldLabel('G: ', '0', 18),
                ],
              ),
            );
          }

          final list = snapshot.data;
          final decoded = list![0].calcs as Map<String, dynamic>;

          return Container(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boldLabel(
                    'B: ', decoded['bruto'].toStringAsFixed(0).toString(), 18),
                boldLabel(
                    'L: ', decoded['limpio'].toStringAsFixed(0).toString(), 18),
                boldLabel(
                    'P: ', decoded['premio'].toStringAsFixed(0).toString(), 18),
                boldLabel('P: ',
                    decoded['perdido'].toStringAsFixed(0).toString(), 18),
                boldLabel(
                    'G: ', decoded['ganado'].toStringAsFixed(0).toString(), 18),
              ],
            ),
          );
        });
  }
}
