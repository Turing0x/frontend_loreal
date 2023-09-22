import 'package:frontend_loreal/models/Chat/sql_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:uuid/uuid.dart';
import 'dart:io';

class DBProviderMessages {
  late Database _database;
  static final DBProviderMessages db = DBProviderMessages.privado();

  DBProviderMessages.privado();

  Future<Database> get database async {
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory listsDirectorio = await getApplicationDocumentsDirectory();
    final listPath = join(listsDirectorio.path, 'MessagesDB.db');
    return await openDatabase(listPath, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Messages('
          'text TEXT,'
          'id TEXT'
          ')');
    });
  }

  newMessage(String text) async {
    final db = await database;
    const uuid = Uuid();

    final list = {
      'id': uuid.v4(),
      'text': '',
    };

    await db.insert('Messages', list);
  }

  Future<List<SQLMessage>> getAllMessages(String chatId) async {
    final db = await database;

    final res = await db.query('Messages', where: 'id = ?', whereArgs: [chatId]);

    List<SQLMessage> list =
        res.isNotEmpty ? res.map((c) => SQLMessage.fromJson(c)).toList() : [];

    return list;
  }

}

