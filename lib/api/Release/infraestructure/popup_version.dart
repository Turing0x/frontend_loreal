import 'package:frontend_loreal/api/Release/domain/buscar_actualizacion.dart';
import 'package:frontend_loreal/api/Release/domain/version_app.dart';
import 'package:frontend_loreal/api/Release/infraestructure/popup_wdiget_release.dart';
import 'package:flutter/material.dart';

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
