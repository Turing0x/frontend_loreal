import 'package:flutter/material.dart';
import 'package:frontend_loreal/design/Release/popup_wdiget_release.dart';
import 'package:frontend_loreal/models/Release/buscar_actualizacion.dart';
import 'package:frontend_loreal/models/Release/version_app.dart';

class PopupLogin extends StatelessWidget {
  const PopupLogin({super.key});

  @override
  Widget build(BuildContext context) {
    const colorPopup = Colors.black;
    return PopupWidgetRelease(
      iconColor: Colors.black,
      icono: Icons.settings,
      opacity: 0.5,
      items: [
        buscarActualizacion(colorPopup, context),
        versionApp(colorPopup, context),
      ],
    );
  }
}
