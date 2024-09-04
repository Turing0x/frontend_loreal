import 'package:frontend_loreal/config/database/collections_debt/coll_debt/debt_bloc.dart';
import 'package:frontend_loreal/config/database/collections_debt/coll_debt/debt_provider.dart';
import 'package:frontend_loreal/config/database/collections_debt/type_coll_debt/type_bloc.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/globals/variables.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/txt_para_info.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';
import 'package:uuid/uuid.dart';

import 'package:frontend_loreal/config/database/collections_debt/coll_debt/coll_debt_model.dart';
import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/riverpod/declarations.dart';
import 'package:frontend_loreal/config/utils_exports.dart';

class ColectorsDebtPage extends StatefulWidget {
  const ColectorsDebtPage({super.key});

  @override
  State<ColectorsDebtPage> createState() => _ColectorsDebtPageState();
}

class _ColectorsDebtPageState extends State<ColectorsDebtPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController initialCahsCtrl = TextEditingController(text: '0');
  TextEditingController percentCtrl = TextEditingController(text: '10');

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Deudas de colecciones', actions: [
        IconButton(
            onPressed: () => setState(() {
                  flag = !flag;
                }),
            icon: const Icon(Icons.add_box_outlined)),
        IconButton(
            onPressed: () async {
              final collsDebt = CollectionsDebtBloc();
              final typecollsDebt = TypeCollectionsDebtBloc();

              collsDebt.deleteFull();
              typecollsDebt.deleteFull();
              showToast(
                  context, 'Todos los datos fueron eliminados correctamente',
                  type: true);

              cambioListas.value = !cambioListas.value;
            },
            icon: const Icon(Icons.delete_forever_outlined))
      ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [newCollection(), const ShowList()],
        ),
      ),
    );
  }

  Visibility newCollection() {
    return Visibility(
      visible: flag,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: textoDosis('Nueva colección a controlar', 20,
                fontWeight: FontWeight.bold),
          ),
          TxtInfo(
              texto: 'Colección:*',
              keyboardType: TextInputType.name,
              controlador: nameCtrl,
              icon: Icons.collections_bookmark,
              onChange: (valor) => (() {})),
          const SizedBox(height: 10),
          TxtInfo(
              texto: 'Deuda inicial:*',
              keyboardType: TextInputType.number,
              controlador: initialCahsCtrl,
              icon: Icons.monetization_on_outlined,
              onChange: (valor) => (() {})),
          TxtInfo(
              texto: 'Porcentaje:*',
              keyboardType: TextInputType.number,
              controlador: percentCtrl,
              icon: Icons.monetization_on_outlined,
              onChange: (valor) => (() {})),
          btnWithIcon(context, Colors.blue, const Icon(Icons.add_box_outlined),
              'Añadir coleccion', () async {
            String collName = nameCtrl.text.trim();

            final collsDebt = CollectionsDebtBloc();
            if (nameCtrl.text.isEmpty ||
                percentCtrl.text.isEmpty ||
                initialCahsCtrl.text.isEmpty) {
              showToast(context, 'Faltan datos para crear esta colección');
              return;
            }

            if (percentCtrl.text == '0') {
              showToast(context, 'El prociento inicial debe ser distinto de 0');
              return;
            }

            if (await collsDebt.getCollByName(collName)) {
              if (mounted) {
                showToast(context, 'Ya existe una colección con ese nombre');
              }
              return;
            }

            final typecollsDebt = TypeCollectionsDebtBloc();

            const uuid = Uuid();
            String id = uuid.v4();

            int res = await collsDebt.addCollDebt(
                id, collName, initialCahsCtrl.text, percentCtrl.text);

            if (initialCahsCtrl.text != '0') {
              await typecollsDebt.addTypeCollDebt(uuid.v4(), id, 'Pierde',
                  initialCahsCtrl.text, jornalGlobal, todayGlobal);
            }

            if (res == 0 && mounted) {
              showToast(
                  context, 'Ha ocurrido un error al agregar la colección');
              return;
            }

            if (mounted) {
              showToast(context, 'La colección ha sido agregada correctamente',
                  type: true);
            }

            nameCtrl.text = '';
            initialCahsCtrl.text = '';
            percentCtrl.text = '';

            cambioListas.value = !cambioListas.value;
          }, MediaQuery.of(context).size.width * 0.6),
          divisor,
        ],
      ),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  TextEditingController plusDebtCtrl = TextEditingController();
  TextEditingController lessDebtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ValueListenableBuilder(
        valueListenable: cambioListas,
        builder: (context, value, child) {
          return FutureBuilder(
            future: DBProviderCollectiosDebt.db.getAllCollectionsDebt(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return waitingWidget(context);
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return noData(context);
              }

              final data = snapshot.data;

              return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: 80,
                      color:
                          (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListTile(
                          title: textoDosis(data[index].name, 25,
                              fontWeight: FontWeight.bold),
                          subtitle:
                              boldLabel('Deuda actual: ', data[index].debt, 20),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              btnPierde(context, data, index),
                              btnGana(context, data, index),
                              btnRestart(data, index, context),
                            ],
                          ),
                          onTap: () => Navigator.of(context).pushNamed(
                              'details_colls_debt',
                              arguments: [data[index].id, data[index].percent]),
                          onLongPress: () => showInfoDialog(
                              context,
                              'Eliminación de deuda',
                              FittedBox(
                                  child: textoDosis(
                                      'Está seguro que desea eliminar esta deuda?',
                                      20)), () {
                            DBProviderCollectiosDebt.db
                                .collectionDelete(data[index].id);

                            cambioListas.value = !cambioListas.value;
                            Navigator.of(context, rootNavigator: true).pop();
                          }),
                        ),
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }

  IconButton btnPierde(
      BuildContext context, List<CollectionDebtModel> data, int index) {
    return IconButton(
        onPressed: () => showInfoDialog(
                context,
                'Aumentar la deuda',
                TxtInfo(
                    texto: '',
                    keyboardType: TextInputType.number,
                    controlador: plusDebtCtrl,
                    icon: Icons.add,
                    onChange: (valor) => (() {})), () {
              if (plusDebtCtrl.text.isNotEmpty) {
                final typecollsDebt = TypeCollectionsDebtBloc();

                const uuid = Uuid();
                String id = uuid.v4();

                int calc =
                    data[index].debt.intParsed + plusDebtCtrl.text.intParsed;

                DBProviderCollectiosDebt.db
                    .updateCollDebt(data[index].id, calc.toString());

                typecollsDebt.addTypeCollDebt(id, data[index].id, 'Pierde',
                    plusDebtCtrl.text, jornalGlobal, todayGlobal);
              }
              cambioListas.value = !cambioListas.value;
              plusDebtCtrl.text = '';
              Navigator.of(context, rootNavigator: true).pop();
            }),
        icon: const Icon(
          Icons.add_box_outlined,
          color: Colors.green,
        ));
  }

  IconButton btnGana(
      BuildContext context, List<CollectionDebtModel> data, int index) {
    return IconButton(
        onPressed: () => showInfoDialog(
                context,
                'Reducir la deuda',
                TxtInfo(
                    texto: '',
                    keyboardType: TextInputType.number,
                    controlador: lessDebtCtrl,
                    icon: Icons.remove,
                    onChange: (valor) => (() {})), () {
              if (lessDebtCtrl.text.isNotEmpty) {
                final typecollsDebt = TypeCollectionsDebtBloc();

                const uuid = Uuid();
                String id = uuid.v4();

                int calc =
                    data[index].debt.intParsed - lessDebtCtrl.text.intParsed;

                DBProviderCollectiosDebt.db
                    .updateCollDebt(data[index].id, calc.toString());

                typecollsDebt.addTypeCollDebt(id, data[index].id, 'Gana',
                    lessDebtCtrl.text, jornalGlobal, todayGlobal);
              }

              cambioListas.value = !cambioListas.value;
              lessDebtCtrl.text = '';
              Navigator.of(context, rootNavigator: true).pop();
            }),
        icon: const Icon(
          Icons.remove_circle_outline,
          color: Colors.red,
        ));
  }

  IconButton btnRestart(
      List<CollectionDebtModel> data, int index, BuildContext context) {
    return IconButton(
        onPressed: () {
          if (data[index].debt != '0') {
            showInfoDialog(
                context,
                'Reiniciar deuda',
                FittedBox(
                    child: textoDosis(
                        'Está seguro que desea reiniciar a 0 esta deuda?', 20)),
                () {
              final typecollsDebt = TypeCollectionsDebtBloc();

              DBProviderCollectiosDebt.db.updateCollDebt(data[index].id, '0');

              typecollsDebt.deleteCollDebt(data[index].id);

              cambioListas.value = !cambioListas.value;
              Navigator.of(context, rootNavigator: true).pop();
            });
          }
        },
        icon: const Icon(Icons.refresh_rounded, color: Colors.blue));
  }
}
