import 'package:flutter/material.dart';
import 'package:taller8/database/db.dart';
import 'package:taller8/model/empresa.dart';

class Editar extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final urlController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final serviciosController = TextEditingController();
  final clasificacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Empresa? empresa = ModalRoute.of(context)!.settings.arguments as Empresa?;
    nombreController.text         = empresa!.nombre;
    urlController.text            = empresa.url;
    telefonoController.text       = empresa.telefono.toString();
    emailController.text          = empresa.email;   
    serviciosController.text      = empresa.servicios;    
    clasificacionController.text  = empresa.clasificacion;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guardar")
      ),
      body: SingleChildScrollView(
        child: Padding(
          child: Form (
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: nombreController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == '') {
                          return "El nombre es obligatorio";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                          labelText: "Nombre"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: urlController,
                      validator: (value) {
                        if (value == '') {
                          return "El url es obligatorio";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                          labelText: "URL"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: telefonoController,
                      validator: (value) {
                        if (value == '') {
                          return "El telefono es obligatorio";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                          labelText: "Telefono"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == '') {
                          return "El email es obligatorio";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                          labelText: "Email"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: serviciosController,
                      validator: (value) {
                        if (value == '') {
                          return "El servicios es obligatorio";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                          labelText: "Servicios"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: clasificacionController,
                      validator: (value) {
                        if (value == '') {
                          return "El clasificacion es obligatorio";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                          labelText: "Clasificacion"
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (empresa.id > 0) {
                              empresa.nombre = nombreController.text;
                              empresa.url = urlController.text;
                              DB.update(empresa);
                            }
                            else {
                              DB.insert(Empresa(nombre: nombreController.text, url: urlController.text));
                            }
                            Navigator.pushNamed(context,"/");
                          }
                        },
                        child: const Text("Guardar"))
                  ]
              )
          ),
          padding: const EdgeInsets.all(15),
        )
      )
    );
  }

}