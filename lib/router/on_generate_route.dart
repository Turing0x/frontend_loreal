import 'package:flutter/material.dart';

import '../api/Banco/make_resumen.dart';
import '../api/Banco/see_list_detail_to_send.dart';
import '../api/Limits/infraestructure/ToUsers/limited_parles_to_user_page.dart';
import '../api/Limits/infraestructure/ToUsers/limited_ball_to_user_page.dart';
import '../api/Payments/infraestructre/payments_to_user.dart';
import '../api/List/pending_offline/list_detail_offline.dart';
import '../api/List/infraestructure/lists_control_page.dart';
import '../api/User/infraestructure/users_control_page.dart';
import '../api/Limits/infraestructure/limits_to_user.dart';
import '../api/List/infraestructure/making_all_docs.dart';
import '../api/List/infraestructure/make_list_page.dart';
import '../api/User/infraestructure/new_user_page.dart';
import '../api/List/infraestructure/list_detail.dart';
import '../api/List/infraestructure/list_review.dart';
import '../api/Storage/see_all_list_on_folder.dart';
import '../api/Cargados/see_details_parle.dart';
import '../api/Listero/see_limited_parle.dart';
import '../api/Cargados/see_details_bola.dart';
import '../api/Colector/create_user_page.dart';
import '../api/Listero/see_limited_ball.dart';
import '../api/Colector/user_control.dart';
import '../api/Listero/list_history.dart';
import '../api/List/main_list_page.dart';

MaterialPageRoute<dynamic>? onGenerateRoute ( RouteSettings settings ) {

  final argumentos = settings.arguments as List;
  Map<String, MaterialPageRoute> argRoutes = {
    
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
        listeros: argumentos[2],
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