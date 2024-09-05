import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/simple_txt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class PosicionWidget extends ConsumerStatefulWidget {
  const PosicionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PosicionWidgetState();
}

class _PosicionWidgetState extends ConsumerState<PosicionWidget> {
  TextEditingController fijo = TextEditingController();
  TextEditingController corrido = TextEditingController();
  TextEditingController corrido2 = TextEditingController();
  TextEditingController posicion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final toJoinList = ref.read(toJoinListR.notifier);
    final getLimit = ref.watch(globalLimits);

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            encabezado(context, 'Jugada de Posición', false, () {}, false),
            const SizedBox(height: 10),
            textoDosis('Escriba los datos de la jugada', 18),
            const SizedBox(height: 20),
            TxtInfo(
                texto: 'Número a jugar: ',
                icon: Icons.numbers_outlined,
                keyboardType: TextInputType.number,
                autofocus: true,
                controlador: posicion,
                left: 35,
                right: 35,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                  LengthLimitingTextInputFormatter(2),
                ],
                onChange: (p0) {}),
            Row(
              children: [
                Flexible(
                  child: SimpleTxt(
                      texto: 'Fijo',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      controlador: fijo,
                      left: 35,
                      right: 25,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        NumberTextInputFormatter(
                            maxValue: getLimit.fijo.toString())
                      ],
                      onChange: (p0) {}),
                ),
                Flexible(
                  child: SimpleTxt(
                      texto: 'Corrido1',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      controlador: corrido,
                      left: 0,
                      right: 35,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        NumberTextInputFormatter(
                            maxValue: getLimit.corrido.toString())
                      ],
                      onChange: (p0) {}),
                ),
              ],
            ),
            Flexible(
              child: SimpleTxt(
                  texto: 'Corrido2',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  controlador: corrido2,
                  left: 213,
                  right: 35,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    NumberTextInputFormatter(
                        maxValue: getLimit.corrido.toString())
                  ],
                  onChange: (valor) => setState(() {})),
            ),
            btnWithIcon(context, Colors.blue[300],
                const Icon(Icons.save_outlined), 'Guardar jugada', () {
              String uuid = const Uuid().v4();

              final payCrtl = ref.read(paymentCrtl.notifier);

              if ((posicion.text.isEmpty || posicion.text.length != 2) ||
                  (fijo.text.isEmpty &&
                      corrido.text.isEmpty &&
                      corrido2.text.isEmpty) ||
                  (fijo.text == '0' &&
                      corrido.text == '0' &&
                      corrido2.text == '0')) {
                showToast(context, 'Jugada inválida');
                return;
              }

              String nposicion = posicion.text;
              int nfijo = fijo.text.intTryParsed ?? 0;
              int ncorrido = corrido.text.intTryParsed ?? 0;
              int ncorrido2 = corrido2.text.intTryParsed ?? 0;

              final value = toBlockIfOutOfLimitFCPC[posicion.text] ?? {};

              bool excedeFijo = (value['fijo'] ?? 0) + nfijo > getLimit.fijo;

              bool excedeCorrido =
                  (value['corrido'] ?? 0) + ncorrido > getLimit.corrido;
              bool excedeCorrido2 =
                  (value['corrido2'] ?? 0) + ncorrido2 > getLimit.corrido;

              if (excedeFijo) {
                showToast(context,
                    'El límite para el fijo está establecido en ${getLimit.fijo}. No puede ser excedido');
                return;
              }
              if (excedeCorrido || excedeCorrido2) {
                showToast(context,
                    'El límite para el corrido está establecido en ${getLimit.corrido}. No puede ser excedido');
                return;
              }

              toBlockIfOutOfLimitFCPC.update(posicion.text, (value) {
                return {
                  'fijo': value['fijo']! + nfijo,
                  'corrido': value['corrido']! + ncorrido,
                  'corrido2': value['corrido2']! + ncorrido2,
                };
              }, ifAbsent: () {
                return {
                  'fijo': nfijo,
                  'corrido': ncorrido,
                  'corrido2': ncorrido2,
                };
              });

              int bruto = ncorrido + ncorrido2 + nfijo;

              payCrtl.totalBruto80 = bruto;
              payCrtl.limpioListero =
                  (bruto * (getLimit.porcientoBolaListero / 100)).toInt();

              listadoPosicion['posicion']?.add({
                'uuid': uuid,
                'numplay': nposicion,
                'corrido': ncorrido,
                'corrido2': ncorrido2,
                'fijo': nfijo,
                'dinero': 0,
              });

              toJoinList.addCurrentList(
                  key: ListaGeneralEnum.posicion, data: listadoPosicion);

              posicion.text = '';
              fijo.text = '';
              corrido.text = '';
              corrido2.text = '';
            }, MediaQuery.of(context).size.width * 0.7)
          ],
        ));
  }
}
