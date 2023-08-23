import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:lottie/lottie.dart';

Future infoModal(BuildContext context, AnimationController controller,
    {String titulo = '', String imagePath = '', String desciption = ''}) {
  final size = MediaQuery.of(context).size;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textoDosis(titulo, 25,
                        fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    Container(
                      height: 250,
                      margin: EdgeInsets.only(
                          left: size.width * .05,
                          right: size.width * .05,
                          top: size.width * .10,
                          bottom: 20),
                      child: Lottie.asset(imagePath, onLoaded: (p0) {
                        controller.duration = p0.duration;
                        controller.forward();
                      }, controller: controller),
                    ),
                    FittedBox(
                        child: textoDosis(desciption, 18,
                            textAlign: TextAlign.center)),
                  ]),
            ),
          )));
}
