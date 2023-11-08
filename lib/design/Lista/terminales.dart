import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/enums/lista_general_enum.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/riverpod/limits_provider.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/simple_txt.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class TerminalesWidget extends ConsumerStatefulWidget {
  const TerminalesWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TerminalesWidgetState();
}

class _TerminalesWidgetState extends ConsumerState<TerminalesWidget> {
  TextEditingController fijo = TextEditingController();
  TextEditingController corrido = TextEditingController();
  TextEditingController corrido2 = TextEditingController();
  String selectedNumber = '0';

  bool inPosicion = false;

  @override
  Widget build(BuildContext context) {
    final getLimit = ref.watch(globalLimits);

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.70,
        child: Column(
          children: [
            encabezado(context, 'Jugada de terminal', false, () => null, false),
            const SizedBox(height: 10),
            textoDosis('Seleccione uno de los terminales', 18),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                boxNumber('0'),
                boxNumber('1'),
                boxNumber('2'),
                boxNumber('3'),
                boxNumber('4'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                boxNumber('5'),
                boxNumber('6'),
                boxNumber('7'),
                boxNumber('8'),
                boxNumber('9'),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [txtFijo(getLimit), txtCorrido1(getLimit)],
            ),
            btnWithIcon(context, Colors.blue[300],
                const Icon(Icons.save_outlined), 'Guardar jugada', () {
              whenIsNotPosicion(fijo, corrido, selectedNumber, getLimit);
            }, MediaQuery.of(context).size.width * 0.7)
          ],
        ));
  }

  Flexible txtCorrido1(GlobalLimits getLimit) {
    return Flexible(
      child: SimpleTxt(
          texto: 'Corrido',
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: corrido,
          left: 0,
          right: 35,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            NumberTextInputFormatter(maxValue: getLimit.corrido.toString())
          ],
          onChange: (valor) => setState(() {})),
    );
  }

  Flexible txtFijo(GlobalLimits getLimit) {
    return Flexible(
      child: SimpleTxt(
          texto: 'Fijo',
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: fijo,
          autofocus: true,
          left: 25,
          right: 15,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            NumberTextInputFormatter(maxValue: getLimit.fijo.toString())
          ],
          onChange: (valor) => setState(() {})),
    );
  }

  GestureDetector boxNumber(String number) {
    return GestureDetector(
      onTap: () => setState(() => selectedNumber = number),
      child: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: (selectedNumber == number)
                  ? Colors.blue[300]
                  : Colors.blue[100],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black26)),
          child: textoDosis(number, 20, fontWeight: FontWeight.bold)),
    );
  }

  void whenIsNotPosicion(
      TextEditingController fijo,
      TextEditingController corrido,
      String selectedNumber,
      GlobalLimits getLimit) {
    String uuid = const Uuid().v4();

    final payCrtl = ref.read(paymentCrtl.notifier);
    final toJoinList = ref.read(toJoinListR.notifier);
    final getLimit = ref.watch(globalLimits);

    if (fijo.text.isEmpty && corrido.text.isEmpty ||
        (fijo.text == '0' && corrido.text == '0')) {
      showToast('Jugada inválida');
      return;
    }

    int toGetselectedNumber = selectedNumber.intTryParsed ?? 0;
    int toGetfijo = fijo.text.intTryParsed ?? 0;
    int toGetcorrido = corrido.text.intTryParsed ?? 0;

    int sumaF = 0;
    int sumaC = 0;

    toBlockIfOutOfLimitTerminal.forEach((clave, valor) {
      if (clave.toString().endsWith(selectedNumber)) {
        sumaF = (valor['fijo'] ?? 0);
        sumaC = (valor['corrido'] ?? 0);
      }
    });

    if ((sumaF + toGetfijo) > getLimit.fijo) {
      showToast(
          'Límite excedido, ya existe en la jugada un total de \$$sumaF pesos para los terminales $selectedNumber');
      return;
    }

    if ((sumaC + toGetcorrido) > getLimit.corrido) {
      showToast(
          'Límite excedido, ya existe en la jugada un total de \$$sumaC pesos para los terminales $selectedNumber');
      return;
    }

    bool doLater = true;

    for (var entry in toBlockIfOutOfLimitFCPC.entries) {
      var key = entry.key;
      var value = entry.value;

      if (key[1] == selectedNumber) {
        int actualFijo = value['fijo']! + toGetfijo + sumaF;
        int actualCorrido = value['corrido']! + toGetcorrido + sumaC;

        if (actualFijo > getLimit.fijo || actualCorrido > getLimit.corrido) {
          showToast('Límite excedido, ya esta pasado en la bola $key.');
          doLater = false;
          break;
        }
      }
    }

    if (!doLater) {
      return;
    }

    toBlockIfOutOfLimitTerminal.update(selectedNumber, (value) {
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

    int bruto = (toGetfijo + toGetcorrido) * 10;

    payCrtl.totalBruto80 = bruto;
    payCrtl.limpioListero =
        (bruto * (getLimit.porcientoBolaListero / 100)).toInt();

    listadoTerminal['terminal']?.add({
      'uuid': uuid,
      'numplay': toGetselectedNumber,
      'fijo': toGetfijo,
      'corrido': toGetcorrido,
      'dinero': 0,
    });

    toJoinList.addCurrentList(
        key: ListaGeneralEnum.terminal, data: listadoTerminal);

    selectedNumber = '0';
    fijo.text = '';
    corrido.text = '';
  }
}
