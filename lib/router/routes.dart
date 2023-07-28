// import 'package:frontend_loreal/api/List/pendingOffline/list_detail_offline.dart';
import 'package:frontend_loreal/Auth/sign_in_page.dart';
import 'package:frontend_loreal/api/Banco/offline_list_control.dart';
import 'package:frontend_loreal/api/Bote/bote_page.dart';
import 'package:frontend_loreal/api/Cargados/bola_cargada_page.dart';
import 'package:frontend_loreal/api/Cargados/parle_cargada_page.dart';
import 'package:frontend_loreal/api/Colector/main_colector_page.dart';
import 'package:frontend_loreal/api/Colector/settings_colector_page.dart';
import 'package:frontend_loreal/api/List/infraestructure/filters_on_lists.dart';
import 'package:frontend_loreal/api/Listero/change_pass.dart';
import 'package:frontend_loreal/api/List/pending_offline/pending_list.dart';
import 'package:frontend_loreal/api/Signature/infraestructure/signature_page.dart';
import 'package:frontend_loreal/api/Signature/infraestructure/signatures_storage.dart';
import 'package:frontend_loreal/api/Storage/internal_storage_colector.dart';
import 'package:frontend_loreal/api/Storage/internal_storage_listero.dart';
import 'package:frontend_loreal/api/User/infraestructure/bancos_control_page.dart';
import 'package:frontend_loreal/api/User/infraestructure/new_banco_page.dart';
import 'package:frontend_loreal/auth/offline_pass_page.dart';
import 'package:frontend_loreal/api/Listero/main_listero_page.dart';
import 'package:frontend_loreal/api/Listero/offline_pass.dart';
import 'package:frontend_loreal/api/Listero/settings_listero_page.dart';
import 'package:flutter/material.dart';

//Rutas para el Banco
import 'package:frontend_loreal/api/Payments/infraestructre/payments_main_banquero.dart';
import 'package:frontend_loreal/api/Limits/infraestructure/limited_parles_page.dart';
import 'package:frontend_loreal/api/Limits/infraestructure/global_limits_page.dart';
import 'package:frontend_loreal/api/Limits/infraestructure/limited_ball_page.dart';
import 'package:frontend_loreal/api/Lottery/infraestructure/sorteos_page.dart';
import 'package:frontend_loreal/api/Million/infraestructure/million_page.dart';
import 'package:frontend_loreal/api/Time/infraestructure/time_page.dart';
import 'package:frontend_loreal/api/Banco/settings_banco_page.dart';
import 'package:frontend_loreal/api/Banco/main_banco_page.dart';

//Rutas para el Listero
import 'package:frontend_loreal/api/Payments/infraestructre/see_pay_listero.dart';
import 'package:frontend_loreal/api/List/pending_offline/main_list_offline_page.dart';
import 'package:frontend_loreal/api/Storage/internal_storage_banco.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'config_off_page': (_) => const ConfigOfflinePass(),
  'change_pass_page': (_) => const ChangeAccessPass(),
  'main_listero_page': (_) => const MainListeroPage(),
  'signIn_page': (_) => const SignInPage(),

// ------------------------------------------------------------

  //Rutas para el Banco
  'signature_storage_page': (_) => const SignaturesStoragePage(),
  'internal_storage_page': (_) => const InternalStoragePage(),
  'offline_list_control': (_) => const OfflineListControl(),
  'payments_page': (_) => const ConfigPaymentsPage(),
  'main_banquero_page': (_) => const MainBanqueroPage(),
  'million_game_page': (_) => const MillionGamePage(),
  'bola_cargada_page': (_) => const BolaCargadaPage(),
  'parle_cargada_page': (_) => const ParleCargadoPage(),
  'bancos_control_page': (_) => const BanksControlPage(),
  'signature_page': (_) => const SignaturePage(),
  'limited_parles_page': (_) => const LimitedParles(),
  'global_limits_page': (_) => const GlobalLimits(),
  'new_banco_page': (_) => const NewBancoPage(),
  'main_settigns_banco': (_) => const SettingsPage(),
  'limited_ball_page': (_) => const LimitedBall(),
  'sorteos_page': (_) => const SorteosPage(),
  'config_time_page': (_) => const TimePage(),
  'bote_page': (_) => const BotePage(),
  'filters_on_lists': (_) => const FiltersOnAllLists(),

//--------------------------------------------------------------

  // Rutas para el Colector
  'internal_storage_colector': (_) => const InternalStorageColectorPage(),
  'settings_colector_page': (_) => const SettingsColectorPage(),
  'main_colector_page': (_) => const MainColectorPage(),

//--------------------------------------------------------------

  // Rutas para el Listero
  'internal_storage_listero': (_) => const InternalStorageListeroPage(),
  'setting_listero_page': (_) => const SettingsListeroPage(),
  'main_make_list_offline': (_) => const MainMakeListOffline(),
  'see_payments_page': (_) => const SeePaymentsPage(),
  'pending_lists': (_) => const PendingLists(),
  'offline_pass': (_) => const OfflinePass(),
};
