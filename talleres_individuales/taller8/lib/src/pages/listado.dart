import 'dart:core';
import 'package:flutter/material.dart';
import 'package:taller8/database/db.dart';
import 'package:taller8/model/empresa.dart';

class Listado extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Empresas"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context,"/editar",arguments: Empresa(id:0,nombre:""));
        },
      ),
      body: Container(
        child: Lista()
      )
    );
  }
}

class Lista extends StatefulWidget {

  @override
  _MiLista createState() => _MiLista();

}

class _MiLista extends State<Lista> {

  List<Empresa> empresas = [];

  @override
  void initState() {
    cargaEmpresas();
    super.initState();
  }

  cargaEmpresas() async {
    List<Empresa> auxEmpresa = await DB.empresas();

    setState(() {
      empresas = auxEmpresa;
    });

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: empresas.length,
        itemBuilder:
            (context, i) =>
          Dismissible(key: Key(i.toString()),
              direction: DismissDirection.startToEnd,
              background: Container (
                color: Colors.red,
                padding: EdgeInsets.only(left: 5),
                  child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.delete, color: Colors.white)
              )
              ),
            onDismissed: (direction) {
              DB.delete(empresas[i]);
            },
            child: ListTile(
              title: Text(empresas[i].nombre),
              trailing: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context,"/editar",arguments: empresas[i]);
                },
                child: Icon(Icons.edit)
              )
            )
          )
    );
  }

}