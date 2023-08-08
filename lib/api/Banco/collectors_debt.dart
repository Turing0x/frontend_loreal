import 'package:frontend_loreal/database/collections_debt/debt_bloc.dart';
import 'package:frontend_loreal/database/collections_debt/debt_provider.dart';
import 'package:frontend_loreal/extensions/string_extensions.dart';
import 'package:frontend_loreal/utils_exports.dart';

import '../../riverpod/declarations.dart';
import '../../widgets/no_data.dart';
import '../../widgets/waiting_page.dart';

class ColectorsDebtPage extends StatefulWidget {
  const ColectorsDebtPage({super.key});

  @override
  State<ColectorsDebtPage> createState() => _ColectorsDebtPageState();
}

class _ColectorsDebtPageState extends State<ColectorsDebtPage> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController initialCahsCtrl = TextEditingController( text: '0');

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
          onPressed: () async{
            final collsDebt = CollectiosDebtBloc();
            int res = await collsDebt.deleteFull();
            ( res == 0 )
              ? showToast('Ha ocurrido un error al eliminar todos los datos')
              : showToast('Todos los datos fueron eliminados correctamente', type: true);

            cambioListas.value = !cambioListas.value;
          }, 
          icon: const Icon(Icons.delete_forever_outlined))
      ]),
      body: SingleChildScrollView(
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            newCollection(),
      
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 15),
              child: textoDosis(
                'Colecciones con dedudas activas', 
                20, fontWeight: FontWeight.bold),
            ),
      
            const ShowList()
      
          ],
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
            child: textoDosis('Nueva colección a controlar', 20, fontWeight: FontWeight.bold),
          ),
    
          TxtInfo(
            texto: 'Colección:*',
            keyboardType: TextInputType.name,
            controlador: nameCtrl,
            color: Colors.grey[200],
            icon: Icons.collections_bookmark,
            onChange: (valor) => (() {})),
    
          const SizedBox(height: 10),
          
          TxtInfo(
            texto: 'Deuda inicial:*',
            keyboardType: TextInputType.number,
            controlador: initialCahsCtrl,
            color: Colors.grey[200],
            icon: Icons.monetization_on_outlined,
            onChange: (valor) => (() {})),

          btnWithIcon(
            context,
            Colors.blue,
            const Icon(Icons.add_box_outlined),
            'Añadir coleccion',
            () async{

              if( nameCtrl.text.isEmpty ){
                showToast('Debe establecer un nombre para la coleccion');
                return;
              }

              final collsDebt = CollectiosDebtBloc();
              int res = await collsDebt.addCollDebt(nameCtrl.text, initialCahsCtrl.text);
              
              if( res == 0 ){
                showToast('Ha ocurrido un error al agregar la colección');
                return;
              }

              showToast('La colección ha sido agregada correctamente', type: true);
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
                    color: (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ListTile(
                      
                        title: textoDosis(data[index].name, 25, fontWeight: FontWeight.bold),
                        subtitle: boldLabel('Deuda actual: ', data[index].debt, 20),
                        trailing: Row( mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
    
                            IconButton(
                              onPressed: () => showInfoDialog(
                                context, 'Aumentar la deuda',
                                TxtInfo(
                                  texto: '',
                                  keyboardType: TextInputType.number,
                                  controlador: plusDebtCtrl,
                                  color: Colors.grey[200],
                                  icon: Icons.add,
                                  onChange: (valor) => (() {})),
                                () {
    
                                  if( plusDebtCtrl.text.isNotEmpty ){
                                    
                                    DBProviderCollectiosDebt.db
                                      .updateCollDebt(data[index].id, {
                                        'name': data[index].name,
                                        'debt': data[index].debt.intParsed 
                                          + plusDebtCtrl.text.intParsed
                                      });
                                        
                                  }
                                  cambioListas.value = !cambioListas.value;
                                  Navigator.of(context, rootNavigator: true).pop();
                                }), 
                              icon: const Icon(Icons.add_box_outlined, color: Colors.green,)),
    
                            IconButton(
                              onPressed: () => showInfoDialog(
                                context, 'Reducir la deuda',
                                TxtInfo(
                                  texto: '',
                                  keyboardType: TextInputType.number,
                                  controlador: lessDebtCtrl,
                                  color: Colors.grey[200],
                                  icon: Icons.remove,
                                  onChange: (valor) => (() {})),
                                () {
    
                                  if( lessDebtCtrl.text.isNotEmpty ){
                                    
                                    DBProviderCollectiosDebt.db
                                      .updateCollDebt(data[index].id, {
                                        'name': data[index].name,
                                        'debt': data[index].debt.intParsed 
                                          - lessDebtCtrl.text.intParsed
                                      });
                                        
                                  }
    
                                  cambioListas.value = !cambioListas.value;
                                  Navigator.of(context, rootNavigator: true).pop();
    
                                }), 
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red,)),
                            
                            IconButton(
                              onPressed: () {
                                if( data[index].debt != '0' ){
                                  showInfoDialog(
                                    context, 'Reiniciar deuda',
                                    FittedBox(
                                        child: textoDosis(
                                            'Está seguro que desea reiniciar a 0 esta deuda?', 20)),
                                    () {
    
                                      DBProviderCollectiosDebt.db
                                        .updateCollDebt(data[index].id, {
                                          'name': data[index].name,
                                          'debt': 0
                                        });
                                      
                                      cambioListas.value = !cambioListas.value;
                                      Navigator.of(context, rootNavigator: true).pop();
                                      
                                    });
                                }
                              },
                                
                              icon: const Icon(Icons.refresh_rounded, color: Colors.blue)),
    
                          ],
                        ),
                        onLongPress: () => showInfoDialog(
                          context, 'Eliminación de deuda',
                          FittedBox(
                              child: textoDosis(
                                  'Está seguro que desea eliminar esta deuda?', 20)),
                          () {
                            DBProviderCollectiosDebt.db
                              .collectionDelete(data[index].id);
                            
                            cambioListas.value = !cambioListas.value;
                          }),
                                      
                      ),
    
                    ),
                  
                  );
              
                }
              
              );
              
            },
    
          );
        
        },
      
      ),
    );

  }
}