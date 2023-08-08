import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/api/DrawList/methods.dart';
import 'package:frontend_loreal/api/List/widgets/toServer/list_controller.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoce_listero.dart';
import 'package:frontend_loreal/api/MakePDF/domain/invoice_colector.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Banco/pdf_banco.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Colecotores/pdf_colector_general.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Colecotores/pdf_colector_simple.dart';
import 'package:frontend_loreal/api/MakePDF/infraestructure/Listero/pdf_listero_banco.dart';
import 'package:frontend_loreal/api/MakePDF/toServer/pdf_controllers.dart';
import 'package:frontend_loreal/api/MakePDF/toServer/pdf_data_model.dart';
import 'package:frontend_loreal/api/User/domian/user_show_model.dart';
import 'package:frontend_loreal/extensions/lista_general_extensions.dart';
import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/utils/glogal_map.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:share_extend/share_extend.dart';

// ignore: prefer_typing_uninitialized_variables
var toChange;

class MakingAllDocs extends ConsumerStatefulWidget {
  const MakingAllDocs(
      {super.key, required this.lotThisDay});

  final String lotThisDay;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MakingAllDocsState();
}

class _MakingAllDocsState extends ConsumerState<MakingAllDocs> {
  
  List<User> allUsers = [];
  
  int cant = 0;
  int total = 0;

  bool blockBtn = false;
  String textBtn = 'Comenzar proceso';

  @override
  void initState() {
    hasBeenDone.clear();
    setState(() {
      total = allUsers.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (textBtn == 'Procesando todos los vales') {
          return false;
        }
        return true;
      },
      child: Scaffold(
          appBar: showAppBar('Procesamiento de vales'),
          body: Column(
            children: [
              const SizedBox(height: 20),
              AbsorbPointer(
                absorbing: blockBtn,
                child: OutlinedButton.icon(
                    onPressed: () => todo(allUsers),
                    icon: const Icon(Icons.flight_takeoff_sharp),
                    label: textoDosis(textBtn, 18)),
              ),
              const SizedBox(height: 20),
              textoDosis('Cantidad finalizados: $cant de $total', 18),
              divisor,
              Expanded(
                  child: ShowList(
                allUsers: allUsers,
              )),
            ],
          )),
    );
  }

  void todo(List<User> peoples) async {
    try {
      blockBtn = true;
      textBtn = 'Procesando todos los vales';
      final janddate = ref.watch(janddateR);
      Map<String, dynamic> result = {};

      int cont = 0;

      for (User each in peoples) {
        toChange = each;
        if (each.role['code'] != 'listero') {
          result = await makePdf(
              each.username, janddate.currentDate, janddate.currentJornada);
        } else {
          result = await makeListsPdf(
              each.username, janddate.currentDate, janddate.currentJornada);
        }
        cont++;
        setState(() {
          hasBeenDone.add(
              {'done': result['done'], 'user': each, 'path': result['path']});
          cant = cont;
        });
        if (cont == peoples.length) {
          textBtn = 'Proceso terminado, todo perfecto';
        }
      }
    } catch (e) {
      throw Error();
    }
  }

  Future<Map<String, dynamic>> makePdf(
      String username, String currentDate, String currentJornada) async {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    List<InvoiceItemColector> toPDF = [];

    Map<String, dynamic> result = {};

    final pdfData = getDataToPDF(username, currentDate, currentJornada);

    List<PdfData> value = await pdfData;

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
            pierde:
                double.parse(data.calcs.perdido.toStringAsFixed(1).toString()),
            gana:
                double.parse(data.calcs.ganado.toStringAsFixed(1).toString())));

        final invoice = InvoiceColector(
            infoColector: InvoiceInfoColector(
                fechaActual: formatFechaActual,
                fechaTirada: currentDate,
                jornada: currentJornada,
                coleccion: username,
                lote: widget.lotThisDay),
            usersColector: toPDF);

        (globalRoleToPDF == 'Banco')
            ? result = await PdfInvoiceApiBanco.generate(invoice)
            : (globalRoleToPDF == 'Colector General')
                ? result = await PdfInvoiceApiColectorGeneral.generate(invoice)
                : result = await PdfInvoiceApiColectorSimple.generate(invoice);
      }
    }

    return result;
  }

  Future<Map<String, dynamic>> makeListsPdf(
      String username, String currentDate, String currentJornada) async {
    DateTime now = DateTime.now();
    String formatFechaActual = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    Map<String, dynamic> result = {};

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
              lote: widget.lotThisDay),
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

      result = await PdfInvoiceApiListero.generate(invoice);
    }
    return result;
  }
}

