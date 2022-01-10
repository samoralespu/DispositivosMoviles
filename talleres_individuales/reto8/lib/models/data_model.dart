import 'package:flutter_sqlite/models/model.dart';

class Empresa extends Model {

  static String table = 'empresas';
  int id;
  String nombre;
  int telefono;
  String url;
  String email;
  String  servicios;
  int  clasificacion;

  Empresa({
    this.id,
    this.nombre,
    this.telefono,
    this.url,
    this.email,
    this.servicios,
    this.clasificacion,
  });

  static Empresa fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map["id"],
      nombre: map['nombre'].toString(),
      telefono: map['telefono'],
      url: map['url'],
      email: map['email'],
      servicios: map['servicios'],
      clasificacion: map['clasificacion'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'url': url,
      'email': email,
      'servicios': servicios,
      'clasificacion': clasificacion,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}

class CategoryModel extends Model {
  static String table = 'product_categories';

  String categoryName;
  int telefono;

  CategoryModel({
    this.telefono,
    this.categoryName,
  });

  static CategoryModel fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      telefono: map["id"],
      categoryName: map['categoryName'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'categoryName': categoryName,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
