import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/controllers/pdf_controllers.dart';
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

bool hasDataInList = false;
String role = '';

String startdate = todayGlobal;
String enddate = todayGlobal;

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
                ? showToast('No hay información de listas para general el PDF')
                : makePdf())
      ]),
      body: Column(
        children: [
          const JornadAndDate(showDate: false),
          ctnDateRangePicker(context),
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

  void makePdf() {
    try {
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
        startDate: startdate,
        endDate: enddate,
      );

      pdfData.then((value) {
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
            ? PdfInvoiceApiBanco.generate(invoice,
                resumen: true, startDate: startdate, endDate: enddate)
            : (globalRoleToPDF == 'Colector General')
                ? PdfInvoiceApiColectorGeneral.generate(invoice,
                    resumen: true, startDate: startdate, endDate: enddate)
                : PdfInvoiceApiColectorSimple.generate(invoice,
                    resumen: true, startDate: startdate, endDate: enddate);
      });

      EasyLoading.showSuccess('El vale ha sido creado exitosamente');
    } catch (e) {
      EasyLoading.showError('Ha ocurrido algo grave');
    }
  }

  Container ctnDateRangePicker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textoDosis('Rango:', 20, fontWeight: FontWeight.bold),
          Flexible(
            child: Container(
                height: 40,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(10)),
                child: textoDosis('$startdate - $enddate', 18)),
          ),
          Flexible(
            child: OutlinedButton(
                child: textoDosis('Cambiar', 16),
                onPressed: () async {
                  DateTimeRange? pickedDate = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 1));

                  if (pickedDate != null) {
                    String pickedStart = pickedDate.toString().split(' - ')[0];
                    String pickedEnd = pickedDate.toString().split(' - ')[1];

                    String formattedStartDate =
                        DateFormat.MMMd().format(DateTime.parse(pickedStart));

                    String formattedEndDate =
                        DateFormat.MMMd().format(DateTime.parse(pickedEnd));

                    setState(() {
                      startdate = formattedStartDate;
                      enddate = formattedEndDate;
                    });
                  }
                }),
          )
        ],
      ),
    );
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
                  startDate: startdate,
                  endDate: enddate,
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
                        color: (isDark) ? Colors.black :(index % 2 != 0)
                              ? Colors.grey[200]
                              : Colors.grey[50],
                        alignment: Alignment.center,
                        child: ListTile(
                            title: textoDosis(user[index].username, 28,
                                fontWeight: FontWeight.bold),
                            subtitle: FittedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  : showToast('Sin acciones para los listeros');
                            }),
                      );
                    });
              },
            );
          }),
    );
  }
}
