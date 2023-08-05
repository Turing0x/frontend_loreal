// ignore_for_file: non_constant_identifier_names
import '../../Payments/toServer/payments_controller.dart';
import '../../DrawList/Calcs/models/calcs_model.dart';
import '../../Payments/domain/payments_model.dart';
import '../../DrawList/export_all.dart';
import '../../../utils_exports.dart';
import '../domain/list_model.dart';

class ListReviewPage extends StatefulWidget {
  const ListReviewPage({super.key,
   required this.infoList,
   required this.lotIncoming});

  final BoliList infoList;
  final String lotIncoming;

  @override
  State<ListReviewPage> createState() => _ListReviewPageState();
}

class _ListReviewPageState extends State<ListReviewPage> {

  // columnpagos_jugada
  String pagos_jugada_Corrido = '';
  String pagos_jugada_Centena = '';
  String pagos_jugada_Parle = '';
  String pagos_jugada_Fijo = '';
  
  // columnPorcentajes
  String porciento_bola_listero = '';
  String porciento_parle_listero = '';

  String username = '';

  int cant = 0;
  int bruto_Fijo = 0;
  int bruto_Corrido = 0;

  List<dynamic> conPremio = [];
  List<dynamic> sinPremio = [];

  bool customTileExpanded = false;
  bool listSelect = true;

  @override
  void initState() {

    Map<String, dynamic> obj = widget.infoList.owner as Map<String, dynamic>;

    getHisPayments(obj['id']);
    username = obj['username'];

    List<dynamic> decoded = boliList(widget.infoList.signature!);
    for (var element in decoded) {
      if( element.runtimeType != CalcsModel ){

        bruto_Fijo += element.fijo as int;
        ( element.dinero != 0 )
          ? conPremio.add(element)
          : sinPremio.add(element);
        
        if( element.runtimeType != CandadoModel && element.runtimeType != ParlesModel ){
          ( element.runtimeType == PosicionModel )
            ? bruto_Corrido += ( element.corrido + element.corrido2 ) as int
            : bruto_Corrido += element.corrido as int;
          
        }
      
      }
    
    }

    setState(() {
      cant = decoded.length - 1;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final decoded = widget.infoList.calcs as Map<String, dynamic>;

    return Scaffold(
      appBar: showAppBar('Revisión de lista'),
      body: Column( mainAxisSize: MainAxisSize.min,
      
        children: [
      
          const SizedBox(height: 10),
          
          textoDosis('Información del listero', 20),
      
          FittedBox(
            child: Row( mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                listeroInfo(),
                listeroInfo2(),
              ],
            ),
          ),
          
          divisor,
      
          textoDosis('Detalles de los cálculos', 20),
      
          Row( mainAxisSize: MainAxisSize.min, 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              calcInfo(decoded),
              jugadasInfo(),
            ],
          ),
      
          divisor,

          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              btnWithIcon(context, 
                Colors.red[300],
                const Icon(Icons.money_off_csred_outlined), 
                'Sin premio', () { setState(() {
                  listSelect = false;
                }); }, 180, fontSize: 17),

              btnWithIcon(context, 
                Colors.green,
                const Icon(Icons.monetization_on),
                'Con premio', () { setState(() {
                  listSelect = true;
                }); }, 180, fontSize: 17),

            ],
          ),

          Expanded(
            child: ShowList(
              list: ( listSelect )
                ? conPremio
                : sinPremio))

        ],
      
      ),

    );
  
  }

  Container listeroInfo() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldLabel( 'Usuario: ', username, 18),
          
          boldLabel( 'Pagos para Fijo: ', pagos_jugada_Fijo, 18),
          
          boldLabel( 'Pagos para Corrido: ', pagos_jugada_Corrido, 18),
          
          boldLabel( 'Pagos para Parlé: ', pagos_jugada_Parle, 18),
          
          boldLabel( 'Pagos para Centena: ', pagos_jugada_Centena, 18),
        ],
        
      )
    );
  }
  
  Container listeroInfo2() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          boldLabel( '% para bola: ', porciento_bola_listero, 18),
          
          boldLabel( '% para parlés: ', porciento_parle_listero, 18)
        
        ]        
      )
    );
  }

  Container calcInfo(Map<String, dynamic> decoded) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldLabel( 'Bruto: ', decoded['bruto']
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Limpio: ', decoded['limpio']
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Premio: ', decoded['premio']
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Perdido: ', decoded['perdido']
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Ganado: ', decoded['ganado']
            .toStringAsFixed(0).toString(), 18),
        ],
        
      )
    );
  }
  
  Container jugadasInfo() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldLabel( 'Cant Jugadas: ', cant
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Bruto en Fijo: ', bruto_Fijo
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Bruto en Corrido: ', bruto_Corrido
            .toStringAsFixed(0).toString(), 18),
          
          boldLabel( 'Sorteo: ', widget.lotIncoming, 18)
        ],
        
      )
    );
  }

  getHisPayments(String userID) {
    Future<List<Payments>> thisUser = getPaymentsOfUser(userID);
    thisUser.then((value) {

      if (value.isNotEmpty) {

        setState(() {
          pagos_jugada_Corrido = value[0].pagosJugadaCorrido.toString();
          pagos_jugada_Centena = value[0].pagosJugadaCentena.toString();
          pagos_jugada_Parle = value[0].pagosJugadaParle.toString();
          pagos_jugada_Fijo = value[0].pagosJugadaFijo.toString();
          porciento_parle_listero = value[0].parleListero.toString();
          porciento_bola_listero = value[0].bolaListero.toString();
        });
      
      }
      
    });
  }

}

class ShowList extends StatelessWidget {
  const ShowList({
    super.key,
    required this.list
  });

  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {

          list.sort(((a, b) {
            return b.dinero - a.dinero;
          }));

          final color = (index % 2 != 0)
              ? Colors.grey[200]
              : Colors.grey[50];
          
          return Container(
            color: color,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 10),
              child: fila(data: list[index], color: color!),
            ),
          );
        }
      )
    );
  }

  Widget fila({required dynamic data, required Color color}) {
    final widgetMap = {
      FijoCorridoModel: (data) => FijosCorridosListaWidget(
            fijoCorrido: data,
            color: color,
          ),
      ParlesModel: (data) => ParlesListaWidget(
            parles: data,
            color: color,
          ),
      CentenasModel: (data) => CentenasListaWidget(
            centenas: data,
            color: color,
          ),
      CandadoModel: (data) => CandadoListaWidget(
            candado: data,
            color: color,
          ),
      TerminalModel: (data) => TerminalListaWidget(
            terminal: data,
            color: color,
          ),
      PosicionModel: (data) => PosicionlListaWidget(
            posicion: data,
            color: color,
          ),
      DecenaModel: (data) => DecenaListaWidget(
            numplay: data,
            color: color,
          ),
      MillionModel: (data) => MillionListaWidget(
            numplay: data,
            color: color,
          ),
    };

    final widgetBuilder = widgetMap[data.runtimeType];
    return widgetBuilder != null ? widgetBuilder(data) : Container();
  }

}