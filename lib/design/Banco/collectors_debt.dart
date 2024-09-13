import 'package:sticker_maker/config/database/collections_debt/coll_debt/debt_bloc.dart';
import 'package:sticker_maker/config/database/collections_debt/coll_debt/debt_provider.dart';
import 'package:sticker_maker/config/database/collections_debt/type_coll_debt/type_bloc.dart';
import 'package:sticker_maker/design/common/no_data.dart';
import 'package:sticker_maker/design/common/txt_para_info.dart';
import 'package:sticker_maker/design/common/waiting_page.dart';
import 'package:uuid/uuid.dart';

import 'package:sticker_maker/config/database/collections_debt/coll_debt/coll_debt_model.dart';
import 'package:flutter/material.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/utils_exports.dart';

class ColectorsDebtPage extends StatefulWidget {
  const ColectorsDebtPage({super.key});

  @override
  State<ColectorsDebtPage> createState() => _ColectorsDebtPageState();
}

class _ColectorsDebtPageState extends State<ColectorsDebtPage> {
  TextEditingController nameCtrl = TextEditingController();

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
          btnWithIcon(context, Colors.blue, const Icon(Icons.add_box_outlined),
              'Añadir coleccion', () async {
            String collName = nameCtrl.text.trim();

            final collsDebt = CollectionsDebtBloc();
            if (nameCtrl.text.isEmpty) {
              showToast(context, 'Faltan datos para crear esta colección');
              return;
            }

            if (await collsDebt.getCollByName(collName)) {
              if (mounted) {
                showToast(context, 'Ya existe una colección con ese nombre');
              }
              return;
            }

            const uuid = Uuid();
            String id = uuid.v4();

            int res = await collsDebt.addCollDebt(id, collName);

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
            cambioListas.value = !cambioListas.value;
            flag = !flag;
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
                          subtitle: boldLabel('Deuda actual: ', '12', 20),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              btnPierde(context, data, index),
                            ],
                          ),
                          onTap: () => Navigator.of(context).pushNamed(
                              'details_colls_debt',
                              arguments: [data[index].id, '12']),
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

                DBProviderCollectiosDebt.db
                    .updateCollDebt(data[index].id, '12');

                // typecollsDebt.addTypeCollDebt(id, data[index].id, 'Pierde',
                //     plusDebtCtrl.text, jornalGlobal, todayGlobal);
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
}
