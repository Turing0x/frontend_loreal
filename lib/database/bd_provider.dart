import 'package:frontend_loreal/api/List/domain/list_offline_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:uuid/uuid.dart';
import 'dart:io';

class DBProviderListas {
  late Database _database;
  static final DBProviderListas db = DBProviderListas.privado();

  DBProviderListas.privado();

  Future<Database> get database async {
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory listsDirectorio = await getApplicationDocumentsDirectory();
    final listPath = join(listsDirectorio.path, 'ListasDB.db');
    return await openDatabase(listPath, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Listas('
          'signature TEXT,'
          'limpio TEXT,'
          'bruto TEXT,'
          'jornal TEXT,'
          'owner TEXT,'
          'date TEXT,'
          'id TEXT'
          ')');
    });
  }

  nuevaLista(String date, String jornal, String signature, String bruto,
      String limpio) async {
    final db = await database;
    const uuid = Uuid();

    final list = {
      'id': uuid.v4(),
      'owner': '',
      'date': date,
      'jornal': jornal,
      'signature': signature,
      'bruto': bruto,
      'limpio': limpio
    };

    await db.insert('Listas', list);
  }

  Future<List<OfflineList>> getLista(String id) async {
    final db = await database;

    final res = await db.query('Listas', where: 'id = ?', whereArgs: [id]);

    List<OfflineList> list =
        res.isNotEmpty ? res.map((c) => OfflineList.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<OfflineList>> getTodasListas() async {
    final db = await database;
    final res = await db.query('Listas');

    List<OfflineList> list =
        res.isNotEmpty ? res.map((c) => OfflineList.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> eliminarLista(String id) async {
    final db = await database;

    final res = await db.delete('Listas', where: 'id = ?', whereArgs: [id]);

    return res;
  }
}
