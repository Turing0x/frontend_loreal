import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:sticker_maker/config/controllers/sorteo_controller.dart';
import 'package:sticker_maker/config/globals/variables.dart';
import 'package:sticker_maker/config/riverpod/sorteos_stream.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/Fecha_Jornada/jornal_and_date.dart';
import 'package:sticker_maker/design/Sorteo/sorteo_pick3.dart';
import 'package:sticker_maker/design/Sorteo/sorteo_pick4.dart';
import 'package:sticker_maker/design/common/no_data.dart';
import 'package:sticker_maker/design/common/waiting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/design/common/encabezado.dart';
import 'package:sticker_maker/design/common/txt_para_info.dart';

import 'package:flutter/services.dart';
import 'package:sticker_maker/models/Sorteo/sorteos_model.dart';

class SorteosPage extends ConsumerStatefulWidget {
  const SorteosPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SorteosPageState();
}

class _SorteosPageState extends ConsumerState<SorteosPage> {
  TextEditingController sorteo = TextEditingController();
  String pick3 = 'Sin datos';
  String pick4 = 'Sin datos';
  int cont = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Agrege y revierta sorteos'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TxtInfo(
                right: 20,
                texto: 'Sorteo: ',
                keyboardType: TextInputType.number,
                controlador: sorteo,
                icon: Icons.numbers_outlined,
                inputFormatters: [
                  MaskedInputFormatter('### ## ##',
                      allowedCharMatcher: RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(9),
                ],
                onChange: (valor) => (() {})),
            const JornadAndDate(),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: 300,
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    elevation: 2,
                  ),
                  child: textoDosis('Enviar sorteo', 20, color: Colors.white),
                  onPressed: () {
                    if (sorteo.text.isEmpty) {
                      showToast(context,
                          'Faltan datos para realizar esta acción. Rectifique por favor');
                      return;
                    }

                    final janddate = ref.read(janddateR);
                    final sorteosStream = SorteosStream();
                    FocusScope.of(context).unfocus();
                    sorteosStream.saveSorteo(sorteo.text,
                        janddate.currentJornada, janddate.currentDate);
                  }),
            ),
            encabezado(context, 'Sorteos anteriores', false, () {}, false),
            const ShowList()
          ],
        ),
      ),
    );
  }

  Future searchLastLot() {
    final janddate = ref.watch(janddateR);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.only(left: 5, top: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  textoDosis('Obtener sorteo automáticamente', 20,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 10),
                  boldLabel('Para hoy: ', janddate.currentDate, 20),
                  (DateTime.now().hour < 14)
                      ? boldLabel('Jornada: ', 'Medio día', 20)
                      : boldLabel('Jornada: ', 'Noche', 20),
                  const SizedBox(height: 20),
                  SorteoPick3(
                    pick3: pick3,
                    onChange: (p0) => pick3 = p0,
                  ),
                  const SizedBox(height: 20),
                  SorteoPick4(pick4: pick4, onChange: (p0) => pick4 = p0),
                  const SizedBox(height: 20),
                  btnsModal(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row btnsModal(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400], elevation: 2),
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('Cancelar'),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400], elevation: 2),
          icon: const Icon(Icons.thumb_up_outlined),
          label: const Text('Es correcto'),
          onPressed: () {
            if (pick3 == 'Sin datos' || pick4 == 'Sin datos') {
              showToast(context, 'Faltan datos para realizar esta acción');
              return;
            }

            final janddate = ref.watch(janddateR);
            final sorteosStream = SorteosStream();
            sorteosStream.saveSorteo(
                pick3 + pick4, janddate.currentJornada, janddate.currentDate);

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ShowList extends StatelessWidget {
  const ShowList({super.key});

  @override
  Widget build(BuildContext context) {
    final sorteosControllers = SorteosControllers();
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.57,
        width: double.infinity,
        child: ValueListenableBuilder(
          valueListenable: cambioSorteo,
          builder: (BuildContext context, bool value, Widget? child) {
            return FutureBuilder<List<Sorteo>>(
              future: sorteosControllers.getDataSorteo(),
              builder: (_, AsyncSnapshot<List<Sorteo>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingWidget(context);
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return noData(context);
                }

                final sorteos = snapshot.data;
                return ListView.builder(
                    itemCount: sorteos!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: 80,
                          color: (isDark)
                              ? Colors.black
                              : (index % 2 != 0)
                                  ? Colors.grey[200]
                                  : Colors.grey[50],
                          alignment: Alignment.center,
                          child: ListTile(
                              horizontalTitleGap: 30,
                              title: textoDosis(sorteos[index].lot, 32,
                                  fontWeight: FontWeight.bold),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  dayAndJornal(sorteos[index].date,
                                      sorteos[index].jornal),
                                ],
                              ),
                              onTap: () => showInfoDialog(
                                      context,
                                      'Confirmar eliminación de sorteo',
                                      Text(
                                          'Se eliminará este sorteo. Seguro desea hacerlo?',
                                          style: subtituloListTile), (() {
                                    final sorteosStream = SorteosStream();

                                    sorteosStream
                                        .deleteSorteo(sorteos[index].id);
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context);
                                  }))));
                    });
              },
            );
          },
        ));
  }

  Future btnEditLot(BuildContext context, String id, String lot) {
    final sorteosStream = SorteosStream();
    TextEditingController forEdit = TextEditingController();
    forEdit.text = lot;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        insetPadding: const EdgeInsets.only(left: 5, top: 20),
        child: SizedBox(
          width: 350,
          height: 250,
          child: Column(
            children: [
              const SizedBox(height: 10),
              textoDosis('Acciones sobre este sorteo', 20),
              const SizedBox(height: 20),
              TxtEditar(forEdit: forEdit),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: btnDeleteLot(id, context)),
                  const SizedBox(width: 20),
                  BtnEditar(
                      id: id, sorteosStream: sorteosStream, forEdit: forEdit),
                ],
              ),
              const BtnCancelar(),
            ],
          ),
        ),
      ),
    );
  }

  OutlinedButton btnDeleteLot(String id, BuildContext context) {
    final sorteosStream = SorteosStream();

    return OutlinedButton.icon(
        icon: const Icon(Icons.delete_forever_outlined),
        label: const Text('Eliminar'),
        onPressed: () {
          sorteosStream.deleteSorteo(id);
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        });
  }

  Column dayAndJornal(String date, String jornal) {
    return Column(
      children: [
        textoDosis(date, 20),
        (jornal == 'dia')
            ? const Icon(
                Icons.light_mode_outlined,
                color: Colors.black,
              )
            : const Icon(
                Icons.nights_stay_outlined,
                color: Colors.black,
              )
      ],
    );
  }
}

class TxtEditar extends StatelessWidget {
  const TxtEditar({
    super.key,
    required this.forEdit,
  });

  final TextEditingController forEdit;

  @override
  Widget build(BuildContext context) {
    return TxtInfo(
        texto: 'Editar: ',
        keyboardType: TextInputType.number,
        controlador: forEdit,
        icon: Icons.numbers_outlined,
        inputFormatters: [
          MaskedInputFormatter('### ## ##',
              allowedCharMatcher: RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(9),
        ],
        onChange: (valor) => (() {}));
  }
}

class BtnCancelar extends StatelessWidget {
  const BtnCancelar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400], elevation: 2),
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Cancelar'),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}

class BtnEditar extends StatelessWidget {
  const BtnEditar({
    super.key,
    required this.sorteosStream,
    required this.forEdit,
    required this.id,
  });

  final SorteosStream sorteosStream;
  final TextEditingController forEdit;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: OutlinedButton.icon(
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Editar'),
          onPressed: () {
            sorteosStream.editSorteo(id, forEdit.text);
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          }),
    );
  }
}
