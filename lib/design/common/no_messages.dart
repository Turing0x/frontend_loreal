import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget noMessages(BuildContext context) {
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
        child: SvgPicture.asset('lib/assets/no_messages.svg'),
      ),
      textoDosis('Aún no tiene conversaciones activas', 20),
    ],
  ));
}
