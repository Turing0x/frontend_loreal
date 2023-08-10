import 'dart:async';

import 'package:frontend_loreal/database/collections_debt/type_coll_debt/type_debt_model.dart';

import 'type_provider.dart';

class TypeCollectionsDebtBloc {

  final _collectionsDebts = StreamController<List<TypeDebtModel>>.broadcast();

  Stream<List<TypeDebtModel>> get listasStream => _collectionsDebts.stream;

  getAllColls( String owner ) async {
    _collectionsDebts.sink.add(
      await DBProviderTypeCollectiosDebt.db.getAllCollectionsDebtByOwner(owner));
  }

  Future<int> addTypeCollDebt( String id, String owner, String typeDebt, String debt, String jornal, String date ) async{
    int res = await DBProviderTypeCollectiosDebt.db.addTypeCollDebt(id, owner, typeDebt, debt, jornal, date);
    return res;
  }

  deleteCollDebt(String owner) {
    DBProviderTypeCollectiosDebt.db.collectionDelete( owner );
  }

  void deleteFull() async{
    DBProviderTypeCollectiosDebt.db.deleteFullTable();
  }

  dispose() {
    _collectionsDebts.close();
  }
}
