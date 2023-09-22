import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/methods/update_methods.dart';
import 'package:flutter/services.dart';
import 'package:frontend_loreal/design/Release/change_log_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../config/utils_exports.dart';

PopupMenuItem<String> versionApp(
  Color colorPopup,
  BuildContext context,
) {
  return PopupMenuItem(
    child: ListTile(
      leading: Icon(
        Icons.search,
        color: colorPopup,
      ),
      title: Text(
        'Versión actual',
        style: TextStyle(
          color: colorPopup,
        ),
      ),
      onTap: () {
        rootBundle.loadString('lib/assets/change_log/change_log.json').then(
              (body) => mostrarDialogo(
                context,
                title: 'Versión actual',
                mostrarCancelar: false,
                shape: shape(),
                titleBoton: 'Aceptar',
                onPressed: () => Navigator.pop(context),
                content: FutureBuilder(
                  future: getAppVersion(),
                  builder: (_, AsyncSnapshot<PackageInfo> data) {
                    if (!data.hasData) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                    const size = 15.0;
                    return SizedBox(
                      width: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          boldLabel(
                            'Versión: ',
                            data.data!.version,
                            size,
                          ),
                          boldLabel(
                            'Número de compilación: ',
                            data.data!.buildNumber,
                            size,
                          ),
                          ChangeLogWidget(
                            body: body,
                            mostrarAlerta: false,
                            versionActual: Version(1, 0, 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
      },
    ),
  );
}
