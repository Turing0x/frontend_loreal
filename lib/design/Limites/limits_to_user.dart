// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/controllers/limits_controller.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/encabezado.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:frontend_loreal/models/Limites/limits_model.dart';

final limitsControllers = LimitsControllers();
class LimitsToUser extends StatefulWidget {
  final String userID;
  final String username;

  const LimitsToUser({super.key, required this.userID, required this.username});

  @override
  State<LimitsToUser> createState() => _LimitsToUserState();
}

class _LimitsToUserState extends State<LimitsToUser> {
  TextEditingController limits_Corrido = TextEditingController();
  TextEditingController limits_Centena = TextEditingController();
  TextEditingController limits_Parle = TextEditingController();
  TextEditingController limits_Fijo = TextEditingController();

  TextEditingController limites_millon_Fijo = TextEditingController();
  TextEditingController limites_millon_Corrido = TextEditingController();

  @override
  void initState() {
    getHisLimits(widget.userID);
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
              limitsControllers.editLimitsOfUser(
                  limits_Fijo.text,
                  limits_Corrido.text,
                  limits_Parle.text,
                  limits_Centena.text,
                  limites_millon_Fijo.text,
                  limites_millon_Corrido.text,
                  widget.userID);
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            encabezado(context, 'Límites para ${widget.username}', false, () {},
                false),
            columnlimits(),
            columnLimitesMillon(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: btnWithIcon(
                      context,
                      Colors.red[300],
                      const Icon(Icons.numbers_outlined),
                      'Bolas',
                      () => Navigator.pushNamed(context, 'limited_ball_to_user',
                          arguments: [widget.userID]), MediaQuery.of(context).size.width * 0.7),
                ),
                SizedBox(
                  width: 150,
                  child: btnWithIcon(
                      context,
                      Colors.blue[300],
                      const Icon(Icons.numbers_outlined),
                      'Parles',
                      () => Navigator.pushNamed(
                          context, 'limited_parle_to_user',
                          arguments: [widget.userID]), MediaQuery.of(context).size.width * 0.7),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column columnlimits() {
    return Column(children: [
      TxtInfo(
          texto: 'Para el Fijo:',
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Corrido:',
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Corrido,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Parle:',
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limits_Parle,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para la Centena:',
          color: Colors.grey[200],
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
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limites_millon_Fijo,
          onChange: (valor) => setState(() {})),
      TxtInfo(
          texto: 'Para el Corrido:',
          color: Colors.grey[200],
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          controlador: limites_millon_Corrido,
          onChange: (valor) => setState(() {})),
    ]);
  }

  getHisLimits(String userID) {
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
}
