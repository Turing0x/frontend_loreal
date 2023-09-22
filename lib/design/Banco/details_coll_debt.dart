import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/database/collections_debt/type_coll_debt/type_provider.dart';
import 'package:frontend_loreal/config/extensions/string_extensions.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:frontend_loreal/design/common/no_data.dart';
import 'package:frontend_loreal/design/common/waiting_page.dart';

int total = 0;

class DetailsCollsDebt extends StatefulWidget {
  const DetailsCollsDebt({super.key, 
    required this.id,
    required this.percent});

  final String id;
  final String percent;

  @override
  State<DetailsCollsDebt> createState() => _DetailsCollsDebtState();
}

class _DetailsCollsDebtState extends State<DetailsCollsDebt> {

  TextEditingController percentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        if( total != 0 ){
          total = 0;
          return true;
        }

        return true;
      },
      child: Scaffold(
        appBar: showAppBar('Historial de entradas'),
        body: ShowList( debtId: widget.id, percent: widget.percent, ),
      ),
    );
  }
}


class ShowList extends StatefulWidget {
  const ShowList({super.key,
    required this.debtId, 
    required this.percent});

  final String debtId;
  final String percent;

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {

  TextEditingController plusDebtCtrl = TextEditingController();
  TextEditingController lessDebtCtrl = TextEditingController();

  List<String> list = [];

  int pierde = 0;
  int gana = 0;

  @override
  Widget build(BuildContext context) {

    double per = widget.percent.intParsed / 100;

    return Scaffold(
      body: Column( mainAxisSize: MainAxisSize.min,
        children: [

          Visibility(
            visible: total != 0,
            child: columnCals(per)),

          Flexible(
            child: FutureBuilder(
              future: DBProviderTypeCollectiosDebt.db.getAllCollectionsDebtByOwner(widget.debtId),
              builder: (context, snapshot) {
          
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingWidget(context);
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return noData(context);
                }
              
                final data = snapshot.data!;
              
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
          
                    String typeDebt = data[index].typeDebt;
                    
                    return GestureDetector(
                      onDoubleTap: () {
                        if( list.contains(data[index].id) ){
                          setState(() {

                            list.remove(data[index].id);
                            total -= data[index].debt.intParsed;

                            if( data[index].typeDebt == 'Pierde' ){
                              pierde -= data[index].debt.intParsed;
                            }else {
                              if( data[index].typeDebt == 'Gana' ){
                                gana -= data[index].debt.intParsed;
                              }
                            }

                          });
                        }else{
                          setState(() {
                            list.add(data[index].id);
                            total += data[index].debt.intParsed;

                            if( data[index].typeDebt == 'Pierde' ){
                              pierde += data[index].debt.intParsed;
                            }else {
                              if( data[index].typeDebt == 'Gana' ){
                                gana += data[index].debt.intParsed;
                              }
                            }

                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        height: 80,
                        color: (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                        alignment: Alignment.center,
                        child: ListTile(
                          horizontalTitleGap: 30,
                          title: textoDosis(data[index].debt, 32, fontWeight: FontWeight.bold, 
                            color: ( typeDebt == 'Pierde' ) ? Colors.green : Colors.red),
                          subtitle: textoDosis(typeDebt, 18),
                          trailing: dayAndJornal(data[index].date, data[index].jornal),
                          leading: ( list.contains(data[index].id) )
                            ? const Icon(Icons.check, color: Colors.green)
                            : null
                        ),
                          
                      ),
                    );
                
                  }
                
                );
                
              },
              
            ),
          ),
        ],
      ),

    );

  }

  Column columnCals(double per) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Row( 
          mainAxisSize: MainAxisSize.min,
          children: [
            boldLabel('Pierde total: ', pierde.toString(), 20),
            const SizedBox(width: 20),
            boldLabel('Gana total: ', gana.toString(), 20),
          ],
        ),

        ( pierde > gana )
          ? textoDosis('$total % ${widget.percent} = ${(total * per).toStringAsFixed(2)}', 20)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: textoDosis('No hay beneficio, el Gana es mayor que el Pierde', 20, maxLines: 2, textAlign: TextAlign.center),
            ),
      ],
    );
  }

  Column dayAndJornal(String date, String jornal) {
    return Column(
      children: [
        textoDosis(date, 20),
        (jornal == 'dia')
          ? const Icon(
              Icons.light_mode_outlined,
              color: Colors.black,
            )
          : const Icon(
              Icons.nights_stay_outlined,
              color: Colors.black,
            )
      ],
    );
  }

}