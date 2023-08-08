// ignore_for_file: avoid_print

import 'package:frontend_loreal/api/DrawList/methods.dart';
import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date.dart';
import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date_bloc.dart';
import 'package:frontend_loreal/api/List/widgets/toServer/list_controller.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoce_listero.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoice_colector.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Banco/pdf_banco.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Colecotores/pdf_colector_general.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Colecotores/pdf_colector_simple.dart';
import 'package:frontend_loreal/api/MakePDF/toServer/pdf_controllers.dart';
import 'package:frontend_loreal/api/MakePDF/toServer/pdf_data_model.dart';
import 'package:frontend_loreal/api/User/domian/user_show_model.dart';
import 'package:frontend_loreal/api/User/toServer/users_controller.dart';
import 'package:frontend_loreal/extensions/lista_general_extensions.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/widgets/no_data.dart';
import 'package:frontend_loreal/widgets/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../MakePDF/infraestructure/Listero/pdf_listero_banco.dart';

bool hasDataInList = false;
String lotThisDay = '';

class ListsControlPage extends ConsumerStatefulWidget {
  const ListsControlPage({
    super.key,
    required this.userName,
    required this.idToSearch,
  });

  final String userName;
  final String idToSearch;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListsControlPageState();
}

class _ListsControlPageState extends ConsumerState<ListsControlPage> {
  TextEditingController usernameCTRL = TextEditingController();

  String datePicked = DateFormat.MMMd().format(DateTime.now());
  String jornada = '';
  int cont = 0;

  List<String> allUsernames = [];

  @override
  void initState() {
    usernameCTRL.text = widget.userName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);

