import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/utils_exports.dart';

Future inProgressModal(BuildContext context, WidgetRef ref) {
  final btnManager = ref.watch(btnManagerR);

  final size = MediaQuery.of(context).size;
  return showDialog(
      context: context,
      builder: (context) => Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: 500,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              textoDosis('Actualización de estado', 25,
                  fontWeight: FontWeight.bold, color: Colors.grey[800]),
              Container(
                  height: 250,
                  margin: EdgeInsets.only(
                      left: size.width * .05,
                      right: size.width * .05,
                      top: size.width * .10,
                      bottom: 20),
                  child: (!btnManager)
                      ? SvgPicture.asset('lib/assets/undraw_agree_re_hor9.svg')
                      : const CircularProgressIndicator()),
              textoDosis('Estamos guardando la lista.', 20),
              textoDosis('Espere unos segundos', 20)
            ]),
          )));
}
