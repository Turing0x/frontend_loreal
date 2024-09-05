import 'package:flutter/material.dart';
import 'package:safe_chat/config/extensions/string_extensions.dart';
import 'package:safe_chat/config/riverpod/declarations.dart';
import 'package:safe_chat/config/utils/glogal_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_chat/config/utils_exports.dart';
import 'package:safe_chat/design/Lista/number_textbox.dart';
import 'package:safe_chat/models/Lista_Main/parles/parles_model.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:safe_chat/design/common/num_redondo.dart';
import 'package:safe_chat/design/common/txt_small.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class ParlesWidget extends ConsumerStatefulWidget {
  const ParlesWidget({
    super.key,
    required this.listaParles,
    required this.parle,
  });

  final String parle;
  final List<ParlesModel> listaParles;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ParlesWidgetState();
}

class _ParlesWidgetState extends ConsumerState<ParlesWidget> {
  TextEditingController pMoney = TextEditingController();
  TextEditingController pNum = TextEditingController();
  TextEditingController pNum1 = TextEditingController();
  Uuid uuid = const Uuid();

  final FocusNode numFijo = FocusNode();
  final FocusNode numFijo1 = FocusNode();
  final FocusNode moniFijo = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final toJoinList = ref.watch(toJoinListR);
      if (toJoinList.currentList['ListaGeneralEnum.principales']!.isNotEmpty) {
        List fcppc = toJoinList.currentList['ListaGeneralEnum.principales']![
            'MainListEnum.parles'];
        for (var element in fcppc) {
          if (!widget.listaParles.contains(element)) {
            widget.listaParles.add(
              ParlesModel.fromTextEditingController(
                0,
                uuid: element.uuid,
                numplay: element.numplay[0].toString(),
                numplay1: element.numplay[1].toString(),
                fijo: element.fijo.toString(),
              ),
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
            child: textoDosis('Parles', 18),
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
                          ...widget.listaParles.map(
                            (parles) => GestureDetector(
                              onTap: () {
                                final payCrtl = ref.read(paymentCrtl.notifier);

                                int bruto = parles.fijo;
                                int limpioListero = (bruto *
                                        (getLimit.porcientoParleListero / 100))
                                    .toInt();

                                payCrtl.restaTotalBruto70 = bruto;
                                payCrtl.restaLimpioListero = limpioListero;

                                widget.listaParles.removeWhere(
                                    (element) => element.uuid == parles.uuid);

                                String a = parles.numplay[0];
                                String b = parles.numplay[1];

                                String joined = '$a$b';
                                String joined1 = '$b$a';

                                toBlockIfOutOfLimit.update(
                                    joined, (value) => value - parles.fijo);

                                toBlockIfOutOfLimit.update(
                                    joined1, (value) => value - parles.fijo);

                                widget.listaParles.remove(parles);
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ...parles.numplay.map(
                                            (numero) => NumeroRedondoWidget(
                                                  numero: numero.toString(),
                                                  mostrarBorde: false,
                                                  isParles: true,
                                                )),
                                      ],
                                    ),
                                    NumeroRedondoWidget(
                                      numero: parles.fijo.toString(),
                                    ),
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
                  child: Column(
                    children: [
                      TxtInfoSmall(
                        keyboardType: TextInputType.number,
                        hintText: r'#',
                        controlador: pNum,
                        focusNode: numFijo,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChange: (p0) {
                          if (p0!.length == 2) {
                            FocusScope.of(context).requestFocus(numFijo1);
                          }
                        },
                      ),
                      TxtInfoSmall(
                        keyboardType: TextInputType.number,
                        hintText: r'#',
                        controlador: pNum1,
                        focusNode: numFijo1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChange: (p0) {
                          if (p0!.length == 2) {
                            FocusScope.of(context).requestFocus(moniFijo);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: TxtInfoSmall(
                    keyboardType: TextInputType.number,
                    hintText: r'$',
                    controlador: pMoney,
                    focusNode: moniFijo,
                    maxLines: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumberTextInputFormatter(maxValue: widget.parle)
                    ],
                    onChange: (p0) {},
                  ),
                ),
              ],
              onPressed: () => setState(() {
                final payCrtl = ref.watch(paymentCrtl.notifier);

                if (pNum.text.isEmpty ||
                    pNum.text.length < 2 ||
                    pNum1.text.isEmpty ||
                    pNum1.text.length < 2 ||
                    pMoney.text.isEmpty ||
                    pMoney.text == '0') {
                  showToast(context, 'Revise los campos por favor');
                  return;
                }

                String a = pNum.text;
                String b = pNum1.text;

                String joined =
                    '${a.toString().rellenarCon00(2)}${b.toString().rellenarCon00(2)}';
                String joined1 =
                    '${b.toString().rellenarCon00(2)}${a.toString().rellenarCon00(2)}';

                int dineroApuesta = (pMoney.text.intTryParsed ?? 0);
                bool excedeApuesta =
                    (((((toBlockIfOutOfLimit[joined] ?? 0) + dineroApuesta) >
                            int.parse(widget.parle)) ||
                        (((toBlockIfOutOfLimit[joined1] ?? 0) + dineroApuesta) >
                            int.parse(widget.parle))));

                if (excedeApuesta) {
                  showToast(context,
                      'El límite para el parlé está establecido en ${widget.parle}. No puede ser excedido');
                  return;
                }

                toBlockIfOutOfLimit.update(
                    joined, (value) => value + dineroApuesta,
                    ifAbsent: () => dineroApuesta);

                toBlockIfOutOfLimit.update(
                    joined1, (value) => value + dineroApuesta,
                    ifAbsent: () => dineroApuesta);

                payCrtl.totalBruto70 = dineroApuesta;
                payCrtl.limpioListero =
                    (dineroApuesta * (getLimit.porcientoParleListero / 100))
                        .toInt();

                widget.listaParles.add(
                  ParlesModel.fromTextEditingController(
                    0,
                    uuid: uuid.v4(),
                    numplay: pNum.text,
                    numplay1: pNum1.text,
                    fijo: dineroApuesta.toString(),
                  ),
                );
                pNum.text = '';
                pNum1.text = '';
                pMoney.text = '';
                FocusScope.of(context).requestFocus(numFijo);
              }),
            );
          }),
        ],
      ),
    );
  }
}
