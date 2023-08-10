import '../../database/collections_debt/debt_provider.dart';
import '../../widgets/waiting_page.dart';
import '../../widgets/no_data.dart';
import '../../utils_exports.dart';

class DetailsCollsDebt extends StatelessWidget {
  const DetailsCollsDebt({super.key, 
    required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Historial de entradas'),
      body: ShowList( debtId: id ),
    );
  }
}


class ShowList extends StatefulWidget {
  const ShowList({super.key,
    required this.debtId});

  final String debtId;

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
      child: FutureBuilder(
        future: DBProviderCollectiosDebt.db.getDebt(widget.debtId),
        builder: (context, snapshot) {
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return waitingWidget(context);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context);
          }
    
          final data = snapshot.data!.first.listDebt;
    
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              
              return Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: 80,
                color: (index % 2 != 0) ? Colors.grey[200] : Colors.grey[50],
                alignment: Alignment.center,
                child: ListTile(
                  horizontalTitleGap: 30,
                  title: textoDosis(data[index].debt, 32, fontWeight: FontWeight.bold),
                  subtitle: textoDosis(data[index].typeDebt, 18),
                  trailing: dayAndJornal(data[index].date, data[index].jornal)
                )
                  
              );
          
            }
          
          );
          
        },
    
      ),

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