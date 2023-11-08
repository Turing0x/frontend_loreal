import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/design/Lista/number_textbox.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:frontend_loreal/design/common/txt_small.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista/rango_numero_model.dart';
import 'package:frontend_loreal/models/Lista_Main/centenas/centenas_model.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

class CentenasWidget extends ConsumerStatefulWidget {
  const CentenasWidget({
    super.key,
    required this.listaCentenas,
    required this.centena,
  });

  final List<CentenasModel> listaCentenas;
  final String centena;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CentenasWidgetState();
}

class _CentenasWidgetState extends ConsumerState<CentenasWidget> {
  TextEditingController cValor = TextEditingController();
  TextEditingController cNum = TextEditingController();

  Uuid uuid = const Uuid();

  final FocusNode numFijo = FocusNode();
  final FocusNode moniFijo = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final toJoinList = ref.watch(toJoinListR);
      if (toJoinList.currentList['ListaGeneralEnum.principales']!.isNotEmpty) {
        List fcppc = toJoinList.currentList['ListaGeneralEnum.principales']![
            'MainListEnum.centenas'];
        for (var element in fcppc) {
          if( !widget.listaCentenas.contains(element) ){
            widget.listaCentenas.add(
              CentenasModel.fromTextEditingController(0,
                  uuid: element.uuid,
                  numplay1: element.numplay.toString(),
                  fijo: element.fijo.toString()),
            );
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    numFijo.dispose();
    moniFijo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ValueNotifier<bool> toChange = ValueNotifier(true);

    final getLimit = ref.watch(globalLimits);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      height: double.infinity,
      width: size.width * 0.3,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black)),
            ),
            width: double.infinity,
            height: 35,
            child: textoDosis('Centenas', 18),
          ),
          ValueListenableBuilder(
              valueListenable: toChange,
              builder: (context, value, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ...widget.listaCentenas.map(
                            (e) => GestureDetector(
                              onTap: () {
                                final payCrtl = ref.read(paymentCrtl.notifier);

                                int bruto = e.fijo;
                                int limpioListero = (bruto * (getLimit.porcientoParleListero / 100)).toInt();

                                payCrtl.restaTotalBruto70 = bruto;
                                payCrtl.restaLimpioListero = limpioListero;

                                widget.listaCentenas.removeWhere(
                                    (element) => element.uuid == e.uuid);

                                toBlockIfOutOfLimit.update(
                                    e.numplay, (value) => value - e.fijo);

                                widget.listaCentenas.remove(e);
                                toChange.value = !toChange.value;
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black)),
                                ),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    NumeroRedondoWidget(
                                        numero: e.numplay.toString(),
                                        mostrarBorde: false,
                                        lenght: 3),
                                    NumeroRedondoWidget(
                                        numero: e.fijo.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
          Consumer(builder: (_, ref, __) {
            return NumberTextbox(
              fila: [
                Flexible(
                  child: TxtInfoSmall(
                    keyboardType: const TextInputType.numberWithOptions(),
                    hintText: '#',
                    controlador: cNum,
                    maxLength: 3,
                    maxLines: 1,
                    focusNode: numFijo,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumericalRangeFormatter(min: 0, max: 999)
                    ],
                    onChange: (p0) {
                      if (p0!.length == 3) {
                        FocusScope.of(context).requestFocus(moniFijo);
                      }
                    },
                  ),
                ),
                Flexible(
                  child: TxtInfoSmall(
                    keyboardType: TextInputType.number,
                    hintText: r'$',
                    controlador: cValor,
                    maxLines: 1,
                    focusNode: moniFijo,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumberTextInputFormatter(
                          maxValue: widget.centena.toString())
                    ],
                    onChange: (p0) {},
                  ),
                ),
              ],
              onPressed: () => setState(() {
                final payCrtl = ref.read(paymentCrtl.notifier);

                if ((cNum.text.isEmpty || cNum.text.length != 3) ||
                    cValor.text.isEmpty ||
                    cValor.text == '0') {
                  showToast('Revise los campos por favor');
                  return;
                }

                int dineroApuesta = (cValor.text.intTryParsed ?? 0);
                bool excedeApuesta =
                    ((toBlockIfOutOfLimit[cNum.text] ?? 0) + dineroApuesta) >
                        int.parse(widget.centena);

                if (excedeApuesta) {
                  showToast(
                      'El límite para la centena está establecido en ${widget.centena}. No puede ser excedido');
                  return;
                }

                toBlockIfOutOfLimit.update(
                    cNum.text, (value) => value + dineroApuesta,
                    ifAbsent: () => dineroApuesta);

                payCrtl.totalBruto70 = dineroApuesta;
                payCrtl.limpioListero =
                    (dineroApuesta * (getLimit.porcientoParleListero / 100))
                        .toInt();

                widget.listaCentenas.add(
                  CentenasModel.fromTextEditingController(
                    0,
                    uuid: uuid.v4(),
                    numplay1: cNum.text,
                    fijo: cValor.text,
                  ),
                );

                cNum.text = '';
                cValor.text = '';
                FocusScope.of(context).requestFocus(numFijo);
              }),
            );
          }),
        ],
      ),
    );
  }
}
