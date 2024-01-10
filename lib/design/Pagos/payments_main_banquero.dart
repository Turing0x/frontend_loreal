// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/payments_controller.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:frontend_loreal/models/Pagos/payments_model.dart';

final paymentsControllers = PaymentsControllers();

class ConfigPaymentsPage extends StatefulWidget {
  const ConfigPaymentsPage({super.key});

  @override
  State<ConfigPaymentsPage> createState() => _ConfigPaymentsPageState();
}

class _ConfigPaymentsPageState extends State<ConfigPaymentsPage> {
  // columnpagos_jugada
  TextEditingController pagos_jugada_Corrido = TextEditingController();
  TextEditingController pagos_jugada_Centena = TextEditingController();
  TextEditingController pagos_jugada_Parle = TextEditingController();
  TextEditingController pagos_jugada_Fijo = TextEditingController();

  // columnLimitados
  TextEditingController limitados_Corrido = TextEditingController();
  TextEditingController limitados_Parle = TextEditingController();
  TextEditingController limitados_Fijo = TextEditingController();

  // columnMillon
  TextEditingController pagos_millon_Corrido = TextEditingController();
  TextEditingController pagos_millon_Fijo = TextEditingController();

  // columnPorcentajes
  TextEditingController porciento_parle_listero = TextEditingController();
  TextEditingController porciento_bola_listero = TextEditingController();

  // columnOthers
  TextEditingController exprense = TextEditingController();

  @override
  void initState() {
    Future<List<Payments>> forPayments = paymentsControllers.getDataPayments();
    forPayments.then((value) => {
          if (value.isNotEmpty)
            {
              pagos_jugada_Corrido.text =
                  value[0].pagosJugadaCorrido.toString(),
              pagos_jugada_Centena.text =
                  value[0].pagosJugadaCentena.toString(),
              pagos_jugada_Parle.text = value[0].pagosJugadaParle.toString(),
              pagos_jugada_Fijo.text = value[0].pagosJugadaFijo.toString(),
              pagos_millon_Fijo.text = value[0].pagosMillonFijo.toString(),
              pagos_millon_Corrido.text =
                  value[0].pagosMillonCorrido.toString(),
              limitados_Corrido.text = value[0].limitadosCorrido.toString(),
              limitados_Parle.text = value[0].limitadosParle.toString(),
              limitados_Fijo.text = value[0].limitadosFijo.toString(),
              porciento_parle_listero.text = value[0].parleListero.toString(),
              porciento_bola_listero.text = value[0].bolaListero.toString(),
              exprense.text = value[0].exprense.toString()
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textoDosis('Pagos por jugada', 24, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (() {
              paymentsControllers.saveDataPayments(
                  pagos_jugada_Corrido.text,
                  pagos_jugada_Centena.text,
                  pagos_jugada_Parle.text,
                  pagos_jugada_Fijo.text,
                  pagos_millon_Fijo.text,
                  pagos_millon_Corrido.text,
                  limitados_Corrido.text,
                  limitados_Parle.text,
                  limitados_Fijo.text,
                  porciento_parle_listero.text,
                  porciento_bola_listero.text,
                  exprense.text);
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            columnpagos_jugada(),
            columnMillon(),
            columnLimitados(),
            columnPorcentajes(),
            columnOthers(),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Column columnpagos_jugada() {
    return Column(children: [
      encabezado(context, 'Pagos', false, () => null, false),
      TxtInfo(
          texto: 'Para el Fijo:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Corrido:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Parle:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Parle,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para la Centena:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Centena,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnMillon() {
    return Column(children: [
      encabezado(context, 'Pagos a Raspaito', false, () => null, false),
      TxtInfo(
          texto: 'Para el Fijo:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_millon_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Corrido:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_millon_Corrido,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnLimitados() {
    return Column(children: [
      encabezado(context, 'Limitados', false, () => null, false),
      TxtInfo(
          texto: 'Fijo:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limitados_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Corrido:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limitados_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Parlé:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limitados_Parle,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnPorcentajes() {
    return Column(children: [
      encabezado(context, 'Pagos en porcentaje', false, () => null, false),
      TxtInfo(
          texto: 'Bola listero:',
          
          icon: Icons.percent_outlined,
          keyboardType: TextInputType.number,
          controlador: porciento_bola_listero,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Parlé listero:',
          
          icon: Icons.percent_outlined,
          keyboardType: TextInputType.number,
          controlador: porciento_parle_listero,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnOthers() {
    return Column(children: [
      encabezado(context, 'Otros datos', false, () => null, false),
      TxtInfo(
          texto: 'Gastos:',
          
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: exprense,
          onChange: (valor) => setState(() {}))
    ]);
  }
}
