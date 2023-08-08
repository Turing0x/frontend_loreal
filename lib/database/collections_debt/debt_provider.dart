import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'coll_debt_model.dart';

class DBProviderCollectiosDebt {
  late Database _database;
  static final DBProviderCollectiosDebt db = DBProviderCollectiosDebt.privado();

  DBProviderCollectiosDebt.privado();

  Future<Database> get database async {
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory debtDirectorio = await getApplicationDocumentsDirectory();
    final listPath = join(debtDirectorio.path, 'CollectionsDebtDB.db');
    return await openDatabase(listPath, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE CollectionsDebt('
          'id TEXT,'
          'name TEXT,'
          'debt TEXT )');
    });
  }

  Future<int> newCollDebt(String name, String debt) async {
    final db = await database;
    const uuid = Uuid();

    final debtColl = {
      'id': uuid.v4(),
      'name': name,
      'debt': debt
    };

    return await db.insert('CollectionsDebt', debtColl);
  }

  Future<int> updateCollDebt(String id, Map<String, Object?> obj) async {
    final db = await database;

    final res = await db.update('CollectionsDebt', obj,
      where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<List<CollectionDebtModel>> getDebt(String id) async {
    final db = await database;

    final res = await db.query('CollectionsDebt', where: 'id = ?', whereArgs: [id]);

    List<CollectionDebtModel> debt =
        res.isNotEmpty ? res.map((c) => CollectionDebtModel.fromJson(c)).toList() : [];

    return debt;
  }

  Future<List<CollectionDebtModel>> getAllCollectionsDebt() async {
    final db = await database;
    final res = await db.query('CollectionsDebt');

    List<CollectionDebtModel> colls =
        res.isNotEmpty ? res.map((c) => CollectionDebtModel.fromJson(c)).toList() : [];

    return colls;
  }

  Future<int> collectionDelete(String id) async {
    final db = await database;

    final res = await db.delete('CollectionsDebt', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteFullTable() async {
    final db = await database;
    return await db.delete('CollectionsDebt');
  }
}