class ShowList extends StatefulWidget {
  const ShowList({super.key, required this.allUsers});

  final List<User> allUsers;

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: recargarUserList,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: widget.allUsers.length,
            itemBuilder: (context, index) {
              List<User> users = widget.allUsers;

              var done =
                  hasBeenDone.where((user) => user['user'] == users[index]);

              bool status = true;

              bool processing = (toChange == users[index]);
              if (done.isNotEmpty) {
                status = done.first['done'];
              }

              return (done.isNotEmpty && status)
                  ? outOfList(users[index])
                  : dinamico(users[index], status, processing);
            },
          );
        },
      ),
    );
  }

  GestureDetector outOfList(User user) {
    return GestureDetector(
      onTap: () {
        var userFound = hasBeenDone.singleWhere((data) => data['user'] == user);
        OpenFile.open(userFound['path']);
      },
      child: Container(
        margin: all,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: style,
        child: ListTile(
          title: textoDosis(user.username, 18, fontWeight: FontWeight.bold),
          subtitle: textoDosis(user.role['name'], 18),
          leading: SizedBox(height: double.infinity, child: done),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [shareFile(user), deleteFile(user)],
          ),
        ),
      ),
    );
  }

  GestureDetector dinamico(User user, bool statusFinal, bool processing) {
    return GestureDetector(
      onTap: () {
        if (!statusFinal) {
          var userFound =
              hasBeenDone.singleWhere((data) => data['user'] == user);
          showToast(userFound['path']);
        }
      },
      child: Container(
          margin: top,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
              title: textoDosis(user.username, 18, fontWeight: FontWeight.bold),
              subtitle: textoDosis(user.role['name'], 18),
              trailing: SizedBox(
                  height: double.infinity,
                  child: (processing)
                      ? proceso
                      : (statusFinal)
                          ? espera
                          : error),
              leading: (processing)
                  ? progressIndicator
                  : (statusFinal)
                      ? icon
                      : fallo)),
    );
  }

  Flexible shareFile(User user) {
    return Flexible(
        child: IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.blue,
            ),
            onPressed: () {
              var userFound =
                  hasBeenDone.singleWhere((data) => data['user'] == user);
              ShareExtend.share(userFound['path'], 'file');
            }));
  }

  Flexible deleteFile(User user) {
    return Flexible(
      child: IconButton(
          icon: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          ),
          onPressed: () {
            var userFound =
                hasBeenDone.singleWhere((data) => data['user'] == user);
            final file = File(userFound['path']);
            file.deleteSync();
            widget.allUsers.remove(user);
            recargarUserList.value = !recargarUserList.value;
            showToast('Documento eliminado exitosamente', type: true);
          }),
    );
  }

  Widget espera = textoDosis('En espera...', 18, color: Colors.grey);
  Widget proceso = textoDosis('En proceso...', 18, color: Colors.blue);
  Widget error = textoDosis('Error al crear', 18, color: Colors.red);

  Icon done = const Icon(Icons.done_all_outlined, color: Colors.green);
  Icon fallo = const Icon(Icons.error_outline, color: Colors.red);

  ProgressIndicator progressIndicator = const CircularProgressIndicator();
  Icon icon = const Icon(Icons.av_timer);

  EdgeInsets all = const EdgeInsets.all(10);
  EdgeInsets top = const EdgeInsets.only(top: 10);

  BoxDecoration style = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            spreadRadius: 0,
            blurRadius: 8,
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 0))
      ]);
}
