import 'package:frontend_loreal/api/DrawList/Calcs/models/calcs_model.dart';
import 'package:frontend_loreal/api/DrawList/Millon/models/million_model.dart';
import 'package:frontend_loreal/api/DrawList/Millon/widgets/million.dart';
import 'package:frontend_loreal/api/DrawList/methods.dart';
import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date.dart';
import 'package:frontend_loreal/api/List/domain/list_model.dart';
import 'package:frontend_loreal/api/List/widgets/toServer/list_controller.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoce_listero.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Listero/pdf_listero.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/no_data.dart';
import 'package:frontend_loreal/widgets/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DrawList/Candado/models/candado_model.dart';
import '../DrawList/Candado/widgets/candado.dart';
import '../DrawList/Decena/models/decena_model.dart';
import '../DrawList/Decena/widgets/decena.dart';
import '../DrawList/MainList/models/centenas/centenas_model.dart';
import '../DrawList/MainList/models/fijo_corrido/fijo_corrido_model.dart';
import '../DrawList/MainList/models/parles/parles_model.dart';
import '../DrawList/MainList/widget/centenas.dart';
import '../DrawList/MainList/widget/fijos_corridos.dart';
import '../DrawList/MainList/widget/parles.dart';
import '../DrawList/Posicion/models/posicion_model.dart';
import '../DrawList/Posicion/widgets/posicion.dart';
import '../DrawList/Terminal/models/terminal_model.dart';
import '../DrawList/Terminal/widgets/terminal.dart';

String lotThisDay = '';
String listID = '';
List<BoliList> listFind = [];

class ListsHistory extends ConsumerStatefulWidget {
  const ListsHistory({super.key, required this.canEditList});

  final bool canEditList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListsHistoryState();
}

class _ListsHistoryState extends ConsumerState<ListsHistory> {
  String datePicked = DateFormat.MMMd().format(DateTime.now());
  int cont = 0;

  String userNAME = '';

  @override
  void initState() {
    AuthServices.getUsername().then((value) {
      setState(() {
        userNAME = value!;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showTheBottom = ref.watch(showButtomtoEditAList);
    final theBottom = ref.read(showButtomtoEditAList.notifier);
    final theList = ref.read(toEditAList.notifier);

    return Scaffold(
      appBar: showAppBar('Mis listas anteriores', actions: [
        IconButton(
            icon: const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
            onPressed: () => (listFind.isNotEmpty) ? makePdf() : null),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const JornadAndDate(),
            encabezado(
                context, 'Resultados de la búsqueda', false, () {}, false),
            Visibility(
                visible: showTheBottom,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: btnWithIcon(context, Colors.red[300],
                          const Icon(Icons.cancel_outlined), 'Cancelar', () {
                        theList.state.clear();
                        theBottom.state = false;
                      }, MediaQuery.of(context).size.width * 0.7),
                    ),
                    SizedBox(
                      width: 150,
                      child: btnWithIcon(
                          context,
                          Colors.blue[300],
                          const Icon(Icons.delete_sweep_outlined),
                          'Eliminar', () async {
                        bool okay = await editOneList(listID, theList.state);
                        if (okay) {
                          theList.state.clear();
                          theBottom.state = false;
                          cambioListas.value = !cambioListas.value;
                        }
                      }, MediaQuery.of(context).size.width * 0.7),
                    ),
                  ],
                )),
            ShowList(
              ref: ref,
              canEditList: widget.canEditList,
            ),
          ],
        ),
      ),
    );
  }

