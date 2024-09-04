// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/controllers/payments_controller.dart';
import 'package:frontend_loreal/config/controllers/time_controller.dart';
import 'package:frontend_loreal/config/server/http/local_storage.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:frontend_loreal/models/Horario/time_model.dart';
import 'package:frontend_loreal/models/Limites/limits_model.dart';
import 'package:frontend_loreal/models/Pagos/payments_model.dart';

class SeePaymentsPage extends StatefulWidget {
  const SeePaymentsPage({super.key});

  @override
  State<SeePaymentsPage> createState() => _ConfigPaymentsPageState();
}

class _ConfigPaymentsPageState extends State<SeePaymentsPage> {
  // columnpagos_jugada
  TextEditingController pagos_jugada_Corrido =
      TextEditingController(text: 'Sin datos');
  TextEditingController pagos_jugada_Centena =
      TextEditingController(text: 'Sin datos');
  TextEditingController pagos_jugada_Parle =
      TextEditingController(text: 'Sin datos');
  TextEditingController pagos_jugada_Fijo =
      TextEditingController(text: 'Sin datos');

  // columnLimits
  TextEditingController limits_Corrido =
      TextEditingController(text: 'Sin datos');
  TextEditingController limits_Centena =
      TextEditingController(text: 'Sin datos');
  TextEditingController limits_Parle = TextEditingController(text: 'Sin datos');
  TextEditingController limits_Fijo = TextEditingController(text: 'Sin datos');

  // columnMillon
  TextEditingController pagos_millon_Corrido =
      TextEditingController(text: 'Sin datos');
  TextEditingController pagos_millon_Fijo =
      TextEditingController(text: 'Sin datos');

  // columnLimitesMillon
  TextEditingController limites_millon_Fijo =
      TextEditingController(text: 'Sin datos');
  TextEditingController limites_millon_Corrido =
      TextEditingController(text: 'Sin datos');

  // columnLimitados
  TextEditingController limitados_Corrido =
      TextEditingController(text: 'Sin datos');
  TextEditingController limitados_Parle =
      TextEditingController(text: 'Sin datos');
  TextEditingController limitados_Fijo =
      TextEditingController(text: 'Sin datos');

  // columnPorcentajes
  TextEditingController porciento_parle_listero =
      TextEditingController(text: 'Sin datos');
  TextEditingController porciento_bola_listero =
      TextEditingController(text: 'Sin datos');

  // columnOthers
  TextEditingController exprense = TextEditingController();

  String role = '';

  @override
  void initState() {
    LocalStorage.getRole().then((value) {
      setState(() {
        role = value!;
      });
    });

    LocalStorage.getUserId()
        .then((value) => {getHisLimits(value!), getHisPayments(value)});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              textoDosis('Parámetros establecidos', 24, color: Colors.white)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            toGetTimeSettings(),
            columnpagos_jugada(),
            columnMillon(),
            columnlimites_jugada(),
            columnLimitesMillon(),
            columnLimitados(),
            columnPorcentajes(),
            (role == 'listero') ? Container() : columnOthers(),
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
          readOnly: true,
          texto: 'Para el Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Parle:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Parle,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para la Centena:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_jugada_Centena,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnlimites_jugada() {
    return Column(children: [
      encabezado(context, 'Límites por apuesta', false, () => null, false),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Parle:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Parle,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para la Centena:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Centena,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnMillon() {
    return Column(children: [
      encabezado(context, 'Pagos a Raspaito', false, () => null, false),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_millon_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: pagos_millon_Corrido,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnLimitesMillon() {
    return Column(children: [
      encabezado(context, 'Límites a Raspaito', false, () => null, false),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limites_millon_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Para el Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limites_millon_Corrido,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnLimitados() {
    return Column(children: [
      encabezado(context, 'Limitados', false, () => null, false),
      TxtInfo(
          readOnly: true,
          texto: 'Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limitados_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
          texto: 'Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limitados_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
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
          readOnly: true,
          texto: 'Bola listero:',
          icon: Icons.percent_outlined,
          keyboardType: TextInputType.number,
          controlador: porciento_bola_listero,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          readOnly: true,
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
          readOnly: true,
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: exprense,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Widget toGetTimeSettings() {
    final timeControllers = TimeControllers();
    return FutureBuilder(
        future: timeControllers.getDataTime(),
        builder: (_, AsyncSnapshot<List<Time>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boldLabel('Jornada de la manaña: ', 'Sin datos', 20),
                  boldLabel('Jornada de la tarde: ', 'Sin datos', 20),
                ],
              ),
            );
          }

          final list = snapshot.data!;

          return Container(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boldLabel('Jornada de la manaña: ',
                    '${list[0].dayStart} AM - ${list[0].dayEnd} PM', 20),
                boldLabel('Jornada de la tarde: ',
                    '${list[0].nightStart} PM - ${list[0].nightEnd} PM', 20),
              ],
            ),
          );
        });
  }

  getHisLimits(String userID) {
    final limitsControllers = LimitsControllers();
    Future<List<Limits>> thisUser = limitsControllers.getLimitsOfUser(userID);
    thisUser.then((value) => {
          if (value.isNotEmpty)
            {
              limits_Corrido.text = value[0].corrido.toString(),
              limits_Centena.text = value[0].centena.toString(),
              limits_Parle.text = value[0].parle.toString(),
              limits_Fijo.text = value[0].fijo.toString(),
              limites_millon_Fijo.text = value[0].limitesmillonFijo.toString(),
              limites_millon_Corrido.text =
                  value[0].limitesmillonCorrido.toString(),
            }
        });
  }

  getHisPayments(String userID) {
    final PaymentsControllers paymentsControllers = PaymentsControllers();
    Future<List<Payments>> forPayments =
        paymentsControllers.getPaymentsOfUser(userID);
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
              exprense.text = value[0].exprense.toString(),
            }
        });
  }
}
