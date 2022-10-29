import 'package:quota_app/models/search_model.dart';
import 'package:quota_app/utilis/message.dart';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DBhelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabse();
    return _db;
  }

  initDatabse() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Test.db');
    Database database =
        await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Test (_id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT ,author TEXT , authorId TEXT , authorSlug TEXT, length INTEGER, dateAdded TEXT, dateModified Text)",
    );
  }

  Future<Searches> insert(Searches nodeModel) async {
    var dbClient = await db;
    await dbClient!.insert('Test', nodeModel.toMap());
    return nodeModel;
  }

  Future<List<Searches>> getNotes() async {
    var dbClient = await db;
    List<Map<String, Object?>> records = await dbClient!.query('Test');
    return records.map((e) => Searches.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('Test',
        where: '_id = ?', whereArgs: [id]).onError((error, stackTrace) {
      Message.toatsMessage(error.toString());
      throw 'e';
    });
  }

  Future<int> update(Searches nodeModel) async {
    var dbClient = await db;
    return await dbClient!.update('Test', nodeModel.toMap(),
        where: '_id = ?',
        whereArgs: [nodeModel.sId]).onError((error, stackTrace) {
      Message.toatsMessage(error.toString());
      throw 'error';
    });
  }

  Future<int> deleteTable() async {
    var dbClient = await db;
    return await dbClient!.delete('Test');
  }
}
