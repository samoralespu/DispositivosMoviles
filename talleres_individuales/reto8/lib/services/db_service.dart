import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/utils/db_helper.dart';

class DBService {
  Future<bool> addEmpresa(Empresa model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.insert(Empresa.table, model);
      isSaved = inserted == 1 ? true : false;
    }

    return isSaved;
  }

  Future<bool> updateEmpresa(Empresa model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.update(Empresa.table, model);

      isSaved = inserted == 1 ? true : false;
    }

    return isSaved;
  }

  Future<List<Empresa>> getEmpresas() async {
    await DB.init();
    List<Map<String, dynamic>> products = await DB.query(Empresa.table);

    return products.map((item) => Empresa.fromMap(item)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    await DB.init();
    List<Map<String, dynamic>> categories = await DB.query(CategoryModel.table);

    return categories.map((item) => CategoryModel.fromMap(item)).toList();
  }

  Future<List<CategoryModel>> getCategorie() async {
    await DB.init();
    List<Map<String, dynamic>> categories = await DB.query(CategoryModel.table);

    return categories.map((item) => CategoryModel.fromMap(item)).toList();
  }

  Future<bool> deleteEmpresa(Empresa model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.delete(Empresa.table, model);

      isSaved = inserted == 1 ? true : false;
    }

    return isSaved;
  }
}
