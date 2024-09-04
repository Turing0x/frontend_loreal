// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:sticker_maker/config/controllers/limits_controller.dart';
import 'package:sticker_maker/config/utils_exports.dart';
import 'package:sticker_maker/design/common/encabezado.dart';
import 'package:sticker_maker/design/common/txt_para_info.dart';
import 'package:sticker_maker/models/Limites/limits_model.dart';

final limitsControllers = LimitsControllers();

class GlobalLimits extends StatefulWidget {
  const GlobalLimits({super.key});

  @override
  State<GlobalLimits> createState() => _GlobalLimitsState();
}

class _GlobalLimitsState extends State<GlobalLimits> {
  TextEditingController limits_Corrido = TextEditingController();
  TextEditingController limits_Centena = TextEditingController();
  TextEditingController limits_Parle = TextEditingController();
  TextEditingController limits_Fijo = TextEditingController();

  TextEditingController limites_millon_Fijo = TextEditingController();
  TextEditingController limites_millon_Corrido = TextEditingController();

  @override
  void initState() {
    Future<List<Limits>> forLimits = limitsControllers.getDataLimits();
    forLimits.then((value) => {
          if (value.isNotEmpty)
            {
              limits_Fijo.text = value[0].fijo.toString(),
              limits_Corrido.text = value[0].corrido.toString(),
              limits_Centena.text = value[0].centena.toString(),
              limits_Parle.text = value[0].parle.toString(),
              limites_millon_Fijo.text = value[0].limitesmillonFijo.toString(),
              limites_millon_Corrido.text =
                  value[0].limitesmillonCorrido.toString(),
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textoDosis('Configuración de límites', 24, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (() {
              FocusScope.of(context).unfocus();
              limitsControllers.saveDataLimits(
                limits_Fijo.text,
                limits_Corrido.text,
                limits_Parle.text,
                limits_Centena.text,
                limites_millon_Fijo.text,
                limites_millon_Corrido.text,
              );
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            encabezado(
                context, 'Límites globales por jugada', false, () {}, false),
            columnlimits(),
            columnLimitesMillon()
          ],
        ),
      ),
    );
  }

  Column columnlimits() {
    return Column(children: [
      TxtInfo(
          texto: 'Para el Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Parle:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Parle,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para la Centena:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Centena,
          onChange: (valor) => setState(() {})),
    ]);
  }

  Column columnLimitesMillon() {
    return Column(children: [
      encabezado(context, 'Límites para Raspaito', false, () => null, false),
      TxtInfo(
          texto: 'Para el Fijo:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limites_millon_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Corrido:',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limites_millon_Corrido,
          onChange: (valor) => setState(() {})),
    ]);
  }
}
