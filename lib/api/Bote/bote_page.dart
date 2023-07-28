import 'package:frontend_loreal/api/Bote/controller/bote_controller.dart';
import 'package:frontend_loreal/api/JornalAndDate/jornal_and_date.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoce_bote.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Bote/pdf_bote.dart';
import 'package:frontend_loreal/extensions/string_extensions.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BotePage extends ConsumerStatefulWidget {
  const BotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BotePageState();
}

class _BotePageState extends ConsumerState<BotePage> {
  TextEditingController fijoController = TextEditingController();
  TextEditingController parleController = TextEditingController();
  TextEditingController centenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Bote de jugadas'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              const JornadAndDate(),
              const Divider(
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              TxtInfo(
                  texto: 'Fijo: ',
                  keyboardType: TextInputType.number,
                  controlador: fijoController,
                  color: Colors.grey[200],
                  icon: Icons.sports_basketball_outlined,
                  onChange: (valor) => (() {})),
              TxtInfo(
                  texto: 'Parlé: ',
                  keyboardType: TextInputType.number,
                  controlador: parleController,
                  color: Colors.grey[200],
                  icon: Icons.format_list_numbered_outlined,
                  onChange: (valor) => (() {})),
              TxtInfo(
                  texto: 'Centena',
                  keyboardType: TextInputType.number,
                  controlador: centenaController,
                  color: Colors.grey[200],
                  icon: Icons.closed_caption_outlined,
                  onChange: (valor) => (() {})),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      elevation: 2,
                    ),
                    child:
                        textoDosis('Descargar bote', 20, color: Colors.white),
                    onPressed: () async {
                      try {
                        EasyLoading.show(
                            status: 'Descargando bote, espere por favor...');

                        final janddate = ref.watch(janddateR);

                        if (fijoController.text.isEmpty &&
                            parleController.text.isEmpty &&
                            centenaController.text.isEmpty) {
                          showToast(
                              'Escribe una cantidad para botar en algún campo');
                          return;
                        }

                        String formatFechaActual =
                            DateFormat('dd/MM/yyyy hh:mm a')
                                .format(DateTime.now());

                        final botados = await makeABote(
                            janddate.currentDate,
                            janddate.currentJornada,
                            fijoController.text.intTryParsed ?? 0,
                            parleController.text.intTryParsed ?? 0,
                            centenaController.text.intTryParsed ?? 0);

                        if (botados[0].bruto == 0) {
                          EasyLoading.showError('Bote no realizado');
                          return;
                        }

                        final invoice = InvoiceBote(
                            infoBote: InvoiceInfoBote(
                                fechaActual: formatFechaActual,
                                fechaTirada: janddate.currentDate,
                                jornada: janddate.currentJornada),
                            infoList: [
                              InvoiceItemList(
                                  lista: botados[0].botado,
                                  bruto: botados[0].bruto)
                            ]);

                        bool doit = await PdfInvoiceApiBote.generate(invoice);

                        if (doit) {
                          EasyLoading.showSuccess(
                              'Bote exportado exitosamente');
                          return;
                        }

                        EasyLoading.showError('Error al realizar el bote');
                      } catch (e) {
                        EasyLoading.showError('Ha ocurrido algo grave');
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
