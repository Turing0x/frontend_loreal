import 'package:frontend_loreal/models/Chat/sql_chat.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:uuid/uuid.dart';
import 'dart:io';

class DBProviderChat {
  late Database _database;
  static final DBProviderChat db = DBProviderChat.privado();

  DBProviderChat.privado();

  Future<Database> get database async {
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory listsDirectorio = await getApplicationDocumentsDirectory();
    final listPath = join(listsDirectorio.path, 'ChatsDB.db');
    return await openDatabase(listPath, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Chats('
          'receiverID TEXT,'
          'receiver TEXT,'
          'id TEXT'
          ')');
    });
  }

  newChat(String receiverID, String receiver) async {
    final db = await database;
    const uuid = Uuid();

    final list = {
      'id': uuid.v4(),
      'receiverID': '',
      'receiver': '',
    };

    await db.insert('Chats', list);
  }

  Future<List<SQLChat>> getAllChatsById(String chatId) async {
    final db = await database;

    final res = await db.query('Chats', where: 'receiverID = ?', whereArgs: [chatId]);

    List<SQLChat> list =
        res.isNotEmpty ? res.map((c) => SQLChat.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<SQLChat>> getAllChats() async {
    final db = await database;
    final res = await db.query('Chats');

    List<SQLChat> list =
        res.isNotEmpty ? res.map((c) => SQLChat.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> chatDelete(String chatId) async {
    final db = await database;

    final res = await db.delete('Chats', where: 'id = ?', whereArgs: [chatId]);

    return res;
  }
}