    return Scaffold(
      appBar: showAppBar('Control de listas',
          actions: [pdfAllLists(janddate), pdfCs()]),
      body: Column(
        children: [
          const JornadAndDate(),
          TxtInfo(
              keyboardType: TextInputType.text,
              icon: Icons.person_pin_outlined,
              texto: 'Filtrar por usuario: ',
              color: Colors.grey[200],
              controlador: usernameCTRL,
              onChange: (valor) => {}),
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: 300,
            height: 40,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  elevation: 2,
                ),
                child: textoDosis('Realizar filtrado', 20, color: Colors.white),
                onPressed: () {
                  if (usernameCTRL.text != '') {
                    usernameCTRL.text = usernameCTRL.text.trim();
                    recargar.value = !recargar.value;
                    FocusScope.of(context).unfocus();
                    return;
                  }
                  showToast('Escriba el nombre del usuario a buscar');
                }),
          ),
          encabezado(context, 'Resultados de la búsqueda', false, () {}, false),
          Expanded(
            child: ShowList(
                janddate: janddate,
                ref: ref,
                idToSearch: widget.idToSearch,
                seeChUsername: usernameCTRL.text,
                allUsernames: allUsernames),
          ),
        ],
      ),
    );
  }

  IconButton pdfCs() {
    return IconButton(
      icon: const Icon(Icons.picture_as_pdf_outlined),
      onPressed: () async {
        try {
          if (!hasDataInList) {
            showToast('No hay información de listas para hacer el PDF');
            return;
          }

          if (lotThisDay == '') {
            showToast(
                'Aún no se ha puesto el sorteo para esta jornada, esta acción estará bloqueada hasta que sea puesto');
            return;
          }

          EasyLoading.show(
              status: 'Buscando información para crear el vale...');
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          DateTime now = DateTime.now();
          String formatFechaActual =
              DateFormat('dd/MM/yyyy hh:mm a').format(now);
          List<InvoiceItemColector> toPDF = [];

          final janddate = ref.watch(janddateR);
          final pdfData = getDataToPDF(
              widget.userName, janddate.currentDate, janddate.currentJornada);

          pdfData.then((value) async {
            Map<String, dynamic> result = {};

            for (PdfData data in value) {
              toPDF.add(InvoiceItemColector(
                  codigo: data.username,
                  exprense: data.payments.exprense,
                  limpio: double.parse(
                      data.calcs.limpio.toStringAsFixed(1).toString()),
                  premio: double.parse(
                      data.calcs.premio.toStringAsFixed(1).toString()),
                  pierde: double.parse(
                      data.calcs.perdido.toStringAsFixed(1).toString()),
                  gana: double.parse(
                      data.calcs.ganado.toStringAsFixed(1).toString())));
            }

            final invoice = InvoiceColector(
                infoColector: InvoiceInfoColector(
                    fechaActual: formatFechaActual,
                    fechaTirada: janddate.currentDate,
                    jornada: janddate.currentJornada,
                    coleccion: widget.userName,
                    lote: lotThisDay),
                usersColector: toPDF);

            (globalRoleToPDF == 'Banco')
                ? result = await PdfInvoiceApiBanco.generate(invoice)
                : (globalRoleToPDF == 'Colector General')
                    ? result =
                        await PdfInvoiceApiColectorGeneral.generate(invoice)
                    : result =
                        await PdfInvoiceApiColectorSimple.generate(invoice);

            final openPdf = prefs.getBool('openPdf');
            if (openPdf ?? false) {
              OpenFile.open(result['path']);
            }
          });

          EasyLoading.showSuccess('El vale ha sido creado exitosamente');
        } catch (e) {
          EasyLoading.showError('Ha ocurrido algo grave');
        }
      },
    );
  }

  IconButton pdfAllLists(JAndDateModel janddate) {
    final janddate = ref.watch(janddateR);

    return IconButton(
      icon: const Icon(Icons.all_inbox_outlined),
      onPressed: () async {
        try {
          EasyLoading.show(
              status:
                  'Buscando información para crear todos los vales de los usuarios implicados...');

          if (!hasDataInList) {
            showToast('No hay información de listas para hacer el PDF');
            return;
          }

          List<User> peoples = await getAllPeople(
              widget.idToSearch, janddate.currentDate, janddate.currentJornada);

          for (User each in peoples) {
            if (each.role['code'] != 'listero') {
              makePdf(
                  each.username, janddate.currentDate, janddate.currentJornada);
            } else {
              makeListsPdf(
                  each.username, janddate.currentDate, janddate.currentJornada);
            }
          }

          EasyLoading.showSuccess('Los vales han sido creados exitosamente');
        } catch (e) {
          EasyLoading.showError('Ha ocurrido un error');
        }
      },
    );
  }

  void makePdf(String username, String currentDate, String currentJornada) {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    List<InvoiceItemColector> toPDF = [];

    final pdfData = getDataToPDF(username, currentDate, currentJornada);

    pdfData.then((value) {
      for (PdfData data in value) {
        if (data.calcs.limpio != 0 ||
            data.calcs.premio != 0 ||
            data.calcs.perdido != 0 ||
            data.calcs.ganado != 0) {
          toPDF.add(InvoiceItemColector(
              codigo: data.username,
              exprense: data.payments.exprense,
              limpio:
                  double.parse(data.calcs.limpio.toStringAsFixed(1).toString()),
              premio:
                  double.parse(data.calcs.premio.toStringAsFixed(1).toString()),
              pierde: double.parse(
                  data.calcs.perdido.toStringAsFixed(1).toString()),
              gana: double.parse(
                  data.calcs.ganado.toStringAsFixed(1).toString())));

          final invoice = InvoiceColector(
              infoColector: InvoiceInfoColector(
                  fechaActual: formatFechaActual,
                  fechaTirada: currentDate,
                  jornada: currentJornada,
                  coleccion: username,
                  lote: lotThisDay),
              usersColector: toPDF);

          (globalRoleToPDF == 'Banco')
              ? PdfInvoiceApiBanco.generate(invoice)
              : (globalRoleToPDF == 'Colector General')
                  ? PdfInvoiceApiColectorGeneral.generate(invoice)
                  : PdfInvoiceApiColectorSimple.generate(invoice);
        }
      }
    });
  }

  void makeListsPdf(
      String username, String currentDate, String currentJornada) async {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    final eachList = await getAllList(
        username: username, jornal: currentJornada, date: currentDate);

    if (eachList['data'].length != 0) {
      final calcs = eachList['data']![0].calcs as Map<String, dynamic>;
      final list = boliList(eachList['data']![0].signature!);

      final invoice = InvoiceListero(
          infoListero: InvoiceInfoListero(
              fechaActual: formatFechaActual,
              fechaTirada: eachList['data']![0].date!,
              jornada: eachList['data']![0].jornal!,
              listero: username,
              lote: lotThisDay),
          infoList: [
            InvoiceItemList(
                lista: list,
                bruto:
                    double.parse(calcs['bruto'].toStringAsFixed(2).toString()),
                limpio:
                    double.parse(calcs['limpio'].toStringAsFixed(2).toString()),
                premio:
                    double.parse(calcs['premio'].toStringAsFixed(2).toString()),
                pierde: double.parse(
                    calcs['perdido'].toStringAsFixed(2).toString()),
                gana:
                    double.parse(calcs['ganado'].toStringAsFixed(2).toString()))
          ]);

      await PdfInvoiceApiListero.generate(invoice);
    }
  }
}

