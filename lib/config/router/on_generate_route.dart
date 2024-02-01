import 'package:flutter/material.dart';
import 'package:frontend_loreal/design/Banco/details_coll_debt.dart';

import '../../design/Almacenamiento/see_all_list_on_folder.dart';
import '../../design/Banco/make_resumen.dart';
import '../../design/Banco/see_list_detail_to_send.dart';
import '../../design/Cargados/see_details_bola.dart';
import '../../design/Cargados/see_details_parle.dart';
import '../../design/Colector/create_user_page.dart';
import '../../design/Colector/user_control.dart';
import '../../design/Limites/limited_ball_to_user_page.dart';
import '../../design/Limites/limited_parles_to_user_page.dart';
import '../../design/Limites/limits_to_user.dart';
import '../../design/Lista/list_detail.dart';
import '../../design/Lista/list_detail_offline.dart';
import '../../design/Lista/list_review.dart';
import '../../design/Lista/lists_control_page.dart';
import '../../design/Lista/main_list_page.dart';
import '../../design/Lista/make_list_page.dart';
import '../../design/Lista/making_all_docs.dart';
import '../../design/Listero/list_history.dart';
import '../../design/Listero/see_limited_ball.dart';
import '../../design/Listero/see_limited_parle.dart';
import '../../design/Pagos/payments_to_user.dart';
import '../../design/Usuario/new_user_page.dart';
import '../../design/Usuario/users_control_page.dart';

MaterialPageRoute<dynamic>? onGenerateRoute ( RouteSettings settings ) {

  final argumentos = settings.arguments as List;
  Map<String, MaterialPageRoute> argRoutes = {
    
    'details_colls_debt': MaterialPageRoute(
      builder: (_) => DetailsCollsDebt(
        id: argumentos[0],
        percent: argumentos[1],
      )),
    
    'making_all_docs': MaterialPageRoute(
      builder: (_) => MakingAllDocs(
        lotThisDay: argumentos[0],
      )),
    
    'list_review_page': MaterialPageRoute(
      builder: (_) => ListReviewPage(
        infoList: argumentos[0],
        lotIncoming: argumentos[1],
      )),
    
    'user_control_page': MaterialPageRoute(
      builder: (_) => UserControlPage(
        username: argumentos[0],
        actualRole: argumentos[1],
        idToSearch: argumentos[2],
      )),
    
    'user_control_page_colector': MaterialPageRoute(
      builder: (_) => UserControlPageColector(
        username: argumentos[0],
        actualRole: argumentos[1],
        idToSearch: argumentos[2],
      )),
    
    'limited_parle_to_user': MaterialPageRoute(
      builder: (_) => LimitedParlesToUser(
        userID: argumentos[0],
      )),
    
    'lists_history': MaterialPageRoute(
      builder: (_) => ListsHistory(
        canEditList: argumentos[0],
      )),
    
    'see_lists_on_folder': MaterialPageRoute(
      builder: (_) => SeeListsOnFolder(
        path: argumentos[0],
      )),
    
    'see_limited_ball': MaterialPageRoute(
      builder: (_) => SeeLimitedBall(
        userID: argumentos[0],
      )),
    
    'see_limited_parle': MaterialPageRoute(
      builder: (_) => SeeLimitedParle(
        userID: argumentos[0],
      )),
    
    'list_control_page': MaterialPageRoute(
      builder: (_) => ListsControlPage(
        userName: argumentos[0],
        idToSearch: argumentos[1],
      )),
    
    'make_resumen': MaterialPageRoute(
      builder: (_) => MakeResumenForBank(
        userName: argumentos[0],
      )),
    
    'limited_ball_to_user': MaterialPageRoute(
      builder: (_) => LimitedBallToUser(
        userID: argumentos[0],
      )),
    
    'payments_page_users': MaterialPageRoute(
      builder: (_) => PaymentsToUser(
        userID: argumentos[0],
        username: argumentos[1],
        role: argumentos[2],
      )),
    
    'new_user_page': MaterialPageRoute(
      builder: (_) => NewUserPage(
        userAsOwner: argumentos[0],
      )),
    
    'create_user_for_colector': MaterialPageRoute(
      builder: (_) => CreateUserForColector(
        userAsOwner: argumentos[0],
      )),
    
    'limits_page_users': MaterialPageRoute(
      builder: (_) => LimitsToUser(
        userID: argumentos[0],
        username: argumentos[1],
      )),
    
    'list_detail': MaterialPageRoute(
      builder: (_) => ListDetails(
        date: argumentos[0],
        jornal: argumentos[1],
        username: argumentos[2],
        lotIncoming: argumentos[3],
      )),
    
    'see_list_detail_after_send': MaterialPageRoute(
      builder: (_) => SeeListDetailAfterSend(
        date: argumentos[0],
        jornal: argumentos[1],
        owner: argumentos[2],
        signature: argumentos[3],
        bruto: argumentos[4],
        limpio: argumentos[5],
      )),
    
    'list_detail_offline': MaterialPageRoute(
      builder: (_) => ListDetailsOffline(
        id: argumentos[0],
      )),
    
    'main_make_list': MaterialPageRoute(
      builder: (_) => MainMakeList(
        username: argumentos[0],
      )),
    
    'make_list': MaterialPageRoute(
      builder: (_) => MakeList(
        fijo: argumentos[0],
        corrido: argumentos[1],
        parle: argumentos[2],
        centena: argumentos[3],
      )),
    
    'see_details_bola_cargada': MaterialPageRoute(
      builder: (_) => SeeDetailsBolasCargadas(
        bola: argumentos[0],
        total: argumentos[1],
        totalCorrido: argumentos[2],
        listeros: argumentos[3],
        jugada: argumentos[4]
      )),
    
    'see_details_parle_cargada': MaterialPageRoute(
      builder: (_) => SeeDetailsParlesCargados(
        bola: argumentos[0],
        fijo: argumentos[1],
        total: argumentos[2],
        listeros: argumentos[3],
      ))
      
  };

  return argRoutes[settings.name];

}