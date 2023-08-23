import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

Widget noData(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Center(
      child: Column(
    children: [
      Container(
        height: size.height * 0.2,
        margin: EdgeInsets.only(
            left: size.width * .09,
            right: size.width * .09,
            top: size.width * .35,
            bottom: 20),
        child: SvgPicture.asset('lib/assets/undraw_empty_re_opql.svg'),
      ),
      textoDosis('No hay datos para mostrar', 20),
    ],
  ));
}
