import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

Widget waitingWidget(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Center(
      child: Column(
    children: [
      Container(
        height: size.height * 0.2,
        margin: EdgeInsets.only(
            left: size.width * .05,
            right: size.width * .05,
            top: size.width * .35,
            bottom: 20),
        child: SvgPicture.asset('lib/assets/undraw_synchronize_re_4irq.svg'),
      ),
      textoDosis('Procesando información', 18),
      textoDosis('Por favor, espere unos segundos', 18),
    ],
  ));
}
