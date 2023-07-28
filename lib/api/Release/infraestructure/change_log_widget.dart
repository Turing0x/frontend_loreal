import 'package:frontend_loreal/methods/update_methods.dart';
import 'package:frontend_loreal/utils_exports.dart';
import 'package:frontend_loreal/widgets/expanded_widget.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:version/version.dart';

class ChangeLogWidget extends StatefulWidget {
  const ChangeLogWidget({
    super.key,
    required this.body,
    this.mostrarAlerta = true,
    this.versionActual,
  });
  final String body;
  final bool mostrarAlerta;
  final Version? versionActual;

  @override
  State<ChangeLogWidget> createState() => _ChangeLogWidgetState();
}

class _ChangeLogWidgetState extends State<ChangeLogWidget> {
  bool primeraVez = true;
  late List<ExpandedTileController> expandeds;
  int pos = 0;
  int sd = 0;

  @override
  void initState() {
    expandeds = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<MapEntry<dynamic, dynamic>>>(
      future: changeLog(
        widget.body,
        actual: widget.versionActual,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (primeraVez) {
          expandeds = List.generate(
            snapshot.data!.length,
            (index) => ExpandedTileController(isExpanded: true),
          );
          primeraVez = false;
        }
        pos = 0;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  textoDosis(
                    'Que trae de nuevo:',
                    18,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...snapshot.data!
                        .map(
                          (e) => ExpandedWidget(
                            title: e.key.toString(),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (e.key.toString().contains('*'))
                                  textoDosis(
                                    '- Esta versión borrará la data'
                                    ' guardada del dispositivo',
                                    13,
                                    fontWeight: FontWeight.normal,
                                    maxLines: 4,
                                    textAlign: TextAlign.start,
                                  ),
                                ...e.value
                                    .toString()
                                    .split('.')
                                    .map(
                                      (value) => textoDosis(
                                        '- $value',
                                        18,
                                        fontWeight: FontWeight.normal,
                                        maxLines: 4,
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                    .toList(),
                                const Divider(),
                              ],
                            ),
                            controller: expandeds[pos++],
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
