import 'dart:async';

import 'coll_debt_model.dart';
import 'debt_provider.dart';

class CollectionsDebtBloc {
  static final CollectionsDebtBloc _singleton = CollectionsDebtBloc._internal();

  factory CollectionsDebtBloc() {
    return _singleton;
  }

  CollectionsDebtBloc._internal() {
    getAllColls();
  }

  final _collectionsDebts =
      StreamController<List<CollectionDebtModel>>.broadcast();

  Stream<List<CollectionDebtModel>> get listasStream =>
      _collectionsDebts.stream;

  getAllColls() async {
    _collectionsDebts.sink
        .add(await DBProviderCollectiosDebt.db.getAllCollectionsDebt());
  }

  Future<bool> getCollByName(String name) async {
    return await DBProviderCollectiosDebt.db.verifyByName(name);
  }

  Future<int> addCollDebt(String uuid, String name) async {
    int res = await DBProviderCollectiosDebt.db.newCollDebt(uuid, name);
    getAllColls();
    return res;
  }

  deleteCollDebt(String id) {
    DBProviderCollectiosDebt.db.collectionDelete(id);
    getAllColls();
  }

  void deleteFull() async {
    DBProviderCollectiosDebt.db.deleteFullTable();
    getAllColls();
  }

  dispose() {
    _collectionsDebts.close();
  }
}
