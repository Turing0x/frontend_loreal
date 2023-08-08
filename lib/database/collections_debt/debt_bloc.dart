import 'dart:async';

import 'coll_debt_model.dart';
import 'debt_provider.dart';

class CollectiosDebtBloc {
  static final CollectiosDebtBloc _singleton = CollectiosDebtBloc._internal();

  factory CollectiosDebtBloc() {
    return _singleton;
  }

  CollectiosDebtBloc._internal() {
    getAllColls();
  }

  final _collectionsDebts = StreamController<List<CollectionDebtModel>>.broadcast();

  Stream<List<CollectionDebtModel>> get listasStream => _collectionsDebts.stream;

  getAllColls() async {
    _collectionsDebts.sink.add(await DBProviderCollectiosDebt.db.getAllCollectionsDebt());
  }

  Future<int> addCollDebt(String name, String debt) async{
    int res = await DBProviderCollectiosDebt.db.newCollDebt(name, debt);
    getAllColls();
    return res;
  }

  deleteCollDebt(String id) {
    DBProviderCollectiosDebt.db.collectionDelete(id);
    getAllColls();
  }

  Future<int> deleteFull() async{
    int res = await DBProviderCollectiosDebt.db.deleteFullTable();
    getAllColls();
    return res;
  }

  dispose() {
    _collectionsDebts.close();
  }
}
