import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_loreal/config/controllers/cargados_controllers.dart';
import 'package:frontend_loreal/config/riverpod/filters_provider.dart';
import 'package:frontend_loreal/config/riverpod/limits_provider.dart';
import 'package:frontend_loreal/config/riverpod/payments_provider.dart';
import 'package:frontend_loreal/config/riverpod/release_riverpod.dart';
import 'package:frontend_loreal/design/Fecha_Jornada/jornal_and_date_bloc.dart';
import 'package:frontend_loreal/design/Lista/candado.dart';
import 'package:frontend_loreal/design/Lista/to_block.dart';
import 'package:frontend_loreal/models/Cargados/cargados_model.dart';
import 'package:frontend_loreal/models/Lista/join_list.dart';
import 'package:frontend_loreal/models/PDFs/invoice_colector.dart';
import 'package:frontend_loreal/models/Release/release_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'declarations.g.dart';

final release = StateNotifierProvider<ReleaseRiverpod, ReleaseModel>(
    (ref) => ReleaseRiverpod());

final paymentCrtl = StateNotifierProvider<PaymentsProvider, Payments>(
    (ref) => PaymentsProvider());

final filterCrtl =
    StateNotifierProvider<FiltersProvider, Filters>((ref) => FiltersProvider());

final globalLimits = StateNotifierProvider<GlobalLimitsProvider, GlobalLimits>(
    (ref) => GlobalLimitsProvider());

final currentPage = StateProvider<Widget>((ref) => const CandadoWidget());

final chUser = StateProvider<String>((ref) => '');

final setMissingLists = StateProvider<String>((ref) => '');

final idToSearch = StateProvider<String>((ref) => '');
final toCreateUser = StateProvider<String>((ref) => 'a, b');

final toEditAList = StateProvider<List<String>>((ref) => []);
final toManageTheMoney = StateProvider<List<dynamic>>((ref) => []);
final showButtomtoEditAList = StateProvider<bool>((ref) => false);

final globalRole = StateProvider<String>((ref) => '');

final setSorteo = StateProvider<String>((ref) => '');

final btnManagerR = StateProvider<bool>((ref) => false);

final invoiceItemColector =
    StateProvider<List<InvoiceItemColector>>((ref) => []);

final toRefreshAnyList = StateProvider<bool>((ref) => false);

final janddateR = StateNotifierProvider<JAndDateProvider, JAndDateModel>(
    (ref) => JAndDateProvider());

final toJoinListR = StateNotifierProvider<JoinListProvider, JoinListModel>(
    (ref) => JoinListProvider());

final toBlockAnyBtnR =
    StateNotifierProvider<ToBlockAnyBtnProvider, ToBlockAnyBtnModel>(
        (ref) => ToBlockAnyBtnProvider());

ValueNotifier<bool> cambioMillionGame = ValueNotifier<bool>(true);
ValueNotifier<bool> searchCargados = ValueNotifier<bool>(true);
ValueNotifier<bool> syncUserControl = ValueNotifier<bool>(true);
ValueNotifier<bool> cambioSorteo = ValueNotifier<bool>(true);
ValueNotifier<bool> cambioListas = ValueNotifier<bool>(true);
ValueNotifier<bool> cambioTime = ValueNotifier<bool>(true);
ValueNotifier<bool> authStatus = ValueNotifier<bool>(false);
ValueNotifier<bool> recargar = ValueNotifier<bool>(true);

ValueNotifier<bool> recargarUserList = ValueNotifier<bool>(true);

ValueNotifier<bool> toEditState = ValueNotifier<bool>(true);

@riverpod
Future<List<BolaCargadaModel>> getBolaCargadaRiv(
    GetBolaCargadaRivRef ref) async {
  return getBolasCargadas();
}

@riverpod
Future<int> totalBrutoBolaCargada(TotalBrutoBolaCargadaRef ref) async {
  final result = ref.watch(getBolaCargadaRivProvider);
  try {
    return result.isLoading
        ? 0
        : result.asData!.value.fold<int>(0, (sum, item) => sum + item.fijo);
  } on Exception catch (_) {
    return 0;
  }
}

@riverpod
Future<List<BolaCargadaModel>> getParlesCargadoRiv(
    GetParlesCargadoRivRef ref) async {
  return getParleCargadas();
}

@riverpod
Future<int> totalBrutoParlesCargado(TotalBrutoParlesCargadoRef ref) async {
  final result = ref.watch(getBolaCargadaRivProvider);
  try {
    return result.isLoading
        ? 0
        : result.asData!.value.fold<int>(0, (sum, item) => sum + item.fijo);
  } on Exception catch (_) {
    return 0;
  }
}