class ShowList extends StatelessWidget {
  const ShowList({
    super.key,
    required this.janddate,
    required this.ref,
    required this.seeChUsername,
    required this.idToSearch,
    required this.allUsernames,
  });

  final JAndDateModel janddate;
  final String seeChUsername;
  final String idToSearch;
  final List<String> allUsernames;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: recargar,
          builder: (_, __, ___) {
            return FutureBuilder(
              future: getUserById(
                  id: seeChUsername,
                  userInfo: false,
                  janddate.currentJornada,
                  janddate.currentDate),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingWidget(context);
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return noData(context);
                }

                String lot = snapshot.data!['lotOfToday'];
                lotThisDay = lot;
                String missingLists = snapshot.data!['missign']
                    .toString()
                    .replaceAll('[', '')
                    .replaceAll(']', '');

                if (snapshot.data!['data']!.isEmpty || snapshot.data!.isEmpty) {
                  hasDataInList = false;
                  return Column(
                    children: [
                      Visibility(
                        visible: missingLists.isNotEmpty,
                        child: GestureDetector(
                            onTap: () => showInfoDialog(
                                context,
                                'Listas por entrar',
                                SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children:
                                          missingLists.split(',').map((e) {
                                        return textoDosis(e, 20);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                () => Navigator.pop(context)),
                            child: textoDosis('Ver listas faltantes', 18,
                                color: Colors.red, underline: true)),
                      ),
                      noData(context),
                    ],
                  );
                }

                final user = snapshot.data!['data'];
                if (allUsernames.isNotEmpty) {
                  allUsernames.clear();
                }

                for (final each in user) {
                  if (each.role['code'] == 'listero') {
                    allUsernames.add(each.username);
                  }
                }

                hasDataInList = true;

                return Column(
                  children: [
                    Visibility(
                      visible: missingLists.isNotEmpty,
                      child: GestureDetector(
                          onTap: () => showInfoDialog(
                              context,
                              'Listas por entrar',
                              SizedBox(
                                height: 200,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: missingLists.split(',').map((e) {
                                      return textoDosis(e, 20);
                                    }).toList(),
                                  ),
                                ),
                              ),
                              () => Navigator.pop(context)),
                          child: textoDosis('Ver listas faltantes', 18,
                              color: Colors.red, underline: true)),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: ListView.builder(
                          itemCount: user!.length,
                          itemBuilder: (context, index) {
                            final calcs =
                                user[index].calcs as Map<String, dynamic>;

                            return Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 110,
                              color: (index % 2 != 0)
                                  ? Colors.grey[200]
                                  : Colors.grey[50],
                              alignment: Alignment.center,
                              child: ListTile(
                                  title: textoDosis(user[index].username, 28,
                                      fontWeight: FontWeight.bold),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          boldLabel(
                                              'B: ',
                                              calcs['bruto']
                                                  .toStringAsFixed(0)
                                                  .toString(),
                                              18),
                                          boldLabel(
                                              'L: ',
                                              calcs['limpio']
                                                  .toStringAsFixed(0)
                                                  .toString(),
                                              18),
                                          boldLabel(
                                              'P: ',
                                              calcs['premio']
                                                  .toStringAsFixed(0)
                                                  .toString(),
                                              18),
                                          boldLabel(
                                              'P: ',
                                              (calcs['perdido'] <
                                                      calcs['ganado'])
                                                  ? 0.toString()
                                                  : calcs['perdido']
                                                      .toStringAsFixed(0)
                                                      .toString(),
                                              18),
                                          boldLabel(
                                              'G: ',
                                              (calcs['perdido'] >
                                                      calcs['ganado'])
                                                  ? 0.toString()
                                                  : calcs['ganado']
                                                      .toStringAsFixed(0)
                                                      .toString(),
                                              18),
                                        ],
                                      ),
                                      textoDosis(lot, 22,
                                          fontWeight: FontWeight.bold)
                                    ],
                                  ),
                                  trailing: const Icon(Icons.arrow_right,
                                      color: Colors.black),
                                  tileColor: (index % 2 != 0)
                                      ? Colors.grey[200]
                                      : Colors.grey[50],
                                  onTap: () {
                                    (user[index].role['code'] != 'listero')
                                        ? Navigator.pushNamed(
                                            context, 'list_control_page',
                                            arguments: [
                                                user[index].username,
                                                idToSearch
                                              ])
                                        : {
                                            Navigator.pushNamed(
                                                context, 'list_detail',
                                                arguments: [
                                                  janddate.currentDate,
                                                  janddate.currentJornada,
                                                  user[index].username,
                                                  lot
                                                ])
                                          };
                                  }),
                            );
                          }),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}