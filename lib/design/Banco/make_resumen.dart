import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/controllers/pdf_controllers.dart';
import 'package:frontend_loreal/design/common/date_range_widget.dart';
import 'package:frontend_loreal/models/pdf_data_model.dart';
import 'package:frontend_loreal/config/controllers/users_controller.dart';
import 'package:frontend_loreal/config/extensions/lista_general_extensions.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date_bloc.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/Banco/pdf_banco.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/Colecotores/pdf_colector_general.dart';
import 'package:frontend_loreal/design/Hacer_PDFs/Colecotores/pdf_colector_simple.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:frontend_loreal/models/PDFs/invoice_colector.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool hasDataInList = false;
String role = '';

class MakeResumenForBank extends ConsumerStatefulWidget {
  const MakeResumenForBank({super.key, required this.userName});

  final String userName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MakeResumenForBankState();
}

class _MakeResumenForBankState extends ConsumerState<MakeResumenForBank> {
  TextEditingController usernameCTRL = TextEditingController();

  String datePicked = DateFormat.MMMd().format(DateTime.now());
  String jornada = '';
  int cont = 0;

  @override
  void initState() {
    usernameCTRL.text = widget.userName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);

    return Scaffold(
      appBar: showAppBar('Resúmen de listas', actions: [
        IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => (!hasDataInList)
                ? showToast(
                    context, 'No hay información de listas para general el PDF')
                : makePdf())
      ]),
      body: Column(
        children: [
          const JornadAndDate(showDate: false),
          const InitialDateSelect(),
          const EndDateSelect(),
          txtUser(),
          encabezado(context, 'Resultados de la búsqueda', false, () {}, false),
          Expanded(
            child: ShowList(
                janddate: janddate, ref: ref, seeChUsername: usernameCTRL.text),
          ),
        ],
      ),
    );
  }

  TxtInfo txtUser() {
    return TxtInfo(
        keyboardType: TextInputType.text,
        icon: Icons.person_pin_outlined,
        texto: 'Usuario buscado: ',
        readOnly: true,
        controlador: usernameCTRL,
        onChange: (valor) => {});
  }

  void makePdf() async {
    try {
      final dateRange = ref.watch(dateRangeR);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final pdfControllers = PdfControllers();
      EasyLoading.show(status: 'Buscando información para crear el vale...');

      DateTime now = DateTime.now();
      String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);
      List<InvoiceItemColector> toPDF = [];

      final janddate = ref.watch(janddateR);
      final pdfData = pdfControllers.getDataToPDF(
        widget.userName,
        janddate.currentDate,
        janddate.currentJornada,
        makeResumen: 'resumen',
        startDate: dateRange.initialDate,
        endDate: dateRange.endDate,
      );

      pdfData.then((value) async {
        String result = '';
        for (PdfData data in value) {
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
        }

        final invoice = InvoiceColector(
            infoColector: InvoiceInfoColector(
                fechaActual: formatFechaActual,
                fechaTirada: janddate.currentDate,
                jornada: janddate.currentJornada,
                coleccion: widget.userName,
                lote: ''),
            usersColector: toPDF);

        (globalRoleToPDF == 'Banco')
            ? result = await PdfInvoiceApiBanco.generate(invoice,
                resumen: true,
                startDate: dateRange.initialDate,
                endDate: dateRange.endDate)
            : (globalRoleToPDF == 'Colector General')
                ? result = await PdfInvoiceApiColectorGeneral.generate(invoice,
                    resumen: true,
                    startDate: dateRange.initialDate,
                    endDate: dateRange.endDate)
                : result = await PdfInvoiceApiColectorSimple.generate(invoice,
                    resumen: true,
                    startDate: dateRange.initialDate,
                    endDate: dateRange.endDate);

        final openPdf = prefs.getBool('openPdf');
        if (openPdf ?? false) {
          OpenFile.open(result);
        }
      });

      EasyLoading.showSuccess('El vale ha sido creado exitosamente');
    } catch (e) {
      EasyLoading.showError('Ha ocurrido algo grave');
    }
  }
}

class ShowList extends StatelessWidget {
  const ShowList({
    super.key,
    required this.janddate,
    required this.ref,
    required this.seeChUsername,
  });

  final JAndDateModel janddate;
  final String seeChUsername;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeR);

    final userCtrl = UserControllers();
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: recargar,
          builder: (_, __, ___) {
            return FutureBuilder(
              future: userCtrl.getUserById(
                  id: seeChUsername,
                  userInfo: false,
                  janddate.currentJornada,
                  janddate.currentDate,
                  startDate: dateRange.initialDate,
                  endDate: dateRange.endDate,
                  makeResumen: true),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  hasDataInList = false;
                  return waitingWidget(context);
                }

                if (snapshot.data!['data']!.isEmpty || snapshot.data!.isEmpty) {
                  hasDataInList = false;
                  return noData(context);
                }

                final user = snapshot.data!['data'];

                hasDataInList = true;

                return ListView.builder(
                    itemCount: user!.length,
                    itemBuilder: (context, index) {
                      final calcs = user[index].calcs as Map<String, dynamic>;
                      role = user[0].role['code'];

                      return Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 110,
                        color: (isDark)
                            ? Colors.black
                            : (index % 2 != 0)
                                ? Colors.grey[200]
                                : Colors.grey[50],
                        alignment: Alignment.center,
                        child: ListTile(
                            title: textoDosis(user[index].username, 28,
                                fontWeight: FontWeight.bold),
                            subtitle: FittedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
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
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_right,
                                color: Colors.black),
                            tileColor: (index % 2 != 0)
                                ? Colors.grey[200]
                                : Colors.grey[50],
                            onTap: () {
                              (user[index].role['code'] != 'listero')
                                  ? Navigator.pushNamed(context, 'make_resumen',
                                      arguments: [user[index].username])
                                  : showToast(context,
                                      'Sin acciones para los listeros');
                            }),
                      );
                    });
              },
            );
          }),
    );
  }
}
