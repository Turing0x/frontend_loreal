// import 'package:frontend_loreal/api/List/pendingOffline/list_detail_offline.dart';
import 'package:frontend_loreal/design/Almacenamiento/internal_storage_banco.dart';
import 'package:frontend_loreal/design/Almacenamiento/internal_storage_colector.dart';
import 'package:frontend_loreal/design/Almacenamiento/internal_storage_listero.dart';
import 'package:frontend_loreal/design/Auth/offline_pass_page.dart';
import 'package:frontend_loreal/design/Auth/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:frontend_loreal/design/Banco/collectors_debt.dart';
import 'package:frontend_loreal/design/Banco/main_banco_page.dart';
import 'package:frontend_loreal/design/Banco/offline_list_control.dart';
import 'package:frontend_loreal/design/Banco/settings_banco_page.dart';
import 'package:frontend_loreal/design/Bote/bote_page.dart';
import 'package:frontend_loreal/design/Cargados/bola_cargada_page.dart';
import 'package:frontend_loreal/design/Cargados/parle_cargada_page.dart';
import 'package:frontend_loreal/design/Colector/main_colector_page.dart';
import 'package:frontend_loreal/design/Colector/settings_colector_page.dart';
import 'package:frontend_loreal/design/Firma/signature_page.dart';
import 'package:frontend_loreal/design/Firma/signatures_storage.dart';
import 'package:frontend_loreal/design/Horario/time_page.dart';
import 'package:frontend_loreal/design/Limites/limited_ball_page.dart';
import 'package:frontend_loreal/design/Limites/limited_parles_page.dart';
import 'package:frontend_loreal/design/Lista/filters_on_lists.dart';
import 'package:frontend_loreal/design/Lista/main_list_offline_page.dart';
import 'package:frontend_loreal/design/Lista/pending_list.dart';
import 'package:frontend_loreal/design/Listero/change_pass.dart';
import 'package:frontend_loreal/design/Listero/main_listero_page.dart';
import 'package:frontend_loreal/design/Listero/offline_pass.dart';
import 'package:frontend_loreal/design/Listero/settings_listero_page.dart';
import 'package:frontend_loreal/design/Millon/million_page.dart';
import 'package:frontend_loreal/design/Pagos/payments_main_banquero.dart';
import 'package:frontend_loreal/design/Pagos/see_pay_listero.dart';
import 'package:frontend_loreal/design/Sorteo/sorteos_page.dart';
import 'package:frontend_loreal/design/Usuario/bancos_control_page.dart';
import 'package:frontend_loreal/design/Usuario/new_banco_page.dart';

import '../../design/Limites/global_limits_page.dart';
import '../../design/Lista/for_now_page.dart';

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
  'colectors_debt_page': (_) => const ColectorsDebtPage(),
  'bancos_control_page': (_) => const BanksControlPage(),
  'main_banquero_page': (_) => const MainBanqueroPage(),
  'parle_cargada_page': (_) => const ParleCargadoPage(),
  'filters_on_lists': (_) => const FiltersOnAllLists(),
  'limited_parles_page': (_) => const LimitedParles(),
  'bola_cargada_page': (_) => const BolaCargadaPage(),
  'million_game_page': (_) => const MillionGamePage(),
  'main_settigns_banco': (_) => const SettingsPage(),
  'payments_page': (_) => const ConfigPaymentsPage(),
  'global_limits_page': (_) => const GlobalLimits(),
  'limited_ball_page': (_) => const LimitedBall(),
  'signature_page': (_) => const SignaturePage(),
  'new_banco_page': (_) => const NewBancoPage(),
  'config_time_page': (_) => const TimePage(),
  'sorteos_page': (_) => const SorteosPage(),
  'bote_page': (_) => const BotePage(),

//--------------------------------------------------------------

  // Rutas para el Colector
  'internal_storage_colector': (_) => const InternalStorageColectorPage(),
  'settings_colector_page': (_) => const SettingsColectorPage(),
  'main_colector_page': (_) => const MainColectorPage(),

//--------------------------------------------------------------

  // Rutas para el Listero
  'internal_storage_listero': (_) => const InternalStorageListeroPage(),
  'main_make_list_offline': (_) => const MainMakeListOffline(),
  'setting_listero_page': (_) => const SettingsListeroPage(),
  'see_payments_page': (_) => const SeePaymentsPage(),
  'pending_lists': (_) => const PendingLists(),
  'offline_pass': (_) => const OfflinePass(),
  'for_now_page': (_) => const ForNowList(),
};