  void makePdf() async {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    final calcs = listFind[0].calcs as Map<String, dynamic>;
    final list = boliList(listFind[0].signature!);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final invoice = InvoiceListero(
        infoListero: InvoiceInfoListero(
            fechaActual: formatFechaActual,
            fechaTirada: listFind[0].date!,
            jornada: listFind[0].jornal!,
            listero: userNAME,
            lote: lotThisDay),
        infoList: [
          InvoiceItemList(
              lista: list,
              bruto: double.parse(calcs['bruto'].toStringAsFixed(2).toString()),
              limpio:
                  double.parse(calcs['limpio'].toStringAsFixed(2).toString()),
              premio:
                  double.parse(calcs['premio'].toStringAsFixed(2).toString()),
              pierde:
                  double.parse(calcs['perdido'].toStringAsFixed(2).toString()),
              gana: double.parse(calcs['ganado'].toStringAsFixed(2).toString()))
        ]);

    Map<String, dynamic> itsDone = await PdfInvoiceApiListero.generate(invoice);

    final openPdf = prefs.getBool('openPdf');
    if (openPdf ?? false) {
      OpenFile.open(itsDone['path']);
    }
    showToast('Lista exportada exitosamente', type: true);
  }

  Padding sumEachList(String lot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          boldLabel('B: ', '3326', 18),
          boldLabel('L: ', '3326', 18),
          boldLabel('P: ', '3326', 18),
          boldLabel('P: ', '3326', 18),
          boldLabel('G: ', '3326', 18)
        ],
      ),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({
    super.key,
    required this.ref,
    required this.canEditList,
  });

  final WidgetRef ref;
  final bool canEditList;

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  List<dynamic> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final janddate = widget.ref.watch(janddateR);

    return ValueListenableBuilder(
        valueListenable: cambioListas,
        builder: (_, __, ___) {
          return FutureBuilder(
            future: getAllList(
                username: globalUserName,
                jornal: janddate.currentJornada,
                date: janddate.currentDate),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingWidget(context);
              }
              if (snapshot.data!['data']!.isEmpty || snapshot.data!.isEmpty) {
                return noData(context);
              }

              List list = snapshot.data!['data'];
              String lot = snapshot.data!['lotOfToday'];
              lotThisDay = lot;

              final toDraw = boliList(list[0].signature!);
              listID = list[0].id!;

              listFind.clear();
              listFind.add(list[0]);

              final decoded = list[0].calcs as Map<String, dynamic>;

              toDraw.sort(((a, b) {
                if (b is! CalcsModel && a is! CalcsModel) {
                  return b.dinero - a.dinero;
                }
                return 0;
              }));

              return Column(
                children: [
                  boldLabel('Sorteo del momento -> ', lot, 23),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        boldLabel('B: ',
                            decoded['bruto'].toStringAsFixed(0).toString(), 18),
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: ListView.builder(
                        itemCount: toDraw.length,
                        itemBuilder: (context, index) {
                          final color = (index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50];
                          return Container(
                            color: color,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: fila(
                                  widget.canEditList && lot == 'Sin datos',
                                  widget.ref,
                                  data: toDraw[index],
                                  color: color!),
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          );
        });
  }

  Widget fila(bool canEditList, ref,
      {required dynamic data, required Color color}) {
    final widgetMap = {
      FijoCorridoModel: (data) => FijosCorridosListaWidget(
          fijoCorrido: data, color: color, canEdit: canEditList),
      ParlesModel: (data) =>
          ParlesListaWidget(parles: data, color: color, canEdit: canEditList),
      CentenasModel: (data) => CentenasListaWidget(
          centenas: data, color: color, canEdit: canEditList),
      CandadoModel: (data) =>
          CandadoListaWidget(candado: data, color: color, canEdit: canEditList),
      TerminalModel: (data) => TerminalListaWidget(
          terminal: data, color: color, canEdit: canEditList),
      PosicionModel: (data) => PosicionlListaWidget(
          posicion: data, color: color, canEdit: canEditList),
      DecenaModel: (data) =>
          DecenaListaWidget(numplay: data, color: color, canEdit: canEditList),
      MillionModel: (data) =>
          MillionListaWidget(numplay: data, color: color, canEdit: canEditList),
    };

    final widgetBuilder = widgetMap[data.runtimeType];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }
}
