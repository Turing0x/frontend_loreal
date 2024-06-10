import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/simple_txt.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class CandadoWidget extends ConsumerStatefulWidget {
  const CandadoWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CandadoWidgetState();
}

class _CandadoWidgetState extends ConsumerState<CandadoWidget> {
  TextEditingController candado = TextEditingController();
  TextEditingController apuesta = TextEditingController();
  String specialSymbol = '##';

  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final toJoinListM = ref.read(toJoinListR.notifier);
    final getFijoLimit = ref.watch(globalLimits).parle;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          encabezado(context, 'Jugada de candado', false, () {}, false),
          const SizedBox(height: 10),
          GestureDetector(
              onTap: () => showInfoDialog(
                  context,
                  'Aclaratoria sobre el 0',
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          boldLabel(
                              'Nota importante: ',
                              'No podrá escribir al inicio del candado una decena 0, simplemente escriba el número decimal y listo.',
                              18),
                          const SizedBox(height: 10),
                          boldLabel(
                              'Por ejemplo: ',
                              'Si desea escribir el 08, solo escriba el 8 y continúe con los demás números, la aplicación lo interpretará como el 08, pero visualmente solo verá el 8.',
                              18),
                          textoDosis('8, 65, 24, 87, 09, 00, 04', 18,
                              fontWeight: FontWeight.bold),
                          const SizedBox(height: 10),
                          boldLabel(
                              'Otra cosa: ',
                              'Eso solo sucede con el 1er número del candado, en otra posición del mismo si podrá escribir todas las decenas 0.',
                              18),
                        ],
                      ),
                    ),
                  ),
                  () => Navigator.pop(context)),
              child: textoDosis('Información importante', 18,
                  color: Colors.red, underline: true)),
          const SizedBox(height: 20),
          textoDosis('Los números serán separados por una coma (,)', 18),

          SimpleTxt(
              icon: Icons.lock_outlined,
              texto: 'Números del candado',
              keyboardType: TextInputType.text,
              controlador: candado,
              autofocus: true,
              maxLength: 59,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                NumberTextInputFormatter(
                  groupDigits: 2,
                  groupSeparator: ',',
                ),
              ],
              onChange: (valor) => setState(() {})),
          TxtInfo(
              texto: 'Apuesta: ',
              icon: Icons.attach_money,
              keyboardType: TextInputType.text,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controlador: apuesta,
              left: 45,
              onChange: (valor) => setState(() {})),
          btnWithIcon(context, Colors.blue[300],
              const Icon(Icons.save_outlined), 'Guardar jugada', () {
            String uuid = const Uuid().v4();

            final payCrtl = ref.read(paymentCrtl.notifier);
            final getLimit = ref.watch(globalLimits);
            final aux = [];

            if (candado.text.length == 2 ||
                candado.text.isEmpty ||
                apuesta.text.isEmpty ||
                apuesta.text == '0') {
              showToast('Jugada inválida');
              return;
            }

            candado.text.split(',').forEach((e) {
              aux.add(e.intTryParsed);
            });

            bool allEquals = aux.every((element) => element == aux[0]);
            if (allEquals) {
              showToast('Jugada inválida');
              return;
            }

            int dineroForEachParle = int.parse(apuesta.text) ~/
                ((aux.length * (aux.length - 1)) / 2);

            bool exedeLimite = dineroForEachParle > getFijoLimit;

            if (exedeLimite) {
              showToast(
                  'El límite para la apuesta del candado está establecido en $getFijoLimit. No puede ser excedido');
              return;
            }

            List allCombinations = combinaciones(aux);

            for (var element in allCombinations) {
              String joined = '${element[0].toString().rellenarCon00(2)}${element[1].toString().rellenarCon00(2)}';
              String joined1 = '${element[1].toString().rellenarCon00(2)}${element[0].toString().rellenarCon00(2)}';

              bool excedeApuesta = (((((toBlockIfOutOfLimit[joined] ?? 0) +
                          dineroForEachParle) >
                      getFijoLimit) ||
                  (((toBlockIfOutOfLimit[joined1] ?? 0) + dineroForEachParle) >
                      getFijoLimit)));

              if (excedeApuesta) {
                showToast(
                    'El límite para el parlé está establecido en $getFijoLimit. No puede ser excedido');
                return;
              }
            }

            for (var element in allCombinations) {
              String joined = '${element[0].toString().rellenarCon00(2)}${element[1].toString().rellenarCon00(2)}';
              String joined1 = '${element[1].toString().rellenarCon00(2)}${element[0].toString().rellenarCon00(2)}';

              toBlockIfOutOfLimit.update(
                  joined, (value) => value + dineroForEachParle,
                  ifAbsent: () => dineroForEachParle);

              toBlockIfOutOfLimit.update(
                  joined1, (value) => value + dineroForEachParle,
                  ifAbsent: () => dineroForEachParle);
            }

            int bruto = int.parse(apuesta.text);

            payCrtl.totalBruto70 = bruto;
            payCrtl.limpioListero =
                (bruto * (getLimit.porcientoParleListero / 100)).toInt();

            listadoCandado['candado']?.add({
              'uuid': uuid,
              'numplay': aux,
              'fijo': bruto,
              'dinero': 0,
            });

            toJoinListM.addCurrentList(
                key: ListaGeneralEnum.candado, data: listadoCandado);

            candado.text = '';
            apuesta.text = '';
          }, MediaQuery.of(context).size.width * 0.7)
        ],
      ),
    );
  }

  List combinaciones(List array) {
    List resultado = [];

    for (int i = 0; i < array.length - 1; i++) {
      for (int j = i + 1; j < array.length; j++) {
        resultado.add([array[i], array[j]]);
      }
    }

    return resultado;
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var selection = newValue.selection;

    var formattedText = '';

    for (var i = 0; i < text.length; i++) {
      if (i == 2) {
        formattedText += ',';
      }
      if (i < 2 || i > 3) {
        formattedText += text[i];
      } else if (i == 3) {
        formattedText += '?${text[i]}';
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: selection.extentOffset + (formattedText.length - text.length),
      ),
    );
  }
}
