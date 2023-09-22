import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/methods/update_methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/Release/release_version_widget.dart';
import 'package:r_upgrade/r_upgrade.dart';

PopupMenuItem<String> buscarActualizacion(
  Color colorPopup,
  BuildContext context,
) {
  return PopupMenuItem(
    child: ListTile(
      leading: Icon(
        Icons.update,
        color: colorPopup,
      ),
      title: Text(
        'Buscar actualización',
        style: TextStyle(
          color: colorPopup,
        ),
      ),
      onTap: () => mostrarDialogo(
        context,
        title: 'Actualización disponible',
        widgetTitle: Consumer(
          builder: (_, ref, __) {
            final releaseActual = ref.watch(release);
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: !releaseActual.buscandoRelease
                  ? () async {
                      final id = await RUpgrade.getLastUpgradedId();
                      if (id != null) {
                        await RUpgrade.cancel(id);
                      }
                      await buscarActualizacionMethod(ref);
                    }
                  : null,
            );
          },
        ),
        shape: shape(),
        titleBoton: 'Aceptar',
        mostrarCancelar: false,
        onPressed: () => Navigator.pop(context),
        content: SizedBox(
          width: MediaQuery.of(context).size.height * 0.7,
          child: const ReleaseVersionsWidget(),
        ),
      ),
    ),
  );
}
