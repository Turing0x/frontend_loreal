import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersProvider extends StateNotifier<Filters> {
  FiltersProvider() : super(Filters());

  void restartFilters() {
    state = Filters();
  }

  set pagination(int pag) {
    state = state.copyWith(pagination: state.pagination);
  }

  set typeOrder(String typeOrder) {
    state = state.copyWith(typeOrder: state.typeOrder);
  }

  set parameter(String parameter) {
    state = state.copyWith(parameter: state.parameter);
  }

  void actualizarEstado({
    int? pagination,
    String? typeOrder,
    String? parameter,
  }) {
    state = state.copyWith(
      pagination: pagination,
      typeOrder: typeOrder,
      parameter: parameter,
    );
  }
}

class Filters {
  int pagination;
  String typeOrder;
  String parameter;

  Filters({
    this.pagination = 5,
    this.typeOrder = 'mayor',
    this.parameter = 'bruto',
  });

  copyWith({
    int? pagination,
    String? typeOrder,
    String? parameter,
  }) {
    return Filters(
      pagination: pagination ?? this.pagination,
      typeOrder: typeOrder ?? this.typeOrder,
      parameter: parameter ?? this.parameter,
    );
  }
}
