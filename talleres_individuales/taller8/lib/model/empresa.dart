class Empresa {
  int     id              = 0;
  String  url             = '';
  String  nombre          = '';
  int     telefono        = 0;
  String  email           = '';
  String  servicios       = '';
  String  clasificacion   = '';

  Empresa({this.id = 0, this.url = '' , this.nombre = '' , this.telefono = 0, this.email = '', this.servicios = '' , this.clasificacion = ''});

  Map<String, dynamic> toMap(){
    return { 'id': id, 'url': url, 'nombre': nombre, 'telefono': telefono, 'email': email, 'servicios': servicios, 'clasificacion': clasificacion};
  }

}