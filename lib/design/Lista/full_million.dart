import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/simple_txt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class FullMillionWidget extends ConsumerStatefulWidget {
  const FullMillionWidget({
    super.key,
    this.offline = false,
  });

  final bool offline;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FullMillionWidgetState();
}

class _FullMillionWidgetState extends ConsumerState<FullMillionWidget> {
  TextEditingController numplay = TextEditingController();
  TextEditingController fijo = TextEditingController();
  TextEditingController corrido = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final toJoinListM = ref.read(toJoinListR.notifier);
    final getLimits = ref.watch(globalLimits);

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            encabezado(context, 'Jugada Raspaito', false, () {}, false),
            btnWithIcon(
                context,
                Colors.blue[300],
                const Icon(Icons.info_outline),
                'Ver la información',
                () => showInfo(),
                MediaQuery.of(context).size.width * 0.7),
            TxtInfo(
                texto: 'Sorteo a jugar: ',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                controlador: numplay,
                autofocus: true,
                left: 35,
                right: 35,
                inputFormatters: [
                  MaskedInputFormatter('### ## ##',
                      allowedCharMatcher: RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(9),
                ],
                onChange: (valor) => setState(() {})),
            Row(
              children: [
                Flexible(
                  child: SimpleTxt(
                      texto: 'Fijo',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      controlador: fijo,
                      left: 25,
                      right: 15,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                        NumberTextInputFormatter(
                            maxValue: (getLimits.limitesmillonFijo != 0)
                                ? getLimits.limitesmillonFijo.toString()
                                : '1'),
                      ],
                      onChange: (valor) => setState(() {})),
                ),
                Flexible(
                  child: SimpleTxt(
                      texto: 'Corrido',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      controlador: corrido,
                      left: 0,
                      right: 35,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                        NumberTextInputFormatter(
                            maxValue: (getLimits.limitesmillonCorrido != 0)
                                ? getLimits.limitesmillonCorrido.toString()
                                : '1'),
                      ],
                      onChange: (valor) => setState(() {})),
                ),
              ],
            ),
            Visibility(
              visible: getLimits.limitesmillonFijo != 0,
              child: Consumer(builder: (_, ref, __) {
                return btnWithIcon(context, Colors.blue[300],
                    const Icon(Icons.save_outlined), 'Guardar jugada', () {
                  String uuid = const Uuid().v4();
                  final payCrtl = ref.read(paymentCrtl.notifier);
                  final getLimit = ref.watch(globalLimits);
                  FocusScope.of(context).unfocus();

                  if ((numplay.text.isEmpty || numplay.text.length != 9) ||
                      (fijo.text.isEmpty && corrido.text.isEmpty) ||
                      (fijo.text == '0' && corrido.text == '0')) {
                    showToast(context, 'Jugada inválida');
                    return;
                  }

                  String toGetselectedNumber = numplay.text;
                  int toGetfijo = fijo.text.intTryParsed ?? 0;
                  int toGetcorrido = corrido.text.intTryParsed ?? 0;

                  final value = toBlockIfOutOfLimitFCPC[numplay.text] ?? {};

                  int fijoLimite = getLimits.limitesmillonFijo;
                  int corridoLimite = getLimits.limitesmillonCorrido;
                  int dineroFijo = toGetfijo;
                  int dineroCorrido = toGetcorrido;

                  bool excedeFijo =
                      (value['fijo'] ?? 0) + dineroFijo > fijoLimite;
                  bool excedeCorrido =
                      (value['corrido'] ?? 0) + dineroCorrido > corridoLimite;

                  if (excedeFijo) {
                    showToast(context,
                        'El límite para el fijo del Raspaito está establecido en $fijoLimite. No puede ser excedido');
                    return;
                  }
                  if (excedeCorrido) {
                    showToast(context,
                        'El límite para el corrido del Raspaito está establecido en $corridoLimite. No puede ser excedido');
                    return;
                  }

                  toBlockIfOutOfLimitFCPC.update(numplay.text, (value) {
                    return {
                      'fijo': value['fijo']! + toGetfijo,
                      'corrido': value['corrido']! + toGetcorrido,
                      'corrido2': value['corrido2']!,
                    };
                  }, ifAbsent: () {
                    return {
                      'fijo': toGetfijo,
                      'corrido': toGetcorrido,
                      'corrido2': 0,
                    };
                  });

                  int bruto = toGetfijo + toGetcorrido;

                  payCrtl.totalBruto80 = bruto;
                  payCrtl.limpioListero =
                      (bruto * (getLimit.porcientoBolaListero / 100)).toInt();

                  listadoMillon['millon']?.add({
                    'uuid': uuid,
                    'numplay': toGetselectedNumber,
                    'fijo': toGetfijo,
                    'corrido': toGetcorrido,
                    'dinero': 0,
                  });

                  toJoinListM.addCurrentList(
                      key: ListaGeneralEnum.millon, data: listadoMillon);

                  numplay.text = '';
                  fijo.text = '';
                  corrido.text = '';
                }, MediaQuery.of(context).size.width * 0.7);
              }),
            )
          ],
        ));
  }

  Future showInfo() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        insetPadding: const EdgeInsets.only(left: 5, top: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.78,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                textoDosis('Información importante', 20,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                boldLabel(
                    'Conciste en: ',
                    'Hacer una jugada con los 7 digitos de un sorteo válido. '
                        'Se puede ganar aceptando al sorteo del día tanto en el órden '
                        'correcto como teniendo los mismos números pero en un órden '
                        'distinto a los del sorteo original',
                    20),
                const SizedBox(height: 10),
                boldLabel('Límite monetario: ', ' \$100 cup ', 20),
                const SizedBox(height: 20),
                textoDosis('Pagos actuales por \$1 cup', 20,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                boldLabel(
                    'Incremento al pago por fijo: ',
                    'El pago por el fijo'
                        'aumentará mensualmente en \$2 000 cup hasta ser ganado por '
                        'alguna persona, una vez que esto suceda será reiniciado el pago.',
                    20),
                const SizedBox(height: 20),
                dinamicGroupBox(
                    'Se paga al órden exacto',
                    [
                      boldLabel('En fijo: ',
                          '\$20 000 cup ( veinte mil pesos ) ', 20),
                      boldLabel('En corrido: ',
                          '\$10 000 cup ( diez mil pesos ) ', 20)
                    ],
                    padding: 0),
                const SizedBox(height: 20),
                dinamicGroupBox(
                    'Mismos números desordenados',
                    [
                      boldLabel('Al corrido: ',
                          '\$10 000 cup ( diez mil pesos ) ', 20)
                    ],
                    padding: 0),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400], elevation: 2),
                    icon: const Icon(Icons.thumb_up_outlined),
                    label: const Text('Entendido'),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
