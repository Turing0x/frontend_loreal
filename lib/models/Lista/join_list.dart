import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sticker_maker/config/extensions/lista_general_extensions.dart';
import '../../config/enums/lista_general_enum.dart';

class JoinListProvider extends StateNotifier<JoinListModel> {
  JoinListProvider() : super(JoinListModel());

  void updateCurrentList({required String key, required dynamic data}) {
    state.currentList[key] = data;
  }

  void addCurrentList({required ListaGeneralEnum key, required Map data}) {
    state.currentList[key.asString]!.addAll(data);
  }

  void removeCurrentList({required ListaGeneralEnum key, required Map data}) {
    state.currentList[key.asString]!.remove(data);
  }

  void clearList() {
    for (var element in state.currentList.values) {
      element.clear();
    }
  }

  bool isEmpty() =>
      state.currentList.values.every((element) => element.isEmpty);
}

class JoinListModel {
  final Map<String, Map> currentList;

  JoinListModel()
      : currentList = {for (var e in ListaGeneralEnum.values) e.asString: {}};
}
