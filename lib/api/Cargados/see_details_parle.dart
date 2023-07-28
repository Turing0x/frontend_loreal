import 'package:frontend_loreal/api/Cargados/models/cargados_model.dart';
import 'package:frontend_loreal/utils_exports.dart';

class SeeDetailsParlesCargados extends StatefulWidget {
  const SeeDetailsParlesCargados({
    super.key,
    required this.bola,
    required this.fijo,
    required this.total,
    required this.listeros,
  });

  final String bola;
  final String fijo;
  final String total;
  final List<Listero> listeros;

  @override
  State<SeeDetailsParlesCargados> createState() =>
      _SeeDetailsParlesCargadosState();
}

class _SeeDetailsParlesCargadosState extends State<SeeDetailsParlesCargados> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Revisión por listas'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dinamicGroupBox('Detalles del parle', [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boldLabel('Parle: ', widget.bola.replaceAll(',', ' -- '), 30),
                  const SizedBox(width: 20),
                  boldLabel('Total: ', widget.total, 20)
                ],
              ),
            ]),
            encabezado(
                context, 'Listas donde aparece', false, () => null, false),
            SizedBox(
              width: double.infinity,
              height: 700,
              child: ListView.builder(
                  itemCount: widget.listeros.length,
                  itemBuilder: (context, index) {
                    widget.listeros.sort((a, b) => b.total - a.total);

                    String username =
                        widget.listeros[index].username.toString();
                    String total = widget.listeros[index].total.toString();

                    return ExpansionTile(
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textoDosis(' $username ', 23,
                                fontWeight: FontWeight.bold),
                            textoDosis(' -> $total ', 23,
                                fontWeight: FontWeight.bold),
                          ]),
                      trailing: Icon(
                        customTileExpanded
                            ? Icons.arrow_drop_down_circle
                            : Icons.arrow_drop_down,
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() => customTileExpanded = expanded);
                      },
                      children: widget.listeros[index].separados.map((value) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                textoDosis('${value.fijo} ', 20),
                                textoDosis(' -> ${value.fijo} ', 20,
                                    fontWeight: FontWeight.bold),
                              ]),
                        );
                      }).toList(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
