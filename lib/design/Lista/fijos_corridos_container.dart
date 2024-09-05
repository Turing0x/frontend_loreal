import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils/glogal_map.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Lista/number_textbox.dart';
import 'package:frontend_loreal/design/common/num_redondo.dart';
import 'package:frontend_loreal/design/common/txt_small.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/models/Lista/rango_numero_model.dart';
import 'package:frontend_loreal/models/Lista_Main/fijo_corrido/fijo_corrido_model.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class FijosCorridosWidget extends ConsumerStatefulWidget {
  const FijosCorridosWidget({
    super.key,
    required this.listaFijoCorrido,
    required this.fijo,
    required this.corrido,
  });

  final List<FijoCorridoModel> listaFijoCorrido;
  final String fijo;
  final String corrido;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FijosCorridosWidgetState();
}

class _FijosCorridosWidgetState extends ConsumerState<FijosCorridosWidget> {
  TextEditingController fcNum = TextEditingController();
  TextEditingController fcValorFijo = TextEditingController();
  TextEditingController fcValorCorrido = TextEditingController();

  Uuid uuid = const Uuid();

  final FocusNode numFijo = FocusNode();
  final FocusNode moniFijo = FocusNode();
  final FocusNode moniCorrido = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final toJoinList = ref.watch(toJoinListR);
      if (toJoinList.currentList['ListaGeneralEnum.principales']!.isNotEmpty) {
        List fcppc = toJoinList.currentList['ListaGeneralEnum.principales']![
            'MainListEnum.fijoCorrido'];
        for (var element in fcppc) {
          if (!widget.listaFijoCorrido.contains(element)) {
            widget.listaFijoCorrido.add(
              FijoCorridoModel.fromTextEditingController(
                0,
                uuid: element.uuid,
                numplayy: element.numplay.toString(),
                fijo: element.fijo.toString(),
                corrido: element.corrido.toString(),
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
    moniCorrido.dispose();
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
            child: textoDosis('Fijos y corridos', 18),
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
                          ...widget.listaFijoCorrido.map(
                            (e) => GestureDetector(
                              onTap: () {
                                final payCrtl = ref.read(paymentCrtl.notifier);

                                int bruto = e.fijo! + e.corrido!;
                                int limpioListero = (bruto *
                                        (getLimit.porcientoBolaListero / 100))
                                    .toInt();

                                payCrtl.restaTotalBruto80 = bruto;
                                payCrtl.restaLimpioListero = limpioListero;

                                widget.listaFijoCorrido.removeWhere(
                                    (element) => element.uuid == e.uuid);

                                toBlockIfOutOfLimitFCPC
                                    .update(e.numplay.toString(), (value) {
                                  return {
                                    'fijo': value['fijo']! - e.fijo!,
                                    'corrido': value['corrido']! - e.corrido!,
                                    'corrido2': value['corrido2']!,
                                  };
                                });

                                widget.listaFijoCorrido.remove(e);
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
                                    ),
                                    NumeroRedondoWidget(
                                      numero: e.fijo.toString(),
                                    ),
                                    NumeroRedondoWidget(
                                      numero: e.corrido.toString(),
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
                    child: TxtInfoSmall(
                      keyboardType: TextInputType.number,
                      hintText: '#',
                      controlador: fcNum,
                      autoFocus: true,
                      focusNode: numFijo,
                      maxLength: 2,
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 0, max: 99),
                      ],
                      onChange: (p0) {
                        if (p0!.length == 2) {
                          FocusScope.of(context).requestFocus(moniFijo);
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: TxtInfoSmall(
                      keyboardType: TextInputType.number,
                      hintText: r'$',
                      controlador: fcValorFijo,
                      maxLines: 1,
                      focusNode: moniFijo,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumberTextInputFormatter(maxValue: widget.fijo)
                      ],
                      onChange: (p0) {},
                    ),
                  ),
                  Flexible(
                    child: TxtInfoSmall(
                      keyboardType: TextInputType.number,
                      hintText: r'$',
                      controlador: fcValorCorrido,
                      focusNode: moniCorrido,
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumberTextInputFormatter(maxValue: widget.corrido)
                      ],
                      onChange: (p0) {},
                    ),
                  ),
                ],
                onPressed: () {
                  setState(() {
                    final payCrtl = ref.read(paymentCrtl.notifier);

                    if ((fcNum.text.isEmpty || fcNum.text.length == 1) ||
                        (fcValorFijo.text.isEmpty &&
                            fcValorCorrido.text.isEmpty) ||
                        (fcValorFijo.text == '0' &&
                            fcValorCorrido.text == '0')) {
                      showToast(context, 'Revise los campos por favor');
                      return;
                    }

                    final value = toBlockIfOutOfLimitFCPC[fcNum.text] ?? {};

                    int fijoLimite = int.parse(widget.fijo);
                    int corridoLimite = int.parse(widget.corrido);

                    int dineroFijo = (fcValorFijo.text.intTryParsed ?? 0);
                    int dineroCorrido = (fcValorCorrido.text.intTryParsed ?? 0);

                    bool excedeFijo =
                        ((value['fijo'] ?? 0) + dineroFijo > fijoLimite) ||
                            ((value['corrido'] ?? 0) + dineroCorrido >
                                corridoLimite);

                    if (excedeFijo) {
                      showToast(context,
                          'Los límites están establecido en $fijoLimite y $corridoLimite. No pueden ser excedido');
                      return;
                    }

                    toBlockIfOutOfLimitFCPC.update(fcNum.text, (value) {
                      return {
                        'fijo': value['fijo']! +
                            (fcValorFijo.text.intTryParsed ?? 0),
                        'corrido': value['corrido']! +
                            (fcValorCorrido.text.intTryParsed ?? 0),
                        'corrido2': value['corrido2']!,
                      };
                    }, ifAbsent: () {
                      return {
                        'fijo': fcValorFijo.text.intTryParsed ?? 0,
                        'corrido': fcValorCorrido.text.intTryParsed ?? 0,
                        'corrido2': 0,
                      };
                    });

                    int bruto = dineroFijo + dineroCorrido;

                    int limpioListero =
                        (bruto * (getLimit.porcientoBolaListero / 100)).toInt();

                    payCrtl.totalBruto80 = bruto;
                    payCrtl.limpioListero = limpioListero;

                    widget.listaFijoCorrido.add(
                      FijoCorridoModel.fromTextEditingController(
                        0,
                        uuid: uuid.v4(),
                        numplayy: fcNum.text,
                        fijo: dineroFijo.toString(),
                        corrido: dineroCorrido.toString(),
                      ),
                    );

                    fcNum.text = '';
                    fcValorFijo.text = '';
                    fcValorCorrido.text = '';
                    FocusScope.of(context).requestFocus(numFijo);
                  });
                });
          }),
        ],
      ),
    );
  }
}
