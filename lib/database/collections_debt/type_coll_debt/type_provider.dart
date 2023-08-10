import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'dart:io';

import 'type_debt_model.dart';

class DBProviderTypeCollectiosDebt {
  late Database _database;
  static final DBProviderTypeCollectiosDebt db = DBProviderTypeCollectiosDebt.privado();

  DBProviderTypeCollectiosDebt.privado();

  Future<Database> get database async {
    _database = await initDB();

    return _database;
  }

  initDB() async {

    String dbPath = await databasePath();
    
    return await openDatabase(dbPath, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE TypeCollectionsDebt('
          'id TEXT,'
          'owner TEXT,'
          'typeDebt TEXT,'
          'debt TEXT,'
          'jornal TEXT,'
          'date TEXT )');
    });
  }

  Future<int> addTypeCollDebt( String id, String owner, String typeDebt, String debt, String jornal, String date ) async {
    final db = await database;

    final debtColl = {
      'id': id,
      'owner': owner,
      'typeDebt': typeDebt,
      'debt': debt,
      'jornal': jornal,
      'date': date,
    };

    return await db.insert('TypeCollectionsDebt', debtColl);
  }

  Future<List<TypeDebtModel>> getAllCollectionsDebtByOwner( String owner ) async {
    final db = await database;
    final res = await db.query('TypeCollectionsDebt', where: 'owner = ?', whereArgs: [owner]);

    List<TypeDebtModel> colls =
        res.isNotEmpty ? res.map((c) => TypeDebtModel.fromJson(c)).toList() : [];

    return colls;
  }

  Future<int> collectionDelete(String owner) async {
    final db = await database;

    final res = await db.delete('TypeCollectionsDebt', where: 'owner = ?', whereArgs: [owner]);

    return res;
  }

  void deleteFullTable() async {
    String dbPath = await databasePath();
    await deleteDatabase(dbPath);
  }

  Future<String> databasePath() async{
    Directory debtDirectorio = await getApplicationDocumentsDirectory();
    return join(debtDirectorio.path, 'TypeCollectionsDebt.db');
  }

}
