import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
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
    String dbPath = await databasePath();

    return await openDatabase(dbPath, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE CollectionsDebt('
          'id TEXT,'
          'name TEXT )');
    });
  }

  Future<int> newCollDebt(String uuid, String name) async {
    final db = await database;

    final debtColl = {
      'id': uuid,
      'name': name,
    };

    return await db.insert('CollectionsDebt', debtColl);
  }

  Future<int> updateCollDebt(String id, String calc) async {
    final db = await database;

    final res = await db.update('CollectionsDebt', {'debt': calc},
        where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<bool> verifyByName(String name) async {
    final db = await database;

    final res =
        await db.query('CollectionsDebt', where: 'name = ?', whereArgs: [name]);

    List<CollectionDebtModel> debt = res.isNotEmpty
        ? res.map((c) => CollectionDebtModel.fromJson(c)).toList()
        : [];

    return debt.isNotEmpty;
  }

  Future<List<CollectionDebtModel>> getDebt(String id) async {
    final db = await database;

    final res =
        await db.query('CollectionsDebt', where: 'id = ?', whereArgs: [id]);

    List<CollectionDebtModel> debt = res.isNotEmpty
        ? res.map((c) => CollectionDebtModel.fromJson(c)).toList()
        : [];

    return debt;
  }

  Future<List<CollectionDebtModel>> getAllCollectionsDebt() async {
    final db = await database;
    final res = await db.query('CollectionsDebt');

    List<CollectionDebtModel> colls = res.isNotEmpty
        ? res.map((c) => CollectionDebtModel.fromJson(c)).toList()
        : [];

    return colls;
  }

  Future<int> collectionDelete(String id) async {
    final db = await database;

    final res =
        await db.delete('CollectionsDebt', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  void deleteFullTable() async {
    String dbPath = await databasePath();
    await deleteDatabase(dbPath);
  }

  Future<String> databasePath() async {
    Directory debtDirectorio = await getApplicationDocumentsDirectory();
    return join(debtDirectorio.path, 'CollectionsDebtDB.db');
  }
}
