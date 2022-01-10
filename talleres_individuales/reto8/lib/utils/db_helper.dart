import 'dart:async';
import 'package:flutter_sqlite/models/model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasesPath = await getDatabasesPath();
      String _path = p.join(databasesPath, 'empresa.db');
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE empresas (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre STRING, telefono INTEGER, url STRING,  email String,  servicios String,  clasificacion INTEGER)');
    await db.execute(
        'CREATE TABLE product_categories (id INTEGER PRIMARY KEY AUTOINCREMENT, categoryName STRING)');
    await db.execute("INSERT INTO product_categories (categoryName) VALUES ('consultoría'), ('desarrollo a la medida'), ('fábrica de software');");        
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future<Batch> batch() async => _db.batch();
}
