import 'dart:async';
import 'dart:io';

import 'package:flutter_wanandroid/data/model/history_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtil {
  static final DatabaseUtil _instance = DatabaseUtil._();

  factory DatabaseUtil() => _instance;

  DatabaseUtil._();

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  final String tableName = "search_history";

  final String columnId = "id";
  final String columnName = "name";

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "wanandroid.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  Future _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT)";
    await db.execute(sql);
    print("$tableName is created!");
  }

  /// 插入
  Future<int> insertItem(HistoryBean item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  /// 查询
  Future<List> queryList() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableName");
    return res.toList();
  }

  /// 根据ID删除
  Future<int> deleteById(int id) async {
    var dbClient = await db;
    return dbClient.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  /// 清空
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }

  /// 关闭
  Future close() async {
    var dbClient = await db;
    print("database is closed!");
    return dbClient.close();
  }
}
