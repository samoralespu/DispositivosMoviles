import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taller8/model/empresa.dart';

class DB {

  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'empresas.db'),
    //Si no está creada
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE empresas (id INTEGER PRIMARY KEY, url TEXT, nombre TEXT, telefono INTEGER, email TEXT, servicios TEXT, clasificacion TEXT)",
        );
      }, version: 1
    );
  }

  static Future<int> insert(Empresa empresa) async {
    Database database = await _openDB();
    return database.insert('empresas', empresa.toMap());
  }

  static Future<int> delete(Empresa empresa) async {
    Database database = await _openDB();
    return database.delete('empresas', where: 'id = ?', whereArgs: [empresa.id]);
  }

  static Future<int> update(Empresa empresa) async {
    Database database = await _openDB();
    return database.update('empresas', empresa.toMap(), where: 'id = ?', whereArgs: [empresa.id]);
  }

  static Future<List<Empresa>> empresas() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> empresasMap = await database.query('empresas');
    return List.generate(empresasMap.length,
      (index) => Empresa(
        id: empresasMap[index]['id'],     
        url: empresasMap[index]['url'], 
        nombre: empresasMap[index]['nombre'], 
        telefono: empresasMap[index]['telefono'], 
        email: empresasMap[index]['email'], 
        servicios: empresasMap[index]['servicios'], 
        clasificacion: empresasMap[index]['clasificacion'],
      ));
  }

}